Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C1271F55F5;
	Tue, 21 Jan 2025 17:59:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737482399; cv=none; b=E5QIsh/+5+15YOr6wqwthzci0XbAojoMBOsWf3AgqeqE0kYL6KJOTGetL/3u1r6+C6ZY6srhHPP+ZPF7zUXArOjzyNHhmOsMxJks0pSOLLwTB0n3/YERfyuRx+IXZLd6W8of9rqTEa6LawkrmJw/sDZNSKnL3PCV7VsgQ2wDUB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737482399; c=relaxed/simple;
	bh=8CCIlaPObFe/qq48KKRNIINj4w6xKHkBlytEmJZXsHw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fJbwKDMGX5pnTvy5oyvogsI4/xrfrTc+uHgxnw95rjVOABpAkwWmDBZebj5b4VdFNldjovwmKmZ8o4XK13u1lH5MuXuiEqbGYKcLbcYMD3StIe9i4hfVOl96EaPd15kjxfErx9L0A5wYQwq3cmr/JOySBNndErxFdTa/QJhUXY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Bfsl1pbg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Bfsl1pbg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 084BBC4CEDF;
	Tue, 21 Jan 2025 17:59:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737482399;
	bh=8CCIlaPObFe/qq48KKRNIINj4w6xKHkBlytEmJZXsHw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Bfsl1pbgeLXen/IKXMiH08pUTbLIKh7ppFPXHIKYbeKpxe7yute2gYlYE8JS5w3l5
	 WWfS2V74yzOOJS2WMAxlJfG1GAAsS7VF6qbc1A1nte3N8ULdxvQiUUjjq0tZT9ghkB
	 WCVEZmszmCvgTAQx7X0cAzqCJnI09hqS0+vh/5S8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 062/122] ACPI: resource: acpi_dev_irq_override(): Check DMI match last
Date: Tue, 21 Jan 2025 18:51:50 +0100
Message-ID: <20250121174535.384508190@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174532.991109301@linuxfoundation.org>
References: <20250121174532.991109301@linuxfoundation.org>
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

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit cd4a7b2e6a2437a5502910c08128ea3bad55a80b ]

acpi_dev_irq_override() gets called approx. 30 times during boot (15 legacy
IRQs * 2 override_table entries). Of these 30 calls at max 1 will match
the non DMI checks done by acpi_dev_irq_override(). The dmi_check_system()
check is by far the most expensive check done by acpi_dev_irq_override(),
make this call the last check done by acpi_dev_irq_override() so that it
will be called at max 1 time instead of 30 times.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Link: https://patch.msgid.link/20241228165253.42584-1-hdegoede@redhat.com
[ rjw: Subject edit ]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/resource.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/acpi/resource.c b/drivers/acpi/resource.c
index d27a3bf96f80d..90aaec923889c 100644
--- a/drivers/acpi/resource.c
+++ b/drivers/acpi/resource.c
@@ -689,11 +689,11 @@ static bool acpi_dev_irq_override(u32 gsi, u8 triggering, u8 polarity,
 	for (i = 0; i < ARRAY_SIZE(override_table); i++) {
 		const struct irq_override_cmp *entry = &override_table[i];
 
-		if (dmi_check_system(entry->system) &&
-		    entry->irq == gsi &&
+		if (entry->irq == gsi &&
 		    entry->triggering == triggering &&
 		    entry->polarity == polarity &&
-		    entry->shareable == shareable)
+		    entry->shareable == shareable &&
+		    dmi_check_system(entry->system))
 			return entry->override;
 	}
 
-- 
2.39.5



