Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5327518A6AE;
	Tue, 17 Jun 2025 15:36:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750174568; cv=none; b=i3Em8+9gNP2k7cTFmV+djc3F7GkjZ0ONAJihpVBwH5Kt7WBkLsE97ACZfqLGHbcycCpLiEmsQwuytQWLAwohUPd0DYOCnqwJ4oAX9fgrsw5nPV7urY+70z43Svoz8NueHKD73MyMUXnhcxEDTzpCSbaEnWBZFUl5JHtNL5evsPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750174568; c=relaxed/simple;
	bh=1K40XHrn2E1on6rABlde5LK7Y90wZrh3fbqblymNcbU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D/fGzGjl3vYKzBWzkXgNoNQuG4L74t17MkIV50y0WvO1wyUA1IBp3OEsNsnw+FsNz76MbiHeGxRAJgR+x+kOeqWic7xvwUFT102FHG2hkah46r9D8ohbjo9qX3c4Og+VN8Ygtpw4pMF6EaVMxfFnrubnoqWWAjMwmzO+AY9HgH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S66c3xl8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S66c3xl8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA127C4CEF1;
	Tue, 17 Jun 2025 15:36:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750174568;
	bh=1K40XHrn2E1on6rABlde5LK7Y90wZrh3fbqblymNcbU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S66c3xl8sMdIkbLsQT199NxO7RoNyy65b14RamKBgZdgM+O6gjKIwQMdniEFtXvCW
	 FH34iL962rpJPDCn7OQybGZM040TeG9eaagQ9xMp32s+W29iDDYgW5lQtlH3zKXyQk
	 yENe4wPCm+C1hnr0HUgEDFIMV3fzEpUsza0DkKI0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniil Tatianin <d-tatianin@yandex-team.ru>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 036/512] ACPICA: exserial: dont forget to handle FFixedHW opregions for reading
Date: Tue, 17 Jun 2025 17:20:02 +0200
Message-ID: <20250617152421.016403653@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



