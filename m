Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93C5D2D594F;
	Wed, 30 Sep 2026 18:50:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794206; cv=none; b=VADPfRIg+8oVBWy8L7NDeIWVdYkBew2NkeAJP6e0KqvesunAumCh4dHo9DG70ST/6HSeOjpcPz9OboFk+HPJk2rZ8H6OSPoQqIuD/PdcxZ+Q4Y9lf4sGM5eivvat9lUoErxplYoC9xzkHY+IB7K+QXNsPXv5vX8xds1GnaatorU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794206; c=relaxed/simple;
	bh=Qp+myG3OM+NBJCUpaxq+Hc7eAqsJAEO6DupfQOSKZxY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rHA8kSdwYuou2PCtzAkyiJznKs7Xhnw8SUSX0F0vqP1jmbTZWclCGxdU14uEsX3asK5jhvPjenzkpZDJ5GV0SjOleGL0JKaS78BCASLAyMKHEX3yY0ehHitINpneB6Jt9+5Fp/Wd5ijJg9k1SduZFQNI3WuJ/Y22exbtzB/9yJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XRw0pBaX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XRw0pBaX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE54E1F000FF;
	Wed, 30 Sep 2026 18:50:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794205;
	bh=V7/l62tHuIzRwvDxpGpSIyRD0alFoPoDbkkcuV3ST+8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XRw0pBaXiuhGhccnc3DUblvAvXQK4jozT8QbNeovoatXdDt6w8ZJQR2YpatlLc9nb
	 fp/S//6B3PXvAjKA6zqcHWaB3oAVgTgEkJRrhweL57iX7jeDP1OLzZHlYAK1smYBOa
	 MzlOg5g/vN+s5GrW2WzvUnN277gMsuxe/gvZK9aE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ikaros <void0red@gmail.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0129/1193] ACPICA: Enhance buffer validation in acpi_ut_walk_aml_resources()
Date: Wed, 30 Sep 2026 17:13:33 +0200
Message-ID: <20260930152437.078757913@linuxfoundation.org>
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
index cff7901f7866e..de9ee72e76c42 100644
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



