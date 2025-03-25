Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5C0C2571DC;
	Tue, 25 Mar 2025 12:28:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742905735; cv=none; b=Y1ZcelWGA8KxwPheYHXT2ANA7xQvvd8kC3Fhr9SthJf2dulCADEbrd8yrcisUGCHLa2IWgDV2GPd0i/8JIwlhfUqj0iFfHfFh3DYQ/Cz23qSyPMTCHSY/j/2ZhyE/JWSyAI3u2KENoF4sr4HflrGO0AVdvU3he2DPC0XxzUHmnc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742905735; c=relaxed/simple;
	bh=4ERosqTaKA8QP6JHdNiKZVrOx92E46px+ldOMay2L5A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pi4fJuTpOnLn4mUO8j82Go4sDFT0jsgyoMMXwXCnbmLyhZ0W19LN312daosXR2qmE2mY97fU25iNQjhpe9ZIUb1siueKPlmbLwZUj7Rwp7uRpIxTWloeG/2pAG9zsaSKgT5jLQozx/uyQKD4kGqfm+FpnRnoS28k/BvMzu84BFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RJMo0eDr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RJMo0eDr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89E41C4CEE4;
	Tue, 25 Mar 2025 12:28:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742905735;
	bh=4ERosqTaKA8QP6JHdNiKZVrOx92E46px+ldOMay2L5A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RJMo0eDrAW3bG/HKzf3C8Q4Z/yXHAXEv1YV+0yx+asNeVtibJb2um/Dwd3yXWOted
	 UK0kRHkBLmMO6nzFaQWJimhzA+0CfBBaP+N5J96mwPHwheebb6ErTvQilk0sEWOcgx
	 dQe9xeWxFk89fpPMGoxii1oEqr75l98J6NBKqfM4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Murad Masimov <m.masimov@mt-integration.ru>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 134/198] cifs: Fix integer overflow while processing acdirmax mount option
Date: Tue, 25 Mar 2025 08:21:36 -0400
Message-ID: <20250325122200.170729344@linuxfoundation.org>
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
index b9a47dd5db632..d2b9aca2b2790 100644
--- a/fs/smb/client/fs_context.c
+++ b/fs/smb/client/fs_context.c
@@ -1085,11 +1085,11 @@ static int smb3_fs_context_parse_param(struct fs_context *fc,
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



