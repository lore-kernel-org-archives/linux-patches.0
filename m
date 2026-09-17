Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDB8E4E533B;
	Thu, 17 Sep 2026 16:54:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664068; cv=none; b=uFNExHz3Mu7nmbZkauGRMidREu+IIiK/hEDRV7pd45puUeEBon8YxWxoO/DkiazN0x/Z07kehS9Kx7LeNpfcj3/99lsOGJSeo8pLbDmnSJl3ED4W6bYjyd4zk/jwAukhwWBh9XyWZf9qz9bUgUTUbPINN4hVnOfo7eqZLvujt7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664068; c=relaxed/simple;
	bh=REgyUweiLuJmFMAw2nLGuQ1Xt24Kcd0+jqboqU1NIqI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=irTvbzWMQYy/R0VwpDyF5cTe5wZD3qJSKuEgDDYCN5X9uZcwlMwfBo02u+GjPj2cYLdL9VdC/tvl0FqcSKAR/dx9uKbf7PjgMCYkOXQq/0lhVo3jjCR8G2XtBlpgJp/SejNl/fIqi70eaxRzah21cLJvXixkJ5wbZQj3pmbH5r8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MXUK5qN+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MXUK5qN+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50B5B1F00898;
	Thu, 17 Sep 2026 16:54:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664066;
	bh=68mMN/iAQoQu7b993AYVvC4LCWWgVrbuZNlh+jsZ6K8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MXUK5qN++scKdUvHE07rPYMVsy7yeTWo6lYW0VtUFsttas9OFPM82PRRIVBzpPTR+
	 EyPsU6M1N8dqGBe9+ScUey+5Sldhm+HPzevmLLVwmGcMQxQif3Fm10G91O70rsmsn7
	 OfHse+UN0RG1rysn8XAl6i9Ajxd5kSGLGLKqBVUM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ikaros <void0red@gmail.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0247/1250] ACPICA: Enhance buffer validation in acpi_ut_walk_aml_resources()
Date: Thu, 17 Sep 2026 16:00:42 +0100
Message-ID: <20260917151558.844571671@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



