Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 936262561C8;
	Tue, 25 Mar 2025 12:30:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742905811; cv=none; b=KJDOmLTC6k5H1j+cjx+gH/oXwgDsXa6bPHED0JbCscwml0+RURirBZZeJGkrZYKmb3nBmKH4eghfjKjMTa5U0VPIBAF/lBsBni3N9E2+THVUb4SARmLlvQXqua+iOyD8tQ+bJSpwL2YS9avnLfqodqFysfmG5nxJ5sSMz34iG+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742905811; c=relaxed/simple;
	bh=/q3Y45F6LdYG18NHlbMbxRnD0sk/mhhn0sQR7Bu9++E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PATzK0KWDbrijMSlDzhSlATbo9lrCccB3pjbLZ2Ht1Xn9+B6q2pvQ7w8SBhB/uNpl0qK3FgCbOXjfyHNqx91lHaibx13J/vZRqFxo76RKdxAzk2gflMtBI1thbD7onz9364ArWyUjmiOfNyCijTc4vyAdKxHwuSX0op8LFlntMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mFkcANXy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mFkcANXy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42690C4CEE4;
	Tue, 25 Mar 2025 12:30:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742905811;
	bh=/q3Y45F6LdYG18NHlbMbxRnD0sk/mhhn0sQR7Bu9++E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mFkcANXy1OK81mmu/ccuOo6CUvvJYA7UiWJuIQ1l/W31uPk0H6fAiHdEAAsMgct2b
	 LLCY5l84IoeL0QGp55v5G+Mo7z1x9r24b5ERR27ZU5AsSEbGYr+H0ZglquWkBY9trl
	 F888IXyFcRWSLby5J8dd6v0Wq791cqaQOmAuF4eU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Murad Masimov <m.masimov@mt-integration.ru>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 136/198] cifs: Fix integer overflow while processing closetimeo mount option
Date: Tue, 25 Mar 2025 08:21:38 -0400
Message-ID: <20250325122200.219871029@linuxfoundation.org>
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

[ Upstream commit d5a30fddfe2f2e540f6c43b59cf701809995faef ]

User-provided mount parameter closetimeo of type u32 is intended to have
an upper limit, but before it is validated, the value is converted from
seconds to jiffies which can lead to an integer overflow.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 5efdd9122eff ("smb3: allow deferred close timeout to be configurable")
Signed-off-by: Murad Masimov <m.masimov@mt-integration.ru>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/fs_context.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
index 76842fbd2bb83..de2366d05767f 100644
--- a/fs/smb/client/fs_context.c
+++ b/fs/smb/client/fs_context.c
@@ -1104,11 +1104,11 @@ static int smb3_fs_context_parse_param(struct fs_context *fc,
 		ctx->acdirmax = ctx->acregmax = HZ * result.uint_32;
 		break;
 	case Opt_closetimeo:
-		ctx->closetimeo = HZ * result.uint_32;
-		if (ctx->closetimeo > SMB3_MAX_DCLOSETIMEO) {
+		if (result.uint_32 > SMB3_MAX_DCLOSETIMEO / HZ) {
 			cifs_errorf(fc, "closetimeo too large\n");
 			goto cifs_parse_mount_err;
 		}
+		ctx->closetimeo = HZ * result.uint_32;
 		break;
 	case Opt_echo_interval:
 		ctx->echo_interval = result.uint_32;
-- 
2.39.5



