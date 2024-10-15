Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB16B1D90CD;
	Tue, 15 Oct 2024 11:52:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728993166; cv=none; b=n6GAwy0Qw0N50qmqTBnrtDY2WvASe0ut9dMq+wPzaEM9YLGlZi5TjA7mSWJJXXi03nOW0rCH+LfV0iPW8228vtB62aKxe47UN9YpDezwINAeHppfIFmGIkjE/nw3ykaYqNSq7ZWx0Nht0OSfOvV4tfooL6cncit00fs5kiu/owY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728993166; c=relaxed/simple;
	bh=scuaBc/33nDt/8UwNLxCDfj8K4xSxjfTrLH/Uh/Qbgg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RwouOrtZJPhJO4Z/pOSm2jz2VgA32O+x6D40ew8T6dvddfm9zXQAdn/J6FfpCyG1l9FYiccPfaoC2EAPETbilQGhCTNGcI76zUmTKycRIzeS7I/fJYKPB0OVZQM+Kp7iiAjruR8XV0+JnvmQibfPjtTYn+AbKVWrz1NxmewLkXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F+H0xIOn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F+H0xIOn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28CB1C4CEC6;
	Tue, 15 Oct 2024 11:52:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728993165;
	bh=scuaBc/33nDt/8UwNLxCDfj8K4xSxjfTrLH/Uh/Qbgg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F+H0xIOn+XgwgGvD8pJMnCfKnCWRnlwJ81/1+Kyd5lzk4u/SMJcZOVKIml/UDNu+e
	 hK9xvMmSZQI+/FP7ixy+9FE9RTdZqUDt3scO7ga4SAKw+FeRG40xmSaTIlTpD88AYQ
	 ID6TNnqxwXfmBuNIztG6tifjoVSNGZatMO3GMfBE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 5.15 331/691] ACPI: sysfs: validate return type of _STR method
Date: Tue, 15 Oct 2024 13:24:39 +0200
Message-ID: <20241015112453.472715417@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -543,8 +543,9 @@ int acpi_device_setup_files(struct acpi_
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


