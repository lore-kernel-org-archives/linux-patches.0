Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C22EE306B35;
	Tue, 30 Sep 2025 15:11:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759245114; cv=none; b=RavaG3QnWxLcfo+JJ4AqkQTAqnSF9SJOSEx0xJb3oVYScmMsJMP2kkSh+K/k8pWCMVxLAlZNHksFL9z33mmbFNqBpCpdYjAnhQT0HFbOkxSEEqvOcR+gTdeA6PnjZryIJXO2scXxlj8YyzAiRvwoky0LDrNAIVLy5o73Kltskkg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759245114; c=relaxed/simple;
	bh=sHxEfPHOGCY7a0SWhjgImpL5Cg/Wt7ndyv+KP4pDC68=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M0ZRQHgWoaiDWhqnAu7g2/XzCNTTZzRjVeHu1kNnI04upyS3oiewZr3/uT+zCjBeOu46qUGVB+Yx2Re2uCrhkX5mKSEh/4dZu0UNGWc6Qo/ZHc+GB0MVtsv30IG6wBJV4PUgGzAsJmC/kIOZ9Q+qXgv2TmgXOWAnWl0+Pv5KG2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TAZyAxMq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TAZyAxMq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 480F5C4CEF0;
	Tue, 30 Sep 2025 15:11:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759245114;
	bh=sHxEfPHOGCY7a0SWhjgImpL5Cg/Wt7ndyv+KP4pDC68=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TAZyAxMqCk2Zdn5lIMeXvakYY0bjyvFt14CNfvRQK/+I7xVGzqdhPn74tWT+J3PbS
	 CTz1hGGgZ+awgiKqb9DgQURlhvkkT3T+yX13nStgXCmOs2jSujwpWxWzA8cfYsagmW
	 +k1XnLk3q5L6pIXZ18DL1yBmLu6FnX5yuqLZRLFA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Rinitha S <sx.rinitha@intel.com>
Subject: [PATCH 5.15 073/151] i40e: remove redundant memory barrier when cleaning Tx descs
Date: Tue, 30 Sep 2025 16:46:43 +0200
Message-ID: <20250930143830.504916603@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143827.587035735@linuxfoundation.org>
References: <20250930143827.587035735@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>

[ Upstream commit e37084a26070c546ae7961ee135bbfb15fbe13fd ]

i40e has a feature which writes to memory location last descriptor
successfully sent. Memory barrier in i40e_clean_tx_irq() was used to
avoid forward-reading descriptor fields in case DD bit was not set.
Having mentioned feature in place implies that such situation will not
happen as we know in advance how many descriptors HW has dealt with.

Besides, this barrier placement was wrong. Idea is to have this
protection *after* reading DD bit from HW descriptor, not before.
Digging through git history showed me that indeed barrier was before DD
bit check, anyways the commit introducing i40e_get_head() should have
wiped it out altogether.

Also, there was one commit doing s/read_barrier_depends/smp_rmb when get
head feature was already in place, but it was only theoretical based on
ixgbe experiences, which is different in these terms as that driver has
to read DD bit from HW descriptor.

Fixes: 1943d8ba9507 ("i40e/i40evf: enable hardware feature head write back")
Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Tested-by: Rinitha S <sx.rinitha@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/i40e/i40e_txrx.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx.c b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
index e2737875e3795..b94d67729283c 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_txrx.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
@@ -949,9 +949,6 @@ static bool i40e_clean_tx_irq(struct i40e_vsi *vsi,
 		if (!eop_desc)
 			break;
 
-		/* prevent any other reads prior to eop_desc */
-		smp_rmb();
-
 		i40e_trace(clean_tx_irq, tx_ring, tx_desc, tx_buf);
 		/* we have caught up to head, no work left to do */
 		if (tx_head == tx_desc)
-- 
2.51.0



