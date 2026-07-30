Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FC3C44CAC9;
	Thu, 30 Jul 2026 15:29:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785425401; cv=none; b=PRvX9t7GJl0v/6o2O+hcMioHKyiAyCE6KEpAEDAkX2E9mxatOD56aULVjW4VQLj3vLBzgGAID2Z8sE5AdMTEDHSj06qvyXThEpe83Q6XSjZz3ONJS2btVWYu6qkXKoeI/9eLhBTot6K6Js9XcUVH5UBvSWwYUpULdEW1jcXfc3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785425401; c=relaxed/simple;
	bh=BZEUrsmxuTPP6op/xO/tXpDOmceVN0+0VKdBEiOVBsw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=loZrn3WKRP6aCKFuGa1J7HBQXQcujR0wcyZ/YXoaLXv7nwSWkNVKbfveAcixF4AZNatasJvQ5XV9Czqg7zWXFpuDTGIcr1BKSZZdfwixwIMO3YAX/UaZld5u0Dy8zr8ZaCcOupGPAl/wBazSwVhS/uroZUa3NUwUL6hEtaLfOGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vYd26qJr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vYd26qJr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 521A01F00A3A;
	Thu, 30 Jul 2026 15:29:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785425397;
	bh=ZbV744XWXFCdaAws22SZFz9rN7LEYT6R7RUnGLHX9LU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vYd26qJrrUBELwN0/vhtJ0zbq99uQiVBXDHpFLVO38TBJBszBt0wfpI90ziIfiIZR
	 jXiKh+o7fjKri0osS+P7VtlObdRIBDjsySAK3ovhqVwu7gS/Oqmb9g4+38PddV10Cg
	 88vJc48ToODi5E8FL3cl+hvEujD5ieFpiWweJ6Jw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 056/602] wifi: ipw2100: fix potential memory leak in ipw2100_pci_init_one()
Date: Thu, 30 Jul 2026 16:07:28 +0200
Message-ID: <20260730141437.180502273@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index fe75941c584d15..95778dfdfa6d81 100644
--- a/drivers/net/wireless/intel/ipw2x00/ipw2100.c
+++ b/drivers/net/wireless/intel/ipw2x00/ipw2100.c
@@ -6167,6 +6167,8 @@ static int ipw2100_pci_init_one(struct pci_dev *pci_dev,
 	if (err) {
 		printk(KERN_WARNING DRV_NAME
 		       "Error calling pci_enable_device.\n");
+		free_libipw(dev, 0);
+		pci_iounmap(pci_dev, ioaddr);
 		return err;
 	}
 
@@ -6179,16 +6181,14 @@ static int ipw2100_pci_init_one(struct pci_dev *pci_dev,
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



