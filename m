Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 660B214534E;
	Tue, 27 Feb 2024 14:06:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709042798; cv=none; b=n6d9L+Dw9t5xRGCQXP48e9Or5MeP0Gws8V49rM/ofvevXrJTv48ckRmDRDjc7iJVudPOzcsvA+ZW/4ewSiZUGWpWU7uYawS2XT6JUIXc2ddMhQRFYKZOCh5HKiGW5Wf/qtp2mED6FsQq/8gjfR1ePkuE4RtnAnlvqOCS3BlvY3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709042798; c=relaxed/simple;
	bh=LJC2sFx+M56weOBdPiORX8MPxmmEjcrFh7hG65RTyjk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QCnEmo2wD1TfiyeLba21dOT3DKwu4bet6h85kPE6nVyB9GjYMZqs+zgZ4q8T1qDEHrseYDl4aBd+P+FYS67PLAfxcXAd5ff1/r3JMI5WvTIo38XCZtY3zhNMjQb9oK5Z47NEjKVYTX8i6P8DMEEH/Z/kQASHEGMMkHIywm8QD8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LndryMch; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LndryMch"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E500CC433C7;
	Tue, 27 Feb 2024 14:06:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709042798;
	bh=LJC2sFx+M56weOBdPiORX8MPxmmEjcrFh7hG65RTyjk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LndryMch3JjtJb7QLABEpV+ijILwIYhY1aQ5GjMEaP5eRb33bk7gNJ550gX0MWUF/
	 ErAd4b2CEtvKnGSA76QU4Ho80DPgHgwylKWXdQ9MrKv5lviUa4cIDfT9W3n7mLGrRF
	 1dWRaW1NdH1RTzO1Zl+wmFWrP+m5+5y1CHyN0y/U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 5.15 096/245] usb: dwc3: gadget: Dont disconnect if not started
Date: Tue, 27 Feb 2024 14:24:44 +0100
Message-ID: <20240227131618.337108889@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131615.098467438@linuxfoundation.org>
References: <20240227131615.098467438@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Thinh Nguyen <Thinh.Nguyen@synopsys.com>

commit b191a18cb5c47109ca696370a74a5062a70adfd0 upstream.

Don't go through soft-disconnection sequence if the controller hasn't
started. Otherwise, there will be timeout and warning reports from the
soft-disconnection flow.

Cc: stable@vger.kernel.org
Fixes: 61a348857e86 ("usb: dwc3: gadget: Fix NULL pointer dereference in dwc3_gadget_suspend")
Reported-by: Marek Szyprowski <m.szyprowski@samsung.com>
Closes: https://lore.kernel.org/linux-usb/20240215233536.7yejlj3zzkl23vjd@synopsys.com/T/#mb0661cd5f9272602af390c18392b9a36da4f96e6
Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Link: https://lore.kernel.org/r/e3be9b929934e0680a6f4b8f6eb11b18ae9c7e07.1708043922.git.Thinh.Nguyen@synopsys.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/gadget.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -2501,6 +2501,11 @@ static int dwc3_gadget_soft_disconnect(s
 	int ret;
 
 	spin_lock_irqsave(&dwc->lock, flags);
+	if (!dwc->pullups_connected) {
+		spin_unlock_irqrestore(&dwc->lock, flags);
+		return 0;
+	}
+
 	dwc->connected = false;
 
 	/*


