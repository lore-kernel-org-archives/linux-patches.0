Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A77A223DE5;
	Mon, 23 Jun 2025 21:45:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750715154; cv=none; b=jfeFd23jli2d8sAkg1eOwJ1Je3quZji60hCTh9yyxFRpu7wpUG5xDjtIz1fjXKL6x9B1H/A7vNLcwwtlIgDVFBvonY0FHYuCAQSts7lb7FHW7wyY/8X5oLJihltt1SrhuVwTmkf8lNfVvywuaVSTWOMnWojR5CagXnVXQB7jHDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750715154; c=relaxed/simple;
	bh=09h7R+QR+GYPkzdVqXP0NrGILx5mldhz2zo7eIGAAMs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EzSspE2OuYyKS7IMjhLoFUd8ADSPZjrxqGCyKkE5GyADllZxQivUBngxheIDpNvh9SHNFJRwntb3eW8wYsF20ItVVkwQR3pwbJEomtN81NzMObqYN1pYxpgt+PGAMER5Z4LDc0Rkkw//CmJ3GrxB+EHHEOaqADPi9SRdlpvTkdA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=udtx+gbB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="udtx+gbB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10AE4C4CEEA;
	Mon, 23 Jun 2025 21:45:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750715154;
	bh=09h7R+QR+GYPkzdVqXP0NrGILx5mldhz2zo7eIGAAMs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=udtx+gbBryPVShJid2ZtGQXWlIRjZ2zAdsqLdwwmR0EA78gWKz4XGvr9RQBmh2nmG
	 BNUJhMR3dHoVtQ8O9qXkSco5sylguy8t2XPLaA6Syu9Q67yVIZbFsYWJd0rej4vi3t
	 JKIr/eJbanhMfhKn5JdWDF1ycg/fRKae2PC11oak=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Lukas Wunner <lukas@wunner.de>,
	Dave Jiang <dave.jiang@intel.com>
Subject: [PATCH 5.15 256/411] PCI: Fix lock symmetry in pci_slot_unlock()
Date: Mon, 23 Jun 2025 15:06:40 +0200
Message-ID: <20250623130640.089896399@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130632.993849527@linuxfoundation.org>
References: <20250623130632.993849527@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>

commit f3efb9569b4a21354ef2caf7ab0608a3e14cc6e4 upstream.

The commit a4e772898f8b ("PCI: Add missing bridge lock to pci_bus_lock()")
made the lock function to call depend on dev->subordinate but left
pci_slot_unlock() unmodified creating locking asymmetry compared with
pci_slot_lock().

Because of the asymmetric lock handling, the same bridge device is unlocked
twice. First pci_bus_unlock() unlocks bus->self and then pci_slot_unlock()
will unconditionally unlock the same bridge device.

Move pci_dev_unlock() inside an else branch to match the logic in
pci_slot_lock().

Fixes: a4e772898f8b ("PCI: Add missing bridge lock to pci_bus_lock()")
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Lukas Wunner <lukas@wunner.de>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20250505115412.37628-1-ilpo.jarvinen@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/pci.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -5593,7 +5593,8 @@ static void pci_slot_unlock(struct pci_s
 			continue;
 		if (dev->subordinate)
 			pci_bus_unlock(dev->subordinate);
-		pci_dev_unlock(dev);
+		else
+			pci_dev_unlock(dev);
 	}
 }
 


