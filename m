Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 833563F0A83;
	Wed, 20 May 2026 17:25:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779297905; cv=none; b=R8wpeNX7rBaY/aOMCSZK/ZJNddYY85Oy6wRlQy2RYTGGNJsTQFzCt3d00Ku2VlXJW0/x2sD8W/OI4Pef20S+a6Y+3vr23/58T/jOQ8K9sJZmwA9dDYtqWdUN4FMD4tkpOrTCcJ4BuJqulpvIs9TtvVW67Yc2Wi7WSKpoeW97noU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779297905; c=relaxed/simple;
	bh=Svs0dXjv6sIGc+FacP43mXlsFjr3maRoIgN3DSTAFHg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PSmqdQLnHhDu+nK9DQNRUSTrLBFPT4VEBDz4KaUMSvJmKVIF2lb3k+exRJTdREbKDbBhQLFVh2NCUQWvOElVIcW9brnP5AN6eR75M3IN2mrnXcBWrFB0ird1Ci01aSWwFtWw6lKejboE4IN5I/fegsuHj4Bpdk7iOPjDV/1YXQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fk2WcV+B; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fk2WcV+B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDE401F000E9;
	Wed, 20 May 2026 17:25:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779297904;
	bh=u+raDk7ittRg963TiknO/OEeBj0dJfrGcHM5eOXBzlY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fk2WcV+B6MfWmOC79vxQ3kn04RbZA5BXL7OoL1yxTSNSFNBITK5iR5ee8E5IEJ62w
	 bdn5o4pcE0iwmP8KQ+Y9SWyoy4hfwP6o+0ra0/Vx9T2+dyPEaWcSWnsybzNBs8hk0i
	 Z/YGqMjM52kJtRYDaXNhqNVbeVuE1dz9J0On/rOQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Zhu <hongxing.zhu@nxp.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 207/957] PCI: dwc: Invoke post_init in dw_pcie_resume_noirq()
Date: Wed, 20 May 2026 18:11:30 +0200
Message-ID: <20260520162139.032218311@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Richard Zhu <hongxing.zhu@nxp.com>

[ Upstream commit c577ce2881f9c76892de5ffc1a122e3ef427ecee ]

In some SoCs like i.MX95, CLKREQ# is pulled low by the controller driver
before link up. After link up, if the 'supports-clkreq' property is
specified in DT, the driver will release CLKREQ# so that it can go high and
the endpoint can pull it low whenever required i.e., during exit from L1
Substates.

Hence, at the end of dw_pcie_resume_noirq(), invoke the '.post_init()'
callback if exists to perform the above mentioned action.

Signed-off-by: Richard Zhu <hongxing.zhu@nxp.com>
[mani: reworded description]
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20251015030428.2980427-9-hongxing.zhu@nxp.com
Stable-dep-of: edb5ca3262e2 ("PCI: dwc: Perform cleanup in the error path of dw_pcie_resume_noirq()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/dwc/pcie-designware-host.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/pci/controller/dwc/pcie-designware-host.c b/drivers/pci/controller/dwc/pcie-designware-host.c
index 894bf23529df5..3fbece96faaad 100644
--- a/drivers/pci/controller/dwc/pcie-designware-host.c
+++ b/drivers/pci/controller/dwc/pcie-designware-host.c
@@ -1236,6 +1236,9 @@ int dw_pcie_resume_noirq(struct dw_pcie *pci)
 	if (ret)
 		return ret;
 
+	if (pci->pp.ops->post_init)
+		pci->pp.ops->post_init(&pci->pp);
+
 	return ret;
 }
 EXPORT_SYMBOL_GPL(dw_pcie_resume_noirq);
-- 
2.53.0



