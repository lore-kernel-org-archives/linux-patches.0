Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6C57359F99;
	Fri,  9 Jan 2026 12:08:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767960528; cv=none; b=pBSNtrWHa7psLr6fr2qKT3T0Xa4I3syj2iUerhDVNlcq2zY2Lj+uCCaUFdEM9O6fsXV45HnJzLJuv/nf13YwlDpMC5EF7wAHw98DmlZL2nCs399ZNJVWF/KVlWDHmpvADeLVIG1AGoQShid7Z6B025yvU/N373vIsRwJvWG6wqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767960528; c=relaxed/simple;
	bh=thu/zXgw42K4YnIwBDKvHaAdKf3h4gUiLCmJXC/VnH8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U+CMcKh8BTpIOyG1M17IlVMos2STU4FdGI9QZZzdv69Jt2tUvt9YEsIVKIGq04sBrfC35Ja6w0TS0soPkI8Tckz5JJH0m3CMkybfEsLthM3EFbC7SdUqZufYYiYtkTAt1SKmyu+Z7ms3mYBzj6amReOUMuvyQZy64hPR9pfj0hg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R78JngLO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R78JngLO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 734FBC19423;
	Fri,  9 Jan 2026 12:08:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767960527;
	bh=thu/zXgw42K4YnIwBDKvHaAdKf3h4gUiLCmJXC/VnH8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R78JngLOOQ9LpOb2jXzB80RveNK6jUjjWqdz+AA2joAffn80+VaCiYpo4VWkfOcxs
	 TsnwI82A/43yEFRQO8qTZFQhprAoGv2wWanmUkFnS9B6COzV0HCf+t3rhLE38OpP/1
	 qctExJCnxObkglnWNhE//cHQhJjmDfScFDnefI6E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Duoming Zhou <duoming@zju.edu.cn>
Subject: [PATCH 6.6 436/737] usb: phy: fsl-usb: Fix use-after-free in delayed work during device removal
Date: Fri,  9 Jan 2026 12:39:35 +0100
Message-ID: <20260109112150.394719356@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

From: Duoming Zhou <duoming@zju.edu.cn>

commit 41ca62e3e21e48c2903b3b45e232cf4f2ff7434f upstream.

The delayed work item otg_event is initialized in fsl_otg_conf() and
scheduled under two conditions:
1. When a host controller binds to the OTG controller.
2. When the USB ID pin state changes (cable insertion/removal).

A race condition occurs when the device is removed via fsl_otg_remove():
the fsl_otg instance may be freed while the delayed work is still pending
or executing. This leads to use-after-free when the work function
fsl_otg_event() accesses the already freed memory.

The problematic scenario:

(detach thread)            | (delayed work)
fsl_otg_remove()           |
  kfree(fsl_otg_dev) //FREE| fsl_otg_event()
                           |   og = container_of(...) //USE
                           |   og-> //USE

Fix this by calling disable_delayed_work_sync() in fsl_otg_remove()
before deallocating the fsl_otg structure. This ensures the delayed work
is properly canceled and completes execution prior to memory deallocation.

This bug was identified through static analysis.

Fixes: 0807c500a1a6 ("USB: add Freescale USB OTG Transceiver driver")
Cc: stable <stable@kernel.org>
Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
Link: https://patch.msgid.link/20251205034831.12846-1-duoming@zju.edu.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/phy/phy-fsl-usb.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/phy/phy-fsl-usb.c
+++ b/drivers/usb/phy/phy-fsl-usb.c
@@ -987,6 +987,7 @@ static void fsl_otg_remove(struct platfo
 {
 	struct fsl_usb2_platform_data *pdata = dev_get_platdata(&pdev->dev);
 
+	disable_delayed_work_sync(&fsl_otg_dev->otg_event);
 	usb_remove_phy(&fsl_otg_dev->phy);
 	free_irq(fsl_otg_dev->irq, fsl_otg_dev);
 


