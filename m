Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FFE8219301;
	Tue,  8 Apr 2025 11:40:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744112439; cv=none; b=YM0nIlnh1B4ysu+VG0H1bCOVKAjt8ge/vGODvAUT/Qsrj2fFPJ1b8hGHkd+mIGdeHrMDrpWQBwLC4ERmolGCSNNXl2Ypt139NohDTdjKx24mDffk3ZCWNjEolo7x8gcTdvD+55FAbNdEv8gVyRpkKper0GoDypIX5UVuVWI3O50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744112439; c=relaxed/simple;
	bh=LjK27GKHtyQCL6Gfv5Kx5AuZs2L/CKjQHiZTUVqqw7w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PBqxxFdx2D/85IFFymRqIiiol71dx5A3/KWIgAFedeMtVu7d+F+e4A7BUAa5frWp5MUaH7hoCG5kJOOvQdS+J02t2SI3uwCulJR0UBjeBPSa/p+FqJfujYjzTaGa0SO1yL8tyS3wPq/70iCJwpYqPwgZ2CSCXb0U6SP0dm3TlMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UrDcgAh5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UrDcgAh5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C47E5C4CEE5;
	Tue,  8 Apr 2025 11:40:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744112439;
	bh=LjK27GKHtyQCL6Gfv5Kx5AuZs2L/CKjQHiZTUVqqw7w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UrDcgAh5dosp7cQAEs48rz5lKOLjE3XBftVE28whCjvlqZQHZk5NvLg0gNZCGdo/F
	 LUUn7sxPVEeEAFwToa+0XBoioFXKH491X5iTRKXyjrNxWEP+bSEm8y1Bj5zKLVJTiC
	 qTrc4MmQddh2sN+sNXZrMTM49bRlouDf5FzqI+gA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Murad Masimov <m.masimov@mt-integration.ru>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 068/279] cifs: Fix integer overflow while processing acregmax mount option
Date: Tue,  8 Apr 2025 12:47:31 +0200
Message-ID: <20250408104828.178707294@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104826.319283234@linuxfoundation.org>
References: <20250408104826.319283234@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Murad Masimov <m.masimov@mt-integration.ru>

[ Upstream commit 7489161b1852390b4413d57f2457cd40b34da6cc ]

User-provided mount parameter acregmax of type u32 is intended to have
an upper limit, but before it is validated, the value is converted from
seconds to jiffies which can lead to an integer overflow.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 5780464614f6 ("cifs: Add new parameter "acregmax" for distinct file and directory metadata timeout")
Signed-off-by: Murad Masimov <m.masimov@mt-integration.ru>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/fs_context.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/fs_context.c b/fs/cifs/fs_context.c
index fb3651513f83a..d86cbed997fdd 100644
--- a/fs/cifs/fs_context.c
+++ b/fs/cifs/fs_context.c
@@ -1055,11 +1055,11 @@ static int smb3_fs_context_parse_param(struct fs_context *fc,
 		ctx->got_wsize = true;
 		break;
 	case Opt_acregmax:
-		ctx->acregmax = HZ * result.uint_32;
-		if (ctx->acregmax > CIFS_MAX_ACTIMEO) {
+		if (result.uint_32 > CIFS_MAX_ACTIMEO / HZ) {
 			cifs_errorf(fc, "acregmax too large\n");
 			goto cifs_parse_mount_err;
 		}
+		ctx->acregmax = HZ * result.uint_32;
 		break;
 	case Opt_acdirmax:
 		ctx->acdirmax = HZ * result.uint_32;
-- 
2.39.5



