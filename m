Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D9991C68B1;
	Tue, 27 Aug 2024 15:02:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724770969; cv=none; b=sOcOZo/zrJw+GY0Uecf0KOxARJR4Lu8p3TvSoO1KrW4NYTFVWjh1MUGJ/lUYhOblHwIYJNTkVGTvabCQrN8MO8ptIN1Kkv/4Avmwz+LunegrloADV2tFzYiCS6Fl1DlxTbj/q3GxK/6AK2IC7vNWMdiCyW1dphUaNIzidMQqVHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724770969; c=relaxed/simple;
	bh=AJG7MIXzwFc9igr6NqUgNQNbDESdJ8/bn3bSE+qQlgM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HU+w7HrKPdmjy36j2bQ10fqtYYLhF4UmrSo4T49zpdEuwWnwqCAJYS2qfcdo7D+o3bZ71xABf2/S6pFYvo9Rj6tLGT0t7Q6DF/XQzZLzg4NVRzwdaM+1aSmyVZzSCcGKWKKhhduIKIt78hN1sh9nJApgVSImRPbGRWBb1/VKjQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lAPP5z5x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lAPP5z5x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 959D8C61042;
	Tue, 27 Aug 2024 15:02:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724770969;
	bh=AJG7MIXzwFc9igr6NqUgNQNbDESdJ8/bn3bSE+qQlgM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lAPP5z5xFFBj56T+RsnCD79fYN8NN2pRINI1k79zrsrr/1LlpO9+VUyRh0eON7EnR
	 UxYY3mCsoqxDDluMpaxAfv0TxxYWyOoHy0DTCPiP5d+u3JAjKJUEiGmVoLdaxfzIvZ
	 8sv3wuMG7EPLZWX3E4KQTjh86vGdpTn6XUlhyiW8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: [PATCH 6.10 047/273] media: atomisp: Fix streaming no longer working on BYT / ISP2400 devices
Date: Tue, 27 Aug 2024 16:36:11 +0200
Message-ID: <20240827143835.188966668@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143833.371588371@linuxfoundation.org>
References: <20240827143833.371588371@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

commit 63de936b513f7a9ce559194d3269ac291f4f4662 upstream.

Commit a0821ca14bb8 ("media: atomisp: Remove test pattern generator (TPG)
support") broke BYT support because it removed a seemingly unused field
from struct sh_css_sp_config and a seemingly unused value from enum
ia_css_input_mode.

But these are part of the ABI between the kernel and firmware on ISP2400
and this part of the TPG support removal changes broke ISP2400 support.

ISP2401 support was not affected because on ISP2401 only a part of
struct sh_css_sp_config is used.

Restore the removed field and enum value to fix this.

Fixes: a0821ca14bb8 ("media: atomisp: Remove test pattern generator (TPG) support")
Cc: stable@vger.kernel.org
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/media/atomisp/pci/ia_css_stream_public.h |    8 ++++--
 drivers/staging/media/atomisp/pci/sh_css_internal.h      |   19 ++++++++++++---
 2 files changed, 22 insertions(+), 5 deletions(-)

--- a/drivers/staging/media/atomisp/pci/ia_css_stream_public.h
+++ b/drivers/staging/media/atomisp/pci/ia_css_stream_public.h
@@ -27,12 +27,16 @@
 #include "ia_css_prbs.h"
 #include "ia_css_input_port.h"
 
-/* Input modes, these enumerate all supported input modes.
- *  Note that not all ISP modes support all input modes.
+/*
+ * Input modes, these enumerate all supported input modes.
+ * This enum is part of the atomisp firmware ABI and must
+ * NOT be changed!
+ * Note that not all ISP modes support all input modes.
  */
 enum ia_css_input_mode {
 	IA_CSS_INPUT_MODE_SENSOR, /** data from sensor */
 	IA_CSS_INPUT_MODE_FIFO,   /** data from input-fifo */
+	IA_CSS_INPUT_MODE_TPG,    /** data from test-pattern generator */
 	IA_CSS_INPUT_MODE_PRBS,   /** data from pseudo-random bit stream */
 	IA_CSS_INPUT_MODE_MEMORY, /** data from a frame in memory */
 	IA_CSS_INPUT_MODE_BUFFERED_SENSOR /** data is sent through mipi buffer */
--- a/drivers/staging/media/atomisp/pci/sh_css_internal.h
+++ b/drivers/staging/media/atomisp/pci/sh_css_internal.h
@@ -341,7 +341,14 @@ struct sh_css_sp_input_formatter_set {
 
 #define IA_CSS_MIPI_SIZE_CHECK_MAX_NOF_ENTRIES_PER_PORT (3)
 
-/* SP configuration information */
+/*
+ * SP configuration information
+ *
+ * This struct is part of the atomisp firmware ABI and is directly copied
+ * to ISP DRAM by sh_css_store_sp_group_to_ddr()
+ *
+ * Do NOT change this struct's layout or remove seemingly unused fields!
+ */
 struct sh_css_sp_config {
 	u8			no_isp_sync; /* Signal host immediately after start */
 	u8			enable_raw_pool_locking; /** Enable Raw Buffer Locking for HALv3 Support */
@@ -351,6 +358,10 @@ struct sh_css_sp_config {
 	     host (true) or when they are passed to the preview/video pipe
 	     (false). */
 
+	 /*
+	  * Note the fields below are only used on the ISP2400 not on the ISP2401,
+	  * sh_css_store_sp_group_to_ddr() skip copying these when run on the ISP2401.
+	  */
 	struct {
 		u8					a_changed;
 		u8					b_changed;
@@ -360,11 +371,13 @@ struct sh_css_sp_config {
 	} input_formatter;
 
 	sync_generator_cfg_t	sync_gen;
+	tpg_cfg_t		tpg;
 	prbs_cfg_t		prbs;
 	input_system_cfg_t	input_circuit;
 	u8			input_circuit_cfg_changed;
-	u32		mipi_sizes_for_check[N_CSI_PORTS][IA_CSS_MIPI_SIZE_CHECK_MAX_NOF_ENTRIES_PER_PORT];
-	u8                 enable_isys_event_queue;
+	u32			mipi_sizes_for_check[N_CSI_PORTS][IA_CSS_MIPI_SIZE_CHECK_MAX_NOF_ENTRIES_PER_PORT];
+	/* These last 2 fields are used on both the ISP2400 and the ISP2401 */
+	u8			enable_isys_event_queue;
 	u8			disable_cont_vf;
 };
 


