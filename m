Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E1E83F1AD5;
	Mon, 17 Aug 2026 14:24:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786976674; cv=none; b=i/m2PXdizwFV0GmX7AiTjBoXyQ0/EYLmMeac7WWL68aMx0GMw1EsRE78mv4OOc482DkdZgdpuuwUWiNkt1OSTgTH9S3x0gGvcHOURA2FlO9ERm54LZOL2Mv9I5HVgMrIdcHecZemDSWwIMlmo8dkCcIZf441G1fzRAbaEpJPVrM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786976674; c=relaxed/simple;
	bh=MkNr9O9GxcdhCnB4ruyKFzPwArYQ18ATDEWLz+WofNo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hw/534217dKhrwuNT62B9q2V4Dz5UxqEqAof2f2CjtgyuyUODlV0C2vV+7AK0meZfVeg4e4eaoL6Hy8yYzGxLLwSR/VSsvKwPtJ79Du2HQWdvrGt2D8oF0PW5fAmPATn2c6Z7oOWL3Bu+drB9yDrY9IrFjj/ErXjJYQRlk5XBxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xRoOLX0a; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xRoOLX0a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F7751F000E9;
	Mon, 17 Aug 2026 14:24:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786976668;
	bh=trHSyAdBih5YE3aPSMhUTNJ9HgKFJYETXcyC5hbOSw4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xRoOLX0abRPkVVv0yr0v8SCAwgP+PLrqTEh3Qq8sxrLvRgKdLeEddocTSOg97wwzS
	 Lbd56nUoDpPEEA7LRnhtaAP0ULzDva0n/H9391rUtGMOHeJldeTRKbflbhPLZlqW/2
	 xYGT1+ZsNBtnQZtRPL/1xljSVhNKkF3qfOm5tO0s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 024/456] wifi: ipw2100: fix potential memory leak in ipw2100_pci_init_one()
Date: Mon, 17 Aug 2026 15:26:54 +0200
Message-ID: <20260817132540.927006812@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
References: <20260817132539.792407575@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abdun Nihaal <nihaal@cse.iitm.ac.in>

[ Upstream commit 0d388f62031dbabcba0f44bb91b59f10e88cac17 ]

The memory allocated in the ipw2100_alloc_device() function is not freed
in some of the error paths in ipw2100_pci_init_one(). Fix that by
converting the direct return into a goto to the error path return.

The error path when pci_enable_device() fails cannot jump to fail, since
at this point priv is not set, so perform error handling inline.

Fixes: 2c86c275015c ("Add ipw2100 wireless driver.")
Signed-off-by: Abdun Nihaal <nihaal@cse.iitm.ac.in>
Link: https://patch.msgid.link/20260620065242.93798-1-nihaal@cse.iitm.ac.in
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/ipw2x00/ipw2100.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/intel/ipw2x00/ipw2100.c b/drivers/net/wireless/intel/ipw2x00/ipw2100.c
index 47eb89b773cf7f..c954e6001eab17 100644
--- a/drivers/net/wireless/intel/ipw2x00/ipw2100.c
+++ b/drivers/net/wireless/intel/ipw2x00/ipw2100.c
@@ -6183,6 +6183,8 @@ static int ipw2100_pci_init_one(struct pci_dev *pci_dev,
 	if (err) {
 		printk(KERN_WARNING DRV_NAME
 		       "Error calling pci_enable_device.\n");
+		free_libipw(dev, 0);
+		pci_iounmap(pci_dev, ioaddr);
 		return err;
 	}
 
@@ -6195,16 +6197,14 @@ static int ipw2100_pci_init_one(struct pci_dev *pci_dev,
 	if (err) {
 		printk(KERN_WARNING DRV_NAME
 		       "Error calling pci_set_dma_mask.\n");
-		pci_disable_device(pci_dev);
-		return err;
+		goto fail;
 	}
 
 	err = pci_request_regions(pci_dev, DRV_NAME);
 	if (err) {
 		printk(KERN_WARNING DRV_NAME
 		       "Error calling pci_request_regions.\n");
-		pci_disable_device(pci_dev);
-		return err;
+		goto fail;
 	}
 
 	/* We disable the RETRY_TIMEOUT register (0x41) to keep
-- 
2.53.0



