Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D0B281728;
	Mon,  8 Apr 2024 13:29:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712582950; cv=none; b=nlv/yf3G7+qo6XieGjGWlbozOgV0rA2lPSURaY/74s8RDhfl/NI0ojdDSm8VSou+nZ4L3SlCQGbBLeUnkxy2I+YeHbNEI35UAQOeVyDjncJ8f4sges1EBeV0k5FvC2mgZhkbNej/WiY31AQQyxVq4FAPQwk5hHCMsVF3c5NNp8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712582950; c=relaxed/simple;
	bh=QcLZYLvwrVDEYv7VYt3wKhX8sJM2VDFqp9myo7TaY68=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rqtJlytEzvhyeo+6fFw7CLKH8VnOmoh5KejZQO+osUJGT/qgNFa+dMssax36elgKIoVqN6A6wlc36PyIiwECZ+uVY17oMO9F+5XiFl/PI0+CnTWg8hEZ/2hr4NFMNzf7n1FUgVzJwN83Qh4RujkKFQolh9zqIeA3lZvj+Eptns8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AVK1y6YD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AVK1y6YD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E19C4C433C7;
	Mon,  8 Apr 2024 13:29:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712582950;
	bh=QcLZYLvwrVDEYv7VYt3wKhX8sJM2VDFqp9myo7TaY68=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AVK1y6YDoxqfFCtp8CysoD0/Cz/+SPasiIbEhm55dKOlhQGR6ujLNQ8Ubnwx0Czyd
	 ueiCvHKP4HmDpb9YvoKgA/xk2ksoCp4n8upOywpTGSLBslQ0B7k1qm586b3FpYwkEY
	 PMmJPWCzgTrNuTqXNrxd+R0oxvUJAANE9r1QHyLE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hariprasad Kelam <hkelam@marvell.com>,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 6.8 124/273] octeontx2-af: Fix issue with loading coalesced KPU profiles
Date: Mon,  8 Apr 2024 14:56:39 +0200
Message-ID: <20240408125313.145450134@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125309.280181634@linuxfoundation.org>
References: <20240408125309.280181634@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1657,7 +1657,7 @@ static int npc_fwdb_detect_load_prfl_img
 	struct npc_coalesced_kpu_prfl *img_data = NULL;
 	int i = 0, rc = -EINVAL;
 	void __iomem *kpu_prfl_addr;
-	u16 offset;
+	u32 offset;
 
 	img_data = (struct npc_coalesced_kpu_prfl __force *)rvu->kpu_prfl_addr;
 	if (le64_to_cpu(img_data->signature) == KPU_SIGN &&


