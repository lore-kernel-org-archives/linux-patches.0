Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 487F324336D;
	Tue, 29 Apr 2025 16:48:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745945338; cv=none; b=D5x4AL7P5mS9N4p7w9caJtDaWzARwuUQpSgmOGWOvD4fGewXgvGFRBEzSfD3YURa6pdC8X8fo5DyfzHfv+vfnqAz9fbKL1u9VwWgzFu/pB6RXzkgskadmgWLEyHfMalIA3pEe5h/2lznxeXWqXuHGshT+sUMYbQCo29tuedLs8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745945338; c=relaxed/simple;
	bh=4CyNbHeMJ7/xvP+O6ASsBqpR4Mzudp2g1Cxs8Myz9KE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qVQMeUcArGIy3N5roLX0nlomzr0V5BYcZ+dv+NVQwWwg3TQ3pDuykZP9Ea1jf7JoM7Blew5DLKPWpl0O0i9uHokM9C59WTVPG0iwOS+K5Nk0hFd2519m8Np/MiLt3/cgUcXPH+4hlVNjik++gHCidNA8dq6nT+Kw7VJYbiR7r/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jJSu0Ajp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jJSu0Ajp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADB23C4CEE3;
	Tue, 29 Apr 2025 16:48:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745945338;
	bh=4CyNbHeMJ7/xvP+O6ASsBqpR4Mzudp2g1Cxs8Myz9KE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jJSu0AjpmmpZJg1edj54juToWusBtP0JBqOe656CjwXy3iBVc/FBPvjfTeR7rdQeD
	 +4qAWv+nISvZ2J1riky/5KYrLaJmh9hnJVQ88V7XejuIwCM46NIq8PA7h/5NX0wnm2
	 wZP8E3g8ndJoNNRRY9NqODX6v7KBcul/oNPWLYOk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make24@iscas.ac.cn>,
	Bjorn Helgaas <bhelgaas@google.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 5.4 078/179] PCI: Fix reference leak in pci_alloc_child_bus()
Date: Tue, 29 Apr 2025 18:40:19 +0200
Message-ID: <20250429161052.569480035@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161049.383278312@linuxfoundation.org>
References: <20250429161049.383278312@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ma Ke <make24@iscas.ac.cn>

commit 1f2768b6a3ee77a295106e3a5d68458064923ede upstream.

If device_register(&child->dev) fails, call put_device() to explicitly
release child->dev, per the comment at device_register().

Found by code review.

Link: https://lore.kernel.org/r/20250202062357.872971-1-make24@iscas.ac.cn
Fixes: 4f535093cf8f ("PCI: Put pci_dev in device tree as early as possible")
Signed-off-by: Ma Ke <make24@iscas.ac.cn>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/probe.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -1041,7 +1041,10 @@ static struct pci_bus *pci_alloc_child_b
 add_dev:
 	pci_set_bus_msi_domain(child);
 	ret = device_register(&child->dev);
-	WARN_ON(ret < 0);
+	if (WARN_ON(ret < 0)) {
+		put_device(&child->dev);
+		return NULL;
+	}
 
 	pcibios_add_bus(child);
 


