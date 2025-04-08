Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F326A19AD5C;
	Tue,  8 Apr 2025 11:40:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744112442; cv=none; b=rCStOcmkzftSoICzuXCzFHIg+B8gxQO/VeTKFV14elhl93SzmyqycmFvVoNzkpC0JyqdowZbKMLAzBSmMnwUGfhFJQWnRvCMvjx38GrkujHv+muS9UIPTSpVxMN4qvT7wjVVEs/xEqVAv8aSsMZNQlc4OZkdoG+Gz/PHiMa1gKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744112442; c=relaxed/simple;
	bh=g0PKZ+7E2n3Dy0faO/0pB6XO93E8pIzdbE66A9B8JbI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T0SZCqxevaCJIE0FWuSiQ+H8dhDVIn6Pww6Cqm5Rs4R1zHFnOs7acAY3FYasZlAgDkNU1SVxnOk6mKpBDC7XA9Rx/hKHcw3KKf5d/ygUP1qLLPwKj3pmaWgy2i85OKzcnBFlUsG5DMH+Ei6W13/7yNZk7F2ZzVBC2g3+zZWBhNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YF/Qc+5c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YF/Qc+5c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82AD1C4CEE5;
	Tue,  8 Apr 2025 11:40:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744112441;
	bh=g0PKZ+7E2n3Dy0faO/0pB6XO93E8pIzdbE66A9B8JbI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YF/Qc+5c4UHFzw7X2qG77m/rh8YMd8BhFbeojK7ZKGjrz2IsbAxVonFJ6NCSH/+KF
	 TOY+oY6Xy1sdnOYaikaW274cPgxAtm7fIT9gYXsHSpvjVLXEh+2Y84/QxWe6xXpbRW
	 57/GXcTfujdTCXoQlGY1dKJdDPiYr98T+WVHEzvc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Murad Masimov <m.masimov@mt-integration.ru>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 069/279] cifs: Fix integer overflow while processing acdirmax mount option
Date: Tue,  8 Apr 2025 12:47:32 +0200
Message-ID: <20250408104828.204477006@linuxfoundation.org>
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
 fs/cifs/fs_context.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/fs_context.c b/fs/cifs/fs_context.c
index d86cbed997fdd..9b1c0e0dfc63b 100644
--- a/fs/cifs/fs_context.c
+++ b/fs/cifs/fs_context.c
@@ -1062,11 +1062,11 @@ static int smb3_fs_context_parse_param(struct fs_context *fc,
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



