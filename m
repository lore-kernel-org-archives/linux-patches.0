Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CE7F2AEEB;
	Sat, 12 Sep 2026 15:31:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789227116; cv=none; b=LO4k2HFZu1ujicSL3xQLKbQfV7yi9ElBaTViUD6b8tMzNrKVY4Y7VOEt4x3L7hZyPaspfXCTK4Gru74bwn+rdjmQhXXVlbYAVZnJi5nDdZXfkjsLYt4qUtLSFiWKiQ7WrB48Xu/SqZPhBnuMPIQFK5+7ZFXX27I8sT5VrDY3GSY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789227116; c=relaxed/simple;
	bh=sLwAH5ND+9LOFRROmNVT8u+QbGc69oMFMGexuYcDnYw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rA/EG6WbZrT9jkMtqAv40FfftrYHfynkcfdQ7AnW3aHtjRoVelVct9a7XEaXDUnYBgbAtwuhX0qyDoyPddvGsyN0qDxXiFIqJPNSWcoOKSdnd8ab6zkgGrXVF+d+85UaCdmYnZMLXeu/ejpiF4aA4yPupfa2Q7SOfztWTEPUrDM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qBtA20Bz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qBtA20Bz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C84E21F000FF;
	Sat, 12 Sep 2026 15:31:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789227114;
	bh=aGFh97vD9Ay2PBu+BbUB91XT82ZEvOMKkMpX4QHF0dk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qBtA20Bzs3RjH2iyW+LCGi5GDD/3xMfQDMRT3DrlF2oloh4oEsB6UeB5uCkBm6+qL
	 +LvYOnGGfPr+6VetOpF0B4smZn53wpD0zo8oQYm3nISi6f4FOI7NRk88QFqtKfdnbI
	 m8AzLaztZeYQ0xU7A1i19Gi91b+7KpGO6W8q94Gg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.1 0116/1191] Bluetooth: hci_intel: fix usage_count leak when autosuspend_delay is negative
Date: Sat, 12 Sep 2026 08:47:24 +0200
Message-ID: <20260912065550.795689636@linuxfoundation.org>
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


