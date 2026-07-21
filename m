Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B57C436212F;
	Tue, 21 Jul 2026 22:26:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784672818; cv=none; b=iN7FlodbOjSmx3I5vRKM4OETZmmoSpDcsNYIxppxAVzrIiR4PINyisX+/BL6dc2yzF9wCUAawXbe041+jeobiCSLpCnNncdcZQ8xXx+Rrc9FbOLahSeflISWw8cwEAg8/RBs3Fu/8bBe0p3bM9i12DPogtcbh6Fi0H0xs683O9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784672818; c=relaxed/simple;
	bh=C7R00HWiu5Zamc/8ybTEElFmO1zTQDfI0eqoNoeh5to=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OzunCCpQ7ueLVXc5UcMgaq1SWiA2xQc/COuha3muxXe4rf4KRJBbZdPpyGboon+PqQaDXqznEKtUvnP8Hree6j35GN0cwFEuTKnjjVY/29lIsBmHxnjpMt5S2uZR81MStOGVxmZo3lQzAyos/Mjhvs7wbP4BGniCMeSokq3BxDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dSXHPnof; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dSXHPnof"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C8B01F000E9;
	Tue, 21 Jul 2026 22:26:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784672817;
	bh=Bq55YKAcWp+19Mk/Ufp3+7eUT5DGmCUZa0xYIgi9O+c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dSXHPnofPwhdQeVg54UYgi42/smCGCaCHBTwcQAVFc2+24vxyDb0Jse/XJ00xOjSc
	 1RxmIcYAMcWkDLzCBQ49MEq9HIWCJzeU9ghDmu/jYzwZds7q2aeAMTV64Xj9pf7z2J
	 ZpUAcJfMV5Cghqvt+8tFOLW9P0c0m9uDy54uP3n4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: [PATCH 5.15 766/843] PCI: Free saved list without holding pci_bus_sem
Date: Tue, 21 Jul 2026 17:26:41 +0200
Message-ID: <20260721152423.285334528@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2269,8 +2269,8 @@ cleanup:
 		pci_claim_resource(bridge, i);
 		pci_setup_bridge(bridge->subordinate);
 	}
-	free_list(&saved);
 	up_read(&pci_bus_sem);
+	free_list(&saved);
 
 	return ret;
 }


