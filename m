Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAF80344DBD;
	Sat, 12 Sep 2026 17:07:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789232868; cv=none; b=Q2DdI8RqRyehjvDVW2ATVuDaLBCnRJpOh2w9HeK8DN0aYiT2O6S5O8wX4/C2B/jVwBn5eEKc5LN8xp/dIpe4cseVshNfhvqJoK7/Sabi9qKsJRmsSkIcjQw6zPjsvJaFbmj9rT8a2R+h6Dx65JCFHu9syOj9pvOX3KP/APL1Fbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789232868; c=relaxed/simple;
	bh=M/0u4iDDdV6EVYn4E7FV4W0d7KACgzvPbJEf2DaIps4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m5P9r+Bsx/C3xJzXx8cnN7x5pfsRnpsMw0GD91ZuKt8bw3grRZpwTGOmd8wGeouI190dQDb6ojAjtJI875aQmf4gy7+rv0/BjepIuoaCZJ2TRTOF03YBqNixJcSmg0GKyxbRBspug+shNlZADBAhk7YjMAx18mnDVe5xUJPofmk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lanvwXey; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lanvwXey"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D23171F000FF;
	Sat, 12 Sep 2026 17:07:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789232866;
	bh=47fpvS0oPm9xAltAIIiiJwFMm+jvBrZgRErK7kFP92Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lanvwXeymwJUXPIxLqyscihJQKwGyoo4d3JSI2d4n5fUg8fJoor7DwtmYOns31S+t
	 uYnTPDKuxw5bQbQZY3W1aELvK50FBTD+f90FVsPqQ1pwWaJae89/T9W3IZ0diM/Xks
	 PMVMQAzJLGJl344GdazGoxM3Py1przKJaAyVtlRY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 5.15 098/935] Bluetooth: hci_intel: fix usage_count leak when autosuspend_delay is negative
Date: Sat, 12 Sep 2026 08:52:08 +0200
Message-ID: <20260912065529.070432781@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


