Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C1A4223C72;
	Thu, 12 Dec 2024 16:18:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734020337; cv=none; b=rZcmjfgQzG7v56mAtm088VIIwNAq/5OEh6YZrTSjbCZf/IQdccL5kLiY5AySjrgSgfHD4GXqGAaKGP282mBmshKCrSghJ+MgFI6HXqNu3HD4lvqXfaQuCADKPRhODiSfbzLqXDrlvbvKPQAvWeiwCPKihF2lmS2bWUuGiqJA8tc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734020337; c=relaxed/simple;
	bh=drcerIuTHABC3GAeIOmv4zx1tEXSyvVZbp94hWUc85o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fmz6CoVLJiUAbcbq5MppJw0Pp/Q6vdQiMUa8l4LtpsrYgmba8YTwM4y+3L1F6ZXogZJwbQa4vVUBhAa1sCf39wJ2TxOXaNz6RVoHGeaNMck8NVhJ+P2CQdeg00e9H5FxMkp5COINnFlXQGNkLxW0hNe43pevsFNxe1/EK0xff2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fTQGV8tC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fTQGV8tC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FFC2C4CECE;
	Thu, 12 Dec 2024 16:18:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734020337;
	bh=drcerIuTHABC3GAeIOmv4zx1tEXSyvVZbp94hWUc85o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fTQGV8tC7eVp7OnfAiSu2WO9x5cTnIjQZjQ/BNUF8flToWrW2Nm+EhVJRHyT/LJpa
	 SuFB2YVGbZlCldK7n3JLkRqISzSuRNgG+k4bHxtPIfaw4wa+SFczSH3kupocWAnj6m
	 S5U5fitnPsJlGiGfKvOzRyvovwUHvzH+bpm7mKf4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Zenla <alex@edera.dev>,
	Alexander Merritt <alexander@edera.dev>,
	Ariadne Conill <ariadne@ariadne.space>,
	Juergen Gross <jgross@suse.com>,
	Dominique Martinet <asmadeus@codewreck.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 441/772] 9p/xen: fix release of IRQ
Date: Thu, 12 Dec 2024 15:56:26 +0100
Message-ID: <20241212144408.146992911@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

From: Alex Zenla <alex@edera.dev>

[ Upstream commit e43c608f40c065b30964f0a806348062991b802d ]

Kernel logs indicate an IRQ was double-freed.

Pass correct device ID during IRQ release.

Fixes: 71ebd71921e45 ("xen/9pfs: connect to the backend")
Signed-off-by: Alex Zenla <alex@edera.dev>
Signed-off-by: Alexander Merritt <alexander@edera.dev>
Signed-off-by: Ariadne Conill <ariadne@ariadne.space>
Reviewed-by: Juergen Gross <jgross@suse.com>
Message-ID: <20241121225100.5736-1-alexander@edera.dev>
[Dominique: remove confusing variable reset to 0]
Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/9p/trans_xen.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/9p/trans_xen.c b/net/9p/trans_xen.c
index f95803736ced0..4ad7e7a269ca0 100644
--- a/net/9p/trans_xen.c
+++ b/net/9p/trans_xen.c
@@ -285,7 +285,7 @@ static void xen_9pfs_front_free(struct xen_9pfs_front_priv *priv)
 		if (!priv->rings[i].intf)
 			break;
 		if (priv->rings[i].irq > 0)
-			unbind_from_irqhandler(priv->rings[i].irq, priv->dev);
+			unbind_from_irqhandler(priv->rings[i].irq, ring);
 		if (priv->rings[i].data.in) {
 			for (j = 0;
 			     j < (1 << priv->rings[i].intf->ring_order);
-- 
2.43.0



