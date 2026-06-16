Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A9153AB267;
	Tue, 16 Jun 2026 15:37:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781624280; cv=none; b=Oh85WOxe9rBvjeAU9rgl2widfEDMWzvHzsBJvCmswEOCYsEuNu+lZt1eBQLPgbYWAq/co99/5hbYUAP9OGvciFiuyMs/izAzmPnWnkvmLhJxZCmXl+HCjcYqkTCCB5vzOLVU1mWqYu/iVPZ0kF1xiwXxbQHLRhTiPApycFbapp0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781624280; c=relaxed/simple;
	bh=6khjy8biSSEKDje9UZ1h4ztOefqZreKmZzbkpSVux4g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RessxIGEZOZqDw7HEKy8XJjs/G8VkMNEKJL2qHHfEqkucobYOmVS3x0Ia89wYRbtvYHVfARuKVIAoxQviib7u3+3v2vDm6iAhpKtFcmOsuFma5OtjiYLEXT68ghwJbg7zrHzRuUfUHDxhqI+jRIIunlyuGwESfwxJUPer3X9EIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eT2KDIPQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eT2KDIPQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36D471F000E9;
	Tue, 16 Jun 2026 15:37:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781624279;
	bh=DVpsSqBhwprGGptwq3xu9/CtG23uTHeWoQYMVayvcME=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eT2KDIPQMvGmzLN81PJCLg05MLgViLaqPnCWQfIhfqw/+36H9dZqulaG2yzD/9u5f
	 +Yvp96CKFd6yf3yUgZ5YSV530BdAgBb15pwZWDFAQpjyGONvtj5OQjfGLwniwGQjRW
	 ntNeesP828MC/MhTbei02MSWc36eqPNLAiuedv18=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muhammad Bilal <meatuni001@gmail.com>,
	"Rob Herring (Arm)" <robh@kernel.org>
Subject: [PATCH 7.0 263/378] accel/ethosu: reject DMA commands with uninitialized length
Date: Tue, 16 Jun 2026 20:28:14 +0530
Message-ID: <20260616145123.928018699@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145109.744539446@linuxfoundation.org>
References: <20260616145109.744539446@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Muhammad Bilal <meatuni001@gmail.com>

commit d9d021218162b6c4fe0bdf42b2b340f1aae23a12 upstream.

cmd_state_init() initializes the command state with memset(0xff),
leaving dma->len at U64_MAX to signal missing setup. The only setter
is NPU_SET_DMA0_LEN; if userspace omits this command and issues
NPU_OP_DMA_START, dma->len remains U64_MAX.

In dma_length(), a positive stride added to U64_MAX wraps to a small
value. With size0 == 1, check_mul_overflow() does not trigger and
dma_length() returns 0 instead of U64_MAX. The caller's U64_MAX check
then passes, region_size[] stays 0, and the bounds check in
ethosu_job.c is bypassed, allowing hardware to execute DMA with stale
physical addresses.

Fix by checking for U64_MAX at the start of dma_length() before any
arithmetic, consistent with the sentinel value used throughout the
driver to detect uninitialized fields.

Fixes: 5a5e9c0228e6 ("accel: Add Arm Ethos-U NPU driver")
Cc: stable@vger.kernel.org
Signed-off-by: Muhammad Bilal <meatuni001@gmail.com>
Link: https://patch.msgid.link/20260524130319.12747-1-meatuni001@gmail.com
Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/accel/ethosu/ethosu_gem.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/accel/ethosu/ethosu_gem.c
+++ b/drivers/accel/ethosu/ethosu_gem.c
@@ -164,6 +164,9 @@ static u64 dma_length(struct ethosu_vali
 	s8 mode = dma_st->mode;
 	u64 len = dma->len;
 
+	if (len == U64_MAX)
+		return U64_MAX;
+
 	if (mode >= 1) {
 		if (dma->stride[0] < 0 && (u64)(-dma->stride[0]) > len)
 			return U64_MAX;


