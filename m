Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95C9F511E90;
	Wed, 30 Sep 2026 18:15:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790792127; cv=none; b=eiNvLNGV3tvvQowlJxznY1NK/AuGTmhG4ZKV4bQerprQuYUmyPNnSrm2oC6vLrW2JtU2fFxKBDaaVWepRwR6+jHIRU9EvGFoO2eaIInvZ+e+XBh3UDkoM4nHvEotRCxwYTwYS/OIHrrmE+lCKSXELiOoUHm5lKFYxj4Tl+PyC2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790792127; c=relaxed/simple;
	bh=Y1wel9MnabnEPNcBzAvtCGrAVdPaUtmyV0lsltXka1w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RhN1Ydwv4vlBaB8zzfoi8taiKHxBkTLRO3Mkupg6XvlO/DbfFjP3tRedPSNb3aD0QbeLv6bQSJScsVol92iZZmn1Ss3X9hieSGBsRDxkL8pudM5myA/HE0UAryf+TNLJ4U7mH4h+RI/9Qao++O5ZR4rXOLir/cbNGrw2MXbiWvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YUngYQoF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YUngYQoF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F17391F000FF;
	Wed, 30 Sep 2026 18:15:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790792126;
	bh=Pc+UvX4J6IV0VGZ3eeYUBp0cjk0LrEzVzrirI7gSx8E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YUngYQoFQOOt/CO6BIM8CRi2ab42mjMv5gJi7eIYubn7isKSESqCLOAJfS01dHMYb
	 nRcStswjKRPDGRmB3jSffSxdbdF36kTqDgQo/RBBFtx4BhwmB0BmG2jGoXtfEDyuuZ
	 5kt7PzVXavjOeIIhcEsuYiYTJpZQoJTfMiHOqYIA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20G=C3=B6ttsche?= <cgzones@googlemail.com>,
	Stephen Smalley <stephen.smalley.work@gmail.com>,
	Paul Moore <paul@paul-moore.com>
Subject: [PATCH 5.15 544/752] selinux: always fill AVC decision in avc_has_perm_noaudit()
Date: Wed, 30 Sep 2026 17:26:54 +0200
Message-ID: <20260930152410.019090195@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

From: Christian Göttsche <cgzones@googlemail.com>

commit 8861db305103107199b1426f25fde1fb6d465583 upstream.

avc_has_perm_noaudit() is documented to return a copy of the access
decision in @avd, but its early return for an empty requested permission
set leaves the buffer untouched.  All callers pass an uninitialized
stack variable and afterwards feed it to avc_audit(), and the inode hook
even stores it in the per-task decision cache.

Fill in a deny-all, audit-all decision, similar to avd_init(), so every
caller receives a defined value at no cost on the hot path.

Cc: stable@vger.kernel.org
Fixes: e6f2f381e4015386 ("selinux: replace BUG_ONs with WARN_ONs in avc.c")
Signed-off-by: Christian Göttsche <cgzones@googlemail.com>
Reviewed-by: Stephen Smalley <stephen.smalley.work@gmail.com>
Signed-off-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/selinux/avc.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/security/selinux/avc.c
+++ b/security/selinux/avc.c
@@ -1134,8 +1134,11 @@ inline int avc_has_perm_noaudit(struct s
 	int rc = 0;
 	u32 denied;
 
-	if (WARN_ON(!requested))
+	if (WARN_ON(!requested)) {
+		/* Provide a deny-all, audit-all decision to the caller. */
+		*avd = (struct av_decision){ .auditdeny = 0xffffffff };
 		return -EACCES;
+	}
 
 	rcu_read_lock();
 


