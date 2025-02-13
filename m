Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BAE814831C;
	Thu, 13 Feb 2025 14:45:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739457910; cv=none; b=qQBZLoudSDue5DclQ8gvio2pq9QNxHOdIu8AXbtL//NLmFdlaiQwYMLGSJH4YxS5nUsKXpgRiL2bv9OXHAZs5ihOBIBDtSJ3d/4oSVj4APKcAc3PCrIalYneUbdRuPhgl0WMoKyo5opvO5eYm/u5K+4QZpXo2bHxp/QSCmu42v8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739457910; c=relaxed/simple;
	bh=5f+iTeDdR23wzDed7iUgPEeXitWXQwtui+R0yO4q/iM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MD14m7OdJem0hMlwqTpl4f8BfakIgstQCnI4SCLFNnae49944fJEZpZ2ZMV4qVZIYiNYN2pZtLMW28DtdyslMCJLOIyqXDj4l4C3tthqVItu2fVpPdr6AgR+yCq5EMAMC1kZBPresZsxtdFYankUx2L3fz0xUqTTY+uIZqi6AVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0RiMC191; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0RiMC191"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7B75C4CEE9;
	Thu, 13 Feb 2025 14:45:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739457910;
	bh=5f+iTeDdR23wzDed7iUgPEeXitWXQwtui+R0yO4q/iM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0RiMC191PBF2GyFXhgqvSL3tTo3S2Sd3WFnGcDRTjqPf52kgH4sWJXIN2jtFY6nuB
	 Vr1/DZLFg7wYe0cGNhIV16qTXeTbV/Gy5cJfsjQ2afhltAOGas9Re3EQXZ7Ts0r/7F
	 U5Lp9YdT5DgOzGRe+0V2Y5roQJoZo3clsCZ+z+ow=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijun Hu <quic_zijuhu@quicinc.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Frank Li <Frank.Li@nxp.com>
Subject: [PATCH 6.12 248/422] PCI: endpoint: Finish virtual EP removal in pci_epf_remove_vepf()
Date: Thu, 13 Feb 2025 15:26:37 +0100
Message-ID: <20250213142446.109694514@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142436.408121546@linuxfoundation.org>
References: <20250213142436.408121546@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zijun Hu <quic_zijuhu@quicinc.com>

commit 3b9f942eb21c92041905e3943a8d5177c9a9d89d upstream.

When removing a virtual Endpoint, pci_epf_remove_vepf() failed to clear
epf_vf->epf_pf, which caused a subsequent pci_epf_add_vepf() to incorrectly
return -EBUSY:

  pci_epf_add_vepf(epf_pf, epf_vf)      // add
  pci_epf_remove_vepf(epf_pf, epf_vf)   // remove
  pci_epf_add_vepf(epf_pf, epf_vf)      // add again, -EBUSY error

Fix by clearing epf_vf->epf_pf in pci_epf_remove_vepf().

Link: https://lore.kernel.org/r/20241210-pci-epc-core_fix-v3-3-4d86dd573e4b@quicinc.com
Fixes: 1cf362e907f3 ("PCI: endpoint: Add support to add virtual function in endpoint core")
Signed-off-by: Zijun Hu <quic_zijuhu@quicinc.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/endpoint/pci-epf-core.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/pci/endpoint/pci-epf-core.c
+++ b/drivers/pci/endpoint/pci-epf-core.c
@@ -202,6 +202,7 @@ void pci_epf_remove_vepf(struct pci_epf
 
 	mutex_lock(&epf_pf->lock);
 	clear_bit(epf_vf->vfunc_no, &epf_pf->vfunction_num_map);
+	epf_vf->epf_pf = NULL;
 	list_del(&epf_vf->list);
 	mutex_unlock(&epf_pf->lock);
 }


