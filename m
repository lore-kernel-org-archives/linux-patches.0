Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 646C9199939;
	Tue, 30 Sep 2025 14:58:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759244293; cv=none; b=nzsF6zHH7IyC/iT64ycTGYDB7x1nHPzBPDdVE2O44FBX3CKDGrtE+wg5Z/tlAWb+XAuOsjGJmHt5F+mHM4wRAygyOEIsDFGtBEXj6VlW1RzJnYLy5Qqbj/SlUSM/RCVyshtHHXUyPwd945X5OnN9gvHsosXkUc9Zs0aGXPAxG1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759244293; c=relaxed/simple;
	bh=3UIysZ5/JwY6PRIMEo0L9cCWDdXzJtVQySN7Cy+Xt/k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dvwDwzfGKkLTW4QwixgFW1wAq+1S2WgyRLJ1FA3c8uE0ssH7lUXrpXQqxUxzV6wqzMheCDdvDD4vI+mBfoO0OxnPnQhEoafWDmkE8iTqc5oPEEKIqBG8S2X0FU/jn6tdJp4bbQgpC+QZeCak+XMfK+apZFU2iSgt0w9kubOxEdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RWo32xe6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RWo32xe6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80B41C4CEF0;
	Tue, 30 Sep 2025 14:58:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759244292;
	bh=3UIysZ5/JwY6PRIMEo0L9cCWDdXzJtVQySN7Cy+Xt/k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RWo32xe6ugtTS/4tWpSxJwUr1DXq0UzHIejKCWZqU50PMQZr6r4CJ7JXxWYz+UNmx
	 QgFKUS9faMa5gh4xfeMj35ilXmxIZtj9WGpPR3UEN5eMwRoi4X/HgpbzO0HSyxbPhG
	 GDlRkF2l6jRnagTqrqIvfO9oMu8LRlZ755cGK0Ys=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Rinitha S <sx.rinitha@intel.com>
Subject: [PATCH 5.10 053/122] i40e: remove redundant memory barrier when cleaning Tx descs
Date: Tue, 30 Sep 2025 16:46:24 +0200
Message-ID: <20250930143825.169034857@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143822.939301999@linuxfoundation.org>
References: <20250930143822.939301999@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 57667ccc28f54..0678705cb1b4a 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_txrx.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
@@ -795,9 +795,6 @@ static bool i40e_clean_tx_irq(struct i40e_vsi *vsi,
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



