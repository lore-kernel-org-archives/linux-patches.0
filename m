Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDAE01C8618;
	Wed, 19 Mar 2025 14:36:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742394985; cv=none; b=VcyofTNe8/zlyBXV2x72/ndwMDKiujle9AUayg8TMSeX2nfci15r6pSkpAoCbyu/o/729WvybegkUDwBx3+G8PvHxfTjwkIM0lzA9jRPqqMjfwRQpt9lDh9Ui8c+QDT9f+KESRun6oaq3W+SI0E+JZDmKrZ8lAUYlbjMbCVUXRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742394985; c=relaxed/simple;
	bh=dAkLYV+QPBfjl1tRRr28vGJ9TMrCVC/9mHEncv8wzkw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UC8YUj9gpiMRFNQm9kouB490Ln2ZZL8VPvvggCqUzx3KQymxF1nQTIA1N9ZzadEYSwCiqGBZxXJDDUizbvMdEFVS+DijjpNc/xiUPblRohRwVk8mg51WdzXaE1M9oK6e9wmjO110TkMhBtFgZV54iDmGaqCFIdXlTOpbI8OT06k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=11psIZaj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="11psIZaj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82F3FC4CEE8;
	Wed, 19 Mar 2025 14:36:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742394985;
	bh=dAkLYV+QPBfjl1tRRr28vGJ9TMrCVC/9mHEncv8wzkw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=11psIZajDE5R7c1xQ99A6+XNgB5v4+09a+T4aoTYnWkoV1U3iy2rkmG2LLCVkxC+s
	 vPWUfr0Y7E9DYoF30V+HwxpNg6NWaCfaqttfh/2oOR8CMXtKCRCiN4yQhcHL13MxN6
	 JF47Dnr8u8a8MGPxmW24VBUujQu8XMWIgPAuFL1g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Murad Masimov <m.masimov@mt-integration.ru>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 225/241] cifs: Fix integer overflow while processing acdirmax mount option
Date: Wed, 19 Mar 2025 07:31:35 -0700
Message-ID: <20250319143033.313408929@linuxfoundation.org>
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

[ Upstream commit 5b29891f91dfb8758baf1e2217bef4b16b2b165b ]

User-provided mount parameter acdirmax of type u32 is intended to have
an upper limit, but before it is validated, the value is converted from
seconds to jiffies which can lead to an integer overflow.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 4c9f948142a5 ("cifs: Add new mount parameter "acdirmax" to allow caching directory metadata")
Signed-off-by: Murad Masimov <m.masimov@mt-integration.ru>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/fs_context.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
index 0fae0afa12626..6d7091ddec16e 100644
--- a/fs/smb/client/fs_context.c
+++ b/fs/smb/client/fs_context.c
@@ -1291,11 +1291,11 @@ static int smb3_fs_context_parse_param(struct fs_context *fc,
 		ctx->acregmax = HZ * result.uint_32;
 		break;
 	case Opt_acdirmax:
-		ctx->acdirmax = HZ * result.uint_32;
-		if (ctx->acdirmax > CIFS_MAX_ACTIMEO) {
+		if (result.uint_32 > CIFS_MAX_ACTIMEO / HZ) {
 			cifs_errorf(fc, "acdirmax too large\n");
 			goto cifs_parse_mount_err;
 		}
+		ctx->acdirmax = HZ * result.uint_32;
 		break;
 	case Opt_actimeo:
 		if (HZ * result.uint_32 > CIFS_MAX_ACTIMEO) {
-- 
2.39.5



