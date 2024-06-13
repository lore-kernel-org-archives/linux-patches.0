Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05A0C143899;
	Thu, 13 Jun 2024 12:45:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718282708; cv=none; b=LYF92bf8DcK18YwcB4XiGEY1zvrCjMtORxXUxR0kzPG+DjbCDonffEFjefdZHsvOGmBlLKpXlBkAxbwrr2Y+9uYyBYtwzF9OjwIifvUa0pmOt6rmktaLLt57MqDvWsGwqWqYBQsmY2GSVfj+LZrXiyTPaL59VOkX3MZjA+ZRNG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718282708; c=relaxed/simple;
	bh=PinPnAPDmyGqWHLA4/buAGdZ5CVujIIEa0Zi/SLrAwM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a9NlJnqjVRvV8tGV2C8sMRcxXFGPN8ZJMQC/2hBAm2NcD2cUpVKpW8xtps/OegqAe/LTsnggyKkqngClbICm9xj3Yw6XJfgi4Xu2VxEQ6AD9xC1OAHnZWoxcEmkdvDI7k/bPt3tE0nbPfAwOVyPRNUkHq/3eBRoBAaVpkNjV/vE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IlBUFO+/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IlBUFO+/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77704C2BBFC;
	Thu, 13 Jun 2024 12:45:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718282707;
	bh=PinPnAPDmyGqWHLA4/buAGdZ5CVujIIEa0Zi/SLrAwM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IlBUFO+/eIu23qY9+nRHr+WNKrlq1CasFdg30Rnh7hpNCnl/0qtoyPc9pkDe9s86z
	 ed/DOv8fRfCNapeQYykYu92abOULC7mVpqm7/2JCPuE9ORsp1PH40MNUAMiunY2IN+
	 CC6SA48WxDts63vENoNgDtBYP8ZRuHumGWWttMEw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	Miguel Ojeda <ojeda@kernel.org>,
	Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH 5.15 368/402] media: mxl5xx: Move xpt structures off stack
Date: Thu, 13 Jun 2024 13:35:25 +0200
Message-ID: <20240613113316.491004265@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113302.116811394@linuxfoundation.org>
References: <20240613113302.116811394@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nathan Chancellor <nathan@kernel.org>

commit 526f4527545b2d4ce0733733929fac7b6da09ac6 upstream.

When building for LoongArch with clang 18.0.0, the stack usage of
probe() is larger than the allowed 2048 bytes:

  drivers/media/dvb-frontends/mxl5xx.c:1698:12: warning: stack frame size (2368) exceeds limit (2048) in 'probe' [-Wframe-larger-than]
   1698 | static int probe(struct mxl *state, struct mxl5xx_cfg *cfg)
        |            ^
  1 warning generated.

This is the result of the linked LLVM commit, which changes how the
arrays of structures in config_ts() get handled with
CONFIG_INIT_STACK_ZERO and CONFIG_INIT_STACK_PATTERN, which causes the
above warning in combination with inlining, as config_ts() gets inlined
into probe().

This warning can be easily fixed by moving the array of structures off
of the stackvia 'static const', which is a better location for these
variables anyways because they are static data that is only ever read
from, never modified, so allocating the stack space is wasteful.

This drops the stack usage from 2368 bytes to 256 bytes with the same
compiler and configuration.

Link: https://lore.kernel.org/linux-media/20240111-dvb-mxl5xx-move-structs-off-stack-v1-1-ca4230e67c11@kernel.org
Cc: stable@vger.kernel.org
Closes: https://github.com/ClangBuiltLinux/linux/issues/1977
Link: https://github.com/llvm/llvm-project/commit/afe8b93ffdfef5d8879e1894b9d7dda40dee2b8d
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Reviewed-by: Miguel Ojeda <ojeda@kernel.org>
Tested-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/dvb-frontends/mxl5xx.c |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

