Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B85B1E9B38;
	Tue, 21 Jan 2025 17:54:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737482093; cv=none; b=CWa705+F5nxDkXDKBZa0vFmgUfvzJjqSWFQ4qnRmlakGeFKExGEV8K6tCetrv8lDyaQRH/YbUIRlxxxAGIa2qAFXJNc+t1SypuTTWFUh8d5dnJjY2hzK0X/c2CIz872qDvto78oTn100MC7ZUtSpX8Mzz6iroAW+R2l1uRuWCSI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737482093; c=relaxed/simple;
	bh=rU6KI3MRIRosZmIm0s/p+uUsIlyBnmwYl7ExBbDrZmA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dUyPv0QsX/Sgfk6XQIsvVgULOFiZrJmirn4+Q8BE+/lE+/XTwxF26YiGFdKq3HlnJ6RpMWKyt03jHZ6tMLtZUPyXvWEMlLdhYd9ONHhrX8Y5H8CicPek5G8dNo7iW/Ajv9q2fmL7ofiw8h1lKloqIa18CVNj+lvi+My4YFJ8pu0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L0Sdhl1r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L0Sdhl1r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD8A0C4CEE0;
	Tue, 21 Jan 2025 17:54:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737482093;
	bh=rU6KI3MRIRosZmIm0s/p+uUsIlyBnmwYl7ExBbDrZmA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L0Sdhl1rE5nlFzypueqOSvu8dIXS+YsImM3A/TpBclglYimYBJZnQp4tjuLlPdF48
	 hjZ98iVFzs4t8fksTeAaw6eUJS8cRgdLJzgB9vmg4b/iTwU2zi2keorsZf1UilFilS
	 0DfYZ8vJtCnMnfZydmTzQt4F76A5sMST0ynykoPw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 32/72] ACPI: resource: acpi_dev_irq_override(): Check DMI match last
Date: Tue, 21 Jan 2025 18:51:58 +0100
Message-ID: <20250121174524.661571924@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174523.429119852@linuxfoundation.org>
References: <20250121174523.429119852@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index c82b255f82bc4..64d83ff3c0d90 100644
--- a/drivers/acpi/resource.c
+++ b/drivers/acpi/resource.c
@@ -680,11 +680,11 @@ static bool acpi_dev_irq_override(u32 gsi, u8 triggering, u8 polarity,
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



