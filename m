Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B4E1348C45;
	Thu, 28 May 2026 19:59:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779998342; cv=none; b=b8z0umYG1eL+tPZwqsQLhnvU67/y9nEH1Hd0G21smc4G1An1Go+LsCMa4cO0NM+Ph7wrzXkojMtVhU8dCGnUW0ScgwNXWJTUnqljWkTfwPc61ZMEcgfyOR40IcOsRaeFOGUao48VSU5a7g5ILLYDqQ+ct8JIzTUkP2mPBIvZfBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779998342; c=relaxed/simple;
	bh=TEP6rTHNtEmA+aQwiDxx59EFOXJN6vnzlD3SO4orRes=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s9AbeCjBYEAIf7CB/1kGyBpqg8vpB1KhJse90Y5BijyGbDq7M29M2dTczYDAmd7nXlCF50JjObSPsnZYn2IPDhw1bCPWBCWqsf+ciy7nATSlEk6wVw+sfDywnIGJ15R+LexVGYA7umODyLDcaXuQMGempFqiYWWwgDMre9kGS8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c/yt8dfF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c/yt8dfF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C900E1F000E9;
	Thu, 28 May 2026 19:59:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779998341;
	bh=kkjgJqV0cNl8KcOsvofAyWDTj/20I316dkJfcwvklqw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c/yt8dfFPEQ05Zm27qCeXXPd9Fmy2dtqSKMRNrjE6ZUW1Y6jf4Q5rYNq7Reek8QRE
	 Qr+3/jP34pEmq0XdGX3kWNR/usFyPI2qd/n8GtZlgvJ4zCuzzE/KQKjt63Iqh/UV2d
	 fu2fI9FfkI0zrSRLOasem1vvkegOzN7uui/rvJE8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Hung <alex.hung@amd.com>,
	Harry Wentland <harry.wentland@amd.com>,
	Ivan Lipski <ivan.lipski@amd.com>,
	Dan Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 7.0 139/461] drm/amd/display: Validate GPIO pin LUT table size before iterating
Date: Thu, 28 May 2026 21:44:28 +0200
Message-ID: <20260528194651.022449959@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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


