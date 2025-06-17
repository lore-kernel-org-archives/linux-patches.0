Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1219E2EE5F4;
	Tue, 17 Jun 2025 15:45:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750175147; cv=none; b=tVwtAKKcbSvfMptIMy6zzxPWYFAmCN9ICm0LuPvHsFeyrwlLHk7k1BAQEX8N9HORj0M53wLnY8jMtWXsGmWVxACRN1DZXRgT90VsaeVVMJjWJeNA4U82g1R2D2XBzhU9G9a5rlYefiQV3ZEX8/nTQuodsQhkizRS4OR3R/xOa6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750175147; c=relaxed/simple;
	bh=In3Z3L55pzIJ7lJ2QgHhhT9PHxORYsS5RQslx2U6HIo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y8QR/wEYfE/aOy+nUEKKRD7ZiI8sp936Yd3fystplZlWCfWFjMsUd0h7eZdrwxER7N9S8zmG0uGVdWwBnr64hjASqXhx+ZgxW3lh0nw0Sgu3ObTv/jhpK7EkSizc0IF2O75wwVl4MaPRI9IkYrkgNG+wC8NhuN3vH4bYZWC6rj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qfEbuhK4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qfEbuhK4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6961CC4CEE3;
	Tue, 17 Jun 2025 15:45:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750175146;
	bh=In3Z3L55pzIJ7lJ2QgHhhT9PHxORYsS5RQslx2U6HIo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qfEbuhK4u/eyRvwCHMcjfA2DfKw1oKaULCixRzEdnABqQu9ApXQDySIra9iVeZBvk
	 lgXTWGztbqZLJu0FYvMxFyjKHnYZ9EubXYeD41xlnEGnc6AKWSefe1WY/GP+9i+KFn
	 /dM6Ye7fRiSWFfa4WvQ2d+JLBm0wEco+FESG3m8M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniil Tatianin <d-tatianin@yandex-team.ru>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 053/780] ACPICA: exserial: dont forget to handle FFixedHW opregions for reading
Date: Tue, 17 Jun 2025 17:16:01 +0200
Message-ID: <20250617152453.658672222@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniil Tatianin <d-tatianin@yandex-team.ru>

[ Upstream commit 0f8af0356a45547683a216e4921006a3c6a6d922 ]

The initial commit that introduced support for FFixedHW operation
regions did add a special case in the AcpiExReadSerialBus If, but
forgot to actually handle it inside the switch, so add the missing case
to prevent reads from failing with AE_AML_INVALID_SPACE_ID.

Link: https://github.com/acpica/acpica/pull/998
Fixes: ee64b827a9a ("ACPICA: Add support for FFH Opregion special context data")
Signed-off-by: Daniil Tatianin <d-tatianin@yandex-team.ru>
Link: https://patch.msgid.link/20250401184312.599962-1-d-tatianin@yandex-team.ru
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/acpica/exserial.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/acpi/acpica/exserial.c b/drivers/acpi/acpica/exserial.c
index 5241f4c01c765..89a4ac447a2be 100644
--- a/drivers/acpi/acpica/exserial.c
+++ b/drivers/acpi/acpica/exserial.c
@@ -201,6 +201,12 @@ acpi_ex_read_serial_bus(union acpi_operand_object *obj_desc,
 		function = ACPI_READ;
 		break;
 
+	case ACPI_ADR_SPACE_FIXED_HARDWARE:
+
+		buffer_length = ACPI_FFH_INPUT_BUFFER_SIZE;
+		function = ACPI_READ;
+		break;
+
 	default:
 		return_ACPI_STATUS(AE_AML_INVALID_SPACE_ID);
 	}
-- 
2.39.5



