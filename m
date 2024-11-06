Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 839221F4296;
	Wed,  6 Nov 2024 13:03:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730898224; cv=none; b=OI3DY7BqWCT6xSEm6D7oIREW50CIGU1z/1c1N9OEmblyuJINB6qLHKXk4QNag9EsqEl3UBReMwzrR62ODbgNNqPE/28ybWTSQLz1JUXVXalRs9vcah05oWaQI3QDUiOcdS6R3ikvVBPueQ3QwH7lgi26qBb0b1rn9AkhjtteQ8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730898224; c=relaxed/simple;
	bh=fKPuP9k2fY4WQ0a5Lb/wEuU6CL35bp+0A4wzWm6Ib/w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WZ+ojZU6jBQrx2vnOKWp3pO2IS6o338OYATnoRQHoTQXiujhCir8oqkx/NWf6gD6vFEkwgf+WX3hFb13WuWKlo1QSRsVKqw4s6p5h5MhjawyY0My5FnXsI8MdXGwEz6nAoX79R1AlmmR5E3mphe8Fy8i/Tc9+olrAzziru30qmU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HyZ4yXpR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HyZ4yXpR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A0CEC4CECD;
	Wed,  6 Nov 2024 13:03:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730898224;
	bh=fKPuP9k2fY4WQ0a5Lb/wEuU6CL35bp+0A4wzWm6Ib/w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HyZ4yXpRXrSGR6xoXOn1D7RAIAFTB+y9C/JtAYPfEHmVOEE9i+Iet/mZ4SGbR6ygd
	 M1Y7lDlYs38gh4AiMaPFO3EDlOWV7bXMq2mhWLycbYeZemNO74T6/7Af/r4TdAAdUt
	 F577GFhOiewTNIi9v8iSkjeljE9UbhhhNw14CYqU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 5.4 149/462] ACPI: sysfs: validate return type of _STR method
Date: Wed,  6 Nov 2024 13:00:42 +0100
Message-ID: <20241106120335.191894837@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
User-Agent: quilt/0.67
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Weißschuh <linux@weissschuh.net>

commit 4bb1e7d027413835b086aed35bc3f0713bc0f72b upstream.

Only buffer objects are valid return values of _STR.

If something else is returned description_show() will access invalid
memory.

Fixes: d1efe3c324ea ("ACPI: Add new sysfs interface to export device description")
Cc: All applicable <stable@vger.kernel.org>
Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
Link: https://patch.msgid.link/20240709-acpi-sysfs-groups-v2-1-058ab0667fa8@weissschuh.net
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/device_sysfs.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/acpi/device_sysfs.c
+++ b/drivers/acpi/device_sysfs.c
@@ -533,8 +533,9 @@ int acpi_device_setup_files(struct acpi_
 	 * If device has _STR, 'description' file is created
 	 */
 	if (acpi_has_method(dev->handle, "_STR")) {
-		status = acpi_evaluate_object(dev->handle, "_STR",
-					NULL, &buffer);
+		status = acpi_evaluate_object_typed(dev->handle, "_STR",
+						    NULL, &buffer,
+						    ACPI_TYPE_BUFFER);
 		if (ACPI_FAILURE(status))
 			buffer.pointer = NULL;
 		dev->pnp.str_obj = buffer.pointer;


