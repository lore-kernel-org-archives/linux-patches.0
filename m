Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3C7125C70F;
	Thu, 17 Apr 2025 18:27:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744914453; cv=none; b=MPRNFZCP1vR990BOmXDfx915TqWR28xmbn27xhJOvoiR7nobeVNASRByrPdTaalFgy9SimfHp+35zWRgUxIa0HS6fPrUX+gawhuPA/MCXswQzsSUI3BxnrPkLfo3dT8swUd/5Ez9oL180hcVUllOevvZ3+UH8GcSLUxpnLvMrN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744914453; c=relaxed/simple;
	bh=u8OKIYADNq8QN8Fx/19/YxH0k8ffKdbwClHoAUvQLsg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ry7Ta21OT/P3fxvwesBCBuXUXZz7UXa75UnpeVOdy4QP+tQEIj3CnufTa3VXiZnEof1DytHvgzqCMcgVZOTKIkF4OWKYAS9NVP/6nMCmTZsiUrDTKfPAGO+BQ52jwu5RZfcK77Z52U2wR+AUgwePa8wXN7+rYkv0WbKbS2Mb8Uw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iMJ7zW/6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iMJ7zW/6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF4D9C4CEE4;
	Thu, 17 Apr 2025 18:27:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744914453;
	bh=u8OKIYADNq8QN8Fx/19/YxH0k8ffKdbwClHoAUvQLsg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iMJ7zW/6+7UW7Be9+8Tu0IjZv5uxi0zZMZQ8p/4gq2cn3wInrxeX8TEBKkRANEbt/
	 5Bay3XY+qLbc4aQ8zLlKWmnHEicyTzyB+JIJkImycV/maM55fOifXlrbe/hBd9Qhya
	 GOgmeAL5KqSoxsAP/2cefh+LUIgBhg0TC0MOmMWU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Hans de Goede <hdegoede@redhat.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.13 221/414] media: ov08x40: Properly turn sensor on/off when runtime-suspended
Date: Thu, 17 Apr 2025 19:49:39 +0200
Message-ID: <20250417175120.327538670@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175111.386381660@linuxfoundation.org>
References: <20250417175111.386381660@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

commit 69dea0ed84611b2b83f4f5fb4f5a1ec4b6bc902d upstream.

Commit df1ae2251a50 ("media: ov08x40: Add OF probe support") added support
for a reset GPIO, regulators and a clk provider controlled through new
ov08x40_power_off() and ov08x40_power_on() functions.

But it missed adding a pm ops structure to call these functions on
runtime suspend/resume. Add the missing pm ops and only call
ov08x40_power_off() on remove() when not already runtime-suspended
to avoid unbalanced regulator / clock disable calls.

Fixes: df1ae2251a50 ("media: ov08x40: Add OF probe support")
Cc: stable@vger.kernel.org
Tested-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/i2c/ov08x40.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/media/i2c/ov08x40.c
+++ b/drivers/media/i2c/ov08x40.c
@@ -2324,11 +2324,14 @@ static void ov08x40_remove(struct i2c_cl
 	ov08x40_free_controls(ov08x);
 
 	pm_runtime_disable(&client->dev);
+	if (!pm_runtime_status_suspended(&client->dev))
+		ov08x40_power_off(&client->dev);
 	pm_runtime_set_suspended(&client->dev);
-
-	ov08x40_power_off(&client->dev);
 }
 
+static DEFINE_RUNTIME_DEV_PM_OPS(ov08x40_pm_ops, ov08x40_power_off,
+				 ov08x40_power_on, NULL);
+
 #ifdef CONFIG_ACPI
 static const struct acpi_device_id ov08x40_acpi_ids[] = {
 	{"OVTI08F4"},
@@ -2349,6 +2352,7 @@ static struct i2c_driver ov08x40_i2c_dri
 		.name = "ov08x40",
 		.acpi_match_table = ACPI_PTR(ov08x40_acpi_ids),
 		.of_match_table = ov08x40_of_match,
+		.pm = pm_sleep_ptr(&ov08x40_pm_ops),
 	},
 	.probe = ov08x40_probe,
 	.remove = ov08x40_remove,


