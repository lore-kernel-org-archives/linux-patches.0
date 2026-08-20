Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC9AF37E5D8;
	Thu, 20 Aug 2026 15:23:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787239406; cv=none; b=bx7vH0c+YrXffHBSngCilJ16sfCZwxclsDTlFBcLrSaiZ6emO5Ok9nc5T8yVjXfYD7W7B/jtg03mSu2TrFoAqV6lGS1O6VLDy2Hz3b8Js0YfVLKyueQcCNHGq6+rcOo7lKgEkOB5rzwlFXfM0bDAog7OONVrAGRbz948Sg8ugEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787239406; c=relaxed/simple;
	bh=NYYIHCnXdE1QS7li0Rko/4+XivxO57F4ziVqq3OaFFY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MtsT/XrLjMkFq8ssPKpAjLSSHOMNB0LQNXq0gLJ4JaGyRK7FTQTQ+swtJeOrrPdV54CP4kZ9zGHV01Vfgh+Gc5bWXZ87butKb/CCIC4/RaTiirvVXObnSbIZgt5o2PCW0x3YLKYSjUBgQPStzUG+BYcOcInlrtn/RsGctD9WDhs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rkXmejHw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rkXmejHw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12DE31F000E9;
	Thu, 20 Aug 2026 15:23:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787239405;
	bh=BVpiPkREXqoMX+iK9mhEiyFIjJp6SwrSSDTLQk4tINY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rkXmejHwUzLetfkba6I7c6A/3enKmizMqIjGY4dEZIb5L2/xpa0gzil/9evubSIVb
	 IpAreto7fE4g0SZBVCVje9sQJCFUw5PvMl+kYEXCvPXc2Y4zeSsuBxdnCL+m2dwZgh
	 d4Kua7L5cQ5CcAUwL52km6/jmOJEcvHz003wHX9A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nayna Jain <nayna@linux.ibm.com>,
	R Nageswara Sastry <rnsastry@linux.ibm.com>,
	George Wilson <gcwilson@linux.ibm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>
Subject: [PATCH 6.12 038/220] powerpc/pseries: pci - logic bug
Date: Thu, 20 Aug 2026 16:53:48 +0200
Message-ID: <20260820145224.641129449@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145223.480031205@linuxfoundation.org>
References: <20260820145223.480031205@linuxfoundation.org>
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


