Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEE77223328;
	Thu, 28 May 2026 20:37:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780000651; cv=none; b=dH6gKZnCA1C+RYXPH4MHGJhIHTBpQmH4mXlPQPyouI3cFXjcqK1S+H/xghWPNRY2UygOxYK32KGYKhqoePkMl3fdaXwMGs6ek4ePpUypml2DtOcYGTzIMnYUDMhWCiJWQIpWuGOIyNdDwkjMB2/INHm+eoqXo+V9QcelcNVAudg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780000651; c=relaxed/simple;
	bh=uNnL0ZQBmjFR/JOymMT/63pBlpuU6BZARfwJ3eby6XU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BI1SJYItJ2/3VZz5LyBgpnK9E3qZ8aF4BGbgeCCEqI1lpWMif29enFbmiV40eWifz0RAdT5y+IYQZ+OUGKhr5RMsLAK7ZDAdHRFF5foXf+jK1SxUcNsXwZfo0NZaWH2RdmSNtyQpZQxjW5JP8f03W2JPRKqO11juRH1Es3xQUjE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dz/3QDbj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dz/3QDbj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0185D1F000E9;
	Thu, 28 May 2026 20:37:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780000650;
	bh=4zM2j8yKLaM2AdvGnZmREON6Cjmepjy4VM9vScZdQjs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dz/3QDbj2SohXIzHrJMl+aJ9PcfeaSyIAHnj5i2BWyi5Wvg2zynd/B/vprh0YsEYL
	 jZlWrp6Ta5ahsUCF7Zazro3A60WH6NY6hOBIgU/kLzAFhRADiweC+aoSuBFkT6kQqg
	 F1+nIR0Pkq6mMTeiK4EWvCXER5U7C2/VkktrhpzQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Hung <alex.hung@amd.com>,
	Harry Wentland <harry.wentland@amd.com>,
	Ivan Lipski <ivan.lipski@amd.com>,
	Dan Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 119/272] drm/amd/display: Validate GPIO pin LUT table size before iterating
Date: Thu, 28 May 2026 21:48:13 +0200
Message-ID: <20260528194632.713445589@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194629.379955525@linuxfoundation.org>
References: <20260528194629.379955525@linuxfoundation.org>
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
@@ -492,6 +492,10 @@ static enum bp_result get_gpio_i2c_info(
 			- sizeof(struct atom_common_table_header))
 				/ sizeof(struct atom_gpio_pin_assignment);
 
+	if (!bios_get_image(&bp->base, DATA_TABLES(gpio_pin_lut),
+			    le16_to_cpu(header->table_header.structuresize)))
+		return BP_RESULT_BADBIOSTABLE;
+
 	pin = (struct atom_gpio_pin_assignment *) header->gpio_pin;
 
 	for (table_index = 0; table_index < count; table_index++) {
@@ -680,6 +684,11 @@ static enum bp_result bios_parser_get_gp
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


