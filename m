Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 446FA3AFB1C;
	Fri,  4 Sep 2026 05:16:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788498969; cv=none; b=ppSnuLtXTzgeNsZjadl+ACOR3/MzpQMUJwJIJJ+49PC3HeOfl6/wNTUV0/PLWoNvRvmVbuZMIQu75A9UfNyxLYo9fpy09E8Z52Q/LpdffzwXTaj8LnBH+Lp0eH5d9PMIzzcUeU4fgiHPGiqKy1JT5CTsCJczwY0QwCF+7qYx88c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788498969; c=relaxed/simple;
	bh=gOeRfJoPppZrrFWccOny4wZAkhAeqKF7zAyZsrrEOu8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V8zOidGaMf4u23WxNseF5M+62RhRkwqQ5s5romjttw1g4sYyLYQKU2d3fCFJZAiB1YwDOEWrEf6E2dE6nqFDnU1VEbbiefLGbS4gEcXSfOeMzClw+F/yBqbXTyDjHIRKRyKLfwHUQAFmsx/b91dfAfzJ7OnPeVm6rtOjOMsHJDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k8bxLnWv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k8bxLnWv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E6A51F00A3D;
	Fri,  4 Sep 2026 05:16:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788498967;
	bh=9uHsAHnOU01pCSllXP+QRfz48ffTcxNMDCkpu72QzzY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k8bxLnWvUbpf2NNlgRh1Q2WGbWjcyIDM6zmIjysx/ACC5oKKvLJOvutTdyoCpEI/Y
	 oFRs2D/IcRbXLRD0WqN1lFrqMxo11vq7CLtMlUBshtiDv8lSZohtOwlawCHH1masMd
	 4QvUtNAHekfZ9EoWLI4MFRL0XlCQmgI7ws7peWcU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <haoxiang_li2024@163.com>,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 7.2 250/713] HID: sensor: custom: Fix field sysfs group cleanup on failure
Date: Fri,  4 Sep 2026 06:53:38 +0200
Message-ID: <20260904045809.438400216@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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


