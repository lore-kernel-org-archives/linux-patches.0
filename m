Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEEA020EB;
	Mon, 14 Oct 2024 14:31:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728916278; cv=none; b=P95HSgKqKqR/UAFqaXW/9ymyCVro+5yBdoISW+Vv+0BmBgoIWOJ9Hrn4Dqo0wRoVGnuknObuC7riiqo697WmU24WKH1qOoLp7+aFQJ5PX6l4rtnb+X6/Ecxx7DSFjrKEMI4V5niojNXL5IGp7D7ZA7Z5/O2a3kRmPxH4wOcwx8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728916278; c=relaxed/simple;
	bh=jkVzW+BjcYvoDdAXoJA28zis3loXeiUXGRJor0IDOcI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=owBt6YdszsB8egrOYC2+ujAU6F/bM2zPYD8rKumgWWtW0dbDknv5N9XQP+IzS/j8AtsVbvHBt4OC5dx9hpP+sV5RljcuWuwJKvBn1sV1KdZ41woE8KkP66DagDPykLhBcBmuorR3WazBX7dzVMac8DtnDwfdeQ30c8gbbo7PT8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ks3ikR3S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ks3ikR3S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FE10C4CEC7;
	Mon, 14 Oct 2024 14:31:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728916278;
	bh=jkVzW+BjcYvoDdAXoJA28zis3loXeiUXGRJor0IDOcI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ks3ikR3S/8qW+aGS0RwKiWUZ53Ua0bAHILIVDMukpdPh44bmrsNFrj3C9N0p093y1
	 MJXLiLTiMEVC5/pJffVTWt8jdPdbsY7tGrKh57+o5MuFRQ2ysXJ/0KdgoOWcPb14Dh
	 yFWFivtAxzmOpSTiy1Qy5h44KRHzMxryccLeuR9w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Breno Leitao <leitao@debian.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 136/214] net: ibm: emac: mal: add dcr_unmap to _remove
Date: Mon, 14 Oct 2024 16:19:59 +0200
Message-ID: <20241014141050.298928600@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141044.974962104@linuxfoundation.org>
References: <20241014141044.974962104@linuxfoundation.org>
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

From: Rosen Penev <rosenp@gmail.com>

[ Upstream commit 080ddc22f3b0a58500f87e8e865aabbf96495eea ]

It's done in probe so it should be undone here.

Fixes: 1d3bb996481e ("Device tree aware EMAC driver")
Signed-off-by: Rosen Penev <rosenp@gmail.com>
Reviewed-by: Breno Leitao <leitao@debian.org>
Link: https://patch.msgid.link/20241008233050.9422-1-rosenp@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ibm/emac/mal.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/ibm/emac/mal.c b/drivers/net/ethernet/ibm/emac/mal.c
index 0c5e22d14372a..99d5f83f7c60b 100644
--- a/drivers/net/ethernet/ibm/emac/mal.c
+++ b/drivers/net/ethernet/ibm/emac/mal.c
@@ -742,6 +742,8 @@ static void mal_remove(struct platform_device *ofdev)
 
 	free_netdev(mal->dummy_dev);
 
+	dcr_unmap(mal->dcr_host, 0x100);
+
 	dma_free_coherent(&ofdev->dev,
 			  sizeof(struct mal_descriptor) *
 			  (NUM_TX_BUFF * mal->num_tx_chans +
-- 
2.43.0



