Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 740382882DE;
	Sat, 12 Sep 2026 17:04:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789232694; cv=none; b=pT4b/etQDBQA9HM2KSxoT0MqZchEuSE+178xVVUrRA81MohZQkrrZFdKvpk+/ROxypTA7Yk2dkTr4IWq+glTPYy5qQvx10dDbIF8b603wx4YFVKbiYdgHeXxC6PyRtkoHKX7061XXHaCtw6D0snRcGc07YwId2vzjZ/UlP23ZbE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789232694; c=relaxed/simple;
	bh=e6bKPxdDEZ+bXCTZjHLz67E1QCXtDYmylfGApMbvd4I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZNM8KHChKK2dZZ9YwTPPKx5cShB9aM3BUe1Bs5ZWVs7vKHkxV2P7TnzMV6+FljOMnH7HnXP8MkBUGPx1lJTlIgxm38DBT9pcZds0mJ5GFicXao9l6kgSke0RmDmjkR+a1PVMZc3K1duLTUOXau2SsiFLZCMT9YxW7lASMHkZDQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qpeo3vJC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qpeo3vJC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 474D71F000FF;
	Sat, 12 Sep 2026 17:04:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789232693;
	bh=SXmE5FMGh7Mib07nrhiT3CF0rlvcHaGq1LEzS8WbGr4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qpeo3vJCEny0bjZh9fEWKdx0oteOn/bxd8Wxs1LGTFpxuEuSGYNuRh9Z/9SSwtSeF
	 BOVfrdBtkrUfecNmkYiFKQ0ti1h3wfUt2TNIf7QXa1ymx2qDgSIdnFRyKIPbw6VNzu
	 W/zk/485bNHrOMBvv4xogbBw3mgqlqs+RgFOYFyk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <haoxiang_li2024@163.com>,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 5.15 061/935] HID: sensor: custom: Fix field sysfs group cleanup on failure
Date: Sat, 12 Sep 2026 08:51:31 +0200
Message-ID: <20260912065528.237751285@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -609,7 +609,7 @@ static int hid_sensor_custom_add_attribu
 					 &sensor_inst->fields[i].
 					 hid_custom_attribute_group);
 		if (ret)
-			break;
+			goto err_remove_groups;
 
 		/* For power or report field store indexes */
 		if (sensor_inst->fields[i].attribute.attrib_id ==
@@ -621,6 +621,13 @@ static int hid_sensor_custom_add_attribu
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


