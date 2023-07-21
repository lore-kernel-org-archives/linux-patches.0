Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D72631F946
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 16:21:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F4D1C433CD;
	Fri, 21 Jul 2023 16:21:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689956475;
	bh=c/Yp+B4Q9yNTi1j3rAndLSzImf8aViYu5VPwTKTTsqk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ezHy4sdTTG+IQAbsdhRekV+YSW7e/08kcnkYybRWMmffkDG0of7WMnPJchEM4i8D4
	 1bbAhHwShMsn4qfQ5SEkcqYtwiKX9ffdShP6S5rezRAKnhd98o0BEK1N5YLcyrnPY3
	 4/N1RgdDtf/CYCl0RDzFvasvo1tEhlh5Hs2l2k8c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wenjing Liu <wenjing.liu@amd.com>,
	Hamza Mahfooz <hamza.mahfooz@amd.com>,
	Ilya Bakoulin <ilya.bakoulin@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.4 206/292] drm/amd/display: Fix 128b132b link loss handling
Date: Fri, 21 Jul 2023 18:05:15 +0200
Message-ID: <20230721160537.733630194@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160528.800311148@linuxfoundation.org>
References: <20230721160528.800311148@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ilya Bakoulin <ilya.bakoulin@amd.com>

commit ed83fe2abcace898fdec5c2ba0455703178ac9a3 upstream.

[Why]
We don't check 128b132b-specific bits in LANE_ALIGN_STATUS_UPDATED DPCD
registers when parsing link loss status, which can cause us to miss a
link loss notification from some sinks.

[How]
Add a 128b132b-specific status bit check.

Cc: stable@vger.kernel.org # 6.3+
Reviewed-by: Wenjing Liu <wenjing.liu@amd.com>
Acked-by: Hamza Mahfooz <hamza.mahfooz@amd.com>
Signed-off-by: Ilya Bakoulin <ilya.bakoulin@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 .../display/dc/link/protocols/link_dp_irq_handler.c   | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/link/protocols/link_dp_irq_handler.c b/drivers/gpu/drm/amd/display/dc/link/protocols/link_dp_irq_handler.c
index ba95facc4ee8..b1b11eb0f9bb 100644
--- a/drivers/gpu/drm/amd/display/dc/link/protocols/link_dp_irq_handler.c
+++ b/drivers/gpu/drm/amd/display/dc/link/protocols/link_dp_irq_handler.c
@@ -82,8 +82,15 @@ bool dp_parse_link_loss_status(
 	}
 
 	/* Check interlane align.*/
-	if (sink_status_changed ||
-		!hpd_irq_dpcd_data->bytes.lane_status_updated.bits.INTERLANE_ALIGN_DONE) {
+	if (link_dp_get_encoding_format(&link->cur_link_settings) == DP_128b_132b_ENCODING &&
+			(!hpd_irq_dpcd_data->bytes.lane_status_updated.bits.EQ_INTERLANE_ALIGN_DONE_128b_132b ||
+			 !hpd_irq_dpcd_data->bytes.lane_status_updated.bits.CDS_INTERLANE_ALIGN_DONE_128b_132b)) {
+		sink_status_changed = true;
+	} else if (!hpd_irq_dpcd_data->bytes.lane_status_updated.bits.INTERLANE_ALIGN_DONE) {
+		sink_status_changed = true;
+	}
+
+	if (sink_status_changed) {
 
 		DC_LOG_HW_HPD_IRQ("%s: Link Status changed.\n", __func__);
 
-- 
2.41.0



