Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33B8A37DE9B;
	Thu, 20 Aug 2026 17:44:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787247887; cv=none; b=G5w0c6xFeM09AmyS9x4fs0ytj0LChuO/+8FrBEeuzxUSVFlKuNgS3t+UuDGhaKXb0hOJ84gMV64gwcnIOTCCiVvLqz/xnMhJqF5LM7hZRQQGLJMiZZzN8oK72wauoprP9Y1+jyTMFxvY9/kgRi6F86AWmvc8uH6uUI8cgyOytLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787247887; c=relaxed/simple;
	bh=z+niHfQ3+OziQYWFTgjhu9G+WMo6P1Zd1yT7GLfhVPQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XHnDIfhM+XNdUgJc87maOoelKjtWkp5tAXr3P04v9/rueL1y64QKgXfghKAEqOTWiQn54UakGbDSvpIVoGiT7SkJu6ElQ5+07k0ef6Tsvpp3dIpsYKVrkZ525ecxNqtdjh9Eda765db9g+2pqtBdiwFN5/P6X79X55l3YhfGJF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Nw9sxOTx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Nw9sxOTx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EBD21F000E9;
	Thu, 20 Aug 2026 17:44:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787247886;
	bh=XosdhQ0If1PVA4nBSNomxCnFnN45Spp95Xo14siBrFE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Nw9sxOTxVQVvv2/IRk7wJ1wi7peFcc+EzhprkXFVXtvTviyY+n27AN6gsPYlJwXSU
	 J+fLehFuOW4jnMySFfJpnq7GIjLI6IE6V4DSltAwO/zGa8qjkvC2QXo1ZBCGpqkCym
	 4o7V+5L7qE78ZCyuQJlLoYnyA8Pnv4jWU9nsA3uI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nayna Jain <nayna@linux.ibm.com>,
	R Nageswara Sastry <rnsastry@linux.ibm.com>,
	George Wilson <gcwilson@linux.ibm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>
Subject: [PATCH 6.1 019/303] powerpc/pseries: pci - logic bug
Date: Thu, 20 Aug 2026 16:52:35 +0200
Message-ID: <20260820145253.757698005@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145253.200766705@linuxfoundation.org>
References: <20260820145253.200766705@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: George Wilson <gcwilson@linux.ibm.com>

commit 649c10bff5cb7a514bf299094833ec8c9190aac3 upstream.

The checks on num_vfs in pseries_pci_sriov_enable() are ANDed where OR
was apparently intended.  Change it to OR.

Fixes: 9a7f6b438664 ("powerpc/pseries/pci: Associate PEs to VFs in configure SR-IOV")
Acked-by: Nayna Jain <nayna@linux.ibm.com>
Tested-by: R Nageswara Sastry <rnsastry@linux.ibm.com>
Cc: stable@vger.kernel.org # 4.16
Signed-off-by: George Wilson <gcwilson@linux.ibm.com>
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/platforms/pseries/pci.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/powerpc/platforms/pseries/pci.c
+++ b/arch/powerpc/platforms/pseries/pci.c
@@ -159,7 +159,7 @@ static int pseries_pci_sriov_enable(stru
 
 	/* First integer stores max config */
 	max_config_vfs = of_read_number(&max_vfs[0], 1);
-	if (max_config_vfs < num_vfs && num_vfs > MAX_VFS_FOR_MAP_PE) {
+	if (max_config_vfs < num_vfs || num_vfs > MAX_VFS_FOR_MAP_PE) {
 		dev_err(&pdev->dev,
 			"Num VFs %x > %x Configurable VFs\n",
 			num_vfs, (num_vfs > MAX_VFS_FOR_MAP_PE) ?


