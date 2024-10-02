Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02E8D1D0B8C;
	Wed,  2 Oct 2024 14:46:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727880405; cv=none; b=jEs6MEtLIqVXuUI1abCyll9ngRQVND+AY39tvZMCec4KoxrQsWrR48R5I3SsRscqAuI1YLy8BnRHbF85INPcVXXjsXbWM7chcguFCzhQVEF2XlRKs8l62aMhKuAnbjXWOKjGOVHoSQ5tJpve+xMrFBADp45MNbrkY69517By0Rk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727880405; c=relaxed/simple;
	bh=7i5PAEVuA77Vw0N0PSORFwqJUTrc1qDFSDKxfXIgasc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CL9R9kJYD/KOyUV8sHNKMa7Of9f+2MYhkdcffn6d4ou29aPxBY3KZLhCsTSQyOTMOrpoYJszzH6HN06D5UTStRDVdIeHPbKfnu8GFbJe/v3HN85h22qmLp/kFq9QivFBYjC14V5jBeRQnj/50XoJPylbeIZZtWKRHufje0dhPpk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t8fUVRRS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t8fUVRRS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DC54C4CEC2;
	Wed,  2 Oct 2024 14:46:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727880404;
	bh=7i5PAEVuA77Vw0N0PSORFwqJUTrc1qDFSDKxfXIgasc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t8fUVRRSkeINxdTgGCRFLmKV5BegWo41Fk6xNiCTup8rrMv9oqNRfI33NqCMbuC6S
	 djEM2sHHGhT4issVt8RfUvj3z0sTHwJPZuEjEqgr9QROuuoHlVsXiKk1hztDD7lMh2
	 E01dDpuHb44L6NGvHfTlYYcUBmfLqON3k1DTEy4U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.6 448/538] ACPI: sysfs: validate return type of _STR method
Date: Wed,  2 Oct 2024 15:01:27 +0200
Message-ID: <20241002125810.125676448@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


