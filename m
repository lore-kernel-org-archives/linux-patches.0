Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FF3F283FC9;
	Wed, 25 Feb 2026 01:42:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983745; cv=none; b=V7zhsQruiDH/m2kqlwThkhoMCBy5QX2PDa1EOk7TRI1GcmFsrIy3w5PdFpvTtdDt2Ub2vMp7KLpjD9FDdHLMBvdpL3U05F7i5mMpq8BEpVHEbwuawIyDHsMlxTRpddSKehoDV8wUVTZTdBumO6buPFK4DlG0rzypjhI+pbX5i2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983745; c=relaxed/simple;
	bh=eUwJozb/7vFlPv3KFbdoX61B7NzeWNOAxxd5MEoZfng=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mfzXdCqzBmmi3MA6EqIDiR2N81PqlSr1XGPpHPafvaLGaxhpqCCiYjato5nQl1B8gHascDONtE6QwggmKkKJ2z4VxWXurK3ecF2oPbpYCV5ulGz6OWbQz72++xZtSr+kyEb3HwBH/U/f/IR7/G2WNvdizGU7ZpRgsw8HyYS5eZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VEz7KxBj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VEz7KxBj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A942C116D0;
	Wed, 25 Feb 2026 01:42:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983745;
	bh=eUwJozb/7vFlPv3KFbdoX61B7NzeWNOAxxd5MEoZfng=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VEz7KxBjcHZ5vscsC5/AsX3uWadtMRQaIrsQVTqrOi4aGsdJeggnGw0M8JRrra6kR
	 CY9rncuCfqsd1ohUxErbtqXvQxFdj3FcvpJp/QmvzjJAD5t3WpalRqE610XHJVc1gj
	 ucTSUh29ntKW87oHFkVfGSNOMpE1tAnqLDWlSk9k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexey Simakov <bigalex934@gmail.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 038/641] ACPICA: Fix NULL pointer dereference in acpi_ev_address_space_dispatch()
Date: Tue, 24 Feb 2026 17:16:04 -0800
Message-ID: <20260225012349.941435825@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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

From: Alexey Simakov <bigalex934@gmail.com>

[ Upstream commit f851e03bce968ff9b3faad1b616062e1244fd38d ]

Cover a missed execution path with a new check.

Fixes: 0acf24ad7e10 ("ACPICA: Add support for PCC Opregion special context data")
Link: https://github.com/acpica/acpica/commit/f421dd9dd897
Signed-off-by: Alexey Simakov <bigalex934@gmail.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Link: https://patch.msgid.link/3030574.e9J7NaK4W3@rafael.j.wysocki
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/acpica/evregion.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/acpi/acpica/evregion.c b/drivers/acpi/acpica/evregion.c
index fa3475da7ea9b..b6198f73c81df 100644
--- a/drivers/acpi/acpica/evregion.c
+++ b/drivers/acpi/acpica/evregion.c
@@ -163,7 +163,9 @@ acpi_ev_address_space_dispatch(union acpi_operand_object *region_obj,
 			return_ACPI_STATUS(AE_NOT_EXIST);
 		}
 
-		if (region_obj->region.space_id == ACPI_ADR_SPACE_PLATFORM_COMM) {
+		if (field_obj
+		    && region_obj->region.space_id ==
+		    ACPI_ADR_SPACE_PLATFORM_COMM) {
 			struct acpi_pcc_info *ctx =
 			    handler_desc->address_space.context;
 
-- 
2.51.0



