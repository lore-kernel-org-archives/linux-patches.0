Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF53F328619;
	Mon, 27 Oct 2025 18:49:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761590993; cv=none; b=h2KpSzLqC3hBzby7oAjbN9j404AYZyx/XnheFiVQ8xQGIRDnga8iPlOz6oFdbyd8lOZIFo9iJ2GsJcT7zk0QV9VFq2B5KdpjBlFQSjebD9ZCkW8uOpsssEi/Ll32jNOrKUlOMZBT/WSotQjflbZwCqA9VhEAknbpjpyqy1v9+8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761590993; c=relaxed/simple;
	bh=Ko2ZEESjdg0yPQL4yoiEiq/l2bYtmaawN93GlLlgdfk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dg3z8RshsGTrjBsJKjC7e49wALAAY+cXQG5D8qg57ElEsAwaVXfplS51ihiQ+2+qBluTF1PHwzM7CUb0+y2Jx1Ygu8zK1hLG0gppbrJiasZTHgGTSsMYYDoBnag4zkMry/Tz5ms1vHL2u+AH7LLqVxHFrQrq8rchP9umRHVnNes=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cjS2NVMT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cjS2NVMT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1990C4CEF1;
	Mon, 27 Oct 2025 18:49:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761590993;
	bh=Ko2ZEESjdg0yPQL4yoiEiq/l2bYtmaawN93GlLlgdfk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cjS2NVMTA8JKT5AxuOLb0NMhhS86m4dGtECe/100wk+A+LDcHcnzWLC5cRldV+FGJ
	 XPXbehA6TWTcexVi/Oz5KO9CyJHcW0oBHUjpNFaIvja2WAkSbXTBsrGfuQbJPeWeAI
	 8fjJOpz1J58D/uKWvctqVXhKbdogZ1ePgGuDkLIY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Huisong Li <lihuisong@huawei.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 026/332] ACPI: processor: idle: Fix memory leak when register cpuidle device failed
Date: Mon, 27 Oct 2025 19:31:19 +0100
Message-ID: <20251027183525.312414099@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183524.611456697@linuxfoundation.org>
References: <20251027183524.611456697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Huisong Li <lihuisong@huawei.com>

[ Upstream commit 11b3de1c03fa9f3b5d17e6d48050bc98b3704420 ]

The cpuidle device's memory is leaked when cpuidle device registration
fails in acpi_processor_power_init().  Free it as appropriate.

Fixes: 3d339dcbb56d ("cpuidle / ACPI : move cpuidle_device field out of the acpi_processor_power structure")
Signed-off-by: Huisong Li <lihuisong@huawei.com>
Link: https://patch.msgid.link/20250728070612.1260859-2-lihuisong@huawei.com
[ rjw: Changed the order of the new statements, added empty line after if () ]
[ rjw: Changelog edits ]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/processor_idle.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/acpi/processor_idle.c b/drivers/acpi/processor_idle.c
index 949efdd1b9a18..cf824841ffead 100644
--- a/drivers/acpi/processor_idle.c
+++ b/drivers/acpi/processor_idle.c
@@ -1406,6 +1406,9 @@ int acpi_processor_power_init(struct acpi_processor *pr)
 		if (retval) {
 			if (acpi_processor_registered == 0)
 				cpuidle_unregister_driver(&acpi_idle_driver);
+
+			per_cpu(acpi_cpuidle_device, pr->id) = NULL;
+			kfree(dev);
 			return retval;
 		}
 		acpi_processor_registered++;
-- 
2.51.0



