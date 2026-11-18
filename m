Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051668;
	b=UuFMJzJOlQhwpwzj57BCA9pVU5sCBUfqtT6hiUxehe5+0l8VnimL6dgWZu4mvMDzs3Aj
	 FSIUHYIzsV7lmdpbcqATQqBVdKTWKAxiy2OALjktH9BYZwxJ0ShXDNAA4PZXXudOq9Im0
	 c8iMCG9xodrP3MIo2Y7Y3sc7mqh7NdD79W4nz/kHUrMhLVonIxjiBKo4MYhxQ5oPSdLFV
	 bLxKv5xSFqNCiDK4SY4uQux2byXnP/m9V38e9ZIISbHNbE5WdJEvxx5PdOcj3+A0wgC7I
	 +/Qm2iUqKlRg1aK0NgslWGvjGtEsigs1UJS86x7KceeD9CZFEbo9uAM99mbO621IXvA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051668;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BKzb2edQUNHr6/ExOacPJcJa45o5i5ZnJQSH6XqiEB8=;
	b=Qb7pPs2TYGWZ5+6WhmPE+2IAPgEyLu6hLlBV0KFYRLaoTQrDV2RI5EmOQiqrqsU31msd
	 KdVrmz0Y6ARBSPc+A2GnHliXDb3Y7lmLf5Mzou63bsotnIIxTiz2Hq49EAEhNLd0VS+nf
	 XTkD5Anf68NbvYNa2dI7vyZ95+EZ/MVh33g6mcMcjfQEAQnOCKSuf/PtEJRlJcNCgMUJ2
	 sydgiKyKaaVM/OafkyPXT5YqB8odutm/CA7czWiGLRgHwcjGEpoAMPV0krFAp80S36c4r
	 OJNIwQ/J9lWhG7kqbo+wgI9WMVm43Y1WrS6klfo/VNFylxpf4I8qnYq0JbmKfo7AGIw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=reW+2P1J;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C974D606A31C;
	Thu, 19 Nov 2026 01:27:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=reW+2P1J
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F4EB1F000C4;
	Thu, 19 Nov 2026 01:27:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051668;
	bh=BKzb2edQUNHr6/ExOacPJcJa45o5i5ZnJQSH6XqiEB8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=reW+2P1JdjC3h4ocDhW6QqQhsxlBM7L5IMDc2X3zEuSNPw9ZIwllka5xm7EZKp8F9
	 SZaI3bVVRdUQFmQsZMVLJutlwu7z+Cnzp/HXBhukKRAVxBV+ejojpuEZiihGq0MYMi
	 aQetUmjsm9eHsE2oydjqpMAG35+OyrmFaKnZC1+o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Wendleder <gonsolo@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5.15 0289/2214] wifi: b43: fix use-after-free in b43_bcma_remove()
Date: Wed, 18 Nov 2026 15:32:45 +0100
Message-ID: <20261118150021.611610652@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andreas Wendleder <gonsolo@gmail.com>

commit c6c8bc355657115664131b38c53c5ddf7d93b072 upstream.

b43_one_core_detach() frees the struct b43_wldev it is given the bus
device of. b43_bcma_remove() then reads wldev->dev again to free the bus
device, which is a read of freed memory.

b43_ssb_remove() does not have the problem: it takes a copy of wldev->dev
at the start. Do the same here.

Fixes: 96838d61102a ("b43: Fix memory leaks in b43_bus_dev_ssb_init and b43_bus_dev_bcma_init")
Cc: stable@vger.kernel.org
Signed-off-by: Andreas Wendleder <gonsolo@gmail.com>
Link: https://patch.msgid.link/20261013000124.48605-1-gonsolo@gmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/broadcom/b43/main.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/net/wireless/broadcom/b43/main.c
+++ b/drivers/net/wireless/broadcom/b43/main.c
@@ -5657,6 +5657,7 @@ static void b43_bcma_remove(struct bcma_
 {
 	struct b43_wldev *wldev = bcma_get_drvdata(core);
 	struct b43_wl *wl = wldev->wl;
+	struct b43_bus_dev *dev = wldev->dev;
 
 	/* We must cancel any work here before unregistering from ieee80211,
 	 * as the ieee80211 unreg will destroy the workqueue. */
@@ -5671,14 +5672,14 @@ static void b43_bcma_remove(struct bcma_
 		ieee80211_unregister_hw(wl->hw);
 	}
 
-	b43_one_core_detach(wldev->dev);
+	b43_one_core_detach(dev);
 
 	/* Unregister HW RNG driver */
 	b43_rng_exit(wl);
 
 	b43_leds_unregister(wl);
 	ieee80211_free_hw(wl->hw);
-	kfree(wldev->dev);
+	kfree(dev);
 }
 
 static struct bcma_driver b43_bcma_driver = {


