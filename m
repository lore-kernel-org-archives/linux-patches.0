Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 020B8269D1B;
	Tue,  8 Apr 2025 12:07:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744114074; cv=none; b=hJIg3kZSk0kZeC7HCG9Btdh2XRHfdG3Vag+nsCkkWQNu7GJX62IJmfX7vpk2yqBLwPjJDrBx4pawnSqaiXUmyJzY3yr7G+sWyqaf+hP2z70PGZCMi+GIQTPmmMUWz+4eUgp9rl/kygqrrpa/4ohR+JfC8A5tBifW3KSIvfzak6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744114074; c=relaxed/simple;
	bh=nm39z3hxOvb5CpF3tzFatY1VTvt5C3H71deKMZPevps=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QQxrZe2+3Fbw/8icIr1QWTwB02FM1Vmmy4EzmEJrBe+jwNk7XNJ3YnzH9nAJyvthuAgYCbvlB0f3AdyTgWVPmbt6McpHQoYp8365ipE707gFSUG+VTJis2ibGeKfaXUTv0FvsDFFCU6rIe64aDeWs2VQawCGaFElB3n7f9G+QOM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CqDYJCIH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CqDYJCIH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEFBDC4CEE5;
	Tue,  8 Apr 2025 12:07:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744114073;
	bh=nm39z3hxOvb5CpF3tzFatY1VTvt5C3H71deKMZPevps=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CqDYJCIHdkzWDtBoeSPiG9pFubLzhnJT+Po7/qsVWBBD+otr9HkHHEPWM9UIlgzho
	 P1sB3qvvPe156XSVJQUpeHltN8gmb1Nea1AYxVUfqUiQ8Qn0shzc+1n1YFc2xYeryM
	 Wm9n1Uq/OhjBsE9pK9MIQrk0mF6OI4fHzI58rCHw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geetha sowjanya <gakula@marvell.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 127/154] octeontx2-af: Fix mbox INTR handler when num VFs > 64
Date: Tue,  8 Apr 2025 12:51:08 +0200
Message-ID: <20250408104819.380690306@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104815.295196624@linuxfoundation.org>
References: <20250408104815.295196624@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geetha sowjanya <gakula@marvell.com>

[ Upstream commit 0fdba88a211508984eb5df62008c29688692b134 ]

When number of RVU VFs > 64, the vfs value passed to "rvu_queue_work"
function is incorrect. Due to which mbox workqueue entries for
VFs 0 to 63 never gets added to workqueue.

Fixes: 9bdc47a6e328 ("octeontx2-af: Mbox communication support btw AF and it's VFs")
Signed-off-by: Geetha sowjanya <gakula@marvell.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20250327091441.1284-1-gakula@marvell.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeontx2/af/rvu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
index f569a98e35a02..57e3a11451b56 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
@@ -1740,7 +1740,7 @@ static irqreturn_t rvu_mbox_intr_handler(int irq, void *rvu_irq)
 		rvupf_write64(rvu, RVU_PF_VFPF_MBOX_INTX(1), intr);
 
 		rvu_queue_work(&rvu->afvf_wq_info, 64, vfs, intr);
-		vfs -= 64;
+		vfs = 64;
 	}
 
 	intr = rvupf_read64(rvu, RVU_PF_VFPF_MBOX_INTX(0));
-- 
2.39.5



