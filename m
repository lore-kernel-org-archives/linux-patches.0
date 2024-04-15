Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3DEF83CDD;
	Mon, 15 Apr 2024 14:29:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713191375; cv=none; b=qAtN/VUR8jFPU7ptEetfHy0v33CYMwjQTYM/TDbvX4ire1bipLBQFmhJyrxhsHijRtN1/NhZLZLG29N/aXycClm+PbG2ymz/ww7cE+6Vztq2xB5hriZ9XRNs/OvTCrzhclX1NpIUVX+tBa5A4e1O/Ei3wQQRhB73Z/MUpwSyzrk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713191375; c=relaxed/simple;
	bh=AZ4lnXpvotHTtU6KmCs3i/I1G7zjl6zU30DhnJ4WhKM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nnP3gEq7ZlXpmcfCKtyshXMTA5HH9f05qdjdH+hBsiZsOnRiMrIaOqz7hTRX4ymhHY49sV+RsAdHqi4rhoAJcFjhFMMU1Ffb11NJOelsRRl5G1YMGUMdPwwL7kA2mPRla5CHKR4kkPvrqrWDcW+1gDxW6mtU6BZc61wsm9qaqQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Aq/7F0bI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Aq/7F0bI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AA8EC2BD11;
	Mon, 15 Apr 2024 14:29:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713191374;
	bh=AZ4lnXpvotHTtU6KmCs3i/I1G7zjl6zU30DhnJ4WhKM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Aq/7F0bI0M0J2r+HhUIcCczjatI3wXoV39ojViYIIcmjbOvto9eHN+NK9SEKvzp7P
	 jzsytfwxRcVdSRc6NiuyL4y7RHpiDxHQBoylUaK1aLOl6feuD4DB7bgZefA9z2jwwI
	 53P1M1MEqmavT6wLj71jU/wn4FByq67bwMbis0ZQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>,
	Jeffrey Hugo <quic_jhugo@quicinc.com>
Subject: [PATCH 6.8 120/172] accel/ivpu: Put NPU back to D3hot after failed resume
Date: Mon, 15 Apr 2024 16:20:19 +0200
Message-ID: <20240415142004.032398964@linuxfoundation.org>
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

From: Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>

commit 875bc9cd1b33eb027a5663f5e6878a43d98e9a16 upstream.

Put NPU in D3hot after ivpu_resume() fails to power up the device.
This will assure that D3->D0 power cycle will be performed before
the next resume and also will minimize power usage in this corner case.

Fixes: 28083ff18d3f ("accel/ivpu: Fix DevTLB errors on suspend/resume and recovery")
Cc: <stable@vger.kernel.org> # v6.8+
Signed-off-by: Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>
Reviewed-by: Jeffrey Hugo <quic_jhugo@quicinc.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240402104929.941186-5-jacek.lawrynowicz@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/accel/ivpu/ivpu_pm.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/accel/ivpu/ivpu_pm.c
+++ b/drivers/accel/ivpu/ivpu_pm.c
@@ -100,6 +100,7 @@ err_mmu_disable:
 	ivpu_mmu_disable(vdev);
 err_power_down:
 	ivpu_hw_power_down(vdev);
+	pci_set_power_state(to_pci_dev(vdev->drm.dev), PCI_D3hot);
 
 	if (!ivpu_fw_is_cold_boot(vdev)) {
 		ivpu_pm_prepare_cold_boot(vdev);


