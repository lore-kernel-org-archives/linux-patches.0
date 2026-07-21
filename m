Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 696C343E079;
	Tue, 21 Jul 2026 22:58:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784674684; cv=none; b=kOq7qA1BPQSpKQkwpr0X6xhw/Uys3MBWOziWZT+lmtIZxvhU8E8q/Paj6BLf1s/M0E6vZeM0bM6R7HGGYs8zeecaBve5Jiv03s3FcxyQ9zNlN64fjrcks0D7uvFv8R/LIDCm3SF7rBoKvkOfjTpeQeH2XoZ6TUUDEteC5Re2CkI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784674684; c=relaxed/simple;
	bh=5eh3F4q6UL85xxOfE/ctQprNfCibZHMXaKsR2BmI//0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ICP5urhYDe91J5XbMhHa9MRXFlYBKaarM5dxd2L8PYs//V4gEszUGNYwq3HIEA+2yDFEvPUFJ1aWUkavnAPbkIPhTbQnMX2L2b4w/HEZaMU7IcNq8mV02bapO0o6hPGM7ZJHP2AblGxuogamcgkx+DQVchP5q51GU/9JpZpdIsg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zd0eFcaO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zd0eFcaO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C52C71F00A3D;
	Tue, 21 Jul 2026 22:58:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784674682;
	bh=s4w5RI4HEWCJHvaqzA8B7bxuCFXFpMHPb6GE5N0pETM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Zd0eFcaOBt4E0g+4PmZlmfmsv2K9ZvPG0ZvBr1FsonPPDj8ImSchGWPrEKB50wlKM
	 ZQtsWuMU97p9aGSlwazVzLODpNMN0tVzYBR9c9TGiwcuXuilbed5tfgbjuZG9LzjNC
	 M7u+ZCbTDLW4PsnVuzuGfwb91E41BDxjSMJ+uHAU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: [PATCH 5.10 631/699] PCI: Free saved list without holding pci_bus_sem
Date: Tue, 21 Jul 2026 17:26:30 +0200
Message-ID: <20260721152409.980320156@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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


