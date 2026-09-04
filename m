Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D11A37C106;
	Fri,  4 Sep 2026 05:50:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788501001; cv=none; b=rb2jCgD6FKcLmrbW4XPBcTYVUhUXmHfhFI/MWFnRyJ/uERznVLa9xyPSs4mfblTv+IabfFs7KuXwjbQGrGEQxC5v5yfP2+tiQO1Qu2LXbj6QtM5OVJy6vvDYsDMSsTDSJFk5stQPJ+g4oVSKZ+53OcE6s6HDlxoq4WCm9lX8viY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788501001; c=relaxed/simple;
	bh=/qjB8QZH/I8EClh6wLWMmSTa/3CkuHVeB+i6BmYQRNI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e+v/4LnNHLdbqOX9HXKbaKFyMKCFtdClPTTRCtZxf23SNrwWuUp+5HlrPERgP6HLYLqgXC7k+qjfw/uiN3Qh54dgvNBRzGc9klvi2M4v+gltiHY7ibLlRoNWGyoZ6sUIQycWmDXZqc3GHh3xlEzCDFWh7V7AUCpQU5S/h8o2Bks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zhu1LdTR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zhu1LdTR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 990271F00A3D;
	Fri,  4 Sep 2026 05:49:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788501000;
	bh=fIo4bYpxgmHjyAprvoQ67ihyc6J7T3Xi++jTDKOVss8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Zhu1LdTRdQPx6dl7f6WSc9Mq1kZVeAK1eAMzt4S164/2Poc7pPuPFkQsBRfP/J3s6
	 Ttt+8IwJVqJk1MhMuFsz+vdLJmJnugCpWYqiKL0Hf2/cm9J/sXaUTAHYwdn2eJIsm4
	 e3tArnzmuI6Gx/qsy+HQJVFFxhFIiVu6hqsp9ijU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.18 253/552] Bluetooth: hci_intel: fix usage_count leak when autosuspend_delay is negative
Date: Fri,  4 Sep 2026 06:56:50 +0200
Message-ID: <20260904045755.417886995@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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


