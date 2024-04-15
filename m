Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92AB0823BF;
	Mon, 15 Apr 2024 14:29:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713191368; cv=none; b=X2uSZB9i2se67yfWmUyoV7rtRI4rJGwO/ae5NQjSBBrEFAwVbbpQrFbCUxoQI1khul7Qt3Uh0aHuo5oFgBhW5e7y6qoriTPXt3bUg8pxIacfKR0+DnfoydQih8yeRziPDSHKUJsTDmBLAZm2sE/pBSIe5477CEhESwKjR0819ho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713191368; c=relaxed/simple;
	bh=nRHiEOfm25NdUIPOB3SpG16gsI6Uz+YEirMZ+jNDX74=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AqW8PniWu5HAr8AZwtiYR9M/qKd76zR1i0lUNNbP2Kr0f6d5NlpKdUzyFJxBj7LDQjVt5KYhrIhKKxCGihOk7BsoKy9iqFcCGPeBfBgsYpyUFybWgot/331OG0qi8pO9BuDebGRovT2pLoKlLR0o9vZbkpwWL2LO1zWjXOlmEqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Hwv8EFso; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Hwv8EFso"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 185A5C113CC;
	Mon, 15 Apr 2024 14:29:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713191368;
	bh=nRHiEOfm25NdUIPOB3SpG16gsI6Uz+YEirMZ+jNDX74=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Hwv8EFso5GUvibsd9K6/P2naexhefaE9YviGIpEW1LHOG2+LWjGSFhtGOnxncb3kF
	 O3cC1Tj4qYhiqrm79jJPk2hZpDqHj0lJFQeBUsYFKFXYRM4hwWucmKkKGH1cSrx502
	 IQu49D9vfmpAwMKdTw+cz9jS/9zZ8/ZHQD7R1+oA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Wachowski, Karol" <karol.wachowski@intel.com>,
	Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>,
	Jeffrey Hugo <quic_jhugo@quicinc.com>,
	Wachowski
Subject: [PATCH 6.8 119/172] accel/ivpu: Fix PCI D0 state entry in resume
Date: Mon, 15 Apr 2024 16:20:18 +0200
Message-ID: <20240415142004.002750267@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240415141959.976094777@linuxfoundation.org>
References: <20240415141959.976094777@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wachowski, Karol <karol.wachowski@intel.com>

commit 3534eacbf101f6e66105f03d869a03893407c384 upstream.

In case of failed power up we end up left in PCI D3hot
state making it impossible to access NPU registers on retry.
Enter D0 state on retry before proceeding with power up sequence.

Fixes: 28083ff18d3f ("accel/ivpu: Fix DevTLB errors on suspend/resume and recovery")
Cc: <stable@vger.kernel.org> # v6.8+
Signed-off-by: Wachowski, Karol <karol.wachowski@intel.com>
Signed-off-by: Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>
Reviewed-by: Jeffrey Hugo <quic_jhugo@quicinc.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240402104929.941186-4-jacek.lawrynowicz@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/accel/ivpu/ivpu_pm.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/accel/ivpu/ivpu_pm.c
+++ b/drivers/accel/ivpu/ivpu_pm.c
@@ -74,10 +74,10 @@ static int ivpu_resume(struct ivpu_devic
 {
 	int ret;
 
-	pci_set_power_state(to_pci_dev(vdev->drm.dev), PCI_D0);
+retry:
 	pci_restore_state(to_pci_dev(vdev->drm.dev));
+	pci_set_power_state(to_pci_dev(vdev->drm.dev), PCI_D0);
 
-retry:
 	ret = ivpu_hw_power_up(vdev);
 	if (ret) {
 		ivpu_err(vdev, "Failed to power up HW: %d\n", ret);


