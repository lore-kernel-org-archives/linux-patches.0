Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 470324F85CD;
	Tue, 13 Oct 2026 12:01:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892920; cv=none; b=riWhHkSgKudO0eRgBpu4V5QvRuNjAnyhUiM1Kz20TD7872actvym1+GQTn/JE9465Ob6U7NZv+allGFf/s1ldxbMhsgHlA/vte4WkHCjmvaqz3jiSkcLkd/JcIqaeWwEncNy9Ji0ElAr2OFT/BGcCYCKk6CYwkXs3Yj4GcAgP6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892920; c=relaxed/simple;
	bh=A0H2RvMLEpX5pst38p2no46olh7PUg0udPstBFaNv2k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PvMQAihGAIivHf98dgjs424bADwZ6enht09SScWRD7ChRVd47WheHL4pRRVEgii5mtqYNHXZj05z14yVMFYGVz3kPeHSoZ9bYL3CWGqV36a1Frdstv6M8elUAWMZyIKu+OjIly8mFn2QrbTIFnSVxnag4wFvWkZXzRVbGhvnG0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qMFzy8/b; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qMFzy8/b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56BB61F000FF;
	Tue, 13 Oct 2026 12:01:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791892918;
	bh=j4GQpACRWG6LzpoYeFZdhTDV2QdplfRXyP99YREaYnk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qMFzy8/blPBdUv7++Jm9S9NjcJlxziziSiBXDWgRUCGc+K9bz3K74qF3kPGJ49BTF
	 Rec6RNGeqKU/EdbgJkclN6ZXBWhSpeXm/QX2Vm+R8LB7xsgg6GIs/J7faz9X3RLZhT
	 I0msR6uJ2S2ps+ceTkErQx546F9kScbRE+cKKU0g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+a7f7cb0737bd91aa698c@syzkaller.appspotmail.com,
	=?UTF-8?q?Christian=20G=C3=B6ttsche?= <cgzones@googlemail.com>,
	Stephen Smalley <stephen.smalley.work@gmail.com>,
	Paul Moore <paul@paul-moore.com>
Subject: [PATCH 6.18 051/621] selinux: fix data race on AVC latest_notif
Date: Tue, 13 Oct 2026 13:30:46 +0200
Message-ID: <20261013112922.074892769@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -578,7 +578,7 @@ static int avc_latest_notif_update(u32 s
 		}
 	} else {
 		if (seqno > selinux_avc.avc_cache.latest_notif)
-			selinux_avc.avc_cache.latest_notif = seqno;
+			WRITE_ONCE(selinux_avc.avc_cache.latest_notif, seqno);
 	}
 	spin_unlock_irqrestore(&notif_lock, flag);
 
@@ -1206,5 +1206,6 @@ int avc_has_perm(u32 ssid, u32 tsid, u16
 
 u32 avc_policy_seqno(void)
 {
-	return selinux_avc.avc_cache.latest_notif;
+	/* Writers hold notif_lock; readers only sample the sequence number. */
+	return READ_ONCE(selinux_avc.avc_cache.latest_notif);
 }


