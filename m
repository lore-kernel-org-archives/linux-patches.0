Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48CC580637;
	Mon,  8 Apr 2024 14:05:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712585157; cv=none; b=NKgsW5XE6FWGkKS59t5/1XaNx/1VlTcRc+k/LK3rill8rQt4C4qllxoZxF1wc/UBqSRADxvzpFOzb9YYTtNvLkGwTkkedI+pxGs00czysMXEIl9x1IAThFcxKnKYvDkieCM96ijobxuuEx1oR7SegXwyg3C6DnXD2OCWsIbiy7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712585157; c=relaxed/simple;
	bh=bBuu5We9Zm68XbSLaHtfY904WZXo6zcJ/nL0w4kiJuU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UmWCxv6HrAsbDq9KRttHIVHqJ7VPfxe5VJlVeEduTNUk3s2nNgiVxT0Je6LlR69XuNNpwd9guX3GFeYB1/eclV5KJjddJUv8snRMHVbP6g1KNURBfPWny/fZRGWVD2+FlJxqmH6RIQtKqL0mFEAzAURzUS20exY2fdnXzKzyVw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B+eECruB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B+eECruB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A113C433F1;
	Mon,  8 Apr 2024 14:05:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712585156;
	bh=bBuu5We9Zm68XbSLaHtfY904WZXo6zcJ/nL0w4kiJuU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B+eECruBYKOrBudcyEcKxqYJR8YWwWOE2hqntGBhubSlNYYmqAuYPU7QtuUYWGTjn
	 Udw9yEp3TzVvrLn3L2J29z86C9pXBIjxNF9erb/karcx6sCduKy0ShPhHaq9S4+GjR
	 6BnM80dUEpwKdPPRmc36FACLHR7M0mOxiZZ9BWCE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hariprasad Kelam <hkelam@marvell.com>,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.15 652/690] octeontx2-af: Fix issue with loading coalesced KPU profiles
Date: Mon,  8 Apr 2024 14:58:38 +0200
Message-ID: <20240408125423.258878188@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1622,7 +1622,7 @@ static int npc_fwdb_detect_load_prfl_img
 	struct npc_coalesced_kpu_prfl *img_data = NULL;
 	int i = 0, rc = -EINVAL;
 	void __iomem *kpu_prfl_addr;
-	u16 offset;
+	u32 offset;
 
 	img_data = (struct npc_coalesced_kpu_prfl __force *)rvu->kpu_prfl_addr;
 	if (le64_to_cpu(img_data->signature) == KPU_SIGN &&


