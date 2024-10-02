Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECC9A1D0E1C;
	Wed,  2 Oct 2024 14:21:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727878891; cv=none; b=oWdl4dIox/78CZ60dsnC/si+DVKU1T0L4YG5v4LhTdkGqqWLcspEXARPXOv8ipOS7TBK796DpHtJaPk0K/OlTuzsJ4f0hu7Am1m6z5mThca/9F4SacrfyUNHww1vnxcRBKIJZcv2EM4n4qsYzKpbefDkDFcCoIAYFI2dPgWY62Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727878891; c=relaxed/simple;
	bh=QaW/ebcYO1wT+nz50cTmAacXIQPWkbV7SKrdzftsNNo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=N2BHy1S216WUW0xPkZaLHdiVnzZe+PandaK5XYc641j+d0psQyRmAxo0mQiNpkdyRy6kiocOXT3Ezd7LTwgg34GCcZTzgvdOY3fEF5EMw2posjvt3gr85KR5kwwVnL2rd6KkaXTyVSd/urakKBWtgTo9ZvNWbR79fimSabCsvsY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a4tbgRag; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a4tbgRag"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 728F4C4CEC5;
	Wed,  2 Oct 2024 14:21:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727878890;
	bh=QaW/ebcYO1wT+nz50cTmAacXIQPWkbV7SKrdzftsNNo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a4tbgRagrhZK6rM2Kl0gawFz62UTOFb95Mmi74grbp5LaFumg9oAR/PgsNwXwBxnm
	 7fEkblUxzDynmhaSrlT4C8UbbMoEJvKNOi1n68DRvnemyXjQPFwq3R+JF2UfDRQusS
	 37/Ixa6SKTB3wu0iCTwturUqb8dfaDuMYTzjxRa8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.10 540/634] ACPI: sysfs: validate return type of _STR method
Date: Wed,  2 Oct 2024 15:00:40 +0200
Message-ID: <20241002125832.424244107@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -540,8 +540,9 @@ int acpi_device_setup_files(struct acpi_
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


