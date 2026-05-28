Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C9BF328B7B;
	Thu, 28 May 2026 20:49:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780001394; cv=none; b=SG0GLumIWs3lsURjhAkf0ILwI8wMpuCcsdoR0qHtT39t6/542K959zOL8ylS2DuiXC0WPc/WReIsu3VWp+i6uzyjLuWvBjLvrOz1Y9cuXg5EeqBrMCHwY1kOyoHGl3ias9VTf1W3m1SoZ+t1OfA9IwAo8jUsJJCz7vXmr0Nr0Ok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780001394; c=relaxed/simple;
	bh=GhO339xVaNlXsy0cnxKlu/GzADeKmkymFjL2bXIvTi8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zat82tc5NPLtDJc/Ju+YqwUfpep7Csh75r5fpjSBiv6uROAr551BdP32SBxoiC7/Vj7gDeGVzo8V6v22ZkveXoxUh1X5omsLZ3PFC3dOThtMfIEkAVftNzIPXtAvMYahouRe5wX/Dwa0hKWfBSFUj2wgaWnu2rp/rhA/bda+ekQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vw5C5cKf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vw5C5cKf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1161B1F00A3A;
	Thu, 28 May 2026 20:49:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780001392;
	bh=HTvqsQEVDETLFu7jjdfAHxkvs0TnJKBZh//8F8uTcvo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Vw5C5cKf/Hu70FdZ2Hqv3Ly/pxpjBTLQ+HZz3tS1IWt7o4918wnxELNqzVjh6Xs17
	 C0pradOEa++23TJ3HKRmyQjQzQoNG2s1ezPPFl0Hcc9FCi7QZ9fjAsP7SCm8sFMEsk
	 jBQrY1cr27fluK+1AQzvidaND4746l0L1fcylYkg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Hung <alex.hung@amd.com>,
	Harry Wentland <harry.wentland@amd.com>,
	Ivan Lipski <ivan.lipski@amd.com>,
	Dan Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.6 074/186] drm/amd/display: Validate GPIO pin LUT table size before iterating
Date: Thu, 28 May 2026 21:49:14 +0200
Message-ID: <20260528194930.937479851@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194928.941004471@linuxfoundation.org>
References: <20260528194928.941004471@linuxfoundation.org>
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

From: Harry Wentland <harry.wentland@amd.com>

commit 86d2b20644b11d21fe52c596e6e922b4590a3e3f upstream.

[Why&How]
The GPIO pin table parsers in get_gpio_i2c_info() and
bios_parser_get_gpio_pin_info() derive an element count from the VBIOS
table_header.structuresize field, then iterate over gpio_pin[] entries.
However, GET_IMAGE() only validates that the table header itself fits
within the BIOS image. If the VBIOS reports a structuresize larger than
the actual mapped data, the loop reads past the end of the BIOS image,
causing an out-of-bounds read.

Fix this by calling bios_get_image() to validate that the full claimed
structuresize is accessible within the BIOS image before entering the
loop in both functions.

Assisted-by: GitHub Copilot:claude-opus-4-6
Reviewed-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Harry Wentland <harry.wentland@amd.com>
Signed-off-by: Ivan Lipski <ivan.lipski@amd.com>
Tested-by: Dan Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit ba5e95b43b773ae1bf1f66ee6b31eb774e65afe3)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/bios/bios_parser2.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/drivers/gpu/drm/amd/display/dc/bios/bios_parser2.c
+++ b/drivers/gpu/drm/amd/display/dc/bios/bios_parser2.c
@@ -488,6 +488,10 @@ static enum bp_result get_gpio_i2c_info(
 			- sizeof(struct atom_common_table_header))
 				/ sizeof(struct atom_gpio_pin_assignment);
 
+	if (!bios_get_image(&bp->base, DATA_TABLES(gpio_pin_lut),
+			    le16_to_cpu(header->table_header.structuresize)))
+		return BP_RESULT_BADBIOSTABLE;
+
 	pin = (struct atom_gpio_pin_assignment *) header->gpio_pin;
 
 	for (table_index = 0; table_index < count; table_index++) {
@@ -677,6 +681,11 @@ static enum bp_result bios_parser_get_gp
 	count = (le16_to_cpu(header->table_header.structuresize)
 			- sizeof(struct atom_common_table_header))
 				/ sizeof(struct atom_gpio_pin_assignment);
+
+	if (!bios_get_image(&bp->base, DATA_TABLES(gpio_pin_lut),
+			    le16_to_cpu(header->table_header.structuresize)))
+		return BP_RESULT_BADBIOSTABLE;
+
 	for (i = 0; i < count; ++i) {
 		if (header->gpio_pin[i].gpio_id != gpio_id)
 			continue;


