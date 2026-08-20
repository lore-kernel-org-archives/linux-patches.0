Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39E10352019;
	Thu, 20 Aug 2026 15:02:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787238131; cv=none; b=TGHAsWDgiHg0qTV2m/MifF/DQUQcDZMH60VfyWD8KEFxoRmC7vkGsIoVKTeaZi8nt8sGBgVfzL7y+GuVRCsm9wRq82sG5nBSBy6wwqYMoU+Q8VxCmROnFbdlci/I4a5AS1UGUVWEHy0WIyRSWQL9Yx1bB9Smsl4qPVSR4wjZSNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787238131; c=relaxed/simple;
	bh=zDJKdw8PIlLtzHbT9Pl9Y3WJ9GFoXfScNmF1Oo+KDi4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IgKkV88Xza8MiZsPBH+yZYKKMi3LP+AvYENTlRgUEbLHIGpdOfeGW6YKE4Oo2xVe/U8WJnPHQEbgZSdW1aaUNfjuAF20+dMuU/VmvohKbD009JCfh3Q69AeMxxDnk/2nfaI1anWHEtn5WEV4WkW3xnw1pDph7qzPuHWk4ezh2wA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aWwLdZqg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aWwLdZqg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5ED471F000E9;
	Thu, 20 Aug 2026 15:02:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787238129;
	bh=62WprRAGZC9GgCby7sF8fRCEWF08+jtS4hgMYaemfXs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aWwLdZqgTjECW63e7M05nvFNn95K4+5WK4SVNRjROLO1UTvEsOBzxq8G3VGMNOryD
	 su9lHl0Xg9ABuqn3Tbzfqi0N8OE2owHHOclP22ENqc5S9mHqlrYaBtzB0SQ9TAsI+a
	 +gqLtYLOI66xr2+sIbjX8mtTDYWGnR2+nG+7mXfg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nayna Jain <nayna@linux.ibm.com>,
	R Nageswara Sastry <rnsastry@linux.ibm.com>,
	George Wilson <gcwilson@linux.ibm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>
Subject: [PATCH 7.1 042/228] powerpc/pseries: pci - logic bug
Date: Thu, 20 Aug 2026 16:53:04 +0200
Message-ID: <20260820145245.750474320@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145244.450574346@linuxfoundation.org>
References: <20260820145244.450574346@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -132,7 +132,7 @@ static int pseries_pci_sriov_enable(stru
 
 	/* First integer stores max config */
 	max_config_vfs = of_read_number(&max_vfs[0], 1);
-	if (max_config_vfs < num_vfs && num_vfs > MAX_VFS_FOR_MAP_PE) {
+	if (max_config_vfs < num_vfs || num_vfs > MAX_VFS_FOR_MAP_PE) {
 		dev_err(&pdev->dev,
 			"Num VFs %x > %x Configurable VFs\n",
 			num_vfs, (num_vfs > MAX_VFS_FOR_MAP_PE) ?


