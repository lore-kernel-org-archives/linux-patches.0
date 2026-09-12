Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C49D330328;
	Sat, 12 Sep 2026 17:04:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789232657; cv=none; b=hp3qpfiRJerQBNtvfjTR83TdSr3QugaY9Fm9d2vLa8RQ8/8jmGRQXQ3L7hjT+HYU6nSV3odhHLo1317YABeJZ0JF5JvIJW9LdnYatXHy/zAWCFCfSTPr2e6pLgt6MPcG/ItTsoSMay73JB+kpoqUIPDVwAXr2XqYSJUx/Wdh390=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789232657; c=relaxed/simple;
	bh=qZ3LSWfSqTypa0qGk/hTfTQzvnfkm4fnq95ZFYD02Po=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VVZQcu9h+6/MMfZRfBrSiTE+G8i5APi1DiAhKcD84wRgiXyFC5FFiSDA8oAZNeS6i0Et7DXhxRcAHVo11QydLlV6MzTZ78uVNvrn+cfB3OLvHL1HyI8pq+8VoVqYcW+ulfsc4Aao1JI1ZUSXQnyoPNpvlaKFGb5a2CcB9jkGqo0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jeHNyltP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jeHNyltP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43E221F000FF;
	Sat, 12 Sep 2026 17:04:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789232654;
	bh=qqLhu0jbUYb1S/XrIhtXBm6JC7Ca7Onfu+86QzD5ba0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jeHNyltPSKaZSIl6/MsSTeOKsC0TMAKNqKr+KvEAAJhgjON3ZOYUkA1qZoTU0Hwf7
	 bG38MBZakUrUngZswOYmhegtFPdUmMnpbF/8+LoLRbpAW2U60LI0pSrk95IQHGiCWg
	 GGYzhHj6ThpYwfu/UVqZxo/JPoMTyPSnZR8xrM+g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiubo Li <xiubo.li@clyso.com>,
	Viacheslav Dubeyko <slava@dubeyko.com>,
	Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 5.15 054/935] ceph: fix UAF in __kick_flushing_caps() on cf entry freed during unlock
Date: Sat, 12 Sep 2026 08:51:24 +0200
Message-ID: <20260912065528.077690206@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2433,9 +2433,14 @@ static void __kick_flushing_caps(struct
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
@@ -2445,6 +2450,7 @@ static void __kick_flushing_caps(struct
 		}
 
 		first_tid = cf->tid + 1;
+		next = list_next_entry(cf, i_list);
 
 		if (!cf->is_capsnap) {
 			struct cap_msg_args arg;
@@ -2485,6 +2491,7 @@ static void __kick_flushing_caps(struct
 		}
 
 		spin_lock(&ci->i_ceph_lock);
+		cf = next;
 	}
 }
 


