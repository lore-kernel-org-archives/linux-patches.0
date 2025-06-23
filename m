Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 685D31AD3FA;
	Mon, 23 Jun 2025 21:52:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750715553; cv=none; b=XkaP+P0FxuRVcXmitM2aPUqqQrO+qOjvitC3iHbZNB6wrS5wfv9bpht1K+zZ6DTMDgRvepb0i+wlDqu0NPRcWHv6IQsFx7HoXWMouyYZjm2m6YEZbLrZkv0Fxs3CHCsyu5ifRn8pvSRjGJw67Z2GO9Bv6Z5zrySmy6DhXpdFH/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750715553; c=relaxed/simple;
	bh=ZdS+Z5KsdKj60QfXbXuxYW9JZKuCLI5XWXsofVfEBMw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hybh4f2TSLVymnY8ORsxT8FJ1Kr9reKHAjERgOXKUXG94zKeQJmgLFmBGjC/YgdsxHPOVK5RoO+AYC6OzON1dKhuHayyOqQdORZO2aCTHh2U5IPNiyrqX9X3wyw3c1RMw70ltZOzb0i6CWm9n0DlyeeBsIJokH0ANaml7n1/1MU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QwCardAo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QwCardAo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6C47C4CEEA;
	Mon, 23 Jun 2025 21:52:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750715553;
	bh=ZdS+Z5KsdKj60QfXbXuxYW9JZKuCLI5XWXsofVfEBMw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QwCardAo0XNlVMBmNsZu89nik163iKxABqPGwq0HdhA4I9RbLmObQbwG0ypN44Wg/
	 n/hxEpJ/280W8b2yB4pL3lERE8J47rFKFvzAXMGd6FijC5ejXjfgEOIJJy0JXdx7Z8
	 mHxxy/owN3panQPdgsN2NKLrcp5wrLTKFFHek82I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Armin Wolf <W_Armin@gmx.de>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 265/411] ACPI: bus: Bail out if acpi_kobj registration fails
Date: Mon, 23 Jun 2025 15:06:49 +0200
Message-ID: <20250623130640.328322930@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130632.993849527@linuxfoundation.org>
References: <20250623130632.993849527@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Armin Wolf <W_Armin@gmx.de>

[ Upstream commit 94a370fc8def6038dbc02199db9584b0b3690f1a ]

The ACPI sysfs code will fail to initialize if acpi_kobj is NULL,
together with some ACPI drivers.

Follow the other firmware subsystems and bail out if the kobject
cannot be registered.

Signed-off-by: Armin Wolf <W_Armin@gmx.de>
Link: https://patch.msgid.link/20250518185111.3560-2-W_Armin@gmx.de
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/bus.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/acpi/bus.c b/drivers/acpi/bus.c
index 9bc5bc5bc359b..ea63b8f272892 100644
--- a/drivers/acpi/bus.c
+++ b/drivers/acpi/bus.c
@@ -1335,8 +1335,10 @@ static int __init acpi_init(void)
 	}
 
 	acpi_kobj = kobject_create_and_add("acpi", firmware_kobj);
-	if (!acpi_kobj)
-		pr_debug("%s: kset create error\n", __func__);
+	if (!acpi_kobj) {
+		pr_err("Failed to register kobject\n");
+		return -ENOMEM;
+	}
 
 	init_prmt();
 	result = acpi_bus_init();
-- 
2.39.5



