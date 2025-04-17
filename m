Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C52331EB1BF;
	Thu, 17 Apr 2025 18:05:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744913147; cv=none; b=rPFSuKij/Gcsh8+4I+A7ysWNN1U84PTCCSA5Dyl6GcJA8oM266uCZWuSzgKYwfxCuXqK6GFigLgiU2jpB4ywLYRylKGrLUIgLWsg8AgyG5QTXlRkjxSVjPneQouiaZ/XxXRwlbjughy8hhvHM+rsgssswfQeEKt707elQXVzwdo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744913147; c=relaxed/simple;
	bh=1gP/y9TeceGfVMe/58d9Vxvx6WoA1BUJZLT6xLQnShw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CNRH+XI2SXda8Ugy446bwHoKxviDkoTF3syUHc+ooBs1A98VfX+rEke5SaX9+aDKkjRO0MscwCxmQFWe6NDUu3GegEyvP/d1WEM8Pjp7BZqdXR1Ngqa4gYgTQRwuL6W91uyRdnzqGTk4XkeijEIr83nx9auJkaA/1ItFqyqadac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iEnxlPa7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iEnxlPa7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0FC0C4CEE4;
	Thu, 17 Apr 2025 18:05:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744913147;
	bh=1gP/y9TeceGfVMe/58d9Vxvx6WoA1BUJZLT6xLQnShw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iEnxlPa7Kv0l0AfxNNtKosr5PBzq9XSy4a2wNuIKdi0NblLSP0zowO5lh+R1UJ162
	 ufXpdvy2IW0VfijDRjwJyx1a/BpXrK+yOYAe6OimSf0lZBF5ya2yJQdeLhfpx/ZZbt
	 5/qtvzwsOfqU7eW/1BbV8h3UccaQj87UgunhF12o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Hans de Goede <hdegoede@redhat.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.14 243/449] media: ov08x40: Properly turn sensor on/off when runtime-suspended
Date: Thu, 17 Apr 2025 19:48:51 +0200
Message-ID: <20250417175127.779485358@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175117.964400335@linuxfoundation.org>
References: <20250417175117.964400335@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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


