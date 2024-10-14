Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 869ED49659;
	Mon, 14 Oct 2024 15:07:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728918432; cv=none; b=bIi0RT5CcQrEiOg0am+cKqjorbbzkrzeLKB8iLWy2jvNSiixSdM+D2wvLa32iVIutMgqjIdCEk+bvT9ch6AzRxV0+iDnhtLv4ztZLqFZQ2+1O6lChp6mfmqNwZQhweJLAmxILp1wrQxXkuYFyp09aFOppJMg6Ami20IquF39Q2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728918432; c=relaxed/simple;
	bh=1y5l8SlHMPkNON8iLPpy7LD+7paniQ53sY9XwKFAwDo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DvJ/Khp/KJ1JNiRgLErfwu4kZnRfgmEgpLwktEsVxdJk4MiRin2/wqOmTZ/teLac/OpijuT4tHdsABH1hgfOmZ98YTYjN9FzSMIOazJury5z2e2MmYCXYuuUnH6Y9ey2uVhwVARBOU5awpNZ3auX26n8Wf9eGhUm8G5YUj1ly24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VsB77yGX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VsB77yGX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA214C4CED1;
	Mon, 14 Oct 2024 15:07:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728918432;
	bh=1y5l8SlHMPkNON8iLPpy7LD+7paniQ53sY9XwKFAwDo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VsB77yGXJ6/TRz+mPIT8f5MRpYX6u4UOnM5mJdG8g3GpYfFgjgIgcc9LzYJXb4847
	 hftyOWGrdsj9D4PK6+v8jqzBE2ftr8Ct+i0oo4nYNNwNgQ6CkCouzmuGytWe7MnKiq
	 pdRywMAgZc8Qz1GBKF0UvVIMypBtwkrOFvnycWu4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.1 320/798] ACPI: sysfs: validate return type of _STR method
Date: Mon, 14 Oct 2024 16:14:34 +0200
Message-ID: <20241014141230.526775869@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -544,8 +544,9 @@ int acpi_device_setup_files(struct acpi_
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


