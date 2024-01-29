Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 775B315B96D;
	Mon, 29 Jan 2024 17:12:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548323; cv=none; b=GBqra2l+ylVfL6Uxf6yBarMkTcg6CKxgF+L6dVqiWhyzPSq4QZ0wkB5LH5ssEM+qSlKg9dzoaXGKn8zWnQwfnFNmRgUs+FhNFN0UFAe7umLbt5KCKAQs+sxsFLqfAMiCl7ZGlS+6ZTYYeeGzQeZRf4dxKIZLdCbBLIF552ACov8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548323; c=relaxed/simple;
	bh=pi2BSln4bHKm6BUp5NwOaG43rQD3FfgR0vwBY7Dz10E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pSD3G991jM0usJOXw7bU4RlNJXQsOImlVxHy7zBVcu5VCmRjGVtzjlQSOKneAGt22qoeptZgsQrZaFDBZQ1JUyI1EoToMZ6qxwkTKxOYy6dHNvK+9/2D4efQOu0IY81SZSi+UIuOYaI19+yc6sg8ZZu8Bz+U7Sn5Tg+08ONrLL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AzQJxrve; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AzQJxrve"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34477C433C7;
	Mon, 29 Jan 2024 17:12:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548323;
	bh=pi2BSln4bHKm6BUp5NwOaG43rQD3FfgR0vwBY7Dz10E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AzQJxrveUF8yMpx5rYqyOLN1daPsUUIkh5PPK1B3uSRPZhHLbddvqIfKicZ00+Ojr
	 K4Mcx7ZOPdPAGelicCfDSWSCA+0JWw6JT/5QLAa7ZztAQm2YtdK6k+/DCxpgxpA0Ar
	 ftwsv1LfjnjypmXkvvbMnAlV/v24T/3jy0c+tyBI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Armin Wolf <W_Armin@gmx.de>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 324/346] platform/x86: wmi: Fix error handling in legacy WMI notify handler functions
Date: Mon, 29 Jan 2024 09:05:55 -0800
Message-ID: <20240129170026.008559055@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170016.356158639@linuxfoundation.org>
References: <20240129170016.356158639@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Armin Wolf <W_Armin@gmx.de>

[ Upstream commit 6ba7843b59b77360812617d071313c7f35f3757a ]

When wmi_install_notify_handler()/wmi_remove_notify_handler() are
unable to enable/disable the WMI device, they unconditionally return
an error to the caller.
When registering legacy WMI notify handlers, this means that the
callback remains registered despite wmi_install_notify_handler()
having returned an error.
When removing legacy WMI notify handlers, this means that the
callback is removed despite wmi_remove_notify_handler() having
returned an error.

Fix this by only warning when the WMI device could not be enabled.
This behaviour matches the bus-based WMI interface.

Tested on a Dell Inspiron 3505 and a Acer Aspire E1-731.

Fixes: 58f6425eb92f ("WMI: Cater for multiple events with same GUID")
Signed-off-by: Armin Wolf <W_Armin@gmx.de>
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20240103192707.115512-2-W_Armin@gmx.de
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/wmi.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/platform/x86/wmi.c b/drivers/platform/x86/wmi.c
index 5dd22258cb3b..bd017478e61b 100644
--- a/drivers/platform/x86/wmi.c
+++ b/drivers/platform/x86/wmi.c
@@ -686,9 +686,10 @@ acpi_status wmi_install_notify_handler(const char *guid,
 			block->handler_data = data;
 
 			wmi_status = wmi_method_enable(block, true);
-			if ((wmi_status != AE_OK) ||
-			    ((wmi_status == AE_OK) && (status == AE_NOT_EXIST)))
-				status = wmi_status;
+			if (ACPI_FAILURE(wmi_status))
+				dev_warn(&block->dev.dev, "Failed to enable device\n");
+
+			status = AE_OK;
 		}
 	}
 
@@ -729,12 +730,13 @@ acpi_status wmi_remove_notify_handler(const char *guid)
 				status = AE_OK;
 			} else {
 				wmi_status = wmi_method_enable(block, false);
+				if (ACPI_FAILURE(wmi_status))
+					dev_warn(&block->dev.dev, "Failed to disable device\n");
+
 				block->handler = NULL;
 				block->handler_data = NULL;
-				if ((wmi_status != AE_OK) ||
-				    ((wmi_status == AE_OK) &&
-				     (status == AE_NOT_EXIST)))
-					status = wmi_status;
+
+				status = AE_OK;
 			}
 		}
 	}
-- 
2.43.0



