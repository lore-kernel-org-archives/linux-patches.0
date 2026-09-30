Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56867357CE0;
	Wed, 30 Sep 2026 19:15:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790795729; cv=none; b=uON3qKeOjx87yqZL1wMZLYtK9SzqZl55AHaj6fuq/fMiqOeOgoG09N5Um9Z2W2x8TXnNdb4VUpx3UsyrQc40EF0VPTI8jUO1WkpxszndqD8KA5nBvfb3g+cD2fJa4BqTwdokgxg+0GeTCMispWmNp0LjBhLWhFD0GXne9m03EJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790795729; c=relaxed/simple;
	bh=4OzYuZEv/vh9R75kgNVZbt8Qdr6e/hl2knZiu+VRPzY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tjv4yytvOO6dstDB0hBN/o57RP230ZTa5b4NzxhXORB8ZHVrPLDKDB3BYBAjukIDA4q8zHvV5cMABQy9mRSHTweA9WtY+CLG9xrbKnj2R4tE8zq7ztSzMVFMJ4sK4R3M2m2n/mk3IXTUBnPVPZAue82ghawCpW5OgriJfHWsMOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KUxftjJf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KUxftjJf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D7A41F000FF;
	Wed, 30 Sep 2026 19:15:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790795728;
	bh=gj4WFcFOa2GKehTaQSh5P1b96mI/0TfCC9YtHanUoRs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KUxftjJfDsZ4suVD/wXZJ3l3YpdRPJ/BXoFZn3fipYHFLmWTY31X3dEHeULipCyvw
	 b4aJfXAuIWkOABrHWUJZlsg5Z/k6Sw7NigdHdNVkUPTH+yjfgWPKiZqM1Wqnmf/Ab3
	 OZ/k17fHCVVTAO1d7MmA2KseU3AtbnzcgrxKC08s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tianchu Chen <flynnnchen@tencent.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.6 0617/1193] ASoC: sprd: validate compress buffer sizes against fixed allocations
Date: Wed, 30 Sep 2026 17:21:41 +0200
Message-ID: <20260930152447.954361576@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

From: Tianchu Chen <flynnnchen@tencent.com>

commit 7a4ce92d150b9e7ecf1a710a34d8cdeb590d3751 upstream.

sprd_platform_compr_open() allocates the stage 0 IRAM buffer (32K data
area) and the stage 1 DDR buffer (2M data area) with fixed sizes, but
sprd_platform_compr_copy() derives all copy lengths from the user
controlled runtime->fragment_size and the write() count, never
comparing them against the physical buffer sizes. The compress core
only checks fragment_size * fragments for an u32 overflow in
snd_compress_check_input(), so a local user can configure a logical
buffer of up to ~4GB via SNDRV_COMPRESS_SET_PARAMS, far exceeding the
fixed allocations.

A fragment_size larger than the 32K IRAM data area makes the stage 0
copy_from_user() overflow past the IRAM allocation, and a buffer_size
larger than the 2M DDR buffer makes the wrapping copy at the end of
sprd_platform_compr_copy() write fully user controlled data past the
buffer. No SNDRV_PCM_TRIGGER_START is needed, a write() in SETUP
state reaches the copy callback directly.

Reject parameters that do not fit into the fixed buffers in
set_params(), and fix the advertised max fragment size: 128K never
fitted into the 32K IRAM buffer. The caps values may have been carried over
from the qdsp6 driver, which allocates its buffers according to the
advertised maxima, unlike this driver. With 32K as max fragment size
the advertised limits are self-consistent: 32K * 64 = 2M equals the
DDR buffer size.

Discovered by Atuin - Automated Vulnerability Discovery Engine.

Fixes: cce1396936ef ("ASoC: sprd: Add Spreadtrum audio compress offload support")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Tianchu Chen <flynnnchen@tencent.com>
Link: https://patch.msgid.link/4386bc53631b052c1866a91061715b009d98b04f@linux.dev
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/sprd/sprd-pcm-compress.c |   15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

--- a/sound/soc/sprd/sprd-pcm-compress.c
+++ b/sound/soc/sprd/sprd-pcm-compress.c
@@ -17,7 +17,7 @@
 
 /* Default values if userspace does not set */
 #define SPRD_COMPR_MIN_FRAGMENT_SIZE	SZ_8K
-#define SPRD_COMPR_MAX_FRAGMENT_SIZE	SZ_128K
+#define SPRD_COMPR_MAX_FRAGMENT_SIZE	SZ_32K
 #define SPRD_COMPR_MIN_NUM_FRAGMENTS	4
 #define SPRD_COMPR_MAX_NUM_FRAGMENTS	64
 
@@ -272,6 +272,19 @@ static int sprd_platform_compr_set_param
 	int ret;
 
 	/*
+	 * The stage 0 IRAM buffer and the stage 1 DDR buffer are allocated
+	 * with fixed sizes at open time, so the requested fragment size and
+	 * fragments must fit into them, otherwise sprd_platform_compr_copy()
+	 * would overflow the buffers. Note the compress core only checks the
+	 * fragment size and fragments against an u32 overflow, not against
+	 * the buffer sizes advertised by get_caps.
+	 */
+	if (params->buffer.fragment_size > SPRD_COMPR_IRAM_BUF_SIZE ||
+	    (u64)params->buffer.fragment_size * params->buffer.fragments >
+	    SPRD_COMPR_AREA_BUF_SIZE)
+		return -EINVAL;
+
+	/*
 	 * Configure the DMA engine 2-stage transfer mode. Channel 1 set as the
 	 * destination channel, and channel 0 set as the source channel, that
 	 * means once the source channel's transaction is done, it will trigger


