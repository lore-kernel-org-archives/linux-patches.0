Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28FBE26B09E;
	Thu, 13 Feb 2025 15:12:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739459528; cv=none; b=Lo+6VGRkH5nDvJkE/M3NshQiCA3lzuEvfuzUugoDmZL94ds8b34dXabtdyymoFLijupZq/rNP6H5JCJr3CVxxGpc3j2olJ6j1J7RzAeoG4KaUELtq7BuyOoh6jg2kTn5fdlZs68ZIvGSHzi+emVh7LDCE/ZAEa7xKhY4e0acI5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739459528; c=relaxed/simple;
	bh=voZPzpVgyv0NspStBAwUYW6ET7UbFHFEcwww57M3CGw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gPvwYK1R9jI9FqNZRJRRpHFHapSxtr8SizCUR7/UlXuFelFpd8eBdTSH1B4JLxYRifCk7abwI1n9SKUT/CK9mjvpI9Ykvx25xFsMrAV2XMajkAxbFusI4Yme4xyAMke1wGOHOR24CRqYEgi/vMV+Y3Z5hN/8V5cGW5jqK4Plxuw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jlqgmV2M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jlqgmV2M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B0B2C4CED1;
	Thu, 13 Feb 2025 15:12:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739459528;
	bh=voZPzpVgyv0NspStBAwUYW6ET7UbFHFEcwww57M3CGw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jlqgmV2MCuh6lI1k30ZdeaIg53eD8CqWR3JynwdJjD1dP/t45YFjwCwS/7c19Q6G0
	 PLmOyntQ2NekruTQ3rE8aLX/+k+v+f+38g7rHz6GjWrFrXRVO5TBNna7CCcQ89Eje2
	 S9LU9ZMgp1vXJuLXcF4P3obMmtXo6GVnOge0Wbqw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijun Hu <quic_zijuhu@quicinc.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Frank Li <Frank.Li@nxp.com>
Subject: [PATCH 6.13 274/443] PCI: endpoint: Finish virtual EP removal in pci_epf_remove_vepf()
Date: Thu, 13 Feb 2025 15:27:19 +0100
Message-ID: <20250213142451.183042635@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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


