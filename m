Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 162442E7379;
	Sat, 30 May 2026 17:31:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780162293; cv=none; b=WAmKVZeMA+IifTf8xWTSM3MThyeLOVMCoHsOTHRShv3K+MArYoXvIkYwUz8ru/NQM3VQuEQ6mATg1i2rS+eiR2R69gryKewvEvkFKdoIIxJ87OEpCoR196M2b3oL9I3IjXzw88xiCD2Gtg/Y4WFGKA+n0QDDdpw9OwEhz4AvkcU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780162293; c=relaxed/simple;
	bh=cnwsB7EaUyhJdAliMVuzoKB5xIr+vBUTbVWwT7Ul0f8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XEtzajrG1X5H9ciJSwvQnNDjJDc0UfhQM6m+s3iCHWWdPZYIlp1R7jY3y6Vdi+vM8ElUteUrAesILMlF7c9pP3lQPWmdvXg1XAACskEtMYpopiD3jyWA+TGj+MTWLqgn654WmyZa4bQaAGDx7b3k5mUXsbVZI5q1W8NSQ+KKRrs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NAWizVU3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NAWizVU3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 515A31F00893;
	Sat, 30 May 2026 17:31:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780162291;
	bh=oVTS3zN0cUURECSOL0yGdor5M2tb9hzKAnbfuZJLiBI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NAWizVU36ukAWQq54h65RweVjuy6KYKI/MJVcIKfeQ//reb3BBF5nl3FbNl9VNH2c
	 T3J1tO7ANpQHY8bMoTTZdtvrdDYAQyxidIvyDqv81/nK9c0+BLhZMVHTaSQ0qfKSVb
	 HZqwqnuPM9CWDf9bt6YEphAGMUVV0PGlARDtxeD4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Hung <alex.hung@amd.com>,
	Harry Wentland <harry.wentland@amd.com>,
	Ivan Lipski <ivan.lipski@amd.com>,
	Dan Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.1 878/969] drm/amd/display: Validate GPIO pin LUT table size before iterating
Date: Sat, 30 May 2026 18:06:42 +0200
Message-ID: <20260530160324.932355756@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -490,6 +490,10 @@ static enum bp_result get_gpio_i2c_info(
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


