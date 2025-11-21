Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AF8A34D3BA;
	Fri, 21 Nov 2025 13:36:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732198; cv=none; b=GJQ5+I3v+y4/u1RWjGJ0W68azugrWifp74bGtZPLcnzKLDFdtf0Dl6n65qMlH96uxxcr1w+fEX9ujJjrgUppBC/Ff5feNepCg/6WlQM5zMTqEHsv3lCwKl6RL5vEGTgpPe199EiTnu8R1mSiFGXC4ZeMmAS/fC6BukAbBoDI2Vg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732198; c=relaxed/simple;
	bh=OS7fPZl+9kKTOWSh2zzq17gMkdWWlq81vRN6FE6c6Vg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ea4Hf5SrSjZeH+D654OW6HzNxG55yXEQWZC67/f2C7HGRc7KRTsKngv/fvL4sbVeEu0WI6GRpn+hu0/yZ8p88GgPeXt8IOz+dAI3dt92XexOhYPABl4h0VAqMpjHC5NylMWGQEhrNpTeiUlHkV4tBdGigGoWfjQM+WjE05UvX58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VqpkLYHc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VqpkLYHc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1B0EC4CEF1;
	Fri, 21 Nov 2025 13:36:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732198;
	bh=OS7fPZl+9kKTOWSh2zzq17gMkdWWlq81vRN6FE6c6Vg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VqpkLYHczs5s52KWgzbUQYYcuDLfwMePTmBi4+fvyOuGk7nyByZpyQ+g9QNSsquXN
	 b2IlitPGVsNuSb+3LbKhSth2pS3X7wtxNqtJnkDyzir1VkYOuoAbU5FFGTrMZceHaa
	 Ba4BqoLePi3dgvtU53dkM3HS4jzMnCUtFeMrscWU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Edward Cree <ecree.xilinx@gmail.com>,
	Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 038/529] sfc: fix potential memory leak in efx_mae_process_mport()
Date: Fri, 21 Nov 2025 14:05:37 +0100
Message-ID: <20251121130232.356975575@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

From: Abdun Nihaal <nihaal@cse.iitm.ac.in>

[ Upstream commit 46a499aaf8c27476fd05e800f3e947bfd71aa724 ]

In efx_mae_enumerate_mports(), memory allocated for mae_mport_desc is
passed as a argument to efx_mae_process_mport(), but when the error path
in efx_mae_process_mport() gets executed, the memory allocated for desc
gets leaked.

Fix that by freeing the memory allocation before returning error.

Fixes: a6a15aca4207 ("sfc: enumerate mports in ef100")
Acked-by: Edward Cree <ecree.xilinx@gmail.com>
Signed-off-by: Abdun Nihaal <nihaal@cse.iitm.ac.in>
Link: https://patch.msgid.link/20251023141844.25847-1-nihaal@cse.iitm.ac.in
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/sfc/mae.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/sfc/mae.c b/drivers/net/ethernet/sfc/mae.c
index c3e2b4a21d105..3b08e36e1ef87 100644
--- a/drivers/net/ethernet/sfc/mae.c
+++ b/drivers/net/ethernet/sfc/mae.c
@@ -1101,6 +1101,9 @@ void efx_mae_remove_mport(void *desc, void *arg)
 	kfree(mport);
 }
 
+/*
+ * Takes ownership of @desc, even if it returns an error
+ */
 static int efx_mae_process_mport(struct efx_nic *efx,
 				 struct mae_mport_desc *desc)
 {
@@ -1111,6 +1114,7 @@ static int efx_mae_process_mport(struct efx_nic *efx,
 	if (!IS_ERR_OR_NULL(mport)) {
 		netif_err(efx, drv, efx->net_dev,
 			  "mport with id %u does exist!!!\n", desc->mport_id);
+		kfree(desc);
 		return -EEXIST;
 	}
 
-- 
2.51.0



