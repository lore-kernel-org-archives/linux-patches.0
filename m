Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCE4B32D7C7;
	Sat, 12 Sep 2026 19:28:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789241304; cv=none; b=rxZvuirXrSMX+JcdVE/+zfuq/CgBtjGmDElaw+dHDTwgBn0ioR/OOq0uFP6BuDe3IG97BTaafkZNbmZnB5foLReiXfrsLgIshfA/McMQBeAEhdjtKGDGAgPyqxRT1qQOcUf3OLaqEC+ZKLKAHkJ10Uhygq81HkwINBJDnHCAsLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789241304; c=relaxed/simple;
	bh=yipAyQ39PmkOfsLyL7hFtCMcF3Ayksku5EofxU3dgxE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VrH4JxOlBA7xLh0eddAwV4yM4d0HlM2LV9I3CLmByZtzsqxZkFYX7QsIaIfZKCPl6Br8Z54ezPruD2C3I+pDjO8IjNwUF25xTg6tepoHcnavqVFGXo3QuNVq98PFHpE1VG7D2ERfeilnphCZ0kkr1X2Ya7vRzkh3tHcWUFluLXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xAmnYRtN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xAmnYRtN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2DF11F000FF;
	Sat, 12 Sep 2026 19:28:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789241302;
	bh=LWq9kUc63D0tyk5Q4vVxZ7BmQ1Z1ZIlwCGJ8yVaafs0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xAmnYRtNRAAFfdE28SsVmecOAi4nGwhua+pedhefPe6eq6Ty87hlXT1cjblSDqY/M
	 Cq657Hv6sKcyIBS0TA0RDbDU5P9f3UGRWCLaL4vobS9IYHU+Rn/fFJO6rei3VELfxg
	 A0Unn1wTU5dtS7flwqzu2K5LhcCTaBkxeUS13dV0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <haoxiang_li2024@163.com>,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 5.10 055/798] HID: sensor: custom: Fix field sysfs group cleanup on failure
Date: Sat, 12 Sep 2026 08:54:43 +0200
Message-ID: <20260912065518.224153311@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haoxiang Li <haoxiang_li2024@163.com>

commit 3789d0802ddb4b3be04062caf4bfadd23496e9a7 upstream.

hid_sensor_custom_add_attributes() creates one sysfs group for each
custom sensor field. If sysfs_create_group() fails after some groups
have already been created, the function returns the error without
removing the previously created groups.

Add a local unwind path to remove the groups that were already created.
With enable_sensor exposed only after the field attributes are ready,
this path can free sensor_inst->fields without leaving enable_sensor
able to access pointers into that array.

Fixes: 4a7de0519df5 ("HID: sensor: Custom and Generic sensor support")
Cc: stable@vger.kernel.org
Signed-off-by: Haoxiang Li <haoxiang_li2024@163.com>
Acked-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-sensor-custom.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/drivers/hid/hid-sensor-custom.c
+++ b/drivers/hid/hid-sensor-custom.c
@@ -605,7 +605,7 @@ static int hid_sensor_custom_add_attribu
 					 &sensor_inst->fields[i].
 					 hid_custom_attribute_group);
 		if (ret)
-			break;
+			goto err_remove_groups;
 
 		/* For power or report field store indexes */
 		if (sensor_inst->fields[i].attribute.attrib_id ==
@@ -617,6 +617,13 @@ static int hid_sensor_custom_add_attribu
 	}
 
 	return ret;
+
+err_remove_groups:
+	while (--i >= 0)
+		sysfs_remove_group(&sensor_inst->pdev->dev.kobj,
+				   &sensor_inst->fields[i].hid_custom_attribute_group);
+	kfree(sensor_inst->fields);
+	return ret;
 }
 
 static void hid_sensor_custom_remove_attributes(struct hid_sensor_custom *


