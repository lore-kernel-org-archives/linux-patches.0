Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795626376;
	b=ksOSkyfwyLzrDe2A7/LySIRUFNJwA2JMA7E2eKbdjoC8h5rrTyvmCmyUf27y+sMmWakV
	 qVnsFIkgMRHXlhRUEkwednfGIevw031NWIROHrO/KNV4i3TN1DStHPJdUZqlpkCmdH5o6
	 zryzUYci7ilLm+hqxN2WYwZsKgABgnlbWiB2KYUz/g2lBfMB39PPCY7mGST2VhIe2OWwD
	 bQamUeSJiYsUKPWU5XKFM6OAPZezffHi2tZsqrhveKaJtgbAkxAlqNnoZfQH8bElzsXvI
	 PCGWilkaEh4SUI7sDR8ZUepl8gVHe370QxJ10U0mXIB9yGeincCOSbejlNFf/4ZKR5g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795626376;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DkFv3V4y/mpZktNUcvMvxvbYueyN8ZONTI1cEbuDn+I=;
	b=wmTmkIbK2lBttlErC4cxkpBNoMquR9CuCSGU/eEeAhHG4EEHQ7GKGhYXl9U4ZyGAtPYy
	 JQyNulWCTknBWOrZa9Qeg53dE9EWX10o8WIFCZprVaFHijcO2XpJd/et5EathiTjbU8gv
	 UYgItx+2684qSCQDqnEgtcNgkoW+AJQ1L06rbYicJCqaBQ4/2fjDuQG9Z15mhG1ju/iBm
	 snSt5dZzXteyyF7zXzBrPJfOrXG2wiBYRTYA6feP2F5NWOiDfI8C1ra1+aixJmSzy3xGk
	 /Pvt2yFaGVQaBKWZ0C4UeP3JiwX6Hqbqnksm0kbY9KfmkNy4cHRsXt2+uRqljWtXU7A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xlA1u4C3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7A37606A32D;
	Wed, 25 Nov 2026 17:06:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xlA1u4C3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15F761F000C6;
	Wed, 25 Nov 2026 17:06:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795626376;
	bh=DkFv3V4y/mpZktNUcvMvxvbYueyN8ZONTI1cEbuDn+I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xlA1u4C3wOLw1cgymP+w2kVPdKC0KuM+Z4UCKTkqNKfv3MSYVj4H/w7zxAVpbXSXY
	 rEMaxZ7Wj4YvKQHkOkYJKdaPeGHDSrGEEhTAIA3UCI7+Z0yozoDbaBBnPYY5YMTh77
	 xHzAazC08sl8IfAyWkQcNmYaOrebgq3NXmHGj2Sw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pierre Barre <pierre@barre.sh>,
	Christian Schoenebeck <linux_oss@crudebyte.com>,
	Dominique Martinet <asmadeus@codewreck.org>
Subject: [PATCH 6.12 808/816] 9p: fix access mode flags being ORed instead of replaced
Date: Wed, 25 Nov 2026 15:39:16 +0100
Message-ID: <20261125143907.872505308@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pierre Barre <pierre@barre.sh>

commit da2346a48a5a1fed86c3fe3d73c0b60e7b3027c9 upstream.

Since commit 1f3e4142c0eb ("9p: convert to the new mount API"),
v9fs_apply_options() applies parsed mount flags with |= onto flags
already set by v9fs_session_init(). For 9P2000.L, session_init sets
V9FS_ACCESS_CLIENT as the default, so when the user mounts with
"access=user", both bits end up set. Access mode checks compare
against exact values, so having both bits set matches neither mode.

This causes v9fs_fid_lookup() to fall through to the default switch
case, using INVALID_UID (nobody/65534) instead of current_fsuid()
for all fid lookups. Root is then unable to chown or perform other
privileged operations.

Fix by clearing the access mask before applying the user's choice.

Fixes: 1f3e4142c0eb ("9p: convert to the new mount API")
Signed-off-by: Pierre Barre <pierre@barre.sh>
Reviewed-by: Christian Schoenebeck <linux_oss@crudebyte.com>
Message-ID: <0ddc72da-d196-4f01-8755-0086f670e779@app.fastmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/9p/v9fs.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/fs/9p/v9fs.c
+++ b/fs/9p/v9fs.c
@@ -394,7 +394,11 @@ static void v9fs_apply_options(struct v9
 	/*
 	 * Note that we must |= flags here as session_init already
 	 * set basic flags. This adds in flags from parsed options.
+	 * Default access flags must be cleared if session options
+	 * changes them to avoid mangling the setting.
 	 */
+	if (ctx->session_opts.flags & V9FS_ACCESS_MASK)
+		v9ses->flags &= ~V9FS_ACCESS_MASK;
 	v9ses->flags |= ctx->session_opts.flags;
 #ifdef CONFIG_9P_FSCACHE
 	v9ses->cachetag = ctx->session_opts.cachetag;


