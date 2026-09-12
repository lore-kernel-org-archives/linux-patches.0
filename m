Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C50538AC72;
	Sat, 12 Sep 2026 19:51:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242712; cv=none; b=pF1KrdPbq4ABmDSIDMBB6LSyty9xIoivkLEvCc0dxN5ZUMIlETUMWZw4Aq94Sd0Qy4CcP8gqFXzbr2VhmNVcamWs+fEGP143Yy5aOqLjdcfbyK5c0nx5lGW1lsR9Az1LR+NjvWE645erMnmKDZ/HujxRtpmAOSt4/dvZAAVihtY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242712; c=relaxed/simple;
	bh=PkLxnJIiq0pfvyU6ZnK0XdAug5U6fDbO2clNRVQ7WEw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UWOnGD7qbzB+o6aYTdYjhM2wYVJ3nP7xIYCy/rt/Rtc9fJDdjxh968PcWHNZm2gTeRWK8U/+NyoWGCtKsxCYktjaIQv14x3xDu61CW+bd4TYV1mJBJEzAV4/LpewsrkgNIoK0wGgyi2MKG1EGSfpMo2dBf3yqR0H/3WN6IVDE7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yKZV+Np/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yKZV+Np/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBBD21F000FF;
	Sat, 12 Sep 2026 19:51:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789242711;
	bh=CSGSB/pYL+d96YnjdjVcx0ZszPCLK8Njbe0Hbri4J2Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yKZV+Np/jOrvHzdf78OVWSbzotGu7P2CpyInwWMCFPsdH5cIUPa2+NS8TP2f1W06a
	 zjbxgEfYUFfK+kgIWsMYF1LDNz61iBrmBO8rnZmbxNoL9dJHiyeI1YF2V9Sp3n3nHu
	 sVq/AeyjS/Yq9uwLSNxkJ2fCpAA4MZHiWYHkSvmY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 499/798] thermal: intel: int3400: clean up ODVP on probe failures
Date: Sat, 12 Sep 2026 09:02:07 +0200
Message-ID: <20260912065528.573949195@linuxfoundation.org>
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
index 588d8fb12490a..9d2473f983ab3 100644
--- a/drivers/thermal/intel/int340x_thermal/int3400_thermal.c
+++ b/drivers/thermal/intel/int340x_thermal/int3400_thermal.c
@@ -290,8 +290,10 @@ static void cleanup_odvp(struct int3400_thermal_priv *priv)
 			kfree(priv->odvp_attrs[i].attr.attr.name);
 		}
 		kfree(priv->odvp_attrs);
+		priv->odvp_attrs = NULL;
 	}
 	kfree(priv->odvp);
+	priv->odvp = NULL;
 	priv->odvp_count = 0;
 }
 
@@ -547,7 +549,6 @@ static int int3400_thermal_probe(struct platform_device *pdev)
 	return 0;
 
 free_sysfs:
-	cleanup_odvp(priv);
 	if (!ZERO_OR_NULL_PTR(priv->data_vault)) {
 		sysfs_remove_group(&pdev->dev.kobj, &data_attribute_group);
 		kfree(priv->data_vault);
@@ -559,6 +560,7 @@ static int int3400_thermal_probe(struct platform_device *pdev)
 		acpi_thermal_rel_misc_device_remove(priv->adev->handle);
 	thermal_zone_device_unregister(priv->thermal);
 free_art_trt:
+	cleanup_odvp(priv);
 	kfree(priv->trts);
 	kfree(priv->arts);
 free_priv:
-- 
2.53.0



