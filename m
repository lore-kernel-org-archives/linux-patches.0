Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211574;
	b=ft11WGDpMLiF7DaCTBEgJqTmI2v/Ea6JWaxoIHYLmkyhgUD45OBNpVNcqaAuUXx5CLc+
	 eHRzT0LjdSRbIrJQcdjW1llpTvPBO0gSz2xBK1iFrcIMvGEjaUEENTQfLTsF/lwoA7kw+
	 GPhn0lPjaMLe/iSEGpEnaDA0Z+WVThw+LwOEM6jXlLFghWNbtzAt+DBjNd8qDnng15ND6
	 LoUS/Kt8vkwFkz4glYLSV2RF4Ti6tin88KXTJfXd7I3CXADLc9UTWoPLzJo+lPr7tjt65
	 O04+gWgDsoxhJIkZSo3JRTfCpTraPLn/5Md5Rifxr9tKDCvo2GpDvq3nDXZVdZ5eRuw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211574;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=PNCMgFfD2p1ngLAAxdTw9Sdzmx8rdAVGVQgQ+XIxP5E=;
	b=gzzDE1AdeS8XfgY7Ez8zGYaVgH+zX3/J+8JpvQEQZmXt/heJBs5y7gzy4qQf77XIZUMl
	 NSyfYfWDKFA8pv1xVwREoo1aRY5EUt3ngLCvcTVYM90bfPMl3NBz+4RPg5OjTSqeK+UwM
	 0jT1QGLmoBuqaROmdPA+pWKt76l7qDybCQP0mv09TyyENLpP6ikvyWNtVzHdkNG4b6qtt
	 FLbLv+B/41F57GljS2SCsy+ZoXjVM/osmSQiYgEvZatijnZjFpkM2H0IS4Sc8VK6cb7U/
	 vo2pAvLyOtvQ6JkeQtDa/wHy7Y7vqiI3vkXa+6ptcvYCnmxqSdSdRGgbzwehmz/W2eQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SP+oQQDV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3A43606A31A;
	Wed, 28 Oct 2026 18:19:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SP+oQQDV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 581921F01825;
	Wed, 28 Oct 2026 18:19:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211572;
	bh=PNCMgFfD2p1ngLAAxdTw9Sdzmx8rdAVGVQgQ+XIxP5E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SP+oQQDVEUqd5wKZ0Yq9p5GB+O8dyeUYvJrTEXe1++/YTM1+WgEs3pe2z1e5nIssO
	 dfVd36+WCPdcftMRmF5vSH8g/zEuVmZ0gc3B/pQUEmLe4VV9AwPYynJ2U172rL9/By
	 VW1y00SVvA3gC64FW335FEUu8vgUtMWvLhlFHlsI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+a7f7cb0737bd91aa698c@syzkaller.appspotmail.com,
	=?UTF-8?q?Christian=20G=C3=B6ttsche?= <cgzones@googlemail.com>,
	Stephen Smalley <stephen.smalley.work@gmail.com>,
	Paul Moore <paul@paul-moore.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 426/571] selinux: fix data race on AVC latest_notif
Date: Wed, 28 Oct 2026 17:59:33 +0100
Message-ID: <20261028170018.126371658@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Adapted global selinux_avc accesses to use avc and state->avc pointers. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/selinux/avc.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/security/selinux/avc.c b/security/selinux/avc.c
index 70eeed3e44c05..04efc9582c56b 100644
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
 
@@ -1191,7 +1191,8 @@ int avc_has_perm(struct selinux_state *state, u32 ssid, u32 tsid, u16 tclass,
 
 u32 avc_policy_seqno(struct selinux_state *state)
 {
-	return state->avc->avc_cache.latest_notif;
+	/* Writers hold notif_lock; readers only sample the sequence number. */
+	return READ_ONCE(state->avc->avc_cache.latest_notif);
 }
 
 void avc_disable(void)
-- 
2.53.0