--- a/drivers/media/dvb-frontends/mxl5xx.c
+++ b/drivers/media/dvb-frontends/mxl5xx.c
@@ -1390,57 +1390,57 @@ static int config_ts(struct mxl *state,
 	u32 nco_count_min = 0;
 	u32 clk_type = 0;
 
-	struct MXL_REG_FIELD_T xpt_sync_polarity[MXL_HYDRA_DEMOD_MAX] = {
+	static const struct MXL_REG_FIELD_T xpt_sync_polarity[MXL_HYDRA_DEMOD_MAX] = {
 		{0x90700010, 8, 1}, {0x90700010, 9, 1},
 		{0x90700010, 10, 1}, {0x90700010, 11, 1},
 		{0x90700010, 12, 1}, {0x90700010, 13, 1},
 		{0x90700010, 14, 1}, {0x90700010, 15, 1} };
-	struct MXL_REG_FIELD_T xpt_clock_polarity[MXL_HYDRA_DEMOD_MAX] = {
+	static const struct MXL_REG_FIELD_T xpt_clock_polarity[MXL_HYDRA_DEMOD_MAX] = {
 		{0x90700010, 16, 1}, {0x90700010, 17, 1},
 		{0x90700010, 18, 1}, {0x90700010, 19, 1},
 		{0x90700010, 20, 1}, {0x90700010, 21, 1},
 		{0x90700010, 22, 1}, {0x90700010, 23, 1} };
-	struct MXL_REG_FIELD_T xpt_valid_polarity[MXL_HYDRA_DEMOD_MAX] = {
+	static const struct MXL_REG_FIELD_T xpt_valid_polarity[MXL_HYDRA_DEMOD_MAX] = {
 		{0x90700014, 0, 1}, {0x90700014, 1, 1},
 		{0x90700014, 2, 1}, {0x90700014, 3, 1},
 		{0x90700014, 4, 1}, {0x90700014, 5, 1},
 		{0x90700014, 6, 1}, {0x90700014, 7, 1} };
-	struct MXL_REG_FIELD_T xpt_ts_clock_phase[MXL_HYDRA_DEMOD_MAX] = {
+	static const struct MXL_REG_FIELD_T xpt_ts_clock_phase[MXL_HYDRA_DEMOD_MAX] = {
 		{0x90700018, 0, 3}, {0x90700018, 4, 3},
 		{0x90700018, 8, 3}, {0x90700018, 12, 3},
 		{0x90700018, 16, 3}, {0x90700018, 20, 3},
 		{0x90700018, 24, 3}, {0x90700018, 28, 3} };
-	struct MXL_REG_FIELD_T xpt_lsb_first[MXL_HYDRA_DEMOD_MAX] = {
+	static const struct MXL_REG_FIELD_T xpt_lsb_first[MXL_HYDRA_DEMOD_MAX] = {
 		{0x9070000C, 16, 1}, {0x9070000C, 17, 1},
 		{0x9070000C, 18, 1}, {0x9070000C, 19, 1},
 		{0x9070000C, 20, 1}, {0x9070000C, 21, 1},
 		{0x9070000C, 22, 1}, {0x9070000C, 23, 1} };
-	struct MXL_REG_FIELD_T xpt_sync_byte[MXL_HYDRA_DEMOD_MAX] = {
+	static const struct MXL_REG_FIELD_T xpt_sync_byte[MXL_HYDRA_DEMOD_MAX] = {
 		{0x90700010, 0, 1}, {0x90700010, 1, 1},
 		{0x90700010, 2, 1}, {0x90700010, 3, 1},
 		{0x90700010, 4, 1}, {0x90700010, 5, 1},
 		{0x90700010, 6, 1}, {0x90700010, 7, 1} };
-	struct MXL_REG_FIELD_T xpt_enable_output[MXL_HYDRA_DEMOD_MAX] = {
+	static const struct MXL_REG_FIELD_T xpt_enable_output[MXL_HYDRA_DEMOD_MAX] = {
 		{0x9070000C, 0, 1}, {0x9070000C, 1, 1},
 		{0x9070000C, 2, 1}, {0x9070000C, 3, 1},
 		{0x9070000C, 4, 1}, {0x9070000C, 5, 1},
 		{0x9070000C, 6, 1}, {0x9070000C, 7, 1} };
-	struct MXL_REG_FIELD_T xpt_err_replace_sync[MXL_HYDRA_DEMOD_MAX] = {
+	static const struct MXL_REG_FIELD_T xpt_err_replace_sync[MXL_HYDRA_DEMOD_MAX] = {
 		{0x9070000C, 24, 1}, {0x9070000C, 25, 1},
 		{0x9070000C, 26, 1}, {0x9070000C, 27, 1},
 		{0x9070000C, 28, 1}, {0x9070000C, 29, 1},
 		{0x9070000C, 30, 1}, {0x9070000C, 31, 1} };
-	struct MXL_REG_FIELD_T xpt_err_replace_valid[MXL_HYDRA_DEMOD_MAX] = {
+	static const struct MXL_REG_FIELD_T xpt_err_replace_valid[MXL_HYDRA_DEMOD_MAX] = {
 		{0x90700014, 8, 1}, {0x90700014, 9, 1},
 		{0x90700014, 10, 1}, {0x90700014, 11, 1},
 		{0x90700014, 12, 1}, {0x90700014, 13, 1},
 		{0x90700014, 14, 1}, {0x90700014, 15, 1} };
-	struct MXL_REG_FIELD_T xpt_continuous_clock[MXL_HYDRA_DEMOD_MAX] = {
+	static const struct MXL_REG_FIELD_T xpt_continuous_clock[MXL_HYDRA_DEMOD_MAX] = {
 		{0x907001D4, 0, 1}, {0x907001D4, 1, 1},
 		{0x907001D4, 2, 1}, {0x907001D4, 3, 1},
 		{0x907001D4, 4, 1}, {0x907001D4, 5, 1},
 		{0x907001D4, 6, 1}, {0x907001D4, 7, 1} };
-	struct MXL_REG_FIELD_T xpt_nco_clock_rate[MXL_HYDRA_DEMOD_MAX] = {
+	static const struct MXL_REG_FIELD_T xpt_nco_clock_rate[MXL_HYDRA_DEMOD_MAX] = {
 		{0x90700044, 16, 80}, {0x90700044, 16, 81},
 		{0x90700044, 16, 82}, {0x90700044, 16, 83},
 		{0x90700044, 16, 84}, {0x90700044, 16, 85},


