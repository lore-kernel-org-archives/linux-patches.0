Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBD7630FF30;
	Mon, 13 Oct 2025 15:06:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760367989; cv=none; b=n/tcUTVvmLd+mtfBJ5bDQ4YWwPrDzzokMYtNc4uaxwmo3kBGU60/GF/RdYXcK1xXEqu9E1+hPDHfO1PgMCqOANr7ISS0T/mAM/8mStulgK54br7KNtfMXk+rRppKDkPEaLaz8ys/rd598Hv13scLnknO6VBt391LQjgtuAnNlYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760367989; c=relaxed/simple;
	bh=9yfLDeOZuJ+B+e8UF2Z5xP/+Y9rmpOWy4E6EhTholps=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tIVKLaHE8+GFqWZNSuLOeNEbpPwu7oz2fSUnwO0gxcw27xsziYWHvfZDm2A6CInjfiU6DWKh3FB1noyCTlNI5raN2TCJ+07nzBz3EbIbG1XTxqsqy0gvJiWj2bN8lJdnWxSLhLayjCWWfjuJrY7yKbHHyGlbB7RjNYIaDXtBEPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lKelp33v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lKelp33v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5796CC4CEE7;
	Mon, 13 Oct 2025 15:06:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760367989;
	bh=9yfLDeOZuJ+B+e8UF2Z5xP/+Y9rmpOWy4E6EhTholps=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lKelp33v4G4UjSflSWTH4j+l1tbLRS83e77L7/x0I8E0KYU0uS67XO1ozzRHob6uB
	 Zctt3dXCqW4wY0sbkz/glKja/ZCGzGl6rvMePmgTSPILxvmoBq3DxvoE0An+IutxWA
	 lhLr32F94vzLmS+wzYYZzGYcS9pDzT7rISWIMMqg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matvey Kovalev <matvey.kovalev@ispras.ru>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.6 180/196] ksmbd: fix error code overwriting in smb2_get_info_filesystem()
Date: Mon, 13 Oct 2025 16:46:11 +0200
Message-ID: <20251013144321.819760298@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144315.184275491@linuxfoundation.org>
References: <20251013144315.184275491@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matvey Kovalev <matvey.kovalev@ispras.ru>

commit 88daf2f448aad05a2e6df738d66fe8b0cf85cee0 upstream.

If client doesn't negotiate with SMB3.1.1 POSIX Extensions,
then proper error code won't be returned due to overwriting.

Return error immediately.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: e2f34481b24db ("cifsd: add server-side procedures for SMB3")
Cc: stable@vger.kernel.org
Signed-off-by: Matvey Kovalev <matvey.kovalev@ispras.ru>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/smb2pdu.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -5596,7 +5596,8 @@ static int smb2_get_info_filesystem(stru
 
 		if (!work->tcon->posix_extensions) {
 			pr_err("client doesn't negotiate with SMB3.1.1 POSIX Extensions\n");
-			rc = -EOPNOTSUPP;
+			path_put(&path);
+			return -EOPNOTSUPP;
 		} else {
 			info = (struct filesystem_posix_info *)(rsp->Buffer);
 			info->OptimalTransferSize = cpu_to_le32(stfs.f_bsize);


