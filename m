Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51A6B3B3894;
	Wed, 30 Sep 2026 18:49:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794178; cv=none; b=QVezZjMgkOsmoLc/Wa7NN6M3P3deRJE/yv4w3KApI5ibeXxuU+WTV/ufPJjcun0KE2GX9mQ6kmF1Hi3QP84nnl/sbtK6XO5K02J+DxoTdE5JJSP6OYNXlSB41ZtNh/3S3AZd52voNqyRyrDs/PpprFI4zPnW9kr1KmJQe6lPzpk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794178; c=relaxed/simple;
	bh=OxvRj1+HYT235HjYTW8GDy8qa8Nrgznf+xIJ0eFvajE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TwnFJ0KG7bn4W8P0lpCOkSYv810qwNDC/6s6T7lFRJsjS5DiC5d9RhSgwtzsm/sllD7d5kVm2MsiKhjveg9RkCHfn/8hmlNdHO4zhZwtSdbiGIcTH5gcUZEvAfZHJofcdZfa0Ogn1mnrdJpILdUbasg2T8e3OgezV354qhoGaKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BwdNQ2Yt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BwdNQ2Yt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 836CC1F000FF;
	Wed, 30 Sep 2026 18:49:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794177;
	bh=o9QKF48zQisI8/3FmKf6Ku9Ld73J47ESPkPByIP1aYQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BwdNQ2YtxnS/1IWNT+7UgG9Wp5onDlrYodoyvk3xxlbwNaxO9xDbL5/AQi6g2+mPt
	 yt1WHS5QtTcjz9e+Q5YrSJkvZVmLH8TKbxfPgJ1+Mffz/+zu2+DyWAa2G+u+iP0gBw
	 j5B7sQ6g3itXSgTRJFCl7pZFOaFs+vcfm6GOvMAo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ikaros <void0red@gmail.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0120/1193] ACPICA: validate byte_count in acpi_ps_get_next_package_length()
Date: Wed, 30 Sep 2026 17:13:24 +0200
Message-ID: <20260930152436.889947565@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

From: ikaros <void0red@gmail.com>

[ Upstream commit d49c6ee08365a8596f639da46eb7e71752b0cd42 ]

Validate package length reading in acpi_ps_get_next_package_length().

Link: https://github.com/acpica/acpica/commit/40e03f9941e2
Signed-off-by: ikaros <void0red@gmail.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Link: https://patch.msgid.link/3616255.QJadu78ljV@rafael.j.wysocki
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/acpica/psargs.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/acpi/acpica/psargs.c b/drivers/acpi/acpica/psargs.c
index 251f3eacb83d1..095cbb77a3fc1 100644
--- a/drivers/acpi/acpica/psargs.c
+++ b/drivers/acpi/acpica/psargs.c
@@ -48,6 +48,7 @@ acpi_ps_get_next_package_length(struct acpi_parse_state *parser_state)
 	u32 package_length = 0;
 	u32 byte_count;
 	u8 byte_zero_mask = 0x3F;	/* Default [0:5] */
+	u32 remaining;
 
 	ACPI_FUNCTION_TRACE(ps_get_next_package_length);
 
@@ -55,7 +56,23 @@ acpi_ps_get_next_package_length(struct acpi_parse_state *parser_state)
 	 * Byte 0 bits [6:7] contain the number of additional bytes
 	 * used to encode the package length, either 0,1,2, or 3
 	 */
+
+	/* Check if we have at least one byte to read */
+	remaining = (u32)ACPI_PTR_DIFF(parser_state->aml_end, aml);
+	if (remaining == 0) {
+		return_UINT32(0);
+	}
+
 	byte_count = (aml[0] >> 6);
+
+	/* Validate byte_count and ensure we have enough bytes to read */
+	if (byte_count >= remaining) {
+
+		/* Clamp to available bytes and advance to end */
+		parser_state->aml = parser_state->aml_end;
+		return_UINT32(0);
+	}
+
 	parser_state->aml += ((acpi_size)byte_count + 1);
 
 	/* Get bytes 3, 2, 1 as needed */
-- 
2.53.0



