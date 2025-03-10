Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D363233156;
	Mon, 10 Mar 2025 17:57:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741629435; cv=none; b=Jaw6CMtqIP0Dn8ZrUeMns9awAs9bGry0Q6rXnpIykMWzRRn3jnRVJ2KhynfTvo4lKIrFbkfkNJTP/K2iC5mw9B5B+GrG/Y+yhKVtY+a9ZDewf60Jsuv6ll/Z5JKDMu4P8NkDHEJd3CTnKTk4TKqD2DSfH7SitEiEIygLZ1QAsRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741629435; c=relaxed/simple;
	bh=pRWuoXyjfCgd8a63Okqk+XW3Fj++3ZYHf8v6hgER2Jk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ESCrOyEhe5S+tKWwXGFB2PdgVmjCCU5X8mufDTYL5dRFlc//fu9nvoPgRvvC3heLc6zH95hBgVV8gjBTAwLduKSIfAmwA4AdLLQlti2iPSZhHJ0x8ltmjWQxL/oxBpVYAIQr35NSu69ffqynrH5L6BpqlwvUrI0cLB+bjObaFYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iw/Lc8UW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iw/Lc8UW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A680CC4CEE5;
	Mon, 10 Mar 2025 17:57:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741629435;
	bh=pRWuoXyjfCgd8a63Okqk+XW3Fj++3ZYHf8v6hgER2Jk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iw/Lc8UWhSjwDUtvKuZL2UNbEwvqkC66YND84uFVA7udllo0nCFORQD2vWRrY/hna
	 +SGv8VlNB6hxdnOqFVsaVALF/sih0M0kOd0WNuk9FYUZKysyKgMNc02N18ezh3IJdq
	 WXtN5UyyrYmrXrHqWX/okb32rQZZO3uJHUtHzmAU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijun Hu <quic_zijuhu@quicinc.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Frank Li <Frank.Li@nxp.com>
Subject: [PATCH 5.15 294/620] PCI: endpoint: Finish virtual EP removal in pci_epf_remove_vepf()
Date: Mon, 10 Mar 2025 18:02:20 +0100
Message-ID: <20250310170557.223532094@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -234,6 +234,7 @@ void pci_epf_remove_vepf(struct pci_epf
 
 	mutex_lock(&epf_pf->lock);
 	clear_bit(epf_vf->vfunc_no, &epf_pf->vfunction_num_map);
+	epf_vf->epf_pf = NULL;
 	list_del(&epf_vf->list);
 	mutex_unlock(&epf_pf->lock);
 }


