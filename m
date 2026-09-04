Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 594AE3B7B7B;
	Fri,  4 Sep 2026 05:20:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788499240; cv=none; b=Nt7FpGESlA93bGAH5AHBRbarrkw2AUss2F55reKD5yNJYACVS6WK9UQw3VQC6bnLZ8D+Bh5aGri0aR+6gzRKNHDiKOjLnBcaB5IAXVvC0ycMYkkpb6eUCtdtadnb3TlLu37WdLJqgklYAR0TaDKQqmrJ65QBkD5gfniZu/pYES0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788499240; c=relaxed/simple;
	bh=T4MDIt8flH+Glp3RjRlMiEmWiVIcpM6BqgfCpyRHilw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HV2VztvtNXIH+a0hZrxTxWi3Zt4pghLFG2f5MSparKI/h06FiBkBEfrUmr2+BD7O0zzbjF2ElHJboUb3EZYQTmW6U+eSyQGyECymP6mFk2iAF0vFrlfUGytrth1RVMUaiBY0r1FuQLu61yHXGQyJhzRXOojVpnFaEBv6r6jHbmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HP0BVkp3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HP0BVkp3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A92901F00ACA;
	Fri,  4 Sep 2026 05:20:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788499239;
	bh=Kx9p5Mf0ajDR20peXQRTyA1xVJjC1fZXE3apLEUOQiE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HP0BVkp3UkSXMejhRbiENXgJLs/rDsmum349HGsfFwIgD+/RrFukQfKEMiBd72Y3v
	 JidrBFTR7VZcyKRYbH/1eKiYeC3hK6112QBjHUjgMunlUhXNAPhMr1O4eO7uKK7uMR
	 zKAqskUtKrpto7SRbM2QPa1t8UgA3d2+1W4ZrvqM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 7.2 346/713] Bluetooth: hci_intel: fix usage_count leak when autosuspend_delay is negative
Date: Fri,  4 Sep 2026 06:55:14 +0200
Message-ID: <20260904045811.585816851@linuxfoundation.org>
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

From: Guangshuo Li <lgs201920130244@gmail.com>

commit c7e9a8cb6918656884a0757c92465075c7555ffa upstream.

intel_set_power() calls pm_runtime_use_autosuspend() when powering on
the device, but the power-off path does not call the matching
pm_runtime_dont_use_autosuspend() before disabling runtime PM.

If the autosuspend delay is set to a negative value while autosuspend
is enabled, the runtime PM core increments usage_count to prevent
runtime suspend. Without calling pm_runtime_dont_use_autosuspend()
during teardown, this reference is not dropped and usage_count remains
unbalanced.

Add the missing pm_runtime_dont_use_autosuspend() call before disabling
runtime PM.

This issue was found by manual code inspection.

Fixes: 74cdad37cd24 ("Bluetooth: hci_intel: Add runtime PM support")
Cc: stable@vger.kernel.org
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/bluetooth/hci_intel.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/bluetooth/hci_intel.c
+++ b/drivers/bluetooth/hci_intel.c
@@ -345,6 +345,7 @@ static int intel_set_power(struct hci_ua
 			devm_free_irq(&idev->pdev->dev, idev->irq, idev);
 			device_wakeup_disable(&idev->pdev->dev);
 
+			pm_runtime_dont_use_autosuspend(&idev->pdev->dev);
 			pm_runtime_disable(&idev->pdev->dev);
 		}
 	}


