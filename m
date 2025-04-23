Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B30B628CF61;
	Wed, 23 Apr 2025 15:05:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745420741; cv=none; b=H9RJS6ztHS6zBqgLpy/SSB9nSSA8q78TUwvHAHICv1vNIrxsISIzvEN6jL/gvVS/wQnjeaFyl3b/4F87rIKGqYgO9H8J130Pb1VjGU3EU5cvmCV4HktO3Y7lIX7tAngK4mMMft5uXqMxbOacbQVleVJsCBNGkO4E90GjQxq4imE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745420741; c=relaxed/simple;
	bh=hMunZ6zfNFcGD0eeQ6W8Fyse0jo6T1bZNbVJ3E274KQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ufv6j0Ptbp6gLOljYnOjLgShDWuS6pe5oIF63mZhT9AWe3Q327c9K9qlD65W2BQrhMe9c8iAgO1jhZaDNtyjHpASulOqxqE9wiF0GjGDTz43do5MV4JWc6lFAn6AaiYuG73eAG+AscKfaKL5ykyDd8g2HrSsqu+RBa9VM7qyfFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mm+JBH2t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mm+JBH2t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4DB3C4CEE2;
	Wed, 23 Apr 2025 15:05:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745420740;
	bh=hMunZ6zfNFcGD0eeQ6W8Fyse0jo6T1bZNbVJ3E274KQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mm+JBH2tGUe2TSNWeoL/smj7JAjgIe8HJVZLOVfAdf3ljNy/05g2JAxh+4+vjZuSU
	 ga2ADpvY/PFn8YIotNhmEaxbxOphsOSMoyYoDu0splpxrwWYvEpPftUn/JqpFVZsVe
	 ge7C4H2gFE2EvNYQia2jX/Ow9BqZBZpWfvvoVJCk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryo Takakura <ryotkkr98@gmail.com>,
	"Luis Claudio R. Goncalves" <lgoncalv@redhat.com>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 108/393] PCI: vmd: Make vmd_dev::cfg_lock a raw_spinlock_t type
Date: Wed, 23 Apr 2025 16:40:04 +0200
Message-ID: <20250423142647.742978377@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142643.246005366@linuxfoundation.org>
References: <20250423142643.246005366@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ryo Takakura <ryotkkr98@gmail.com>

[ Upstream commit 18056a48669a040bef491e63b25896561ee14d90 ]

The access to the PCI config space via pci_ops::read and pci_ops::write is
a low-level hardware access. The functions can be accessed with disabled
interrupts even on PREEMPT_RT. The pci_lock is a raw_spinlock_t for this
purpose.

A spinlock_t becomes a sleeping lock on PREEMPT_RT, so it cannot be
acquired with disabled interrupts. The vmd_dev::cfg_lock is accessed in
the same context as the pci_lock.

Make vmd_dev::cfg_lock a raw_spinlock_t type so it can be used with
interrupts disabled.

This was reported as:

  BUG: sleeping function called from invalid context at kernel/locking/spinlock_rt.c:48
  Call Trace:
   rt_spin_lock+0x4e/0x130
   vmd_pci_read+0x8d/0x100 [vmd]
   pci_user_read_config_byte+0x6f/0xe0
   pci_read_config+0xfe/0x290
   sysfs_kf_bin_read+0x68/0x90

Signed-off-by: Ryo Takakura <ryotkkr98@gmail.com>
Tested-by: Luis Claudio R. Goncalves <lgoncalv@redhat.com>
Acked-by: Luis Claudio R. Goncalves <lgoncalv@redhat.com>
[bigeasy: reword commit message]
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Tested-off-by: Luis Claudio R. Goncalves <lgoncalv@redhat.com>
Link: https://lore.kernel.org/r/20250218080830.ufw3IgyX@linutronix.de
[kwilczynski: commit log]
Signed-off-by: Krzysztof Wilczyński <kwilczynski@kernel.org>
[bhelgaas: add back report info from
https://lore.kernel.org/lkml/20241218115951.83062-1-ryotkkr98@gmail.com/]
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/vmd.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/pci/controller/vmd.c b/drivers/pci/controller/vmd.c
index 5ff2066aa5164..dfa222e02c4da 100644
--- a/drivers/pci/controller/vmd.c
+++ b/drivers/pci/controller/vmd.c
@@ -125,7 +125,7 @@ struct vmd_irq_list {
 struct vmd_dev {
 	struct pci_dev		*dev;
 
-	spinlock_t		cfg_lock;
+	raw_spinlock_t		cfg_lock;
 	void __iomem		*cfgbar;
 
 	int msix_count;
@@ -402,7 +402,7 @@ static int vmd_pci_read(struct pci_bus *bus, unsigned int devfn, int reg,
 	if (!addr)
 		return -EFAULT;
 
-	spin_lock_irqsave(&vmd->cfg_lock, flags);
+	raw_spin_lock_irqsave(&vmd->cfg_lock, flags);
 	switch (len) {
 	case 1:
 		*value = readb(addr);
@@ -417,7 +417,7 @@ static int vmd_pci_read(struct pci_bus *bus, unsigned int devfn, int reg,
 		ret = -EINVAL;
 		break;
 	}
-	spin_unlock_irqrestore(&vmd->cfg_lock, flags);
+	raw_spin_unlock_irqrestore(&vmd->cfg_lock, flags);
 	return ret;
 }
 
@@ -437,7 +437,7 @@ static int vmd_pci_write(struct pci_bus *bus, unsigned int devfn, int reg,
 	if (!addr)
 		return -EFAULT;
 
-	spin_lock_irqsave(&vmd->cfg_lock, flags);
+	raw_spin_lock_irqsave(&vmd->cfg_lock, flags);
 	switch (len) {
 	case 1:
 		writeb(value, addr);
@@ -455,7 +455,7 @@ static int vmd_pci_write(struct pci_bus *bus, unsigned int devfn, int reg,
 		ret = -EINVAL;
 		break;
 	}
-	spin_unlock_irqrestore(&vmd->cfg_lock, flags);
+	raw_spin_unlock_irqrestore(&vmd->cfg_lock, flags);
 	return ret;
 }
 
@@ -1020,7 +1020,7 @@ static int vmd_probe(struct pci_dev *dev, const struct pci_device_id *id)
 	if (features & VMD_FEAT_OFFSET_FIRST_VECTOR)
 		vmd->first_vec = 1;
 
-	spin_lock_init(&vmd->cfg_lock);
+	raw_spin_lock_init(&vmd->cfg_lock);
 	pci_set_drvdata(dev, vmd);
 	err = vmd_enable_domain(vmd, features);
 	if (err)
-- 
2.39.5



