Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A91402C9A;
	Tue, 22 Jul 2025 14:06:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753193179; cv=none; b=LeOAXXBSgPm9yAT7iOAAC0N69wbal+cR0TtBX1Vq2aN59o5yRUTWBP7UC38pZmrwIAr4lox1pWs5I2Ty4lppNywP1rud/8ta8mtxgqTnvvORJpcmPEQIcogGKF9cu2TI3ffNSS+E6SvSHg++MF5K34Ca1n87zuH6p0I56IOuM7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753193179; c=relaxed/simple;
	bh=fQUCvR8d5eiutRkCrSPwS2rciMWFE6O2rgHdB+ALWMs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jlI7pJ2Az5PzGPobzsH0Fz6VsyVbQ8sFY9R5mt01iHLVsCnU/v6eD0yG5P4xZXV0F0RiB6bZWX9/Dqs/yIhoSMBpFKc5WTLUBBSti4jx0yZ++1gGHqovwGcIAAhWY+v6dttwLoso21RLNVS99PRQOBu5ERdwgpX5CqQ6z9qN49o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l8fUJ49v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l8fUJ49v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB1CDC4CEEB;
	Tue, 22 Jul 2025 14:06:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753193179;
	bh=fQUCvR8d5eiutRkCrSPwS2rciMWFE6O2rgHdB+ALWMs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l8fUJ49vLfbsZXB9pZSn18cUugLrEOuW2e6ACWhJ70uQbNfIxNZNMPPixq7WDWfXe
	 BZzpjy7mvYCGO4JetAlmLgryOuRFr2CMLlDyebEjd4kk2VdijAtz1vNpHn6QkkhoNJ
	 i0pO3EguRI/etawv7TOtva7oQUvnk3BC+BJIO3u4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alok Tiwari <alok.a.tiwari@oracle.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 6.15 015/187] thunderbolt: Fix bit masking in tb_dp_port_set_hops()
Date: Tue, 22 Jul 2025 15:43:05 +0200
Message-ID: <20250722134346.328112363@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134345.761035548@linuxfoundation.org>
References: <20250722134345.761035548@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alok Tiwari <alok.a.tiwari@oracle.com>

commit 2cdde91c14ec358087f43287513946d493aef940 upstream.

The tb_dp_port_set_hops() function was incorrectly clearing
ADP_DP_CS_1_AUX_RX_HOPID_MASK twice. According to the function's
purpose, it should clear both TX and RX AUX HopID fields.  Replace the
first instance with ADP_DP_CS_1_AUX_TX_HOPID_MASK to ensure proper
configuration of both AUX directions.

Fixes: 98176380cbe5 ("thunderbolt: Convert DP adapter register names to follow the USB4 spec")
Cc: stable@vger.kernel.org
Signed-off-by: Alok Tiwari <alok.a.tiwari@oracle.com>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thunderbolt/switch.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/thunderbolt/switch.c
+++ b/drivers/thunderbolt/switch.c
@@ -1450,7 +1450,7 @@ int tb_dp_port_set_hops(struct tb_port *
 		return ret;
 
 	data[0] &= ~ADP_DP_CS_0_VIDEO_HOPID_MASK;
-	data[1] &= ~ADP_DP_CS_1_AUX_RX_HOPID_MASK;
+	data[1] &= ~ADP_DP_CS_1_AUX_TX_HOPID_MASK;
 	data[1] &= ~ADP_DP_CS_1_AUX_RX_HOPID_MASK;
 
 	data[0] |= (video << ADP_DP_CS_0_VIDEO_HOPID_SHIFT) &


