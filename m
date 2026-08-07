Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74E4A43F4C8;
	Fri,  7 Aug 2026 15:12:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786115580; cv=none; b=SYaTjStCvPLxvvRcqTwGfJwuoNe/V2+Z/x8IzSbM21WAKlFwL6lJIhLZ7vbhEt8nokjjd/QJyusuoAa0Q8nE1SZvEN5UvtGLsV0GSQv1PJeYX17oBW5MFkjfYJxloQLug9Bj3Rf+8xrcj2QioaS0kfD1uZ8+A0f3p1NX6lhSDC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786115580; c=relaxed/simple;
	bh=Fq5wMMqKlLGBXE/Kd+ug72DqjCxBMNRDjiS+Rcv/v/g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TszUlrK2qUMUoj0tVklr/dmvb3k41E3N//v0OEOKucVPiJUDEmi2VkmiQAGxUhZ6m3izl5HUrVHtiVHvU6t0le4nZIRZpIS5FakzOuH29TDDBEDlzrT4zzvnAZ2YuCIx5AyErwby1vB1wX4jE8l4JAdH0Ofe1oiI+jnMfd5jmXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tDeKvowr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tDeKvowr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF1D21F000E9;
	Fri,  7 Aug 2026 15:12:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786115579;
	bh=II43kAk1wu2mpnRKNvVLhYaDv176Uk91N9IVXWf995c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tDeKvowrdDoZuOOxFT3DrKzktWN1FAPSeaORorjhl4AykhE72FBjm/rwC3K6D/d1Q
	 nkCZk0gNFOac7PiVg5sQFFVNpUsU9KlngEkQFw0akTxwtTMYsHMXGTCmTR7PYgByNf
	 bgnh2uVhJCND4wBykcjiUmC+JDaJIYqWnz7va61A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bhawanpreet Lakha <bhawanpreet.lakha@amd.com>,
	"Jiri Slaby (SUSE)" <jirislaby@kernel.org>,
	"Lakha, Bhawanpreet" <Bhawanpreet.Lakha@amd.com>,
	Harry Wentland <harry.wentland@amd.com>,
	Leo Li <sunpeng.li@amd.com>,
	Rodrigo Siqueira <siqueira@igalia.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>,
	amd-gfx@lists.freedesktop.org
Subject: [PATCH 6.18 324/396] drm/amd/display: use proper context for logging
Date: Fri,  7 Aug 2026 16:38:04 +0200
Message-ID: <20260807143431.252604967@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143424.272339768@linuxfoundation.org>
References: <20260807143424.272339768@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Slaby (SUSE) <jirislaby@kernel.org>

commit 114b42507b6a23d9d24e24e4ef165233332c64d4 upstream.

The same as the rest of the code, get_ss_info_from_atombios() uses
calc_pll_cs->ctx->logger for logging. But calc_pll_cs->ctx is
initialized only later in calc_pll_max_vco_construct(). Therefore, any
output using DC_LOG_SYNC() leads to a NULL pointer deference in
get_ss_info_from_atombios().

According to Sashiko, the very same problem exists in
dce112_get_pix_clk_dividers() and dcn3_get_pix_clk_dividers() too.

To avoid accessing the NULL context, use clk_src->base.ctx->logger
everywhere. That context in base is initialized earlier in
dce110_clk_src_construct() and dce112_clk_src_construct(). Before
get_ss_info_from_atombios() or Sashiko's get_pix_clk_dividers functions
above are actually called. This is done by redefining DC_LOGGER to
CTX->logger.

Before:
dce110_clk_src_construct() did:
 -> sets clk_src->base.ctx = ctx;
 -> ss_info_from_atombios_create()
   -> get_ss_info_from_atombios()   <- uses calc_pll_cs->ctx  # BOOM
 -> calc_pll_max_vco_construct()    <- sets calc_pll_cs->ctx

After:
dce110_clk_src_construct() does:
 -> sets clk_src->base.ctx = ctx;
 -> ss_info_from_atombios_create()
   -> get_ss_info_from_atombios()   <- uses clk_src->base.ctx

Closes: https://bugzilla.suse.com/show_bug.cgi?id=1271175
Closes: https://lore.kernel.org/all/a9ee54e6-2413-4156-9bde-d528ae3c63a3@kernel.org/
Fixes: 1296423bf23c ("drm/amd/display: define DC_LOGGER for logger")
Reviewed-by: Bhawanpreet Lakha <bhawanpreet.lakha@amd.com>
Signed-off-by: Jiri Slaby (SUSE) <jirislaby@kernel.org>
Cc: Lakha, Bhawanpreet <Bhawanpreet.Lakha@amd.com>
Cc: Harry Wentland <harry.wentland@amd.com>
Cc: Leo Li <sunpeng.li@amd.com>
Cc: Rodrigo Siqueira <siqueira@igalia.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: "Christian König" <christian.koenig@amd.com>
Cc: David Airlie <airlied@gmail.com>
Cc: Simona Vetter <simona@ffwll.ch>
Cc: amd-gfx@lists.freedesktop.org
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 6f16fcbb0c46a87e3d9685407e906573d60104b0)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/dce/dce_clock_source.c |   20 ++++++++----------
 1 file changed, 9 insertions(+), 11 deletions(-)

