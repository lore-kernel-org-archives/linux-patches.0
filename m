Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EE131D0164;
	Wed,  2 Oct 2024 13:50:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727877056; cv=none; b=uG/pPLwQKD4Ln3N8mBN5qHJV7Zv9z3sKKJ9ImFup2oEab6hfJ49f53F6EHFhiqqzJ7RvwMDLCPCLK1bDY4JrjvH4/lLJjOUiQc74Czd9+7VrHa9wt3V1lqw0BNZrp24/24lj1r1jl+ZZXorXFRJPAPkACGMDXKWkwgUkVD3czvE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727877056; c=relaxed/simple;
	bh=D8fR3Wh5FEh5LiiX/euvEyUNpItSxWt26qVmvDEIph8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aqw5VEW5PFmecGY52AHHmEFuL1OFHSFmW6DqcvZABdJUqEGrIcHFVNwAu186gKpRxQ6RmqKX4/PjcpubRC7r/19DYV65uJuLKG/ck2nZYf5GaQEvtscx93Vk8+4SW3aWoUXCF2v+VbcmRXHakR2mWhDl3nqBuAYmgb3NljeHMWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D/H3KzI3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D/H3KzI3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 161E3C4CEC2;
	Wed,  2 Oct 2024 13:50:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727877056;
	bh=D8fR3Wh5FEh5LiiX/euvEyUNpItSxWt26qVmvDEIph8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D/H3KzI3o2AJL8YzZFsJ005Lh7XJJs5dg10UJP5Nc5XB65tJDhSNIwromgl540H8X
	 lkeKOuDP0z+dix8urNxPY9GKDVQnESvUrVTmP38aK9Y64iSWe2YyHffiOz6KSKY8hh
	 vjYNR1muSeEgKh/D55bIDoiy6nEYMurkmAX71Gfo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qiuxu Zhuo <qiuxu.zhuo@intel.com>,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH 6.11 649/695] EDAC/igen6: Fix conversion of system address to physical memory address
Date: Wed,  2 Oct 2024 15:00:47 +0200
Message-ID: <20241002125848.420012349@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qiuxu Zhuo <qiuxu.zhuo@intel.com>

commit 0ad875f442e95d69a1145a38aabac2fd29984fe3 upstream.

The conversion of system address to physical memory address (as viewed by
the memory controller) by igen6_edac is incorrect when the system address
is above the TOM (Total amount Of populated physical Memory) for Elkhart
Lake and Ice Lake (Neural Network Processor). Fix this conversion.

Fixes: 10590a9d4f23 ("EDAC/igen6: Add EDAC driver for Intel client SoCs using IBECC")
Signed-off-by: Qiuxu Zhuo <qiuxu.zhuo@intel.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/stable/20240814061011.43545-1-qiuxu.zhuo%40intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/edac/igen6_edac.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/edac/igen6_edac.c
+++ b/drivers/edac/igen6_edac.c
@@ -316,7 +316,7 @@ static u64 ehl_err_addr_to_imc_addr(u64
 	if (igen6_tom <= _4GB)
 		return eaddr + igen6_tolud - _4GB;
 
-	if (eaddr < _4GB)
+	if (eaddr >= igen6_tom)
 		return eaddr + igen6_tolud - igen6_tom;
 
 	return eaddr;


