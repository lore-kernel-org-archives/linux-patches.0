Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 362713A6418;
	Sat, 17 Oct 2026 17:15:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792257331; cv=none; b=QZi9WBl4tgXZXjB8BEteXj7thXPNauorR1KchsQHSN0W/8uyXAW0ElRAMmQ0eNoZrLYjyr6WKRNvlvKLAsbrwDjcZwks39whjLjMdItn5Jal67agDCoSIEU0FvoT38wTksFjYbPljBbknNxNFnWds/hX7LvBqqZqenPMTyiVIjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792257331; c=relaxed/simple;
	bh=mLjYItqivEACxxW0taKAWFywAnbVRbYqApERS4QaLxM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MAq5ntYjlgLvjINody9EIrS9RLUfyTu7OwSkMsqx9gwdI42GomaMltIvoCfP+dguvyPJw1bXqMxoQI/s8XM778H+AqOOt6fC6ACvK5FrLYqJbou0Xh8K09wnfgiz7CxMSliS2gqX9a3YrMHWb93cWUf3+qnjBkA62VY/y4W3o88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FY7Sc1Sz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FY7Sc1Sz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E6F81F000C4;
	Sat, 17 Oct 2026 17:15:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792257330;
	bh=SacDY2mGtoCcix5l1sXamkiRSc+hbbFm1Q/RJHDbNVE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FY7Sc1SzADFAm8aTLVV9IJQ8etEcZejIRYnhAEip9cS6ZWeEWkTijJ4igauuIox9w
	 VVZ93jQ5EhLjPes1r9iS0OxWyI3gowyfEX3lcgNhL3EPoxxL8yhZl0ZdHmkb12Z0F7
	 hL//J9WQn97Jk3t5lRyCXHyXUhErCvAotHAetArQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+a7f7cb0737bd91aa698c@syzkaller.appspotmail.com,
	=?UTF-8?q?Christian=20G=C3=B6ttsche?= <cgzones@googlemail.com>,
	Stephen Smalley <stephen.smalley.work@gmail.com>,
	Paul Moore <paul@paul-moore.com>
Subject: [PATCH 6.6 0483/1674] selinux: fix data race on AVC latest_notif
Date: Sat, 17 Oct 2026 17:45:55 +0200
Message-ID: <20261017160443.510716007@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -581,7 +581,7 @@ static int avc_latest_notif_update(u32 s
 		}
 	} else {
 		if (seqno > selinux_avc.avc_cache.latest_notif)
-			selinux_avc.avc_cache.latest_notif = seqno;
+			WRITE_ONCE(selinux_avc.avc_cache.latest_notif, seqno);
 	}
 	spin_unlock_irqrestore(&notif_lock, flag);
 
@@ -1208,5 +1208,6 @@ int avc_has_perm(u32 ssid, u32 tsid, u16
 
 u32 avc_policy_seqno(void)
 {
-	return selinux_avc.avc_cache.latest_notif;
+	/* Writers hold notif_lock; readers only sample the sequence number. */
+	return READ_ONCE(selinux_avc.avc_cache.latest_notif);
 }


