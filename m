Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD7B432B125;
	Sat, 12 Sep 2026 16:22:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789230175; cv=none; b=JfGB63ZWXGL4ME27QgNvm6GEVhh8iyYqmlJp9izcX52EI+wjToxQ+qhtA+6m7No+u9sb/O8BMZS+UQYU+H2yfBFIz266nJ/EhvpDiY0mgOr03P0QiYQT/4xNFeHaiZAwmryUYhEN/pyLqIRCzTG7N+C8p8WjrrO+5tb21AfGWaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789230175; c=relaxed/simple;
	bh=WlwKYv1fMeMHdaGWF5r8zFrVBMT0n/BL8xYwNaAKXPg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g+cwtqLueuulrnkPQEqQlFlXx9q3tXS7v1/gVMRbQRhjg2o9Y+aa2QCrN/0NNiOtagWOfspQ1L4w6VFh2YOBBGj4A6AGzrApQFmgOAlImSgYpSVpaL6H8TWmtZ+y4jKKNK+tLHYWjm8WGGnnAnatNbj+kzYzlU8I62m2YPt2Yxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WDYa+G7w; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WDYa+G7w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E46EE1F000FF;
	Sat, 12 Sep 2026 16:22:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789230173;
	bh=DEPLJmMfWjjViuoZcANVYo2xC4VrVAO81v/H9NC/ioc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WDYa+G7wnNiko1hupAysjy3oKf1ODOapyQEz4tu8wJ3XrCrWavucFrdO8wYNFXdp7
	 Sbiro7PEfHcyIA0zh0CEJ9AWZSbnPtQlJM/e5ABygpFLG5ETZwc050kgVPuXXGPlkE
	 qE+stRb0tadUvEfY4/Dy73DS9TPIX7omVD56q6NI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0697/1191] thermal: intel: int3400: clean up ODVP on probe failures
Date: Sat, 12 Sep 2026 08:57:05 +0200
Message-ID: <20260912065603.914934483@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 9280241518ee6..86876b99d1dd3 100644
--- a/drivers/thermal/intel/int340x_thermal/int3400_thermal.c
+++ b/drivers/thermal/intel/int340x_thermal/int3400_thermal.c
@@ -336,8 +336,10 @@ static void cleanup_odvp(struct int3400_thermal_priv *priv)
 			kfree(priv->odvp_attrs[i].attr.attr.name);
 		}
 		kfree(priv->odvp_attrs);
+		priv->odvp_attrs = NULL;
 	}
 	kfree(priv->odvp);
+	priv->odvp = NULL;
 	priv->odvp_count = 0;
 }
 
@@ -613,7 +615,6 @@ static int int3400_thermal_probe(struct platform_device *pdev)
 	return 0;
 
 free_sysfs:
-	cleanup_odvp(priv);
 	if (!ZERO_OR_NULL_PTR(priv->data_vault)) {
 		sysfs_remove_group(&pdev->dev.kobj, &data_attribute_group);
 		kfree(priv->data_vault);
@@ -627,6 +628,7 @@ static int int3400_thermal_probe(struct platform_device *pdev)
 		acpi_thermal_rel_misc_device_remove(priv->adev->handle);
 	thermal_zone_device_unregister(priv->thermal);
 free_art_trt:
+	cleanup_odvp(priv);
 	kfree(priv->trts);
 	kfree(priv->arts);
 free_priv:
-- 
2.53.0



