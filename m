Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98B0247C11A;
	Sat, 12 Sep 2026 13:37:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789220239; cv=none; b=Bkuv54fmnbb5ECrAEUHmXpUSb7RrFdS+ysAluJU1DzyxQmsqbD81Vc+/XaU5DYPEkM4fjHAe42i+Y2FFq6ZN6GKjDnWPvOdxRbUHfzfCPykgtKQV0yRyCJxm/EMHWMhHPlAoOni3/qslUuWi/pTnp5ksh1maW5GmXn0pRhfaKfE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789220239; c=relaxed/simple;
	bh=P/zxiUEN+njIU4saEFBFn1uGqa/TW8buOfKoNcXnZQM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d0tcNW/3McUdYa5LuQHvM2qQzZZ5n5xW2q/KtwXQVzIHBIip0mTAlEjdYV8Rv6RKLZhY0qiLwXbLjZrVMva0dgTq7sYVEO5jqmaJQ/MvZifYhqLl8LIz6Cpfsw1JoMxCvGuKQIIAuw5iQnD+p6kVEpbBSz3xtHFl9sVofriaU48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yVLRgivS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yVLRgivS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 026C01F000FF;
	Sat, 12 Sep 2026 13:37:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789220238;
	bh=yqZq3rRb7QHohW6AeRMVXDI/bvQzDz6M4ApcErsr+i8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yVLRgivSH3IdOhym0OTYHUFSUxznDeCrAKx7IGUsFWk2NNuNAeiiK4WcEWpMMyojy
	 gP78KAcdZRc3YeUYX5zcAAEmRo+BJjBFxD7ZqofQZcz0htaulDHUHFZyOHzmhLgz2H
	 V/xUSueSNTPIpIf/3Fo3Q5eXky4abLmoT9+IqLm4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.6 0136/1424] Bluetooth: hci_intel: fix usage_count leak when autosuspend_delay is negative
Date: Sat, 12 Sep 2026 08:42:48 +0200
Message-ID: <20260912065610.345247827@linuxfoundation.org>
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
@@ -348,6 +348,7 @@ static int intel_set_power(struct hci_ua
 			devm_free_irq(&idev->pdev->dev, idev->irq, idev);
 			device_wakeup_disable(&idev->pdev->dev);
 
+			pm_runtime_dont_use_autosuspend(&idev->pdev->dev);
 			pm_runtime_disable(&idev->pdev->dev);
 		}
 	}


