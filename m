Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 950BA1D5AD7;
	Wed,  6 Nov 2024 12:12:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730895130; cv=none; b=RrMdKAVkM5lLeuj6jG4QUBd2NjYIW+55wMQvZOtC6qQsGN/Cfyt1QSwXUYucwpH/2cVqSfde4mNK9s0Hy0r0wh5yewe1nMGEMz/tzXAvp5/jzzvhd6K7Tn2mD8hgAe4tXsj+ysaRqZI51r4x1N1DRrL/hg/dLPEIkVZ3Haa7URI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730895130; c=relaxed/simple;
	bh=CSwjAWfQFV3QxecjS4/3WPDN14+Uy3/dNI/UTYeGEok=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MgJc0PV74oIwUOxUPlzO1EFD/l4QQiKNNQEFt12599N/QWNQAbcZ0TrS5hXZMy3mSowfU+/74P5MHmp1aXlu44W7Dr0RCXLbJyGghhOkBm3BK53E/ZryHpg4D+nbhEvzPJCY0Qi+V7jpUdtCYE4/Rsdcs6FUUGjDi5ifcjeuSfM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aMHlKagl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aMHlKagl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16471C4CECD;
	Wed,  6 Nov 2024 12:12:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730895130;
	bh=CSwjAWfQFV3QxecjS4/3WPDN14+Uy3/dNI/UTYeGEok=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aMHlKaglqvQtCkpa/VzvwguF85+excRJswytcv8/eveExc1tuiULVP7ivjMygFunk
	 BRB1MnrKzXlj21kAycvPgkeDFeaf6ulAtUTASiSEMHfkLlMuiL+z9RxiVxujOUkrWA
	 +QUaUZpdAwG+bk+UQNT7u7d07oGaQKABB6inXphM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 4.19 115/350] ACPI: sysfs: validate return type of _STR method
Date: Wed,  6 Nov 2024 13:00:43 +0100
Message-ID: <20241106120323.745273173@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120320.865793091@linuxfoundation.org>
References: <20241106120320.865793091@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
@@ -539,8 +539,9 @@ int acpi_device_setup_files(struct acpi_
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


