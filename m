Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 782B9846C
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 14:30:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1B99C433EF;
	Fri, 10 Mar 2023 14:30:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678458615;
	bh=PYK8onxS01aT7/GWezj3mKdLWGMe20WrEM3Y7ElsjeM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pNKNA8qu6SOmGn/eMo0k/4rUiFcSuKpU7lLAclCyen+ubMCRe56CCaIVAgL1pyl1v
	 0uIdPloWje7S9nz8qnqRUg16+0T6FO2KJZ5aSMTksHrHG/aIQixG3leBiVUxeGt2iK
	 Dhrmr9HpYdj5ydV9JrvNu2IfadQrTdGWft+W9AS8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniil Tatianin <d-tatianin@yandex-team.ru>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 055/357] ACPICA: nsrepair: handle cases without a return value correctly
Date: Fri, 10 Mar 2023 14:35:44 +0100
Message-Id: <20230310133736.396789972@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133733.973883071@linuxfoundation.org>
References: <20230310133733.973883071@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Daniil Tatianin <d-tatianin@yandex-team.ru>

[ Upstream commit ca843a4c79486e99a19b859ef0b9887854afe146 ]

Previously acpi_ns_simple_repair() would crash if expected_btypes
contained any combination of ACPI_RTYPE_NONE with a different type,
e.g | ACPI_RTYPE_INTEGER because of slightly incorrect logic in the
!return_object branch, which wouldn't return AE_AML_NO_RETURN_VALUE
for such cases.

Found by Linux Verification Center (linuxtesting.org) with the SVACE
static analysis tool.

Link: https://github.com/acpica/acpica/pull/811
Fixes: 61db45ca2163 ("ACPICA: Restore code that repairs NULL package elements in return values.")
Signed-off-by: Daniil Tatianin <d-tatianin@yandex-team.ru>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/acpica/nsrepair.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/acpi/acpica/nsrepair.c b/drivers/acpi/acpica/nsrepair.c
index be86fea8e4d48..57e6488f6933f 100644
--- a/drivers/acpi/acpica/nsrepair.c
+++ b/drivers/acpi/acpica/nsrepair.c
@@ -181,8 +181,9 @@ acpi_ns_simple_repair(struct acpi_evaluate_info *info,
 	 * Try to fix if there was no return object. Warning if failed to fix.
 	 */
 	if (!return_object) {
-		if (expected_btypes && (!(expected_btypes & ACPI_RTYPE_NONE))) {
-			if (package_index != ACPI_NOT_PACKAGE_ELEMENT) {
+		if (expected_btypes) {
+			if (!(expected_btypes & ACPI_RTYPE_NONE) &&
+			    package_index != ACPI_NOT_PACKAGE_ELEMENT) {
 				ACPI_WARN_PREDEFINED((AE_INFO,
 						      info->full_pathname,
 						      ACPI_WARN_ALWAYS,
@@ -196,14 +197,15 @@ acpi_ns_simple_repair(struct acpi_evaluate_info *info,
 				if (ACPI_SUCCESS(status)) {
 					return (AE_OK);	/* Repair was successful */
 				}
-			} else {
+			}
+
+			if (expected_btypes != ACPI_RTYPE_NONE) {
 				ACPI_WARN_PREDEFINED((AE_INFO,
 						      info->full_pathname,
 						      ACPI_WARN_ALWAYS,
 						      "Missing expected return value"));
+				return (AE_AML_NO_RETURN_VALUE);
 			}
-
-			return (AE_AML_NO_RETURN_VALUE);
 		}
 	}
 
-- 
2.39.2



