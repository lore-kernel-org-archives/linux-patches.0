Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 778461C173D;
	Wed, 19 Feb 2025 09:25:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739957138; cv=none; b=YMh3UpQgYicibHfMYl8BhE/GoG9quHJXlGkIu+SjCw/VvtfO9Lsh0O5p2+lz8wApeGljJPWoea+gqfEylSZUDHCQQaDo4u3OEVp8BLOx2SxLet0PJBGAfv6oXtA8+Lki6FY7v237FIc1ATnQ/4Uwzkbw4kQx4xwXfPlCkM4M6jo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739957138; c=relaxed/simple;
	bh=oXmMRJi99mRrVvUJbO9Bm8p5tqp+V45Sx27m8aMENVs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c3A9n3QOH7G23sGs2RRtOlxW+YgC4R8tvqA14TtPjZQgW4Yzx4g5pm6iC3t7KLQAy7iHQuO+uH77r6P5aub0GBPIzYcW9Odw051VJ7oBiCoggG/Gj/NDivlZozFlsMDubK6XwbnTPRZTNpC5pk0U71Dwt+5rgOWUEG0oOi2CgdA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ebkEHPjD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ebkEHPjD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D115C4CED1;
	Wed, 19 Feb 2025 09:25:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739957137;
	bh=oXmMRJi99mRrVvUJbO9Bm8p5tqp+V45Sx27m8aMENVs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ebkEHPjDx1gEQgmqNSrNAKFmnpEeEgztRdWpRcoXfTjKekCIsxznSoIao3zHqAJ8G
	 /3orS/KBYIYNzr3rTcisrfwx8kInkyNpwEsJsif70Uf2qWYCNOabUbdK3oWHGqB7HF
	 4plvuegLYo24d8ebf/mbuRFy9R3485AwW/YQ/7wg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijun Hu <quic_zijuhu@quicinc.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Frank Li <Frank.Li@nxp.com>
Subject: [PATCH 6.1 390/578] PCI: endpoint: Finish virtual EP removal in pci_epf_remove_vepf()
Date: Wed, 19 Feb 2025 09:26:34 +0100
Message-ID: <20250219082708.368299427@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


