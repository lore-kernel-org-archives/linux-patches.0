Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C487147DD4B;
	Thu, 20 Aug 2026 16:42:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787244127; cv=none; b=b7RatCN9qsb7oyzoY9EcRQ9tenMXOaa0IN3glzh4y1c3OrJdTv15tRVWTCieK6QjnYtY1F4jONriSHewjUY9Xkww9wNltcqmYQFwnvGvJufPudQ7TCwbuqL1t2cAQvDrBjpfszNbfGKbE4ni/KjgvL3FxbSpOzOA9S2xM+uy/4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787244127; c=relaxed/simple;
	bh=VeXcFAbT3lYtZ9dFD0mnsDlYiph+Vs9537ZWlGb4lCk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kjs2udkNB7TmPw94Lu0af8b8SUvGe4fzOkBleid03EQOurlNi7uajHv5LjzyvGiE7V5vfdsyEOOBdPN7eRQ0qeketUmkGtoSQ4wTNOUx+NHnOJ4qm+/Yukx2bycCcSLORKeJnHFdm+7CkWn54qOIcNwVfOxN7lUcSh18DJP3ODQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ycm18GbB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ycm18GbB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0E481F000E9;
	Thu, 20 Aug 2026 16:42:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787244125;
	bh=1nC7ykCmnUj7fZwuvM8I49D54Mg4RL2Lz+FLbo3+e6c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ycm18GbBeC0YNDWVpyaryMtKrzyY/OhBsAumMFIsmdIkrlc9P8+OWR2/k6bSghFDh
	 o52hXcuL0jnCMx+3lSbO77bNgrvubP4YY1MPhWqeK+IFtV1I5OTQ82Y8M/g1OHC2Wp
	 u6/VhB2l7OWovGFzP4piVdGSjynQ8wB2smRFyiII=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nayna Jain <nayna@linux.ibm.com>,
	R Nageswara Sastry <rnsastry@linux.ibm.com>,
	George Wilson <gcwilson@linux.ibm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>
Subject: [PATCH 5.10 010/235] powerpc/pseries: pci - logic bug
Date: Thu, 20 Aug 2026 16:54:06 +0200
Message-ID: <20260820145216.753979663@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145216.426568665@linuxfoundation.org>
References: <20260820145216.426568665@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -161,7 +161,7 @@ int pseries_pci_sriov_enable(struct pci_
 
 	/* First integer stores max config */
 	max_config_vfs = of_read_number(&max_vfs[0], 1);
-	if (max_config_vfs < num_vfs && num_vfs > MAX_VFS_FOR_MAP_PE) {
+	if (max_config_vfs < num_vfs || num_vfs > MAX_VFS_FOR_MAP_PE) {
 		dev_err(&pdev->dev,
 			"Num VFs %x > %x Configurable VFs\n",
 			num_vfs, (num_vfs > MAX_VFS_FOR_MAP_PE) ?


