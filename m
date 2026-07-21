Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81020433042;
	Tue, 21 Jul 2026 19:34:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662489; cv=none; b=KSE4JGAxLJIzgZCJLjoxQKIBjS+puoRUaDf8tRXfFPrztXVtSRSq1eGVTj4KR0KUtP968fp83u8rg8xCeXrIMe0NL/UYyKXAtJ7ZtmuZPejwXpOC3qOu4xSTnjCWKg7HtCPjbSNxRuVUFmdG8JAFpPG4aUpqFdNwA9YfB6dOf9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662489; c=relaxed/simple;
	bh=9UVpfdKTQcUEypYlvt9QeAtClWsUWoqbYA/JpZKEALI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mJZIQa82r2UuZGGaYOFLQgQT+r6npjNzVn3bPLfwFFwmFBN+b8H9y/X1vzdPe0X+mz9FjDQ7HHx/0JdjPY9ZLqeX6RoVEnb6M0RDCDLDLJtLYRDm8EekZt31PxfKSAQp0QuFiqnUCJfsK7xy/VzetxgCkQUYrAxUndDR46AGw/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gXnw4puS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gXnw4puS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4B4D1F000E9;
	Tue, 21 Jul 2026 19:34:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662488;
	bh=K6PD9TRHd4UcaY5I9yuMfLOSigP99D9VwvfhLtkwwb0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gXnw4puSztPFXRlktHfwLDW+gCM4PTs7nGS1gOv0qFniUKyLWuR+7dqM7dUJg1dN3
	 HF/gkc+pcXCc/clwbQfh2yUSOp34ROiB3wSvF8wKBD4TrYMRPP9m1cw60nWU8eQCz8
	 B/SPTCsEVnK8ozKfg/IQ/jnZ7mH5A1nP1+NRva+8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0421/1276] platform/x86: xo15-ebook: Fix wakeup source and GPE handling
Date: Tue, 21 Jul 2026 17:14:24 +0200
Message-ID: <20260721152455.525587154@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

[ Upstream commit b2fc2c6ebbd2d49935c8960755d8170faead2159 ]

The device_set_wakeup_enable() call in ebook_switch_add() doesn't
actually do anything because power.can_wakeup is not set for ACPI
device objects.  Moreover, had it done anything, it would have
registered a wakeup source object that wouldn't have been used
going forward and that wakeup source would have been leaked after
driver removal because ebook_switch_remove() doesn't clean it up.
Accordingly, remove that call from ebook_switch_add().

Also prevent leaking an enabled ACPI GPE after removing the driver by
adding appropriate cleanup code to ebook_switch_remove().

Fixes: 89ca11771a4b ("OLPC XO-1.5 ebook switch driver")
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Link: https://patch.msgid.link/1966125.tdWV9SEqCh@rafael.j.wysocki
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/xo15-ebook.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/platform/x86/xo15-ebook.c b/drivers/platform/x86/xo15-ebook.c
index df2bf1c585239b..baeee33d6352e8 100644
--- a/drivers/platform/x86/xo15-ebook.c
+++ b/drivers/platform/x86/xo15-ebook.c
@@ -38,6 +38,7 @@ MODULE_DEVICE_TABLE(acpi, ebook_device_ids);
 struct ebook_switch {
 	struct input_dev *input;
 	char phys[32];			/* for input device */
+	bool gpe_enabled;
 };
 
 static int ebook_send_state(struct acpi_device *device)
@@ -132,7 +133,7 @@ static int ebook_switch_add(struct acpi_device *device)
 		/* Button's GPE is run-wake GPE */
 		acpi_enable_gpe(device->wakeup.gpe_device,
 				device->wakeup.gpe_number);
-		device_set_wakeup_enable(&device->dev, true);
+		button->gpe_enabled = true;
 	}
 
 	return 0;
@@ -148,6 +149,10 @@ static void ebook_switch_remove(struct acpi_device *device)
 {
 	struct ebook_switch *button = acpi_driver_data(device);
 
+	if (button->gpe_enabled)
+		acpi_disable_gpe(device->wakeup.gpe_device,
+				 device->wakeup.gpe_number);
+
 	input_unregister_device(button->input);
 	kfree(button);
 }
-- 
2.53.0



