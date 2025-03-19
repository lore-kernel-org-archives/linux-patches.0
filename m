Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEA5B20468F;
	Wed, 19 Mar 2025 14:36:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742394985; cv=none; b=GyqXYTXPSppR621szeFu5q72oBCX/4MY3Ky5gkIeEK4JIVCeTOTRenN4zbLC9SMESZ+AGKAWKytgbBU6LNJ9LcoEtZ8FkbqVTfNrrUyN8gceWbSXps2y5aGtzpJBRCQCp0dUV0wbsY8+O035itgc/4Ycyh6BP5Qe76xQP/5EQfM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742394985; c=relaxed/simple;
	bh=QtJkF/b54DUQq0aonzSGbQConOnqmTz+lAnluJ91hPQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YDsaqRd9Rjv1nsKcSk0fw5C5yys4bWc41DKqnm+IlUBIl358SIXCZGzFcO3kH9BWoO/wWWrSy8kEri5sLGZun4fLKtbGQDrT2gXWAlLUL6OzwVQeMBgiasXe4H8QUVsfDHg69/1hBsWmqLANsvzoRLGDXMLqH4L9YlEodN9qY1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T7uyZexK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T7uyZexK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B160BC4CEE8;
	Wed, 19 Mar 2025 14:36:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742394984;
	bh=QtJkF/b54DUQq0aonzSGbQConOnqmTz+lAnluJ91hPQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T7uyZexKSnIScXz6YkALyeAWMhXCpY1gXMh314PY8qUpU0PRnAtXRrwkwmARH4qxj
	 HZoTCmY5VAWOe/8fsSS5jEzUxcwhgPOF42/MhFgd0alHPfpQZMlbdqyrRviT6JUXSH
	 N0GWi2+avVSPVE++M5uoZsjbUkbhIjqI+Kwcl6a4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Murad Masimov <m.masimov@mt-integration.ru>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 224/241] cifs: Fix integer overflow while processing acregmax mount option
Date: Wed, 19 Mar 2025 07:31:34 -0700
Message-ID: <20250319143033.289098363@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143027.685727358@linuxfoundation.org>
References: <20250319143027.685727358@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
 fs/smb/client/fs_context.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
index 2d307dd03fbc4..0fae0afa12626 100644
--- a/fs/smb/client/fs_context.c
+++ b/fs/smb/client/fs_context.c
@@ -1284,11 +1284,11 @@ static int smb3_fs_context_parse_param(struct fs_context *fc,
 		}
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



