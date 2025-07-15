Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA5102E7F1D;
	Tue, 15 Jul 2025 13:28:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752586115; cv=none; b=thIvWomZ/9D/3p6Cf/Cl3gczxtcO2UaZkATl7oxhz/IWk/C4OSFJ8WHXGHVB0zQ3/DzkQvu5Msqruhan6z2dhZ/aOEW4jaTQxa+a7eb78Mz3fsUX4jyhEGl4zp67ICMsjFdUK0fu1qyMfcSH/iTg6ZPsTpSz2ir7+sUbKto/3bs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752586115; c=relaxed/simple;
	bh=E2vT8tuYRNg4uZBodpZrv0e62W+D2rI0iE5gcnfmEXM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xdon+Wtm6pyvxCiO2x8TMRfna0w2kzS9pC6OZJ4jwCTlnaSGlhz30FcH01BKbm20bOkN0FH3CsZAXxySo/EqXlRO5X6H4q/tbHVZitKmx6Lbdl5FQ5yJdLpRP44ERcHBmBj9vJ0YMfhofXKFEU2VtwMoQnBYkUPQeqsO91clGek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mUKiKWFN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mUKiKWFN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E276C4CEF7;
	Tue, 15 Jul 2025 13:28:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752586115;
	bh=E2vT8tuYRNg4uZBodpZrv0e62W+D2rI0iE5gcnfmEXM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mUKiKWFNfDoE1Tahc7iF33PIjOcps1xSeY3qu9N09OEWZpJyF7cCR0EbAzfciW5Se
	 ql4EAKqttX88n/dCi+aCGMTQoyomyWDYk1sjy1kMijB5f4DJstJ4ChqlKTF9hVxmF7
	 W6RIH+7v37XutWE0IR7lUtQsAEgE7PPOATFFkcIA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Lee, Chun-Yi" <jlee@suse.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Larry Bassel <larry.bassel@oracle.com>
Subject: [PATCH 5.15 21/77] thermal/int340x_thermal: handle data_vault when the value is ZERO_SIZE_PTR
Date: Tue, 15 Jul 2025 15:13:20 +0200
Message-ID: <20250715130752.549224496@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130751.668489382@linuxfoundation.org>
References: <20250715130751.668489382@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
[ Larry: backport to 5.15.y. Minor conflict resolved due to missing commit 9e5d3d6be664
  thermal: int340x: Consolidate freeing of acpi_buffer pointer ]
Signed-off-by: Larry Bassel <larry.bassel@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thermal/intel/int340x_thermal/int3400_thermal.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/drivers/thermal/intel/int340x_thermal/int3400_thermal.c
+++ b/drivers/thermal/intel/int340x_thermal/int3400_thermal.c
@@ -469,7 +469,7 @@ static void int3400_setup_gddv(struct in
 	priv->data_vault = kmemdup(obj->package.elements[0].buffer.pointer,
 				   obj->package.elements[0].buffer.length,
 				   GFP_KERNEL);
-	if (!priv->data_vault) {
+	if (ZERO_OR_NULL_PTR(priv->data_vault)) {
 		kfree(buffer.pointer);
 		return;
 	}
@@ -540,7 +540,7 @@ static int int3400_thermal_probe(struct
 			goto free_imok;
 	}
 
-	if (priv->data_vault) {
+	if (!ZERO_OR_NULL_PTR(priv->data_vault)) {
 		result = sysfs_create_group(&pdev->dev.kobj,
 					    &data_attribute_group);
 		if (result)
@@ -558,7 +558,8 @@ static int int3400_thermal_probe(struct
 free_sysfs:
 	cleanup_odvp(priv);
 	if (priv->data_vault) {
-		sysfs_remove_group(&pdev->dev.kobj, &data_attribute_group);
+		if (!ZERO_OR_NULL_PTR(priv->data_vault))
+			sysfs_remove_group(&pdev->dev.kobj, &data_attribute_group);
 		kfree(priv->data_vault);
 	}
 free_uuid:
@@ -590,7 +591,7 @@ static int int3400_thermal_remove(struct
 	if (!priv->rel_misc_dev_res)
 		acpi_thermal_rel_misc_device_remove(priv->adev->handle);
 
-	if (priv->data_vault)
+	if (!ZERO_OR_NULL_PTR(priv->data_vault))
 		sysfs_remove_group(&pdev->dev.kobj, &data_attribute_group);
 	sysfs_remove_group(&pdev->dev.kobj, &uuid_attribute_group);
 	sysfs_remove_group(&pdev->dev.kobj, &imok_attribute_group);


