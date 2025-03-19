Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAC6E1DE3AA;
	Wed, 19 Mar 2025 14:39:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742395158; cv=none; b=I/Y3nVI2DXa23TRw8vFA0+XP+0vNTJl+M2prvp1Hl81UMIexDFoDx51rx+uRUj1DNT+MTjjXpLnThkH7ZjxYGUMxFkpl1d9/smeOR4GTQdI9NyE5wo1EpVt3jADmsn5FRRCKKldSL5q0cUHOVFw4D2Q0z5tsb4ZD7CrvU80g+ag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742395158; c=relaxed/simple;
	bh=hnz1EHSJSe5HTUBSZvHSpxwlRs86dOQ3DQaOVZP7uVg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sVvek408D8RoIxMxdMWGzrRamlFlwwdwLbRJAu5HcYpOUvoIMUNEhqqlg/JIbtfZRnKi5CYiyi+WPxAg6woOZg+mKMHDudSAG+Lz2Yd7fxTK72r0iDOpOR7ZbEvAWbYWG6ZVw0tspJfsKzjCNX8d6lHWanwpN+HyOvgdTqqQ73k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2BtNteVB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2BtNteVB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C268DC4CEE4;
	Wed, 19 Mar 2025 14:39:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742395157;
	bh=hnz1EHSJSe5HTUBSZvHSpxwlRs86dOQ3DQaOVZP7uVg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2BtNteVB6tuJkLRkFmzkXCGTZcgWQgAKh4lEf5DA3Vz3h6/Y+2Zwm6I7nV2evp2dI
	 cJusxsYgD83PS3JVvVxJyKP2oPMjJx/b39fkN05D55kueRmJlOrx1ZlZOyAWaPfTUL
	 irtRuwMunREkzircNJAxw0UHnQtALMcsKhNP1ups=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Murad Masimov <m.masimov@mt-integration.ru>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 216/231] cifs: Fix integer overflow while processing acdirmax mount option
Date: Wed, 19 Mar 2025 07:31:49 -0700
Message-ID: <20250319143032.183637248@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143026.865956961@linuxfoundation.org>
References: <20250319143026.865956961@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index e03946dc1d965..1b54287593298 100644
--- a/fs/smb/client/fs_context.c
+++ b/fs/smb/client/fs_context.c
@@ -1261,11 +1261,11 @@ static int smb3_fs_context_parse_param(struct fs_context *fc,
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



