Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C0E27867D;
	Mon,  8 Apr 2024 13:14:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712582040; cv=none; b=YuPYlM8zX6OOaPjffJnwNKrPkCQKgbFb56fdCEbdwNePGLnYkHpmFH1OqzcrnvhqqTeEUVITI07wkNFGPQZwcf9Hna4sigl821BlsRRDdCtIiTOuzgtCOPvz/vFiR1ACPVd6NSYgEtMMPHzoowaBVU0FUzAX49RimNNgAkYDyNk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712582040; c=relaxed/simple;
	bh=Y7b+HSxzQAaKnu+oxTQnc/lqxoZjlx97Klc5rw+fBaU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G1oQmK49m8//SWb0q686pYteYD9Kaj4BZfso3OsrtQZ/7z7IUUSIFELQC5QN4HLFqAwsVDuxgrE6RMuysFxsp5NmsFtViBbGZVJY8BjLe+R3QiCeQP/Do0nBjocMsh4BnJOvnq24H2GxOpwNvMb9aQOs66l6KGFtj/GxWq1BZBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lOMcbPU6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lOMcbPU6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A81F4C433C7;
	Mon,  8 Apr 2024 13:13:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712582040;
	bh=Y7b+HSxzQAaKnu+oxTQnc/lqxoZjlx97Klc5rw+fBaU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lOMcbPU6NmGkawUMNTVukZAc3P1OmxljvunJ17el2wSbnNE5SbzZZwxyIAuCoJxq3
	 g37mpSWe/rVfyQpu7leDlypVwzrUP5th/7HYJewn1NeEpLkvRdKayakrBkuFMvhCCD
	 I1eu3+VGYcENF/xm5su9Nk/Qlq7yIsSoNTsPgxdY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hariprasad Kelam <hkelam@marvell.com>,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 6.1 064/138] octeontx2-af: Fix issue with loading coalesced KPU profiles
Date: Mon,  8 Apr 2024 14:57:58 +0200
Message-ID: <20240408125258.211591632@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125256.218368873@linuxfoundation.org>
References: <20240408125256.218368873@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hariprasad Kelam <hkelam@marvell.com>

commit 0ba80d96585662299d4ea4624043759ce9015421 upstream.

The current implementation for loading coalesced KPU profiles has
a limitation.  The "offset" field, which is used to locate profiles
within the profile is restricted to a u16.

This restricts the number of profiles that can be loaded. This patch
addresses this limitation by increasing the size of the "offset" field.

Fixes: 11c730bfbf5b ("octeontx2-af: support for coalescing KPU profiles")
Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
Reviewed-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
@@ -1669,7 +1669,7 @@ static int npc_fwdb_detect_load_prfl_img
 	struct npc_coalesced_kpu_prfl *img_data = NULL;
 	int i = 0, rc = -EINVAL;
 	void __iomem *kpu_prfl_addr;
-	u16 offset;
+	u32 offset;
 
 	img_data = (struct npc_coalesced_kpu_prfl __force *)rvu->kpu_prfl_addr;
 	if (le64_to_cpu(img_data->signature) == KPU_SIGN &&


