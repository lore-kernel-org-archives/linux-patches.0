Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 239492FA629;
	Tue, 17 Jun 2025 16:45:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750178735; cv=none; b=YXNLceGINw3JdDhMfcdN2yDa8Bd8es8j6ML01KH5EG7K70qi3bM77Ij2p6HhGSLJ+hxTQwvOUz7U2jgXoVJjW45rHvaUdRyucW+RranUfgwCMPFfKJMl+2LmPby7Su0rDbSnG/zTiPKWNPTyKZo7H9EzxTtCWAj3U+9GDgndpDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750178735; c=relaxed/simple;
	bh=1EP1vp7V0QqH7hsrztGCOZxB7dDYyw1zKEMpJGv5LI0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cFl+MYcx5FZu5AStwiewrpS3++ryADkAejJpBvTLtAkf3TfhO8WlTvT+ieQsbj2SNCCY+zZYXDrhpbIas/dFJzQ2WSVfrEM8ihc7zdg2U9iFoIr9u4yE8HcutOV+S4uy0Gcug8lsNvHpcO5f8kONq5Zd5EKPxIMCH+4x2vLRKLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=12JpbbTn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="12JpbbTn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73B2BC4CEE3;
	Tue, 17 Jun 2025 16:45:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750178734;
	bh=1EP1vp7V0QqH7hsrztGCOZxB7dDYyw1zKEMpJGv5LI0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=12JpbbTn2L31OzCPRXsXcjrAb55XChqolj0jKqFAfpBd8aFiL3kR0B9VEgG8oUu5w
	 HmdaxkzVQRfpbZdOswfZdI9SDFNybIWmGrqjzn+SuFtcFy5LUaJapBNaINPBKqC/kT
	 B/qCaiqv8Wu1nsab950WrKVdZ6lUvNb/FPr7n7C4=
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
Subject: [PATCH 6.15 510/780] PCI/pwrctrl: Cancel outstanding rescan work when unregistering
Date: Tue, 17 Jun 2025 17:23:38 +0200
Message-ID: <20250617152512.282869254@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/pci/pwrctrl/core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/pci/pwrctrl/core.c b/drivers/pci/pwrctrl/core.c
index 9cc7e2b7f2b56..6bdbfed584d6d 100644
--- a/drivers/pci/pwrctrl/core.c
+++ b/drivers/pci/pwrctrl/core.c
@@ -101,6 +101,8 @@ EXPORT_SYMBOL_GPL(pci_pwrctrl_device_set_ready);
  */
 void pci_pwrctrl_device_unset_ready(struct pci_pwrctrl *pwrctrl)
 {
+	cancel_work_sync(&pwrctrl->work);
+
 	/*
 	 * We don't have to delete the link here. Typically, this function
 	 * is only called when the power control device is being detached. If
-- 
2.39.5



