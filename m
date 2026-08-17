Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F7793BB687;
	Mon, 17 Aug 2026 14:08:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786975732; cv=none; b=k8tBEuMwqpqpjEsDGPM5aijw1p/BO2qeqA+XY2jRSgGfJcl6DSvPd96yF2zu0FMQW4+zPfsrGuXgWJkltbbACUQIDOwMtfsTHFOsjYR5ygSmT+glH4roYUYtqnGR7tPeckVWRMUG6jdHCnZTFjMsbxfnEnJF7tH5g4ONvv/u48U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786975732; c=relaxed/simple;
	bh=UleHuZjMTq8EcXDwhP/NN/nlvpPNbtY/4LrL2drQmR8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N5unbzGwR9vodKfZnK42slITpVYNJUouP1/KOT9ddwaoo6PVJ3RpF3UyADE+2bFla0hJWnSQRB9qfKkTv+K6WehNxaMM6/Q3c7YUXOpX7ZS90XSEofCgd35h9LXwdEp3UiXlL0c7lGSqCTA1YZ/adMH+TLWDANiVnBZTMvbX3pA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WL6886QM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WL6886QM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5448D1F000E9;
	Mon, 17 Aug 2026 14:08:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786975730;
	bh=B9KP77s/7e9vVOPAaQVoLkLrqT35Ffj7z1qd7Yw1ygs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WL6886QM06dD6Mb6QrLvRj6KmVkcXH1/3B2qLsAtVY5Okuf5lddtwJfWyZt0Gy5vH
	 A9oqGO1YXDigDBDAjRbE+NNFRNzU6UO+d0nscpYArEaqLRqqr0SvxWrv74YSi+lPDZ
	 RtZnKXvS7nr+mSGO3PVCkOSBhoqChxd35SiJiv5A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 5.10 129/389] media: pci: dm1105: Free allocated workqueue
Date: Mon, 17 Aug 2026 15:29:28 +0200
Message-ID: <20260817132544.194208653@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132538.796021292@linuxfoundation.org>
References: <20260817132538.796021292@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>

commit 1a65db225b25bb8c8febf16974c060e0cc242eb9 upstream.

Destroy allocated workqueue in remove() callback to free its resources,
thus fixing memory leak.

Fixes: 519a4bdcf822 ("V4L/DVB (11984): Add support for yet another SDMC DM1105 based DVB-S card.")
Cc: <stable@vger.kernel.org>
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/pci/dm1105/dm1105.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/media/pci/dm1105/dm1105.c
+++ b/drivers/media/pci/dm1105/dm1105.c
@@ -1195,6 +1195,7 @@ static void dm1105_remove(struct pci_dev
 
 	dm1105_hw_exit(dev);
 	free_irq(pdev->irq, dev);
+	destroy_workqueue(dev->wq);
 	pci_iounmap(pdev, dev->io_mem);
 	pci_release_regions(pdev);
 	pci_disable_device(pdev);


