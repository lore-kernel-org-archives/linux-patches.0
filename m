Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BA1E222D7B;
	Thu, 12 Dec 2024 17:09:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734023381; cv=none; b=RTilETfdElfVGh3fOeHL/+eKOr6D6yjcR9hFL9CTjJiHsWCct0QmpHWQSFK2RHrKe8E8e/aIKftah1gi5IFtqfHbTxDl1m1rNnI6XEqDEXDWQ93PpYqOC5L8vo5nMCFRGCzm+0pBVRocGjTxxTvUw/QuweCdvU1BLxmWQIc18no=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734023381; c=relaxed/simple;
	bh=lU2ffF1nUosYALtsXbYvA/3vPZdGhTR3R2YybfOOtAM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EsT+FvhzTYqkPX2Ttc0b0HdV6zXu5v6h8tDaYU6v+4blhGU2EN+JcMhNaMIyoZl/1W5ovVFwfPeXs/J9hYxgYKuX5QS8PwTRlepi0pidx14icKLAzZ7Z3z8plRjbszGugrdXtS5HEG6ynKFA7lx5hxj2H0bpTD+LDCe7/UUhMgU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QcxUUsNI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QcxUUsNI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4EB8C4CED3;
	Thu, 12 Dec 2024 17:09:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734023381;
	bh=lU2ffF1nUosYALtsXbYvA/3vPZdGhTR3R2YybfOOtAM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QcxUUsNIpZMLZsxVR26uPOqIxrzCg37G1+TCbEKUBeCc6fNJNuUsGX0RV0T5KjDgT
	 0Xy3p0HIyQcV69ro0+wizrXwAFKSLSRHi88WW3iBDrLtZ1IRoDoQcacTohzs16883k
	 wQbtHtUVI8ZogCEH727wMVySTvKsXDzbgMbox+jE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Elena Salomatkina <esalomatkina@ispras.ru>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 485/565] net/sched: cbs: Fix integer overflow in cbs_set_port_rate()
Date: Thu, 12 Dec 2024 16:01:20 +0100
Message-ID: <20241212144330.933246285@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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

From: Elena Salomatkina <esalomatkina@ispras.ru>

[ Upstream commit 397006ba5d918f9b74e734867e8fddbc36dc2282 ]

The subsequent calculation of port_rate = speed * 1000 * BYTES_PER_KBIT,
where the BYTES_PER_KBIT is of type LL, may cause an overflow.
At least when speed = SPEED_20000, the expression to the left of port_rate
will be greater than INT_MAX.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Signed-off-by: Elena Salomatkina <esalomatkina@ispras.ru>
Link: https://patch.msgid.link/20241013124529.1043-1-esalomatkina@ispras.ru
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_cbs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sched/sch_cbs.c b/net/sched/sch_cbs.c
index 459cc240eda9c..e0ced550808a5 100644
--- a/net/sched/sch_cbs.c
+++ b/net/sched/sch_cbs.c
@@ -310,7 +310,7 @@ static void cbs_set_port_rate(struct net_device *dev, struct cbs_sched_data *q)
 {
 	struct ethtool_link_ksettings ecmd;
 	int speed = SPEED_10;
-	int port_rate;
+	s64 port_rate;
 	int err;
 
 	err = __ethtool_get_link_ksettings(dev, &ecmd);
-- 
2.43.0



