Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7E841C6F46;
	Tue, 27 Aug 2024 15:13:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724771593; cv=none; b=KRgewgCp8//q+ysVkWxvhQRj5E2jwsBj31thYm5qeFeLfQctTxlIzDx/bckTMiNhzX8FL5sY4B96Vllv6wTTzr/a1zd5lqucrlSQ1KKvx7SPdAjGq0674Z3KdUtG5yaZJn/3BcLZPFhAkh7CkhrcEiuWz+93WypRILlfBdzuXFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724771593; c=relaxed/simple;
	bh=Mhxlj3fBiDACg/pC6pqkZLB/7aGiaApzRa8/vxgjTAg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cYaf+d/xi2BZe1pfl2PRj7YPIm7mHyYDMwwsJyGZPlHnDXlYUHm+UL9xtKfDGFdpV6GAG9lq1PeSeW2JCC/fFWerxgytLQ5LyyW+F6r3arMQgGoEa8wNGQGxePOBm4kHju3ZTx/3iEX23Mm3SpRkkVSE2vlPQKK6TUnNJYdP5/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=crZ6jHOj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="crZ6jHOj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CDF0C61053;
	Tue, 27 Aug 2024 15:13:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724771593;
	bh=Mhxlj3fBiDACg/pC6pqkZLB/7aGiaApzRa8/vxgjTAg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=crZ6jHOjpKmZPRtbpHj1GVstmiAVNR2ARR3Y7ln2pAMqmK/5Pohr2gdbGfxmRZt1K
	 2+3V2h1wTQNJJBGuOsi2B4GYi3yWO7NQl+u1dORdWjOiQgoQY5+mlRA+FicJzisztL
	 w2tr54CFyFFSjpJlerOLbeDnwfkP+cI/tmYYMILY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Suraj Kandpal <suraj.kandpal@intel.com>,
	Ankit Nautiyal <ankit.k.nautiyal@intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 204/273] drm/i915/hdcp: Use correct cp_irq_count
Date: Tue, 27 Aug 2024 16:38:48 +0200
Message-ID: <20240827143841.173802807@linuxfoundation.org>
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

From: Suraj Kandpal <suraj.kandpal@intel.com>

[ Upstream commit 5d41eeb6725e3e24853629e5d7635e4bc45d736e ]

We are checking cp_irq_count from the wrong hdcp structure which
ends up giving timed out errors. We only increment the cp_irq_count
of the primary connector's hdcp structure but here in case of
multidisplay setup we end up checking the secondary connector's hdcp
structure, which will not have its cp_irq_count incremented. This leads
to a timed out at CP_IRQ error even though a CP_IRQ was raised. Extract
it from the correct intel_hdcp structure.

--v2
-Explain why it was the wrong hdcp structure [Jani]

Fixes: 8c9e4f68b861 ("drm/i915/hdcp: Use per-device debugs")
Signed-off-by: Suraj Kandpal <suraj.kandpal@intel.com>
Reviewed-by: Ankit Nautiyal <ankit.k.nautiyal@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240809114127.3940699-2-suraj.kandpal@intel.com
(cherry picked from commit dd925902634def895690426bf10e0a8b3e56f56d)
Signed-off-by: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/display/intel_dp_hdcp.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/display/intel_dp_hdcp.c b/drivers/gpu/drm/i915/display/intel_dp_hdcp.c
index 92b03073acdd5..555428606e127 100644
--- a/drivers/gpu/drm/i915/display/intel_dp_hdcp.c
+++ b/drivers/gpu/drm/i915/display/intel_dp_hdcp.c
@@ -39,7 +39,9 @@ static u32 transcoder_to_stream_enc_status(enum transcoder cpu_transcoder)
 static void intel_dp_hdcp_wait_for_cp_irq(struct intel_connector *connector,
 					  int timeout)
 {
-	struct intel_hdcp *hdcp = &connector->hdcp;
+	struct intel_digital_port *dig_port = intel_attached_dig_port(connector);
+	struct intel_dp *dp = &dig_port->dp;
+	struct intel_hdcp *hdcp = &dp->attached_connector->hdcp;
 	long ret;
 
 #define C (hdcp->cp_irq_count_cached != atomic_read(&hdcp->cp_irq_count))
-- 
2.43.0



