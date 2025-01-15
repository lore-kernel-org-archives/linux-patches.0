Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B4D5248BB2;
	Wed, 15 Jan 2025 10:47:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736938030; cv=none; b=BkAlSqMD9EiBv/rXHrm1V50JCzvOl81cn8KUMzOniFs+5HGb/ZtqRZbTuX3+KEk/7VBjFTAnesG8TKaPLyo4aiLcy3BOYkB7JDHekQP+lZWEbKlafop06rPyKP+qGxSuUpGDOIXldV10DCfD2DWkn95WApvBaYKDYc4x+EaS8kI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736938030; c=relaxed/simple;
	bh=sQ+NU0LgMLJhYxkweqlH1G3Y0kP/ZcU6qBmVoNCA260=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dcQc/Koe5rMG6+UytS2RgdusOAkw3i++76FngRv1jmAp4pRHlV6Xy82i2gCjwAz3SfLv3j3qD8o98m2MvwBuT2JGLzs0CZinpWoRdjzjDO442Qa8bHpSAiohnpbrEm07P2wja+MfPN0UG6fPHIVFscmPx5ueXLF6LsJAJGBcQio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OUz9Lk7/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OUz9Lk7/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A205C4CEDF;
	Wed, 15 Jan 2025 10:47:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736938030;
	bh=sQ+NU0LgMLJhYxkweqlH1G3Y0kP/ZcU6qBmVoNCA260=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OUz9Lk7/c5F4NtC59Mcf6Mcx3Wp3h94yCIS08vV+smdJMw3PBaoE3Y7Ery2aweleo
	 Xh0qEVsy/tfKAEDwEm6dhDI9ETux64dkzcuj6o3u6IuaxYrfaEAdbbrlDG6DA8wV4Y
	 it+3T4gBy212leIENUkSR6Fz/yXuDgxcd7crOSd8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anumula Murali Mohan Reddy <anumula@chelsio.com>,
	Potnuri Bharat Teja <bharat@chelsio.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 033/189] cxgb4: Avoid removal of uninserted tid
Date: Wed, 15 Jan 2025 11:35:29 +0100
Message-ID: <20250115103607.680533939@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103606.357764746@linuxfoundation.org>
References: <20250115103606.357764746@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anumula Murali Mohan Reddy <anumula@chelsio.com>

[ Upstream commit 4c1224501e9d6c5fd12d83752f1c1b444e0e3418 ]

During ARP failure, tid is not inserted but _c4iw_free_ep()
attempts to remove tid which results in error.
This patch fixes the issue by avoiding removal of uninserted tid.

Fixes: 59437d78f088 ("cxgb4/chtls: fix ULD connection failures due to wrong TID base")
Signed-off-by: Anumula Murali Mohan Reddy <anumula@chelsio.com>
Signed-off-by: Potnuri Bharat Teja <bharat@chelsio.com>
Link: https://patch.msgid.link/20250103092327.1011925-1-anumula@chelsio.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
index fb3933fbb842..757c6484f535 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
@@ -1799,7 +1799,10 @@ void cxgb4_remove_tid(struct tid_info *t, unsigned int chan, unsigned int tid,
 	struct adapter *adap = container_of(t, struct adapter, tids);
 	struct sk_buff *skb;
 
-	WARN_ON(tid_out_of_range(&adap->tids, tid));
+	if (tid_out_of_range(&adap->tids, tid)) {
+		dev_err(adap->pdev_dev, "tid %d out of range\n", tid);
+		return;
+	}
 
 	if (t->tid_tab[tid - adap->tids.tid_base]) {
 		t->tid_tab[tid - adap->tids.tid_base] = NULL;
-- 
2.39.5



