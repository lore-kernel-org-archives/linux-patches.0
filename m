Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209179;
	b=yQRCnIqvR1pfGUzTYveMknRnCFhNFiwc9+bI0gRX2Bx2ALmvUfMc2OcYj4UvGx3S5+xY
	 Y20OA37uTNKNjxOqbXf8WqFY4+uCKW7NPnKTysDTG6a7pIsK6Xhan9iHkW3pmP38+agDE
	 F2nA5mYcuRruapsaU/VqRVk4jVzJZU2frwW0o8EAK/X737gl23KSwTl0yza7fjz+4KUDU
	 Tek5VrWeNstOVj1ZRGO1+wVbrJHyaTbCY6PUcPCEbohV0i8R5VRaQrjmQW6+uEJ7OoU0P
	 F8rbk2xzUxGhJeUuugx41Ev3KexBVu5a10cE4g6rAtpTa3uNvxWUzNt/ieoBqmbeYBg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209179;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=s+DDmZ0NVcxLFTe7hdrRgUvVdxstp+GVPumxDBf4G5E=;
	b=L9s0Ud0tcWONnywdlkI8Q6ulfsRUeJBSHL5R5ayGMS/Btfs3aY18gm1Hj9zid77wVKnv
	 TBVegAIEyhmyA8ddX12SQzHFFntH5j9Il7stA94knTBiNoR0SFt2If3QWZ3wzCPuB6lvn
	 +wHP7dgSmQu35GEhqfKMT2aKIV195djU1iKD2KgZ0NKdUrcf7tqtBDsZ+VN6QcGjPM6J0
	 RiPUA5GEUjDJB20zFtYEtK06akJMsyejUDZ0TLK+1YCR+EYNwrTnoDw/Ccz53AigbR+pm
	 C4e03giajQDoneglzYKetqVaLT14HuS3fOLZnj0XlD6I6AEL8YhkmCjkg9t+3GqbWrg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=s0feqT1e;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31DF1606A322;
	Wed, 28 Oct 2026 17:39:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=s0feqT1e
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8469A1F01825;
	Wed, 28 Oct 2026 17:39:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209179;
	bh=s+DDmZ0NVcxLFTe7hdrRgUvVdxstp+GVPumxDBf4G5E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=s0feqT1eN3xSjjtMBZH8LMM0qbSrlWojwBNmQ2P+m8Ep9R7jZKBo/t3gHrqDvL9Vw
	 9r5tElhZ9PpAPD9txpEfdyUspnjlebBezuhu4Y5DLi0EP2kgNr/EA9IPIgYtaiNXqd
	 i7bi3AvOKAcgFV4AjuQ82q7KHcDuNS8re8OUGXto=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+a7f7cb0737bd91aa698c@syzkaller.appspotmail.com,
	=?UTF-8?q?Christian=20G=C3=B6ttsche?= <cgzones@googlemail.com>,
	Stephen Smalley <stephen.smalley.work@gmail.com>,
	Paul Moore <paul@paul-moore.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 373/516] selinux: fix data race on AVC latest_notif
Date: Wed, 28 Oct 2026 17:58:45 +0100
Message-ID: <20261028170012.321830462@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Göttsche <cgzones@googlemail.com>

[ Upstream commit 1ca924044bf0de879a1648be93a56939652267d3 ]

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
[ sashal: Adapted global selinux_avc accesses to avc and state->avc pointer accesses. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/selinux/avc.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/security/selinux/avc.c b/security/selinux/avc.c
index 441ff3e773894..2359db283e7bb 100644
--- a/security/selinux/avc.c
+++ b/security/selinux/avc.c
@@ -588,7 +588,7 @@ static int avc_latest_notif_update(struct selinux_avc *avc,
 		}
 	} else {
 		if (seqno > avc->avc_cache.latest_notif)
-			avc->avc_cache.latest_notif = seqno;
+			WRITE_ONCE(avc->avc_cache.latest_notif, seqno);
 	}
 	spin_unlock_irqrestore(&notif_lock, flag);
 
@@ -1221,7 +1221,8 @@ int avc_has_perm_flags(struct selinux_state *state,
 
 u32 avc_policy_seqno(struct selinux_state *state)
 {
-	return state->avc->avc_cache.latest_notif;
+	/* Writers hold notif_lock; readers only sample the sequence number. */
+	return READ_ONCE(state->avc->avc_cache.latest_notif);
 }
 
 void avc_disable(void)
-- 
2.53.0



