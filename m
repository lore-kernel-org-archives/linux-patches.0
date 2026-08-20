Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02360376BD1;
	Thu, 20 Aug 2026 15:15:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787238910; cv=none; b=i/JxL7qkd+MamSbwzPuNaR/VEiEZk2BRwYAAqBPJ2b0/eswCP+R8sSkrUNnFtqu7wzcehsXEm28A2CUDOhBP/IS/HdrGMlwu1NInVsPOhGk3z8Mwy/jTQ8JV9viro/0TjgOocf5LafVRIMXcBrhOv6JpSCvWbgiKkfB+K//F3KE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787238910; c=relaxed/simple;
	bh=CBvaZh63vailaL2e2Z8O1BdcEvaXx0oTueiZ9+PjV/4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cvj68CwZ7+xEtjKi2JRGrnO53IBJQoJQGdraKDsytNRtaVqAJiMza+hPJCDhXFJyVuSuf+YFiK0subnEYFcDZcXn0+p0R/pXsGoRs1mKbylTwQ3tBqhJlz0j14JYYoVJCo79lfcDbn46mLeQ03Sc0JwkGBjzwQkVOEQqpZnK7Qk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gbePczip; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gbePczip"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DEAF1F000E9;
	Thu, 20 Aug 2026 15:15:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787238908;
	bh=N9Op5yq+w1f8Tp/eWTvUW2j9//9l9iRLrhS6NF29+KI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gbePczipoDNYCHDQURLdipcPz1QUs7R9F7YiJk8iqP1O2Fo1bIE0j67MrHrUq5f70
	 ZbODdwpH0HPmiRWxq8cS8OxWhdEjYbdlU53hupyAyhetmst7BjY8oXJVPM5LHp0gmA
	 aktuCwKuL+zLsy6fBDuDDVj5k6hDdk9YZJLDXwLM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nayna Jain <nayna@linux.ibm.com>,
	R Nageswara Sastry <rnsastry@linux.ibm.com>,
	George Wilson <gcwilson@linux.ibm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>
Subject: [PATCH 6.18 034/217] powerpc/pseries: pci - logic bug
Date: Thu, 20 Aug 2026 16:53:22 +0200
Message-ID: <20260820145238.643647478@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145237.531699751@linuxfoundation.org>
References: <20260820145237.531699751@linuxfoundation.org>
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


