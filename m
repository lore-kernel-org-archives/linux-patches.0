Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46C314189DA;
	Tue, 21 Jul 2026 21:49:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784670546; cv=none; b=nbYUDVPrDDidkztDhuP3Pljjo5Y7fqBGSAJ4IyA21osT2D5ZvrR+GBgDjDP5YLtAtvYJiF4UULjIG1uMloNlvmQSAKvfI+N3+kkCkHinhWGa/FxDXl8nmIX0gf6HzktZ1ZdyrhZB1uodseeiAKcnVPgs/9OiDDqemtOy0gUHZKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784670546; c=relaxed/simple;
	bh=LpeTUWAqMTag4/3SNiEk8nUy11JjDMJjCo6z8N+ySZo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TRMNn7dp4vbnXrjfZqBajrVSubp9v2br3cDnE1inUgwLD6mpLeuY+77N65VpJ5K9pghFq5lDAnDFEwA8ef+E/KkmyxCYoYNZk0FCmdfWalZT2M86q+ifct3wj2IVwOug+j0zJxSq0FDRQwmvDmC/Q3ICaGxztaNuZ8fXkpaM/do=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZA2Uvt5l; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZA2Uvt5l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 921801F000E9;
	Tue, 21 Jul 2026 21:49:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784670545;
	bh=NxGl2fPcMCS9nFU4zNN0INaS50zpP5kLHl+twy1p+Wo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZA2Uvt5lLov1U3Dm2cOi44X12jiQkXsh18GVwxZ2ZU16fjEUMFo5BpyScupXICDBg
	 OdHLaWxvvsIeqCFqZLdTJ6lHhqcAJrzi9Og/rm9xVtL2vLvO0JwYQRRcvFAPH6OCF3
	 yIanVNoWJqGx502hbP8cqn52y0ksh8TygAfNMjqg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: [PATCH 6.1 0971/1067] PCI: Free saved list without holding pci_bus_sem
Date: Tue, 21 Jul 2026 17:26:12 +0200
Message-ID: <20260721152446.263296545@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>

[ Upstream commit 1d8a0506f69895b7cfd9d5c4546761c508231a8a ]

Freeing the saved list does not require holding pci_bus_sem, so the
critical section can be made shorter.

Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Tested-by: Alex Bennée <alex.bennee@linaro.org> # AVA, AMD GPU
Link: https://patch.msgid.link/20251113162628.5946-6-ilpo.jarvinen@linux.intel.com
Stable-dep-of: ee7471fe968d ("PCI: Skip Resizable BAR restore on read error")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/setup-bus.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/pci/setup-bus.c
+++ b/drivers/pci/setup-bus.c
@@ -2326,8 +2326,8 @@ cleanup:
 		pci_claim_resource(bridge, i);
 		pci_setup_bridge(bridge->subordinate);
 	}
-	free_list(&saved);
 	up_read(&pci_bus_sem);
+	free_list(&saved);
 
 	return ret;
 }


