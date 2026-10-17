Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5535A359A9B;
	Sat, 17 Oct 2026 16:08:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792253314; cv=none; b=ulP6Jco88sGR9DlTCYxlNClHj2Tkeg3rkC2Xt6x3QvtPDg8RkMNmadJKFNs/heMBvxRZZNLtv3mhYR72dGTjPJej4y27xKDtmwX8yxl5L3jRtUVm/IO6Ex6dBjj+nwgZNMlnbfURycqrUAs5hsnTVJCKH6FKKJkQQ+OlkbS/UyU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792253314; c=relaxed/simple;
	bh=eF8qs0+P8uM+jP3zvWQMvTajoiUE8QI2smZ+6uKc9vo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=O9Phrl0y8KFOMUgMcJAiLjwf9z8PMVilnIKhHyEX3rXbYgqd5wupQM3Fo4tibRZVSPx5XNa6nSHLQ26gJwvEKZlezof0Ru8ktsKNsbKzFfLZ3Msv0cPpl2zWW/Pznwk4gsq1nFI1TQipbmRQ6OL38kOr1sDXNaDd/nIQE8iOmGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W/DK5kpM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W/DK5kpM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B7921F000C4;
	Sat, 17 Oct 2026 16:08:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792253311;
	bh=hZ//0ZCxGXHQcQskAQkA46oti0NtnlftnDTZGeg6/u4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W/DK5kpMH9r3ZfEnGlyrmqrs8zF+B6W7wvTdx8yg1CG4k9CrNXi7fDMyNHpcNHb5e
	 +FblVpgVT9/J7IPDvS3LkoRIF0NBM4zLStrcbpC2K/WOJZ3Ad8SFNuN17fC8Gct85F
	 Z+RhMTP1CAhYn29a0cFKIM5kN3a7PUlMpS4a74T0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brian Norris <briannorris@google.com>,
	Brian Norris <briannorris@chromium.org>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Konrad Dybcio <konradybcio@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 078/869] PCI/pwrctrl: Cancel outstanding rescan work when unregistering
Date: Sat, 17 Oct 2026 17:48:39 +0200
Message-ID: <20261017160039.027816607@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Brian Norris <briannorris@google.com>

[ Upstream commit 8b926f237743f020518162c62b93cb7107a2b5eb ]

It's possible to trigger use-after-free here by:

  (a) forcing rescan_work_func() to take a long time and
  (b) utilizing a pwrctrl driver that may be unloaded for some reason

Cancel outstanding work to ensure it is finished before we allow our data
structures to be cleaned up.

[bhelgaas: tidy commit log]
Fixes: 8f62819aaace ("PCI/pwrctl: Rescan bus on a separate thread")
Signed-off-by: Brian Norris <briannorris@google.com>
Signed-off-by: Brian Norris <briannorris@chromium.org>
Signed-off-by: Krzysztof Wilczyński <kwilczynski@kernel.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Acked-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Cc: Konrad Dybcio <konradybcio@kernel.org>
Link: https://patch.msgid.link/20250409115313.1.Ia319526ed4ef06bec3180378c9a008340cec9658@changeid
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/pwrctl/core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/pci/pwrctl/core.c b/drivers/pci/pwrctl/core.c
index 01d913b603160..316c1bc05d4d9 100644
--- a/drivers/pci/pwrctl/core.c
+++ b/drivers/pci/pwrctl/core.c
@@ -110,6 +110,8 @@ EXPORT_SYMBOL_GPL(pci_pwrctl_device_set_ready);
  */
 void pci_pwrctl_device_unset_ready(struct pci_pwrctl *pwrctl)
 {
+	cancel_work_sync(&pwrctl->work);
+
 	/*
 	 * We don't have to delete the link here. Typically, this function
 	 * is only called when the power control device is being detached. If
-- 
2.53.0



