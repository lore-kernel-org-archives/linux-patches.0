Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A09C21D6AA;
	Wed, 28 Jan 2026 15:56:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769615762; cv=none; b=axdeokV24DvZ/uoR40+nTGzgPvEuqHomdOvqHyDCjC8rNyQoKHlkczSFgL1JJ7BbH2dqJm+U577z3oDyZy+jAvO+aac77Q4JFmB5Z0g35JauAgsuOGYxHnRkVM66hzXamrAVNtVXvJqcJSusxer4KHza32Sd+oB5Ed2jXk3Dy9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769615762; c=relaxed/simple;
	bh=ilH5ktigD/fqM5H6RQuAD0zhPjo9H9ZHtzSh1cKzKho=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ioj7YW1ihqGbke5AtKEBpjprVuu8MOeleqBTNy4LlsihMTUJ9OgRGfu+xdoy1TWHhoMwVHeBNDsekeZ+G5i5LL0CBDJ9Ug9blRgu14VDN3fAprw0uPVCf8hQ/qdkEjO7HUweVdbN/j0QWw302bJWn30+8KQBx52W+h3SzhvLJqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0GIDuZh2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0GIDuZh2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDEABC116C6;
	Wed, 28 Jan 2026 15:56:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769615762;
	bh=ilH5ktigD/fqM5H6RQuAD0zhPjo9H9ZHtzSh1cKzKho=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0GIDuZh2Nzu1oDRm0yGrXWVndAV1ZMQDlm5y8BHYTTNgprn3M9CmKvSTy4zvKyYZI
	 oBf8oiPQZLheovsXxjwuaDehGsrFZe0j19ZCB6HBzzen+UHzEK3/T3ikGVKM3GaWVT
	 WOkU4xcOKBjSjq7UGNFT/tBlCKscZlHEx00Kg5vQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	lrizzo@google.com,
	namangulati@google.com,
	willemb@google.com,
	intel-wired-lan@lists.osuosl.org,
	milena.olech@intel.com,
	jacob.e.keller@intel.com,
	Shachar Raindel <shacharr@google.com>,
	Mina Almasry <almasrymina@google.com>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Samuel Salin <Samuel.salin@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 107/227] idpf: read lower clock bits inside the time sandwich
Date: Wed, 28 Jan 2026 16:22:32 +0100
Message-ID: <20260128145348.320547320@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.331957407@linuxfoundation.org>
References: <20260128145344.331957407@linuxfoundation.org>
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

From: Mina Almasry <almasrymina@google.com>

[ Upstream commit bdfc7b55adcd04834ccc1b6b13e55e3fd7eaa789 ]

PCIe reads need to be done inside the time sandwich because PCIe
writes may get buffered in the PCIe fabric and posted to the device
after the _postts completes. Doing the PCIe read inside the time
sandwich guarantees that the write gets flushed before the _postts
timestamp is taken.

Cc: lrizzo@google.com
Cc: namangulati@google.com
Cc: willemb@google.com
Cc: intel-wired-lan@lists.osuosl.org
Cc: milena.olech@intel.com
Cc: jacob.e.keller@intel.com

Fixes: 5cb8805d2366 ("idpf: negotiate PTP capabilities and get PTP clock")
Suggested-by: Shachar Raindel <shacharr@google.com>
Signed-off-by: Mina Almasry <almasrymina@google.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Tested-by: Samuel Salin <Samuel.salin@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/idpf/idpf_ptp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/idpf/idpf_ptp.c b/drivers/net/ethernet/intel/idpf/idpf_ptp.c
index 3e1052d070cfd..0a8b50350b860 100644
--- a/drivers/net/ethernet/intel/idpf/idpf_ptp.c
+++ b/drivers/net/ethernet/intel/idpf/idpf_ptp.c
@@ -108,11 +108,11 @@ static u64 idpf_ptp_read_src_clk_reg_direct(struct idpf_adapter *adapter,
 	ptp_read_system_prets(sts);
 
 	idpf_ptp_enable_shtime(adapter);
+	lo = readl(ptp->dev_clk_regs.dev_clk_ns_l);
 
 	/* Read the system timestamp post PHC read */
 	ptp_read_system_postts(sts);
 
-	lo = readl(ptp->dev_clk_regs.dev_clk_ns_l);
 	hi = readl(ptp->dev_clk_regs.dev_clk_ns_h);
 
 	spin_unlock(&ptp->read_dev_clk_lock);
-- 
2.51.0



