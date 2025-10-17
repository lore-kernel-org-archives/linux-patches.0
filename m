Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4640330B06;
	Fri, 17 Oct 2025 15:56:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760716567; cv=none; b=rt5JxOz5G0dowY7x5GL+VvIgrJip4+XBOewl4PuOQHPlk3Fp5A9G+6pVwFojKcrUR9TU4KjvljF15Itn81rAIonU4dciwT5PFTP61tIOefCBy8F9wWPNJgknT3G/zcLXaqhlkP2AUCiOHagA9meSue2aUiNPrZ9dH/1Gvy9vUAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760716567; c=relaxed/simple;
	bh=7x9QzPtvqOEK93ueLpz6jfyNAxoiadqxq9dxi5giihg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D/KKCWs1D9CS+NIKFexU2dOOzRfd5xs7O14l/XXxZotvbVimixKE2bn/hic03yW5jWdIC0QJTr/olP/0Ls6u1DMCe9oEwn1iJktNBqtGu0wRVqhefpDyD2nqbPJ9ayh/NuWl+G46Lo+a+drmle/KZIcczlBxAhUWW0c4ZR10k8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mTKtEhvj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mTKtEhvj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBB53C4CEFE;
	Fri, 17 Oct 2025 15:56:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760716567;
	bh=7x9QzPtvqOEK93ueLpz6jfyNAxoiadqxq9dxi5giihg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mTKtEhvjaOsGPTko5AmqXYkvPmIB3PoL/XekyqeZwKctk/cs7OCnRC2WHo6SCLJcd
	 dMCxsiScHcVf5eLoDFL1f/DRRPn+ffq9zjm5ZO8TgwIiZqzW38Lk45O5tWnFz2S5y0
	 tLe8vhYp8L0uROKbjdsHXmXY8hGLi5iec6X/j2Iw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matvey Kovalev <matvey.kovalev@ispras.ru>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 235/276] ksmbd: fix error code overwriting in smb2_get_info_filesystem()
Date: Fri, 17 Oct 2025 16:55:28 +0200
Message-ID: <20251017145151.046730557@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145142.382145055@linuxfoundation.org>
References: <20251017145142.382145055@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matvey Kovalev <matvey.kovalev@ispras.ru>

[ Upstream commit 88daf2f448aad05a2e6df738d66fe8b0cf85cee0 ]

If client doesn't negotiate with SMB3.1.1 POSIX Extensions,
then proper error code won't be returned due to overwriting.

Return error immediately.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: e2f34481b24db ("cifsd: add server-side procedures for SMB3")
Cc: stable@vger.kernel.org
Signed-off-by: Matvey Kovalev <matvey.kovalev@ispras.ru>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
[ adjusted file path from fs/smb/server/smb2pdu.c to fs/ksmbd/smb2pdu.c ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ksmbd/smb2pdu.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -5204,7 +5204,8 @@ static int smb2_get_info_filesystem(stru
 
 		if (!work->tcon->posix_extensions) {
 			pr_err("client doesn't negotiate with SMB3.1.1 POSIX Extensions\n");
-			rc = -EOPNOTSUPP;
+			path_put(&path);
+			return -EOPNOTSUPP;
 		} else {
 			info = (struct filesystem_posix_info *)(rsp->Buffer);
 			info->OptimalTransferSize = cpu_to_le32(stfs.f_bsize);


