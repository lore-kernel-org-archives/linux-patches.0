Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E55F41E6DB;
	Sat, 12 Sep 2026 10:13:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789207999; cv=none; b=BxKFKiUaEMkXQWVro5OTVoLMg1UDuKyggyp7uxewMNn1q74bzcHuOtSWmUhj+tBE8GzDG73ioy+vApExcJi62T89SRsgzJpX9EboCIZ9xw6tUuRpEY6n4FZUhJAXxU29iV4W8fZJaqr9FdLKWOTy3UzE0DCFJUbnTCCU9kG+Pac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789207999; c=relaxed/simple;
	bh=PxE67oO81LVC7vBrItA7mlZQ2ZGAy5T1X01S74vFzPM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i85dorasHwnN1IG3I6pIXcuU83VNVbg55HoQ+/MNN0l3Sh3VTDFsOkliT5sck74z9m6El9YIVIZi94JUvZr2IT3U3OUeHCm6cHLE8rXj8dys6LGt5S819vAECjio4AFrvQfdMLABEW9+4y2JjEbIYIyrK9AoPbBnzxDwAfkCAKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QRTvCBW5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QRTvCBW5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D5001F000FF;
	Sat, 12 Sep 2026 10:13:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789207994;
	bh=qYevSyRb13AYVzCvsU/U3A0jxcEaJVUYUPdrVGkrm4I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QRTvCBW5oYvZKD9xNWW1oNXyqFNsXa2aTYuiLXRq3mJBTWx3vgAIAJbKx2IhRCysZ
	 9lrtMND2NhU3KNDNPjBI1Q2kezinyEjK+yZcLb/enYGcbB4lmLQmHOFy2GjFe6gwLO
	 IaZ6RleUoIDyfW5OtQ4IgYk4Sgh9rHRtBwi9gXEk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0527/1518] thermal: intel: int3400: clean up ODVP on probe failures
Date: Sat, 12 Sep 2026 08:44:56 +0200
Message-ID: <20260912065635.366133341@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 908cc1bf57f19..2aa03ceb570e7 100644
--- a/drivers/thermal/intel/int340x_thermal/int3400_thermal.c
+++ b/drivers/thermal/intel/int340x_thermal/int3400_thermal.c
@@ -354,8 +354,10 @@ static void cleanup_odvp(struct int3400_thermal_priv *priv)
 			kfree(priv->odvp_attrs[i].attr.attr.name);
 		}
 		kfree(priv->odvp_attrs);
+		priv->odvp_attrs = NULL;
 	}
 	kfree(priv->odvp);
+	priv->odvp = NULL;
 	priv->odvp_count = 0;
 }
 
@@ -635,7 +637,6 @@ static int int3400_thermal_probe(struct platform_device *pdev)
 	acpi_remove_notify_handler(priv->adev->handle, ACPI_DEVICE_NOTIFY,
 				   int3400_notify);
 free_sysfs:
-	cleanup_odvp(priv);
 	if (!ZERO_OR_NULL_PTR(priv->data_vault)) {
 		device_remove_bin_file(&pdev->dev, &bin_attr_data_vault);
 		kfree(priv->data_vault);
@@ -649,6 +650,7 @@ static int int3400_thermal_probe(struct platform_device *pdev)
 		acpi_thermal_rel_misc_device_remove(priv->adev->handle);
 	thermal_zone_device_unregister(priv->thermal);
 free_art_trt:
+	cleanup_odvp(priv);
 	kfree(priv->trts);
 	kfree(priv->arts);
 free_priv:
-- 
2.53.0



