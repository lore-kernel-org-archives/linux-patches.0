Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623844;
	b=DlZogDsLk8veXz9tH4k0ElGxWCMVbUkVo29sFl666cXyC1r/13Trtdwnlmr3lixINtG1
	 vV2TDRjGMLWwAEJ1hABIl0m1MJ9IznaDdxwOKu5bNNB26cSw0tHgOycQCbCK/pLoN9klD
	 N0KOK79DU4VyLrjRSHppgJvan0B7HhUcBv+dHPa+4jBDCWWGiPi3NBjlff46QnsAScIra
	 1k6uN0tjJpFy8X1VfckOnNtA2zK4Yxm+c+bx6lIhNMefBAKY1wFLOXWkQBSyr2BZt3m5X
	 RbF3yvMEkcanulUmfZ72WwZnEZubE18f0IE4IyyiNtIKKzR3yVnjD9/5jjgggBdKN8w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623844;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mL8TJ6WC014P+LHnJadjKV/AZevBEY+CcHl8FmIMAHE=;
	b=Q2MIxpYaTF6NBm/D+/ravauFiI589z2ZLd4T/nnBsndEKC4cfoyshQZVlQ5I4pw6W9ww
	 iMa0mcgTxUHEFQoQ+W4h9bV7LN4EhIMl+wwnulpsvvejSKeOYwQILhfoa7tMpKdo+0Ns0
	 FFYdmnWaoU7BOmv71DEEMH4pnFjwMRNXCBIhQr7qJ0O7jCgnfUcROwYbpPUote/qXetCI
	 e+VOoi2YBvTf7ynP0+cNyriiD7/SLuXzhxPRRiwzXaMvKg5oyn08K5xme9Ga2Gl85xXQa
	 hI9hWKLmZshBy5XUoOC7SJTFcoX/IPvFJBQkQeUlOoeSdUI8+6+3BJd74EIxBQG2JBg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nWPzGI9W;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93D86606A31E;
	Wed, 25 Nov 2026 16:24:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nWPzGI9W
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C62931F000C6;
	Wed, 25 Nov 2026 16:24:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623844;
	bh=mL8TJ6WC014P+LHnJadjKV/AZevBEY+CcHl8FmIMAHE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nWPzGI9WjQs6eEIzo1Ozvrz3TE8gQUbkABY1579DHXfnM+t/XHzbZVHqQ9SGvs+zt
	 j/+RaxoxhFbBjP9S+uv7z3l+jdg4mcuHRq9OioWEjg+E1Bx14dugrYihKOwMm+f2ts
	 N4y3n7BRysDCx+bU+sL/gyUSCK/vNdsu0wLBBPr0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pierre Barre <pierre@barre.sh>,
	Christian Schoenebeck <linux_oss@crudebyte.com>,
	Dominique Martinet <asmadeus@codewreck.org>
Subject: [PATCH 6.18 977/990] 9p: fix access mode flags being ORed instead of replaced
Date: Wed, 25 Nov 2026 15:39:04 +0100
Message-ID: <20261125143844.868459636@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -408,7 +408,11 @@ static void v9fs_apply_options(struct v9
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


