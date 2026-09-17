Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 700063BD65D;
	Thu, 17 Sep 2026 18:49:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789670976; cv=none; b=oaqi/ClurvsY5CNacR1/35BHDI/PAiaELXy3KudZpCq2Z0ewoRD609LBIyZvkRlNvVIOJRVp/bpLSoPhOEeXiKIDqv0IkVbr8TO7y+Nrt/IcYd5okWF+UCVXCo5bzoaCynOvrEwuwX15MEFOZLZj/HilRKq/NylwnCzsLczGKxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789670976; c=relaxed/simple;
	bh=S+JcA0LymLdV4t6DKg9iOKhcu3YOSNFzbA360CdJCu4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cnsgou9BCb7V0MqVES2bBOFKaWwXxbYwyGtrb6nhjyXxfe9Knr/tni8gyp75HMaSjrjhcXFaJg7i+qBvVCKsb7z0goHVsAiNTdSevFOg1EC/DhM4apFMXyU1rLTmi+qUnDaqn8tEHTn+tHVRCjH3rZwia87QjgZKsD7eWl9evG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FgU8bqRu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FgU8bqRu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF3F21F000FF;
	Thu, 17 Sep 2026 18:49:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789670975;
	bh=QoPeG6ftk8g42k61rQBph0WhirFnNnCZFl34r3N02+s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FgU8bqRujZZXfzGGciRRcakcdKkLxfTZaapWDP/ADsmu1e2UwGmZ7S8WPdnwkSiCx
	 dvcVWf2KAbhMo/a+Dvp/fuBLFZ7nP3IOZkhaWvqzCkqU0d4nQYaLl5YHKygkK4hFjp
	 YtzJs132vvSg96sPhFmOSKuBlCZscZMnPKe0Wy3c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tianchu Chen <flynnnchen@tencent.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.12 0828/1102] ASoC: sprd: validate compress buffer sizes against fixed allocations
Date: Thu, 17 Sep 2026 16:12:51 +0100
Message-ID: <20260917151601.297033891@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


