Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92B6D377AA1;
	Sat, 12 Sep 2026 13:33:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789219988; cv=none; b=mPf6ZNgs0TNZH44p6oUM5WrItw6X+8KUvba6A/FtXz9ajJvR7aY2KQe/f3bJMZgYyDdj8tguDQIkv6JBz3IpWGA34QzpFLdOrfF13flBu9ukVqMihLVUW4wIxydVUXBFsAd0NMYGxijxp8L64344L0UXvgKvesbKaG+V2PjwAKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789219988; c=relaxed/simple;
	bh=4GMuTbmD0y99fyyydItWT9YsdmlfjIn4+nr3Q4LRlfU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fOOdMt1wvHKyi6dvozgtAVqWqo1na37fFCzRxWRlGnzqR1QIJl3fJghUBqC+boxpj+h4D7AbVSufhiVB87I1eZRcY71WSXuSCvbqqEuTwAGs/GSo3nftQB91OA52MLdO1gE6cf0T9Q2bOMGYs4T/DuETdB6NWvPHB/av7/KlozA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RoEvk27a; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RoEvk27a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D7251F000FF;
	Sat, 12 Sep 2026 13:33:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789219987;
	bh=7SQxMJ0ZH9edstfCwheqn49R9YEbmDKiKXUy3mBZwQ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RoEvk27agHj83GATj3PZ5Ep7UhBm6SSYytQyNkD6HY2ARFcapDnQewOZ89UlLRGgq
	 BqAI5SSbWLOF99LfipbtKAUw82aajB/HX6Gz0PJDYdeCE6vEvzoSbTXPmJu8bCgSAS
	 OcDHRPjvu07Q5+fHa4nbXVVmh93LbpKiyjWE7/vk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <haoxiang_li2024@163.com>,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 6.6 0086/1424] HID: sensor: custom: Fix field sysfs group cleanup on failure
Date: Sat, 12 Sep 2026 08:41:58 +0200
Message-ID: <20260912065609.232416213@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -610,7 +610,7 @@ static int hid_sensor_custom_add_attribu
 					 &sensor_inst->fields[i].
 					 hid_custom_attribute_group);
 		if (ret)
-			break;
+			goto err_remove_groups;
 
 		/* For power or report field store indexes */
 		if (sensor_inst->fields[i].attribute.attrib_id ==
@@ -622,6 +622,13 @@ static int hid_sensor_custom_add_attribu
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


