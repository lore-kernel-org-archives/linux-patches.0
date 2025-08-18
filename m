Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CECA320CA0;
	Mon, 18 Aug 2025 13:39:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755524390; cv=none; b=JybcJT+QPAYvWBGRM2XxKwagJmQLYWJHYnKmWWbYdAftu0lV9WeylSSQFk7aHQRDJpVC2JxhaFdG9TZEkLs2ALI4Xq/PNTAqIV68WOxq6Rin/dg4bNlOsH2Mit8GN7Zdl+eV8mkK7FlaIJiSyY+nHp10z303mkZEzOKp9Tun3Rc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755524390; c=relaxed/simple;
	bh=lA++yPzomopGAA8a/ZCYWoq/d9NUwAyCnOWu809Iv1A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fasT9/qqXSU/b/gEadkCBneFBf8MK3XJTFcQ6ymTqyF0GpIG19c+TZhjfj42LjJWWRaPgEGk2TzPUmim5pvpmB1D/xCDmYisA+C/CBIAQM590ttKj9crjP5w0/zd+xZMx/6ne1RisxfMCGfNAUCjr9IaGKTDJTg2nH5s8B3Kdw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xVZFeCHf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xVZFeCHf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3081C4CEEB;
	Mon, 18 Aug 2025 13:39:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755524390;
	bh=lA++yPzomopGAA8a/ZCYWoq/d9NUwAyCnOWu809Iv1A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xVZFeCHftAOHJlwp30/0Mqww5bKYrHAEULVhTDK0Zmu2mWMqhhq87I1NfdNIQpMrk
	 2a+V7dUrZfse/jxTya1y6Z3h/MPUJk8Q+1RNjpV0W9jTQ+iU37BC/ydY5OOcoSroaK
	 0mtvpG7KDi0pBYS5xOVU0PEYGtzV63fkg77JS51o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Myrrh Periwinkle <myrrhperiwinkle@qtmlabs.xyz>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 6.15 457/515] usb: typec: ucsi: Update power_supply on power role change
Date: Mon, 18 Aug 2025 14:47:23 +0200
Message-ID: <20250818124516.013193136@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Myrrh Periwinkle <myrrhperiwinkle@qtmlabs.xyz>

commit 7616f006db07017ef5d4ae410fca99279aaca7aa upstream.

The current power direction of an USB-C port also influences the
power_supply's online status, so a power role change should also update
the power_supply.

Fixes an issue on some systems where plugging in a normal USB device in
for the first time after a reboot will cause upower to erroneously
consider the system to be connected to AC power.

Cc: stable <stable@kernel.org>
Fixes: 0e6371fbfba3 ("usb: typec: ucsi: Report power supply changes")
Signed-off-by: Myrrh Periwinkle <myrrhperiwinkle@qtmlabs.xyz>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://lore.kernel.org/r/20250721-fix-ucsi-pwr-dir-notify-v1-1-e53d5340cb38@qtmlabs.xyz
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/ucsi/ucsi.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/typec/ucsi/ucsi.c
+++ b/drivers/usb/typec/ucsi/ucsi.c
@@ -1246,6 +1246,7 @@ static void ucsi_handle_connector_change
 
 	if (change & UCSI_CONSTAT_POWER_DIR_CHANGE) {
 		typec_set_pwr_role(con->port, role);
+		ucsi_port_psy_changed(con);
 
 		/* Complete pending power role swap */
 		if (!completion_done(&con->complete))


