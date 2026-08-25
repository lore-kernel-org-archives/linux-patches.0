Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 483BA480320;
	Tue, 25 Aug 2026 13:32:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787664744; cv=none; b=DYJZrIox71K3zRJB+zHIdqPujpOdORty8rFnl5/0JdtNPYf4WhaOVs+B1U4jK6rIQjuJEoi7y0wjNfnE9TWlBKpBg3B/lJjQKp2cLV1hKhp+mwok/NXDjzz89NGtYekZyHAjHYzcBAhJc77u343NrZdP5AiSAiaT6TE3BCX4paE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787664744; c=relaxed/simple;
	bh=GVViSIJ0cBHPskrhndkLJCibcLQ1r0zxbO7DnwbQEYA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pcbRNSr1hG+XYgLeBPp7OqCcmpGSy9S0viOiS22NJ9m6/KyeW5ukwH0KXkE3xzfCZ3kKb2LZMz51Wkp9mt1WrloaCVthXkBkMU5vYdbRGixK4VzRDROOuHwtB9pqokHUVc8QT/1T0zjSn5ujIFHLqc9SQzkrls1fKwndL45fbJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nTWe9DGZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nTWe9DGZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1F5E1F000E9;
	Tue, 25 Aug 2026 13:32:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787664743;
	bh=PhYnTU/gXdT3tISRh7KU/sAuz0CGZojYR6o3/w12RUo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nTWe9DGZtfQxW9gPnckfF4GIGz8EvRmTZEZdWFJF4ZKkAWed+XSpHwLRmhsRhtpfO
	 hA++YrJUIcPdB18MQ+ScUU9s+2AI64T1vHVxr/81+r15MF9+ZHNUp/zmtXjMVUJOZH
	 vrmWpW548rOVZmbODpHI03CDYpoOTdRkRxYrMFLY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko AI Review <sashiko-bot@kernel.org>,
	Haoxiang Li <haoxiang_li2024@163.com>,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 7.2 71/82] HID: sensor: custom: Fix use-after-free in enable_sensor
Date: Tue, 25 Aug 2026 15:25:58 +0200
Message-ID: <20260825132544.276182893@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.560541185@linuxfoundation.org>
References: <20260825132541.560541185@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haoxiang Li <haoxiang_li2024@163.com>

commit ad8fb82b04422f49530d2aa2753cc81d1c60102c upstream.

enable_sensor_store() can call set_power_report_state(), which
dereferences sensor_inst->power_state and sensor_inst->report_state.
These pointers refer to entries in sensor_inst->fields.

Create the field attributes before exposing the enable_sensor sysfs
attribute, so enable_sensor cannot be accessed before the state it
depends on has been initialized.

On remove, delete enable_sensor before freeing the field attributes,
so a concurrent sysfs write cannot dereference freed memory through
power_state or report_state.

Reported-by: Sashiko AI Review <sashiko-bot@kernel.org>
Link: https://sashiko.dev/#/patchset/20260623021950.1736413-1-haoxiang_li2024@163.com?part=1
Fixes: 4a7de0519df5 ("HID: sensor: Custom and Generic sensor support")
Cc: stable@vger.kernel.org
Signed-off-by: Haoxiang Li <haoxiang_li2024@163.com>
Acked-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-sensor-custom.c |   17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

--- a/drivers/hid/hid-sensor-custom.c
+++ b/drivers/hid/hid-sensor-custom.c
@@ -1005,26 +1005,26 @@ static int hid_sensor_custom_probe(struc
 		return ret;
 	}
 
-	ret = sysfs_create_group(&sensor_inst->pdev->dev.kobj,
-				 &enable_sensor_attr_group);
+	ret = hid_sensor_custom_add_attributes(sensor_inst);
 	if (ret)
 		goto err_remove_callback;
 
-	ret = hid_sensor_custom_add_attributes(sensor_inst);
+	ret = sysfs_create_group(&sensor_inst->pdev->dev.kobj,
+				 &enable_sensor_attr_group);
 	if (ret)
-		goto err_remove_group;
+		goto err_remove_attributes;
 
 	ret = hid_sensor_custom_dev_if_add(sensor_inst);
 	if (ret)
-		goto err_remove_attributes;
+		goto err_remove_group;
 
 	return 0;
 
-err_remove_attributes:
-	hid_sensor_custom_remove_attributes(sensor_inst);
 err_remove_group:
 	sysfs_remove_group(&sensor_inst->pdev->dev.kobj,
 			   &enable_sensor_attr_group);
+err_remove_attributes:
+	hid_sensor_custom_remove_attributes(sensor_inst);
 err_remove_callback:
 	sensor_hub_remove_callback(hsdev, hsdev->usage);
 
@@ -1042,9 +1042,10 @@ static void hid_sensor_custom_remove(str
 	}
 
 	hid_sensor_custom_dev_if_remove(sensor_inst);
-	hid_sensor_custom_remove_attributes(sensor_inst);
+	/* Remove enable_sensor first as it uses fields via power_state/report_state. */
 	sysfs_remove_group(&sensor_inst->pdev->dev.kobj,
 			   &enable_sensor_attr_group);
+	hid_sensor_custom_remove_attributes(sensor_inst);
 	sensor_hub_remove_callback(hsdev, hsdev->usage);
 }
 


