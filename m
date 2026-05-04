Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ADEC3D9029;
	Mon,  4 May 2026 14:04:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777903480; cv=none; b=NnH+K184ovX6t2uaatwuaT37kuY9lN/xYLoEwRPCjBmQ4ShmvYDVuMhFrmRo3W5xnzwyvy4PFjxif28rIZlnyX63QPylRZVcx9f+EJEQZ+nuBGxhWgjN/u3TsxgGmbj0/r/TFWkaVB1qVQGGW82zg75pkjxrZ2pWvZxy3HBVlLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777903480; c=relaxed/simple;
	bh=cEuKnlYXp4dseraV60XEvUp82F9v7FjPVwROeqoU18k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k3pn6LuqiJdgs0L47av9ue4aqhc6kOKn7LimMGAp9oYzpC8x4cV1XGyOrRC0wlltt+xtVmunNj+pvFqJ06gTTCcabizIBGlEl4ZPB+SdX+F1mgAgjAu4MG1k+Sg1z7821MTwdTot4b02u6ZB9VdLaC4cmwKJ9qBmt0oJctUZvDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qk1+7sRJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qk1+7sRJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20D42C2BCB8;
	Mon,  4 May 2026 14:04:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777903480;
	bh=cEuKnlYXp4dseraV60XEvUp82F9v7FjPVwROeqoU18k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qk1+7sRJ6kO1xbmkMKKUtx/CE+vY32xXaM5phovf8Xw0C+mWv7SCy+mZQnm6HCURs
	 LCoq5AwU0wNvCuRsloNGr7+5Q9najxLFo5lT/zof8ddO/ig4w2DC2uY6Fb3Pj323jX
	 xLMdC0kvqCXcOrklMqdGXBG/ZVU2+881B6OdfSe8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brian Mak <makb@juniper.net>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Lee Jones <lee@kernel.org>
Subject: [PATCH 7.0 251/307] mfd: core: Preserve OF node when ACPI handle is present
Date: Mon,  4 May 2026 15:52:16 +0200
Message-ID: <20260504135152.266350709@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.814938198@linuxfoundation.org>
References: <20260504135142.814938198@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Brian Mak <makb@juniper.net>

commit caa5a5d44d8ae4fd13b744857d66c9313b712d1f upstream.

Switch device_set_node to set_primary_fwnode, so that the ACPI fwnode
does not overwrite the of_node with NULL.

This allows MFD children with both OF nodes and ACPI handles to have OF
nodes again.

Cc: stable@vger.kernel.org
Fixes: 51e3b257099d ("mfd: core: Make use of device_set_node()")
Signed-off-by: Brian Mak <makb@juniper.net>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://patch.msgid.link/20260325223024.35992-1-makb@juniper.net
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mfd/mfd-core.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

--- a/drivers/mfd/mfd-core.c
+++ b/drivers/mfd/mfd-core.c
@@ -88,7 +88,17 @@ static void mfd_acpi_add_device(const st
 		}
 	}
 
-	device_set_node(&pdev->dev, acpi_fwnode_handle(adev ?: parent));
+	/*
+	 * NOTE: The fwnode design doesn't allow proper stacking/sharing. This
+	 * should eventually turn into a device fwnode API call that will allow
+	 * prepending to a list of fwnodes (with ACPI taking precedence).
+	 *
+	 * set_primary_fwnode() is used here, instead of device_set_node(), as
+	 * device_set_node() will overwrite the existing fwnode, which may be an
+	 * OF node that was populated earlier. To support a use case where ACPI
+	 * and OF is used in conjunction, we call set_primary_fwnode() instead.
+	 */
+	set_primary_fwnode(&pdev->dev, acpi_fwnode_handle(adev ?: parent));
 }
 #else
 static inline void mfd_acpi_add_device(const struct mfd_cell *cell,


