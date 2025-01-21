Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D86F1F427B;
	Tue, 21 Jan 2025 18:04:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737482651; cv=none; b=HJ//NMh1Ra301XKA8pQAJKPcMKpzNBhGMLIlrDPzMCNqtsRc4sWvTUQItvALjFYt0IqW/lqvGlmhMX/JvSqGS2JCt6mUuJ+wMiWcDcsudsYBk1FYxOjAk7DMWnMBsul4kIeL9+QYMMvj3j5rs25DEPHgvHvwcd3krpm9Y8vVMG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737482651; c=relaxed/simple;
	bh=342yvIiHyrGHBeU8+eYkUsgQ/y/YcY43svtIwywKv/o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N5z9qNNGjfcyU5F5c0hbRrjWDBgfhYxt5hN9BkcShTtHtqrzWG6/WSVKGDU8qBlsIyRCUZRQOKW89G6WRyRaOGej/XYdemK713ZnVSsqu5gh+c85aD52O3e9Itxy0hWrUabxvmEK34Sfk0w71BJtHCdx+p7PTfTmOLvFn3x0ynM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Jryo1Vde; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Jryo1Vde"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3825EC4CEDF;
	Tue, 21 Jan 2025 18:04:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737482650;
	bh=342yvIiHyrGHBeU8+eYkUsgQ/y/YcY43svtIwywKv/o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Jryo1VdeXmeV1JwsqeTN6K5+4j8svz5mB5qXimSX3B4jgXEBqdlPXH6T3ye7nCgfR
	 zpe9qdoAZ61HAuR5gndo2kfC1sj5/6YnVVfSzW1qGq2REF/+xJ2UIvyvZOcB2Cbkqx
	 5E2ZQnnikd7ssL0/9Hfwqr1UZ0HpIjAdwgggmhp4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 26/64] ACPI: resource: acpi_dev_irq_override(): Check DMI match last
Date: Tue, 21 Jan 2025 18:52:25 +0100
Message-ID: <20250121174522.553832255@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174521.568417761@linuxfoundation.org>
References: <20250121174521.568417761@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 6e041d40cad50..34cb7894e54ee 100644
--- a/drivers/acpi/resource.c
+++ b/drivers/acpi/resource.c
@@ -663,11 +663,11 @@ static bool acpi_dev_irq_override(u32 gsi, u8 triggering, u8 polarity,
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



