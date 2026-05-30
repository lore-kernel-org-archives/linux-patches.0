Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC896219303;
	Sat, 30 May 2026 18:27:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780165651; cv=none; b=qvBDau/GpZKQLDU0RSjcsxK7iRkit9UQ0W6nnRVV5cyp24unDQF6QnQD3zqCKLfXZeSmbH4eDbdF9CQrJOC4Q3rp5SovMpPPfGKZmmfzedvjufBSRxsDJMnInD9nArxg9zzfasxsnGLJsP1ClMRXddh08EGSZmCb5zJOBqWFmgU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780165651; c=relaxed/simple;
	bh=j2mhRffQqFXpprP9WqbtOhHXyAcRCyqrTMk7hqUVQjE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OP08+vc+ip9QauV2wHgG0I1evKtOj8wdBOknoX1lGXPs9exLfC+kXEJ0xWQoe+ZLLCd6QmKttx/DakCu0tBoqX+1utcXEOMoY4W5j7ZdTWPn2oSrBqYAbpD/cclQapSCc1GEIE37ROVDRxv1rOSpvP/zrrhW49/iT9i7CSLS4vg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B6XuIeO4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B6XuIeO4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF3E91F00893;
	Sat, 30 May 2026 18:27:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780165650;
	bh=2KhVcKESoOdqbiWVy9kvyd/NZ5bcs0oBJnCDV1KGqCc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=B6XuIeO4mxlLMZe1cjmOUl2Z2pC76x18APPawpqvAFKZyDiXURTuUfvhEGfWO0Qor
	 9mruv/+1ry08zQ02NMjH5CIo6nzKEaq+BjdxsBemKaYWMTcNkeiNdtL/UMXounZ2zl
	 n8KuTpwIodhcX6Q4BtK/27uUhoZgYT9ZF1qmEqa4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Lee, Chun-Yi" <jlee@suse.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Vasiliy Kovalev <kovalev@altlinux.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 093/589] thermal/int340x_thermal: handle data_vault when the value is ZERO_SIZE_PTR
Date: Sat, 30 May 2026 17:59:34 +0200
Message-ID: <20260530160227.137399577@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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

From: Lee, Chun-Yi <joeyli.kernel@gmail.com>

commit 7931e28098a4c1a2a6802510b0cbe57546d2049d upstream.

In some case, the GDDV returns a package with a buffer which has
zero length. It causes that kmemdup() returns ZERO_SIZE_PTR (0x10).

Then the data_vault_read() got NULL point dereference problem when
accessing the 0x10 value in data_vault.

[   71.024560] BUG: kernel NULL pointer dereference, address:
0000000000000010

This patch uses ZERO_OR_NULL_PTR() for checking ZERO_SIZE_PTR or
NULL value in data_vault.

Signed-off-by: "Lee, Chun-Yi" <jlee@suse.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
[ kovalev: bp to fix CVE-2022-48703 ]
Signed-off-by: Vasiliy Kovalev <kovalev@altlinux.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/intel/int340x_thermal/int3400_thermal.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/thermal/intel/int340x_thermal/int3400_thermal.c b/drivers/thermal/intel/int340x_thermal/int3400_thermal.c
index 28913867cd4bc..a064a4eb31fba 100644
--- a/drivers/thermal/intel/int340x_thermal/int3400_thermal.c
+++ b/drivers/thermal/intel/int340x_thermal/int3400_thermal.c
@@ -466,7 +466,7 @@ static void int3400_setup_gddv(struct int3400_thermal_priv *priv)
 	priv->data_vault = kmemdup(obj->package.elements[0].buffer.pointer,
 				   obj->package.elements[0].buffer.length,
 				   GFP_KERNEL);
-	if (!priv->data_vault) {
+	if (ZERO_OR_NULL_PTR(priv->data_vault)) {
 		kfree(buffer.pointer);
 		return;
 	}
@@ -531,7 +531,7 @@ static int int3400_thermal_probe(struct platform_device *pdev)
 	if (result)
 		goto free_rel_misc;
 
-	if (priv->data_vault) {
+	if (!ZERO_OR_NULL_PTR(priv->data_vault)) {
 		result = sysfs_create_group(&pdev->dev.kobj,
 					    &data_attribute_group);
 		if (result)
@@ -549,7 +549,8 @@ static int int3400_thermal_probe(struct platform_device *pdev)
 free_sysfs:
 	cleanup_odvp(priv);
 	if (priv->data_vault) {
-		sysfs_remove_group(&pdev->dev.kobj, &data_attribute_group);
+		if (!ZERO_OR_NULL_PTR(priv->data_vault))
+			sysfs_remove_group(&pdev->dev.kobj, &data_attribute_group);
 		kfree(priv->data_vault);
 	}
 free_uuid:
@@ -579,7 +580,7 @@ static int int3400_thermal_remove(struct platform_device *pdev)
 	if (!priv->rel_misc_dev_res)
 		acpi_thermal_rel_misc_device_remove(priv->adev->handle);
 
-	if (priv->data_vault)
+	if (!ZERO_OR_NULL_PTR(priv->data_vault))
 		sysfs_remove_group(&pdev->dev.kobj, &data_attribute_group);
 	sysfs_remove_group(&pdev->dev.kobj, &uuid_attribute_group);
 	thermal_zone_device_unregister(priv->thermal);
-- 
2.53.0



