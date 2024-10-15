Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96EA01C07FF;
	Tue, 15 Oct 2024 13:09:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728997748; cv=none; b=MpKgxgJ+Z8Y9xNRh6slYx3zznaPTvtFVP+HEyeLXa6cx8s49qdEPe2ZCb0kKLvqyxn5MsbkrDpbpFLxH6HXKDEy6oMrvZKKemQTGPUDLJeEg1L7/9Ahz6uaafY4mIOLDTnoG+agvvHArppamx6liuLNeQyU0Crkecdi1W3+C1n8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728997748; c=relaxed/simple;
	bh=kD4oI/DaDZqGuZrTWD4d5QAJtYjWri3uINDlvo/pRQs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LKEOLvA4k2AG8Fj6Kxzl8PORRd9TEWBytMRQq6/2Lthz08hWAksTvPrv+i7XB8l8YIanU5DYMuaYr58ETk87xUdy5QPqdRFeUcQceEkJVOIi/72piH2lvFKAX5PbZLwuOm/279gWT5WvCYNIdVx8fV4osnpyNcA0D3gdhE3tNNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j8/UZHhZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j8/UZHhZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADD03C4CEC6;
	Tue, 15 Oct 2024 13:09:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728997748;
	bh=kD4oI/DaDZqGuZrTWD4d5QAJtYjWri3uINDlvo/pRQs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j8/UZHhZJWPblYsJ7Ex2usF3UVTWPnDUPIOAbV02QupPCj2JIjvPoQ0R9+pjc/EUx
	 S1+P5pjDPcRg2CKkJlZdZBxIxMBd5WTesB8ihKc+/Lcwo7Hn0zEoW2KTnctcXllWV9
	 k7Z6+RdwP92vYip6KiPPdiA5So072IxxMgO33Szo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 5.10 233/518] ACPI: sysfs: validate return type of _STR method
Date: Tue, 15 Oct 2024 14:42:17 +0200
Message-ID: <20241015123925.985149440@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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


