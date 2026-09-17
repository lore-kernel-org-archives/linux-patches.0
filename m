Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B9113AAF49;
	Thu, 17 Sep 2026 17:56:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667794; cv=none; b=ScYrMabsg6ItxDK/Cxnua6VMeXYeQT89AC5j30eYzHYusBEYuDMwRPLXsIUogHoMEG+BKXnxSyfaipUDbhoMTMiMfjnhL24bU91zENFWMu3ezQ1h7pFC1NV0dUA4IRntgcwfYu206QBGa0v+zanpk7LO7aH5vxTe0kwZ/UUEejk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667794; c=relaxed/simple;
	bh=p/yQ8A8JzCbN8lFUVx94PAXzUV90X7rjjfcqJmZo9CM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CtDi1WLLuSwPGCZbPO+ud7KZHrRq/OZ1sJO8s8MYWSn88A1r7MEbUg2njv3w2bL0u964zjXjvcO9yXkF9mONIUd1AL1o2LNMj6/oT+w0fzgMAPI6niRlJcd2bHiAwn9rnA/qKTMC5FpX8lP4H9E9Az26oPKO/XGdka2M++msk8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iVQqztpu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iVQqztpu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EBA11F000FF;
	Thu, 17 Sep 2026 17:56:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789667793;
	bh=cMuUDMPi3o7l0tsPmxhJ8lKI2sS8zdmHPj836qzbzX0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iVQqztpuS8K1VUJkwqEAVVAfDdG4AoobdoEbh/WEWuDnAm/7df6YUdVNSyfSjpf71
	 cc7xOsH2dlJ981u8y76DnAi50cBb8TSd3CfHkU66D3IG9GLXGcDh4hL3MyMGZmXiWF
	 wGQRGFkLsEhuMqsHauGl68dfVZf8COHqamj1SWQ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ikaros <void0red@gmail.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0173/1102] ACPICA: Enhance buffer validation in acpi_ut_walk_aml_resources()
Date: Thu, 17 Sep 2026 16:01:56 +0100
Message-ID: <20260917151543.886041719@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

From: ikaros <void0red@gmail.com>

[ Upstream commit b2e21fe8c3361c3d0d57ee56d359bea9b51fda3d ]

Enhance buffer validation in acpi_ut_walk_aml_resources() to prevent
buffer overflows.

Link: https://github.com/acpica/acpica/commit/975cb20c7992
Signed-off-by: ikaros <void0red@gmail.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Link: https://patch.msgid.link/2481429.NG923GbCHz@rafael.j.wysocki
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/acpica/utresrc.c | 30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/drivers/acpi/acpica/utresrc.c b/drivers/acpi/acpica/utresrc.c
index e1cc3d3487508..86ebd9fb869af 100644
--- a/drivers/acpi/acpica/utresrc.c
+++ b/drivers/acpi/acpica/utresrc.c
@@ -165,6 +165,28 @@ acpi_ut_walk_aml_resources(struct acpi_walk_state *walk_state,
 	/* Walk the byte list, abort on any invalid descriptor type or length */
 
 	while (aml < end_aml) {
+		/*
+		 * Validate that the remaining buffer space can hold enough
+		 * bytes to safely access fields during validation.
+		 * For large resource descriptors (bit 7 set), we need enough
+		 * bytes to access the Type field in serial_bus resources.
+		 * Small resource descriptors only need sizeof(struct aml_resource_end_tag).
+		 */
+		if ((acpi_size)(end_aml - aml) <
+		    sizeof(struct aml_resource_end_tag)) {
+			return_ACPI_STATUS(AE_AML_BUFFER_LENGTH);
+		}
+
+		/*
+		 * For large resource descriptors, ensure enough space for
+		 * the header plus serial_bus Type field access.
+		 */
+		if ((ACPI_GET8(aml) & ACPI_RESOURCE_NAME_LARGE) &&
+		    ((acpi_size)(end_aml - aml) <
+		     ACPI_OFFSET(struct aml_resource_common_serialbus,
+				 type) + 1)) {
+			return_ACPI_STATUS(AE_AML_BUFFER_LENGTH);
+		}
 
 		/* Validate the Resource Type and Resource Length */
 
@@ -182,6 +204,14 @@ acpi_ut_walk_aml_resources(struct acpi_walk_state *walk_state,
 
 		length = acpi_ut_get_descriptor_length(aml);
 
+		/*
+		 * Validate that the descriptor length doesn't exceed the
+		 * remaining buffer size to prevent reading beyond the end.
+		 */
+		if (length > (acpi_size)(end_aml - aml)) {
+			return_ACPI_STATUS(AE_AML_BUFFER_LENGTH);
+		}
+
 		/* Invoke the user function */
 
 		if (user_function) {
-- 
2.53.0



