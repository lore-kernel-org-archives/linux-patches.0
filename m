Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F2C0470420;
	Tue, 21 Jul 2026 18:46:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659567; cv=none; b=tA++Md0KL27Ar20jsQskeVHZY4/caZEfe9M9s7GHz2P1WDiC10gg4GMte+u6t+m4hSzTWVrDfrSg5vNDRjPIzDmoUNn4LdxuYk2zZSATqH1wd10HWg9aLPpQFb+qXGEO7eoXGoRV7k3A/+YwIn8S9YyXJcEF2FOIDo4Jtn4NXNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659567; c=relaxed/simple;
	bh=AFpQSVfaSgFfsvRXNqa/xy1V6vgh1CURSLtK6UluiIs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rDDLV/lvg7l311TE1OXLbDhIkDW8hTlldC+WyP40qCkoQON2wTNeetriBrq4n/9+h7o6NeBAnqEvYVEGQZ0jA3q1rS1XDu4ifNO1E9Ut9PencBflvrHaNfRSzXTGLnEt9BRTFher12zr+b2q9YfIE8wehh5FxCptlklVn03yKx8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0qiwdSta; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0qiwdSta"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 852241F000E9;
	Tue, 21 Jul 2026 18:46:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659566;
	bh=Wc7G1AwMF9kC89xxOoyCX5Fl7giwrurAhD9AZk79RF0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0qiwdStaw+vnzvM9GZip2JWfiltt/ZyyoPZBOAbSAOr8hDcUQrk/HNaRdMxvk51P0
	 OwpReMBDiGCoPtA0bzsI5pYaYflzxw6X4GSxtCO/5QiuExioe4gDZIU841x13+jLl/
	 ZQnzI1wGInVpaXrNk6l7Qjoy5boMglJNwkNTUOIE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1532/1611] PCI: Change pci_dev variable from bridge to dev
Date: Tue, 21 Jul 2026 17:27:28 +0200
Message-ID: <20260721152549.906028078@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>

[ Upstream commit 34c702ea0497e092a487eacdf28a037f43e3e39f ]

Upcoming fix to BAR resize will store also device BAR resource in the
saved list. Change the pci_dev variable in the loop from 'bridge' to
'dev' as the former would be misleading with non-bridges in the list.

This is in a separate change to reduce churn in the upcoming BAR resize
fix.

While it appears that the logic in the loop doing pci_setup_bridge() is
altered as 'bridge' variable is no longer updated, a bridge should never
appear more than once in the saved list so the check can only match to the
first entry. As such, the code with two distinct pci_dev variables better
represents the intention of the check compared with the old code where
bridge variable was reused for a different purpose.

Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Tested-by: Alex Bennée <alex.bennee@linaro.org> # AVA, AMD GPU
Reviewed-by: Alex Bennée <alex.bennee@linaro.org>
Link: https://patch.msgid.link/20251113162628.5946-4-ilpo.jarvinen@linux.intel.com
Stable-dep-of: ee7471fe968d ("PCI: Skip Resizable BAR restore on read error")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/setup-bus.c |   17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

--- a/drivers/pci/setup-bus.c
+++ b/drivers/pci/setup-bus.c
@@ -2431,12 +2431,13 @@ int pbus_reassign_bridge_resources(struc
 	}
 
 	list_for_each_entry(dev_res, &saved, list) {
+		struct pci_dev *dev = dev_res->dev;
+
 		/* Skip the bridge we just assigned resources for */
-		if (bridge == dev_res->dev)
+		if (bridge == dev)
 			continue;
 
-		bridge = dev_res->dev;
-		pci_setup_bridge(bridge->subordinate);
+		pci_setup_bridge(dev->subordinate);
 	}
 
 	free_list(&saved);
@@ -2452,19 +2453,19 @@ cleanup:
 	/* Revert to the old configuration */
 	list_for_each_entry(dev_res, &saved, list) {
 		struct resource *res = dev_res->res;
+		struct pci_dev *dev = dev_res->dev;
 
-		bridge = dev_res->dev;
-		i = pci_resource_num(bridge, res);
+		i = pci_resource_num(dev, res);
 
 		if (res->parent) {
 			release_child_resources(res);
-			pci_release_resource(bridge, i);
+			pci_release_resource(dev, i);
 		}
 
 		restore_dev_resource(dev_res);
 
-		pci_claim_resource(bridge, i);
-		pci_setup_bridge(bridge->subordinate);
+		pci_claim_resource(dev, i);
+		pci_setup_bridge(dev->subordinate);
 	}
 	free_list(&saved);
 	up_read(&pci_bus_sem);


