Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2166C1A76D4;
	Tue, 30 Jul 2024 17:20:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722360048; cv=none; b=Ubu5zskwipJ704CmF+COdkY2ZWwDGIH4mT1AJDTdZRKrgYAkZKVPGmrEw3Cj+3UmX3ess8t3Nf/BKxdQFIY3P/Kxiqqy7UNkuCzmO+2dSwcFL/506JqGCd3cjcljVspX6eYG/ikIS/vJGzGu8/lecCmvGVEsmvMFMtbfSojoRjc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722360048; c=relaxed/simple;
	bh=WDqI3JGUIyi1x6wvoHl6x/AmS5nOgxWWTCXaV0LQ5sg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mj6XlZglQ3+HibBTQCcMfUTJXCg+qcnnMme359jWnnc+ByE0cssdn5phk+gnrf2ggOay7zXqH6WZ13V64a4Iq0JrHmiv8cUqDoD4v8iIfYNAj89gQ4O7elh+PRGxUEvXFFTHj6+1mVK+4nB+Btz+5pFjZfgo8iODEDv+9yhFBLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zXKnpI5O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zXKnpI5O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D384C4AF13;
	Tue, 30 Jul 2024 17:20:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722360048;
	bh=WDqI3JGUIyi1x6wvoHl6x/AmS5nOgxWWTCXaV0LQ5sg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zXKnpI5OLEBJZABRupCrbF4JqaF9QxhwXUwvxrSkYb1wgsmjumK1/XoSPKbm2aBae
	 C0piKl6qV30/w/UgVnu7gqbcqdoKqKIHJOL8KiM3Bj0Uyu9+3yUT3OshTKYwWqH+oC
	 jTRjsfEALRmQiMRwRKyw5EkmYznijtsZFtB9lPbc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	mikhail.v.gavrilov@gmail.com,
	Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.10 580/809] drm/amd/display: fix corruption with high refresh rates on DCN 3.0
Date: Tue, 30 Jul 2024 17:47:36 +0200
Message-ID: <20240730151747.689088773@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

From: Alex Deucher <alexander.deucher@amd.com>

commit e3615bd198289f319172c428f20857accb46b830 upstream.

This reverts commit bc87d666c05a13e6d4ae1ddce41fc43d2567b9a2 and the
register changes from commit 6d4279cb99ac4f51d10409501d29969f687ac8dc.

Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/3412
Cc: mikhail.v.gavrilov@gmail.com
Cc: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Tested-by: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
Reviewed-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org # 6.10.x
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/optc/dcn10/dcn10_optc.c |   15 +++------------
 drivers/gpu/drm/amd/display/dc/optc/dcn20/dcn20_optc.c |   10 ++++++++++
 2 files changed, 13 insertions(+), 12 deletions(-)

--- a/drivers/gpu/drm/amd/display/dc/optc/dcn10/dcn10_optc.c
+++ b/drivers/gpu/drm/amd/display/dc/optc/dcn10/dcn10_optc.c
@@ -945,19 +945,10 @@ void optc1_set_drr(
 				OTG_FORCE_LOCK_ON_EVENT, 0,
 				OTG_SET_V_TOTAL_MIN_MASK_EN, 0,
 				OTG_SET_V_TOTAL_MIN_MASK, 0);
-
-		// Setup manual flow control for EOF via TRIG_A
-		optc->funcs->setup_manual_trigger(optc);
-
-	} else {
-		REG_UPDATE_4(OTG_V_TOTAL_CONTROL,
-				OTG_SET_V_TOTAL_MIN_MASK, 0,
-				OTG_V_TOTAL_MIN_SEL, 0,
-				OTG_V_TOTAL_MAX_SEL, 0,
-				OTG_FORCE_LOCK_ON_EVENT, 0);
-
-		optc->funcs->set_vtotal_min_max(optc, 0, 0);
 	}
+
+	// Setup manual flow control for EOF via TRIG_A
+	optc->funcs->setup_manual_trigger(optc);
 }
 
 void optc1_set_vtotal_min_max(struct timing_generator *optc, int vtotal_min, int vtotal_max)
--- a/drivers/gpu/drm/amd/display/dc/optc/dcn20/dcn20_optc.c
+++ b/drivers/gpu/drm/amd/display/dc/optc/dcn20/dcn20_optc.c
@@ -462,6 +462,16 @@ void optc2_setup_manual_trigger(struct t
 {
 	struct optc *optc1 = DCN10TG_FROM_TG(optc);
 
+	/* Set the min/max selectors unconditionally so that
+	 * DMCUB fw may change OTG timings when necessary
+	 * TODO: Remove the w/a after fixing the issue in DMCUB firmware
+	 */
+	REG_UPDATE_4(OTG_V_TOTAL_CONTROL,
+				 OTG_V_TOTAL_MIN_SEL, 1,
+				 OTG_V_TOTAL_MAX_SEL, 1,
+				 OTG_FORCE_LOCK_ON_EVENT, 0,
+				 OTG_SET_V_TOTAL_MIN_MASK, (1 << 1)); /* TRIGA */
+
 	REG_SET_8(OTG_TRIGA_CNTL, 0,
 			OTG_TRIGA_SOURCE_SELECT, 21,
 			OTG_TRIGA_SOURCE_PIPE_SELECT, optc->inst,


