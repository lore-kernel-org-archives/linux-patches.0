Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE89C46E012;
	Tue, 21 Jul 2026 18:46:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659585; cv=none; b=hGrMImHVhs3zmDovBrm/x3wY8Tj/jMAkcCUmc9uWjW/PRers2MjnMjwWSYJ38hgu4M3O9nUdmMo/VC9BtIfFx6FKTcofMWaSL1FKV4vVfdaYwQ7vqS1U3lHDnBARcpknDjOT7Rgu+c5oZgeyR0dLY4i/eH9eh4zB6YmdNZczeqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659585; c=relaxed/simple;
	bh=dIHbDf1ylKd2x25PVQaQ/iVzIvuKyfaoFCO2m5Z1KoA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=s0IN185/X6SRS13q4pSKK+n9qnR4K4tVwN7vTjaWEE0UdWRQ6D+HGLq1pGepNsWIGiO8Pli9QuXGKB/YgjpiFbq+6aSMJi3/fpMJc2FS/rqBS0hGPgYNiBiKOZ7JTa9nbctBdqIuGObzuz7KTvcMzY9zIC58L+pld9vDwsDGZZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ablO3eiQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ablO3eiQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A47C1F000E9;
	Tue, 21 Jul 2026 18:46:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659584;
	bh=vN8gwgZ1jxsHeglddWf+/PU9ILUh4JssthFrNcufVss=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ablO3eiQgveSvPsLZEWDdCNm+fD5tlJNH1QLX9DOcOOtDVdmC6WxzZdyhAcmq6+wI
	 B0sXKIY6KDhzCm/VddjMMGTRzGSQeAcT0kIAJNqL0ElnhYUm04J+Rgnyu4de9p/lG3
	 mNc1zLwTFrMJlzA9DnMFL5ysjA2Iqp8nSqDfyCRA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: [PATCH 6.18 1533/1611] PCI: Try BAR resize even when no window was released
Date: Tue, 21 Jul 2026 17:27:29 +0200
Message-ID: <20260721152549.928338663@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>

[ Upstream commit 121d3e9e4b217f2f23715901fb15c6a3ca2bab46 ]

Usually, resizing BARs requires releasing bridge windows in order to
resize it to fit a larger BAR into the window. This is not always the
case, however, FW could have made the window large enough to accommodate
larger BAR as is, or the user might prefer to shrink a BAR to make more
space for another Resizable BAR.

Thus, replace the check that requires that at least one bridge window
was released with a check that simply ensures bridge is not NULL.

Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Tested-by: Alex Bennée <alex.bennee@linaro.org> # AVA, AMD GPU
Link: https://patch.msgid.link/20251113162628.5946-5-ilpo.jarvinen@linux.intel.com
Stable-dep-of: ee7471fe968d ("PCI: Skip Resizable BAR restore on read error")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/setup-bus.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/drivers/pci/setup-bus.c
+++ b/drivers/pci/setup-bus.c
@@ -2376,7 +2376,7 @@ int pbus_reassign_bridge_resources(struc
 {
 	unsigned long type = res->flags;
 	struct pci_dev_resource *dev_res;
-	struct pci_dev *bridge;
+	struct pci_dev *bridge = NULL;
 	LIST_HEAD(saved);
 	LIST_HEAD(added);
 	LIST_HEAD(failed);
@@ -2411,10 +2411,8 @@ int pbus_reassign_bridge_resources(struc
 		bus = bus->parent;
 	}
 
-	if (list_empty(&saved)) {
-		up_read(&pci_bus_sem);
+	if (!bridge)
 		return -ENOENT;
-	}
 
 	__pci_bus_size_bridges(bridge->subordinate, &added);
 	__pci_bridge_assign_resources(bridge, &added, &failed);


