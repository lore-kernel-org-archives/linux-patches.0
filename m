Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03A922571DC;
	Tue, 25 Mar 2025 12:28:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742905734; cv=none; b=D2g0/fCCuoGRCpKAJueX2ptikSqFrftwhyQcTkvQW4OifSXkSoMVb0YqCLuJjMwF6afK7KYGTYv5a1l1JFzzderK8ompb2HPO9W4cOP4No0zMsvP/sNBxZNah4MINS3EAAH+FrJjh2uQggCTmMSjlnqfO8ofzRxTLToLA1Cu5Sw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742905734; c=relaxed/simple;
	bh=pfcC5D0z4d56x5t7Sj9a7GUWj5Cqsu/Ew2GpYCCXE24=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QOUMYDQ7o4yAJK0kJcVNGX8xod3Rd5YTxxGhNKPqlrspNe083a4XrLhp0ZWyTFBhpBMbD8GvLnO+6bWKU/nRZUgO+VQavH7xajHlJAU/psH69J+QYJ5x0/2JaWqamMkmrZS6sTPb5RVXQo3oLjBoXeErm2J1uxY6KzXVbCsTzNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rn+fCeRX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rn+fCeRX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC8EEC4CEE9;
	Tue, 25 Mar 2025 12:28:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742905733;
	bh=pfcC5D0z4d56x5t7Sj9a7GUWj5Cqsu/Ew2GpYCCXE24=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rn+fCeRX/0hPZ1Z3CLVrK8wiY4GGEtunGwdjTlAzT9gOsEWGFERxETLYE+hwRON6m
	 h5u9LHZODSUDfFh1/z5yBi1/GaGbuiYhYz+aNgfvory6DfK+bRqW52m5ty4eJ8jngH
	 ztVHkwf25QWvSb3y0hqySaYU+8dDZ2kZ2VLqnK9M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Murad Masimov <m.masimov@mt-integration.ru>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 133/198] cifs: Fix integer overflow while processing acregmax mount option
Date: Tue, 25 Mar 2025 08:21:35 -0400
Message-ID: <20250325122200.143151392@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122156.633329074@linuxfoundation.org>
References: <20250325122156.633329074@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index ca39d01077cdf..b9a47dd5db632 100644
--- a/fs/smb/client/fs_context.c
+++ b/fs/smb/client/fs_context.c
@@ -1078,11 +1078,11 @@ static int smb3_fs_context_parse_param(struct fs_context *fc,
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



