Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 430414BEE4C;
	Sat, 12 Sep 2026 14:35:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789223748; cv=none; b=QksnqWJkQcKmyr9osEWOv6znBARqszK7i2mpJmZqPGH+y3+SEiadXLiLY0WNPMS3hwN8naOl8y4NHGFsLWp4F30kQ5WJ2FR2eBIs3mL13N6V1Pe3oVrbyTjFzW5NbHeR5Idg5m3dqx37ZoG9ytapxSVRDb5LiSDHBJOZlTKmZGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789223748; c=relaxed/simple;
	bh=nAtNzxtzvbvZ67fqNrkz0i1PUI2hdEKrMV5oTpBbUbI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k3IY1RMkp5mPsT/yBySadFMxAxksKog7ybrzAEpicflbeVizEjhZK/VSuB8hgTX8QSown5IEbKcvDjub/1BVC8IiFqN8RWzIBxZ4Uy/vAF/gCXWVa6RJ7AyRT0Nrp7/ZfB2900Qsbc0FsG+mqemxC4xTm7Zm/byryTf9xFNh5y4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MDxiKjt5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MDxiKjt5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1BFA1F000FF;
	Sat, 12 Sep 2026 14:35:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789223747;
	bh=a+7fEgAnwb6z6ecJEz7TFa+kkVjzvo9l9L0oYmsGotE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MDxiKjt59sKAWxZFi2C/yg2WZcWmfZYsfxDMx0e1PHQZizhsFw46Viunv0TuYzfUm
	 7rHnrS26ikUQwfqhyvJ8Mteveci8L5MrDvY4Kwqh9WA2BAJvHbFb3p89C2nobsFv7D
	 wdzjkxu3XGImKJorTK4NSRg/+i5yJXyxhTYy5eSI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0851/1424] thermal: intel: int3400: clean up ODVP on probe failures
Date: Sat, 12 Sep 2026 08:54:43 +0200
Message-ID: <20260912065626.368812937@linuxfoundation.org>
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

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit d83dc9ce57a746a6dca28439bcc0575d26fa6986 ]

evaluate_odvp() creates per-ODVP sysfs files before the thermal zone
and later probe resources are registered. The current unwind path only
calls cleanup_odvp() from the late sysfs failure path, so failures after
evaluate_odvp() but before that label, including
thermal_tripless_zone_device_register() failures, leave the ODVP files
and storage behind.

Move the ODVP cleanup to the common ART/TRT unwind path so every failure
after evaluate_odvp() releases the ODVP state. Also clear the cached
ODVP pointers in cleanup_odvp(), because evaluate_odvp() can already call
it for partial setup failures while probe continues.

Fixes: 006f006f1e5c ("thermal/int340x_thermal: Export OEM vendor variables")
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Link: https://patch.msgid.link/20260623015140.19300-1-pengpeng@iscas.ac.cn
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/intel/int340x_thermal/int3400_thermal.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/thermal/intel/int340x_thermal/int3400_thermal.c b/drivers/thermal/intel/int340x_thermal/int3400_thermal.c
index f252bac676bca..1bf02f74d2c7f 100644
--- a/drivers/thermal/intel/int340x_thermal/int3400_thermal.c
+++ b/drivers/thermal/intel/int340x_thermal/int3400_thermal.c
@@ -370,8 +370,10 @@ static void cleanup_odvp(struct int3400_thermal_priv *priv)
 			kfree(priv->odvp_attrs[i].attr.attr.name);
 		}
 		kfree(priv->odvp_attrs);
+		priv->odvp_attrs = NULL;
 	}
 	kfree(priv->odvp);
+	priv->odvp = NULL;
 	priv->odvp_count = 0;
 }
 
@@ -653,7 +655,6 @@ static int int3400_thermal_probe(struct platform_device *pdev)
 	acpi_remove_notify_handler(priv->adev->handle, ACPI_DEVICE_NOTIFY,
 				   int3400_notify);
 free_sysfs:
-	cleanup_odvp(priv);
 	if (!ZERO_OR_NULL_PTR(priv->data_vault)) {
 		sysfs_remove_group(&pdev->dev.kobj, &data_attribute_group);
 		kfree(priv->data_vault);
@@ -667,6 +668,7 @@ static int int3400_thermal_probe(struct platform_device *pdev)
 		acpi_thermal_rel_misc_device_remove(priv->adev->handle);
 	thermal_zone_device_unregister(priv->thermal);
 free_art_trt:
+	cleanup_odvp(priv);
 	kfree(priv->trts);
 	kfree(priv->arts);
 free_priv:
-- 
2.53.0



