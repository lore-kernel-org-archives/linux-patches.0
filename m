Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98DBF2E92BA;
	Sat, 12 Sep 2026 19:23:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789241030; cv=none; b=mKZ/oGTG7JFhZ7qJV6EPimUWgW5//LNt5dolx2VoYeEkxbW9qnxwpKxhDa35sHh29hg/JD369Gk+KeQfrbsN2VlxnmT/p58WRjntjGQKasQcHKU9LrqNv9eRQDMXkVFoP0DKsoRAUOLvkaPUTCzyu/rUsGilvtHP2upEDVrLfLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789241030; c=relaxed/simple;
	bh=2e053C8uPTW9OYc50bcgDJEyudqqxmGsIjbaodd9ry8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=K8qhNZstuMS/B8xKPwfLHB3UakL9ZT+Y3h5v+PlNsjkQEdvu30/tWsyNQYpY+BwUoEs9knjJWWes0tVCAEc1PmYYYPZEb4xkqN61T4rfbYICjMnlgcQFPzWLVF3GMrVmn8vSXej3qfUFVlmu+mp30r210+m4pzkV1Ix8u2bhIMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SwbgUjMM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SwbgUjMM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 130F21F000FF;
	Sat, 12 Sep 2026 19:23:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789241029;
	bh=Ml6Wj160X9KyTPT2WSBJ417YWP+sAEuHNlgOcL+iKEU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SwbgUjMMGzQ5G09LNiBSdg23VyqyANCRPlnFUH7QsmnrYNjtPGvcbdbZm2pdN1VIQ
	 tn8nsPlee6IQEc7VEEAxkhzypnrToU0Q/pQ2jxfBzdVVWzrvKKsHXo+qBWfpXIerob
	 P+DlrJaotBnohKHpHWqPPIplc5OW2XqDze06p5Iw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiubo Li <xiubo.li@clyso.com>,
	Viacheslav Dubeyko <slava@dubeyko.com>,
	Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 5.10 050/798] ceph: fix UAF in __kick_flushing_caps() on cf entry freed during unlock
Date: Sat, 12 Sep 2026 08:54:38 +0200
Message-ID: <20260912065518.110085016@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xiubo Li <xiubo.li@clyso.com>

commit 7af4c4f01305b0935adf6d4301b1ec407025485d upstream.

list_for_each_entry() iterates ci->i_cap_flush_list but drops
i_ceph_lock to send cap messages.  During the unlock window,
handle_cap_flush_ack() can acquire i_ceph_lock, detach cf entries
with tid <= flush_tid from the list, release i_ceph_lock, and free
them via ceph_free_cap_flush() outside any lock.  When the original
thread reacquires i_ceph_lock and the for-loop macro advances via
cf = list_next_entry(cf, i_list), it dereferences cf->i_list.next
on freed memory.

The race timeline:

  __kick_flushing_caps()              handle_cap_flush_ack()
  -----------------------             -----------------------
  holds i_ceph_lock        <---
  iterates to cf (tid=10)
  prepares FLUSH message
  drops i_ceph_lock        <---
  __send_cap() ── FLUSH(tid=10)
	                              MDS sends FLUSH_ACK(tid=10)
                           --->       acquires i_ceph_lock
                                      cf->tid(10) <= flush_tid(10),
                                      detaches cf from i_cap_flush_list
                                      drops i_ceph_lock
                                      ceph_free_cap_flush(cf) <- frees it!
  acquires i_ceph_lock     <---
  for-loop advances:
    cf = list_next_entry(cf, i_list)
      -- UAF on freed cf->i_list.next

The cf was just sent by __kick_flushing_caps itself via __send_cap().
The MDS may respond with FLUSH_ACK quickly enough that
handle_cap_flush_ack() frees cf before __kick_flushing_caps can
finish the iteration.

Fix by converting to a manual while loop: save the next pointer
under i_ceph_lock before dropping it, then use the saved pointer
after reacquiring, so the potentially-freed cf is never accessed again.

Cc: stable@vger.kernel.org
Signed-off-by: Xiubo Li <xiubo.li@clyso.com>
Reviewed-by: Viacheslav Dubeyko <slava@dubeyko.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ceph/caps.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -2513,9 +2513,14 @@ static void __kick_flushing_caps(struct
 		}
 	}
 
-	list_for_each_entry(cf, &ci->i_cap_flush_list, i_list) {
-		if (cf->tid < first_tid)
+	cf = list_first_entry(&ci->i_cap_flush_list, struct ceph_cap_flush, i_list);
+	while (&cf->i_list != &ci->i_cap_flush_list) {
+		struct ceph_cap_flush *next;
+
+		if (cf->tid < first_tid) {
+			cf = list_next_entry(cf, i_list);
 			continue;
+		}
 
 		cap = ci->i_auth_cap;
 		if (!(cap && cap->session == session)) {
@@ -2525,6 +2530,7 @@ static void __kick_flushing_caps(struct
 		}
 
 		first_tid = cf->tid + 1;
+		next = list_next_entry(cf, i_list);
 
 		if (!cf->is_capsnap) {
 			struct cap_msg_args arg;
@@ -2565,6 +2571,7 @@ static void __kick_flushing_caps(struct
 		}
 
 		spin_lock(&ci->i_ceph_lock);
+		cf = next;
 	}
 }
 


