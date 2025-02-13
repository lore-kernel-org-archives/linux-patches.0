Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02318227EB2;
	Thu, 13 Feb 2025 14:39:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739457549; cv=none; b=CMbEMmp1kh5jjshKOGsenpOnK/QILv5DrDKkObxckrvkuNP2RZ6A9YuKhmjrmfVhkcYyXglq1JbiCp6Mk55/Q5vi/BoBKLB7mNSBS6FxRR6/mqBcMoB2VFFfDuWFo2ifQEOO94wk/7s54odWDO2j+FE0t07TYCXTguEenWWphAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739457549; c=relaxed/simple;
	bh=C535Ap/R3+aK8Fgjqiz45hX4vOUhNnGhjHKVR6hPhgw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LKrs/JhWv/p24GxCLT/FN2qXlLWr3wMYZcnWGJQNk05Uvct14gc4vzVi99Lie3to5H6Vrx8Gh1wHimzZTNDB8M+UoMKBMB38/jjZGnoM3kNA+MnPmI3wl97gB/bKC4qUNhnzLgli3RvWqHLe/tyKl5JocutNB48Uw0i5nEd4sII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Cw/LtWtZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Cw/LtWtZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65AEAC4CED1;
	Thu, 13 Feb 2025 14:39:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739457548;
	bh=C535Ap/R3+aK8Fgjqiz45hX4vOUhNnGhjHKVR6hPhgw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Cw/LtWtZ3EEm33kkqtthWoNdMnHTueLoFdFhpT5BJmKG7D1gnlZhy8h6yDf3PMrHh
	 Up8xtEGVXKin2aK4+MK4QDzHD//UyfHiTh+/J5L1MLNzeiw4fpCowS+rQifznZ5FEG
	 RnZVWFk0YFsTh1Ph1OcysK9Lq+XHdkhATmi6OgpA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karol Wachowski <karol.wachowski@linux.intel.com>,
	Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>
Subject: [PATCH 6.12 143/422] accel/ivpu: Fix Qemu crash when running in passthrough
Date: Thu, 13 Feb 2025 15:24:52 +0100
Message-ID: <20250213142442.064179084@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142436.408121546@linuxfoundation.org>
References: <20250213142436.408121546@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>

commit 901dd2617c9c3554b2449c8844b6338009112fcf upstream.

Restore PCI state after putting the NPU in D0.
Restoring state before powering up the device caused a Qemu crash
if NPU was running in passthrough mode and recovery was performed.

Fixes: 3534eacbf101 ("accel/ivpu: Fix PCI D0 state entry in resume")
Cc: stable@vger.kernel.org # v6.8+
Reviewed-by: Karol Wachowski <karol.wachowski@linux.intel.com>
Signed-off-by: Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20241106105549.2757115-1-jacek.lawrynowicz@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/accel/ivpu/ivpu_pm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/accel/ivpu/ivpu_pm.c
+++ b/drivers/accel/ivpu/ivpu_pm.c
@@ -73,8 +73,8 @@ static int ivpu_resume(struct ivpu_devic
 	int ret;
 
 retry:
-	pci_restore_state(to_pci_dev(vdev->drm.dev));
 	pci_set_power_state(to_pci_dev(vdev->drm.dev), PCI_D0);
+	pci_restore_state(to_pci_dev(vdev->drm.dev));
 
 	ret = ivpu_hw_power_up(vdev);
 	if (ret) {


