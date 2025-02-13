Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC8B015A856;
	Thu, 13 Feb 2025 15:30:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739460602; cv=none; b=E6xkq6ig2mSHL0QQH5LPj5X8HLC9tRdvVS3Xc8iOExYA/tF3MuCbOeyiwoFkLsXAaJeB3z0rxPVNgH7QC/Ept3DvWL7d4Taw+u5mIO1A7nrNe6hRZr8u8Pjn+j07boXSa78uJaYNGujexBsoIefH4Q+K9TdCkURtVRyNLBKe0SU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739460602; c=relaxed/simple;
	bh=vQ1iV9FVKAPO8xe/T/fDvNpNGNwyvpsiRFcanTJ8lGY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GasF1pCwXUmxYd3vEyFWGAo6aidnAY6G+nLEqsFbKLuMUlE9moaD/jK88lMbX7pZDQXkl41Amn9bbcbP7wvZosBE38z/J/3L9xG6tHKJrJPbfvjr+zFIzwogPxRSnO8651dVMPMyQTrEoSwBDChdvJz9G66w18qPpAiPjjaF6YY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S0Byv38F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S0Byv38F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D2AFC4CED1;
	Thu, 13 Feb 2025 15:30:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739460602;
	bh=vQ1iV9FVKAPO8xe/T/fDvNpNGNwyvpsiRFcanTJ8lGY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S0Byv38FPgaDj2NyNmzXqG7bNeSBLtgfyJ/LJyhYgpQWjdtt3uFwfSb0MisWnpDDU
	 OlP7wb4E6OE78hxPyofKR45akEHOfnCIll2dUzSwBavlH7vPdErxZuGUkPFhHLKEun
	 cKkpaMZqMzXTmw6oerZjx0ka0oYSz7WN7JY/mzCo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijun Hu <quic_zijuhu@quicinc.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Frank Li <Frank.Li@nxp.com>
Subject: [PATCH 6.6 159/273] PCI: endpoint: Finish virtual EP removal in pci_epf_remove_vepf()
Date: Thu, 13 Feb 2025 15:28:51 +0100
Message-ID: <20250213142413.619740420@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142407.354217048@linuxfoundation.org>
References: <20250213142407.354217048@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