--- a/drivers/gpu/drm/amd/display/dc/dce/dce_clock_source.c
+++ b/drivers/gpu/drm/amd/display/dc/dce/dce_clock_source.c
@@ -45,9 +45,7 @@
 	clk_src->base.ctx
 
 #define DC_LOGGER \
-	calc_pll_cs->ctx->logger
-#define DC_LOGGER_INIT() \
-	struct calc_pll_clock_source *calc_pll_cs = &clk_src->calc_pll
+	CTX->logger
 
 #undef FN
 #define FN(reg_name, field_name) \
@@ -291,6 +289,7 @@ static bool calc_pll_dividers_in_range(
 }
 
 static uint32_t calculate_pixel_clock_pll_dividers(
+		struct dce110_clk_src *clk_src,
 		struct calc_pll_clock_source *calc_pll_cs,
 		struct pll_settings *pll_settings)
 {
@@ -479,7 +478,7 @@ static uint32_t dce110_get_pix_clk_divid
 {
 	uint32_t field = 0;
 	uint32_t pll_calc_error = MAX_PLL_CALC_ERROR;
-	DC_LOGGER_INIT();
+
 	/* Check if reference clock is external (not pcie/xtalin)
 	* HW Dce80 spec:
 	* 00 - PCIE_REFCLK, 01 - XTALIN,    02 - GENERICA,    03 - GENERICB
@@ -522,12 +521,14 @@ static uint32_t dce110_get_pix_clk_divid
 		/*Calculate Dividers by HDMI object, no SS case or SS case */
 		pll_calc_error =
 			calculate_pixel_clock_pll_dividers(
+				        clk_src,
 					&clk_src->calc_pll_hdmi,
 					pll_settings);
 	else
 		/*Calculate Dividers by default object, no SS case or SS case */
 		pll_calc_error =
 			calculate_pixel_clock_pll_dividers(
+					clk_src,
 					&clk_src->calc_pll,
 					pll_settings);
 
@@ -572,7 +573,6 @@ static uint32_t dce110_get_pix_clk_divid
 {
 	struct dce110_clk_src *clk_src = TO_DCE110_CLK_SRC(cs);
 	uint32_t pll_calc_error = MAX_PLL_CALC_ERROR;
-	DC_LOGGER_INIT();
 
 	if (pix_clk_params == NULL || pll_settings == NULL
 			|| pix_clk_params->requested_pix_clk_100hz == 0) {
@@ -604,7 +604,6 @@ static uint32_t dce112_get_pix_clk_divid
 		struct pll_settings *pll_settings)
 {
 	struct dce110_clk_src *clk_src = TO_DCE110_CLK_SRC(cs);
-	DC_LOGGER_INIT();
 
 	if (pix_clk_params == NULL || pll_settings == NULL
 			|| pix_clk_params->requested_pix_clk_100hz == 0) {
@@ -1370,8 +1369,6 @@ static uint32_t dcn3_get_pix_clk_divider
 	unsigned long long actual_pix_clk_100Hz = pix_clk_params ? pix_clk_params->requested_pix_clk_100hz : 0;
 	struct dce110_clk_src *clk_src = TO_DCE110_CLK_SRC(cs);
 
-	DC_LOGGER_INIT();
-
 	if (pix_clk_params == NULL || pll_settings == NULL
 			|| pix_clk_params->requested_pix_clk_100hz == 0) {
 		DC_LOG_ERROR(
@@ -1441,7 +1438,6 @@ static const struct clock_source_funcs d
 	.get_pixel_clk_frequency_100hz = get_pixel_clk_frequency_100hz
 };
 
-
 static void get_ss_info_from_atombios(
 		struct dce110_clk_src *clk_src,
 		enum as_signal_type as_signal,
@@ -1454,7 +1450,7 @@ static void get_ss_info_from_atombios(
 	struct spread_spectrum_info *ss_info_cur;
 	struct spread_spectrum_data *ss_data_cur;
 	uint32_t i;
-	DC_LOGGER_INIT();
+
 	if (ss_entries_num == NULL) {
 		DC_LOG_SYNC(
 			"Invalid entry !!!\n");
@@ -1589,6 +1585,7 @@ static void ss_info_from_atombios_create
 }
 
 static bool calc_pll_max_vco_construct(
+			struct dce110_clk_src *clk_src,
 			struct calc_pll_clock_source *calc_pll_cs,
 			struct calc_pll_clock_source_init_data *init_data)
 {
@@ -1740,6 +1737,7 @@ bool dce110_clk_src_construct(
 	ss_info_from_atombios_create(clk_src);
 
 	if (!calc_pll_max_vco_construct(
+			clk_src,
 			&clk_src->calc_pll,
 			&calc_pll_cs_init_data)) {
 		ASSERT_CRITICAL(false);
@@ -1754,7 +1752,7 @@ bool dce110_clk_src_construct(
 
 
 	if (!calc_pll_max_vco_construct(
-			&clk_src->calc_pll_hdmi, &calc_pll_cs_init_data_hdmi)) {
+			clk_src, &clk_src->calc_pll_hdmi, &calc_pll_cs_init_data_hdmi)) {
 		ASSERT_CRITICAL(false);
 		goto unexpected_failure;
 	}


