Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1C3A216E18;
	Thu, 12 Dec 2024 15:19:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734016747; cv=none; b=GYOHI5bGZ5POa0yuYcFbwv84wC997WNvW//3s9nS+tm8jJRH8jjcZVEDjkKRQSeqz2IUwCZYn1FpQrjdw0CXKxqCzZo/3+6ObyjIN7D/oryMGMIRCmweJCNbtDxyUssIjmXl9yYxNgFofSPqyy38PwP9fMxFmXGLm/cWZDs7w2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734016747; c=relaxed/simple;
	bh=1o4GzRjXN0HrxXdFPe+MQ2TMYeBlcIv1jsfcO5uzjyM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MD/Et/9qaNH43fRu89mBAGFOfwNUQJm11KeXfProrMNzu+m+yguJngC7y81bU/zMxvc4XTnrovCfBtnJRo/XMuSOc5mc4BPVq7XhlIgThNoivOIsi6PMXMXYT5R3Ij8xNmncQu5Gb6JFJi2UXeBhyKr/BFeA1ZH7clei2Qpt1Qw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A1rDr+1M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A1rDr+1M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DCA9C4CED4;
	Thu, 12 Dec 2024 15:19:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734016747;
	bh=1o4GzRjXN0HrxXdFPe+MQ2TMYeBlcIv1jsfcO5uzjyM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A1rDr+1MitwyH2CAK+r/00elCNP9+AVFgkaPRAdwOW1kR1Aj4S27QswZtxU9KS6qv
	 OX9LvQM1oU50T0u+qECt1Y5IqM5BzfgElbx328ugmQwF48jbvcjwxAvTR9iY2r8AVk
	 31SN+ABIEByfX53YCJQrepYjrigrHDC+4ru5IYtw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Elena Salomatkina <esalomatkina@ispras.ru>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 286/466] net/sched: cbs: Fix integer overflow in cbs_set_port_rate()
Date: Thu, 12 Dec 2024 15:57:35 +0100
Message-ID: <20241212144318.089957925@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 939425da18955..8c9a0400c8622 100644
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



