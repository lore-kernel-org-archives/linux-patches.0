Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 661D1168B4
	for <patches@lists.linux.dev>; Mon,  8 May 2023 09:51:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E08E1C433EF;
	Mon,  8 May 2023 09:51:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683539490;
	bh=u2ifpftMhKqpEYDiTOHYOLI0gumrbaP0Xx5/Ggt+uT4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dAXvBjs8hjr7qvqqJF/KOCg8yfTCr2dT2g56qnffuCFPF4yA7fEiDVorN4GFsBgfp
	 rAStPov/JKwclQL1j4+xzkIQoSoasryjfjdc+eSvmZVYd2JGythSXXNpx4BjgujCSc
	 DjvUx+eFOiue8iqHWvoNWurkBK0X8fSOeXg/Rzfs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Jun <jun.li@nxp.com>,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
	Johan Hovold <johan+linaro@kernel.org>
Subject: [PATCH 6.1 034/611] USB: dwc3: fix runtime pm imbalance on unbind
Date: Mon,  8 May 2023 11:37:56 +0200
Message-Id: <20230508094422.899196591@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094421.513073170@linuxfoundation.org>
References: <20230508094421.513073170@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Johan Hovold <johan+linaro@kernel.org>

commit 44d257e9012ee8040e41d224d0e5bfb5ef5427ea upstream.

Make sure to balance the runtime PM usage count on driver unbind by
adding back the pm_runtime_allow() call that had been erroneously
removed.

Fixes: 266d0493900a ("usb: dwc3: core: don't trigger runtime pm when remove driver")
Cc: stable@vger.kernel.org	# 5.9
Cc: Li Jun <jun.li@nxp.com>
Acked-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Link: https://lore.kernel.org/r/20230404072524.19014-3-johan+linaro@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/core.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/dwc3/core.c
+++ b/drivers/usb/dwc3/core.c
@@ -1979,6 +1979,7 @@ static int dwc3_remove(struct platform_d
 	dwc3_core_exit(dwc);
 	dwc3_ulpi_exit(dwc);
 
+	pm_runtime_allow(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
 	pm_runtime_put_noidle(&pdev->dev);
 	pm_runtime_set_suspended(&pdev->dev);


