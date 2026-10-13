Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9807F4F3916;
	Tue, 13 Oct 2026 11:47:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892061; cv=none; b=uo+r80a+16vTIykpJgaGM+hchC6abUr3R8c9xe+QULXek8w4lByy5AkSmjcODpTaiNftZRVMBC1n9naSgI3Eg9Y9Ps4wztts3CEeC1C7mpa2ioilXg+erg/QxO1J5mfHOdU99TK3FhZH9pM0s+7QNggyWAfkDZnYlCfOl7LnEmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892061; c=relaxed/simple;
	bh=2cPbhScRV6QoFwW9Qd6lPoN9sF8rr/fhzYH/VC5ffok=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IE0B8ES4/LdgIxW5QKH85QW0Hw1/Bj4B9kgWxMkrZCEnS2DTd0zI8DKYJXZiTD0au2OIlKwUwLf/zZYYhhrWOYDNV/xBH4Z3VLKawM4aZoWWttjeYvyiBqRgcjW/D4mO8mAcfuRRUWqt0MYKzOdDOjXym9cTPd9itPNaetunwhA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wDYjf+7D; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wDYjf+7D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBBB71F00898;
	Tue, 13 Oct 2026 11:47:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791892060;
	bh=b4TmhmM5Vg676da3loJ3inBKn/CYJrkKC6dGKcZIm20=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wDYjf+7Dn5N9rd4eKp4X1kVXuYRvRuY2JLYvpyCUa4d5YSkASmrT+O70sw/Z6Rbyi
	 6p4T68rq17YYprp2Qg7y35naiCv5hyfd4IVvGUN4fIzrNixkTWvHqTwQYhHkD0jkx4
	 fq8Aq6h/+WdVAV6VLU9z/81i6LcNH7klw1czx7QA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+a7f7cb0737bd91aa698c@syzkaller.appspotmail.com,
	=?UTF-8?q?Christian=20G=C3=B6ttsche?= <cgzones@googlemail.com>,
	Stephen Smalley <stephen.smalley.work@gmail.com>,
	Paul Moore <paul@paul-moore.com>
Subject: [PATCH 7.2 047/281] selinux: fix data race on AVC latest_notif
Date: Tue, 13 Oct 2026 13:36:03 +0200
Message-ID: <20261013112856.192886064@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112855.045212108@linuxfoundation.org>
References: <20261013112855.045212108@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Göttsche <cgzones@googlemail.com>

commit 1ca924044bf0de879a1648be93a56939652267d3 upstream.

avc_policy_seqno() reads latest_notif without holding notif_lock, while
avc_latest_notif_update() can update it under that lock. KCSAN reports
these concurrent accesses during policy boolean updates and permission
checks.

Use READ_ONCE() for the lockless read and WRITE_ONCE() for the update.
The spinlock continues to serialize the comparison and update against
other writers. Reads made while holding notif_lock cannot race with a
writer and can remain plain accesses.

This marks both sides of the intentional concurrent access and constrains
compiler transformations, without suppressing checking with data_race().

Cc: stable@vger.kernel.org
Fixes: 788e7dd4c22e ("SELinux: Improve read/write performance")
Reported-by: syzbot+a7f7cb0737bd91aa698c@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=a7f7cb0737bd91aa698c
Signed-off-by: Christian Göttsche <cgzones@googlemail.com>
Acked-by: Stephen Smalley <stephen.smalley.work@gmail.com>
Signed-off-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/selinux/avc.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/security/selinux/avc.c
+++ b/security/selinux/avc.c
@@ -579,7 +579,7 @@ static int avc_latest_notif_update(u32 s
 		}
 	} else {
 		if (seqno > selinux_avc.avc_cache.latest_notif)
-			selinux_avc.avc_cache.latest_notif = seqno;
+			WRITE_ONCE(selinux_avc.avc_cache.latest_notif, seqno);
 	}
 	spin_unlock_irqrestore(&notif_lock, flag);
 
@@ -1207,5 +1207,6 @@ int avc_has_perm(u32 ssid, u32 tsid, u16
 
 u32 avc_policy_seqno(void)
 {
-	return selinux_avc.avc_cache.latest_notif;
+	/* Writers hold notif_lock; readers only sample the sequence number. */
+	return READ_ONCE(selinux_avc.avc_cache.latest_notif);
 }


