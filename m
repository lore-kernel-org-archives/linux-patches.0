Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D633D40FDB9;
	Thu, 30 Jul 2026 15:14:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785424499; cv=none; b=nKidQx1Z2I+HtvlEhlUI7yVhcKBqX65k709/Mt30oO8OQR9jfiN5s9IL+6TnAKfaaUb9N48YSyYYn3/pj1v052geAc0oA7kIA4krMbQFZRvmUt+tubsN7iCWSIrWIrh54XNthhB4gjva/hLVlF18FScIoPt5JU3Op+XXkGjuYbI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785424499; c=relaxed/simple;
	bh=83b3q7xRQhjwyys3kcTvIWYktTJ4KCcBdTEaFGsoQ+c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SqLf+etjJI7EJKnJZ2tL0o0Q4F1oIMQAl/WNRuq+ACHD/PGJDy4Xzu8sAWHjDkbL+tdjsPipBi0bIo99X8DBRfrpJ08tW4c4QegrV6jdpG71DiMPsqM5LAjOOOdOTJuFo7pxuzmnqzjsvIigXp4E7oN2uOxSpAY/D1lxPfdcyyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WI9xU2vD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WI9xU2vD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3288F1F000E9;
	Thu, 30 Jul 2026 15:14:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785424497;
	bh=tmuRqki+O+5UzXovANretLqeP/jCVvVYK8CxRkUfdJQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WI9xU2vDqR0UmXcMQhKG3r0EYti6U5A+uzfdR/k29toYo8WxgMXi85W5D6j4z/+Ld
	 7fvQU1VE0M9puHZnHN58ZBsE7tsymg/B3Q41IM6abxhjqQqQ0LS9QkzXgSFQuYtNnc
	 K6j4AcixZMY3GKRCCxBpojH2mqagRBHJYpV+heqg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.18 408/675] media: marvell-cam: fix missing pci_disable_device() on remove
Date: Thu, 30 Jul 2026 16:12:18 +0200
Message-ID: <20260730141453.804435929@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

commit 033ff0420e4c9c240ae5523fff39770298efa964 upstream.

During manual code audit, we found that cafe_pci_probe() enables the
PCI device with pci_enable_device(), and its probe error path properly
calls pci_disable_device() on failure.

However, cafe_pci_remove() tears down the controller and frees the
driver data without disabling the PCI device, leaving the remove path
inconsistent with probe cleanup.

Add the missing pci_disable_device() call to cafe_pci_remove().

Fixes: abfa3df36c01 ("[media] marvell-cam: Separate out the Marvell camera core")
Cc: stable@vger.kernel.org
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/marvell/cafe-driver.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/media/platform/marvell/cafe-driver.c
+++ b/drivers/media/platform/marvell/cafe-driver.c
@@ -609,6 +609,7 @@ static void cafe_pci_remove(struct pci_d
 		return;
 	}
 	cafe_shutdown(cam);
+	pci_disable_device(pdev);
 	kfree(cam);
 }
 


