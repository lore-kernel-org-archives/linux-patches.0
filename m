Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40ED237B41F;
	Thu, 20 Aug 2026 17:36:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787247370; cv=none; b=VKfJm/51Gw+XOV7ipHCpQm7qBQ5zEfKmFIFP6Cs35ZHUw7hEIYOijIjWeZxvSoo/3ezCGJU3YxWe0s8OAkPBA7/Ur+408aMP8UCTBTcXQkdoGXHASOIqv6dQyqZDS01qZGCFahGUFYdOkO4VGPPMWZDXtcK9wEDMrmOn0dlOlTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787247370; c=relaxed/simple;
	bh=k1cjNVlb9mQ3hWPeL3vVfawxFDM+54gHkPtaAb8BuD4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LUzpXSu8J89IdIZGQnAxN2KrLNeN42fUhHruzL+HYhjA1QggT84U+kKyDCXaQnyYMd6gdda5fAljqkbTmmK1mi0XtzOO0zgdNqG8L1H3+usUj2fB/20r29Jvg/DRcPEHvr8Z2VpiOncJGjks+2tBzfapJsX8T8GCHnaVbtUkHyQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DUlAj9hU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DUlAj9hU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F3C71F000E9;
	Thu, 20 Aug 2026 17:36:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787247369;
	bh=R+XNmgjTImYZSalDzfSa+9t8bw5+6OcjCUar9NpqVTE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DUlAj9hU4b4jq8dd9dM0RifT4qYil4ZMz0z7kCwtnKS39lnRnvhPk5OTSOCovXM6j
	 bX4Eijmc8CzZbOK+JkBrrdXtSRaLqC0Qo1AddjC6+u2cgy4kRKVDwEduq772glTV0w
	 YEUJFl1NYJ+NbBd3sKCvpgW6oeUEzEGA+h9zWsnY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nayna Jain <nayna@linux.ibm.com>,
	R Nageswara Sastry <rnsastry@linux.ibm.com>,
	George Wilson <gcwilson@linux.ibm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>
Subject: [PATCH 6.6 022/166] powerpc/pseries: pci - logic bug
Date: Thu, 20 Aug 2026 16:54:41 +0200
Message-ID: <20260820145211.856193220@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145211.194104353@linuxfoundation.org>
References: <20260820145211.194104353@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


