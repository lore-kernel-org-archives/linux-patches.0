Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4776938E8CE;
	Wed, 30 Sep 2026 18:07:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790791657; cv=none; b=CI3DuqBLNB1gpqBFyOECUPVhYMV23Xv8DMh7bwv8bQFeE5eSmJiJxYpHIHjc+UlGxuvIxnueN/a92ezftuONPgoOlv6VU3WzblF/7r0BC3ENKihsddRR1smQ80hBHXLd6SbkXWan3ho9VvEjSpUMbP6y+8Xx4E3uf+LT4vOuppE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790791657; c=relaxed/simple;
	bh=GyU+H3tHVqEVXzoiQ8wTKNg48QdF6PZmtj90zl33vAc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T6SN/cbf14z1J8p1TTeMULMz6mr0ScSIDUMP8jK7pXrx/2RNENCtWUn3AiWDmA61vTazUuls7PbjbnJoMjucuK45Op+ZXp9+kPMiosrgmoHhhbx29Bsnja1vNHjZvpchlQx89gRAYSY5GD7afpnIy46js9sxOciuR84W2/akS84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ugZPEYVl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ugZPEYVl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46C2D1F000FF;
	Wed, 30 Sep 2026 18:07:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790791655;
	bh=DqtOdqsWAIBVvofteeW/BwM0hUOGVlT+//nHEQfI0Us=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ugZPEYVlAQ4SdqBzv3V0pDoAzqc0WfW5AB+9RFZTYt1oXe9wI3Xyrdw4BJoeSHS1I
	 fTc6zMDFKfTAcmi4/DfziLs1KL5qTsVWM1Q9nZEgpuLRuEe42va4uOfQPyN4PLjb8j
	 0wfFkdo1zUrirrWCfCu8flLNpa1tcqwOXU2nLe5M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tianchu Chen <flynnnchen@tencent.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.15 380/752] ASoC: sprd: validate compress buffer sizes against fixed allocations
Date: Wed, 30 Sep 2026 17:24:10 +0200
Message-ID: <20260930152406.499149436@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


