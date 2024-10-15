Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56BC61E764B;
	Tue, 15 Oct 2024 11:58:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728993490; cv=none; b=KkVv1KizNWN09hyZ1aAw8CiLmhiVnjifmdi8Sn5J2OD8trk1UXQZjwuy+nGj7tId5JvGP1SZfbkzUc9qQXYRd51OOBcoud6tieMTCT8sNdfmMmbD2djayt3kZyQ8QL37UYn8If/SrjW4gtzSP0RsXJEGBYpdrxXMJcp0arNucfs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728993490; c=relaxed/simple;
	bh=9Tk2BmtdrsmNjYyzyW768j1Y9bx4XrUUQXr5mJ19KHc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nZFGpcXw0LkaffQrP575aUjhq4wBM0IQwzkc8W6cdlRvqO0GPJIyBvPXTJpb10Ee+sGDltVhK8THHb+DEVcZq0ku7aAHNsC1uHNU6RTZKdVqdzqeBdwLUF1Z73bm88xDQgt2qx4B48E9H/nI/Bw4RGsj0KGVGKfKUYFTTHYY4sI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UQ9mVB7C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UQ9mVB7C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1236C4CEC6;
	Tue, 15 Oct 2024 11:58:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728993490;
	bh=9Tk2BmtdrsmNjYyzyW768j1Y9bx4XrUUQXr5mJ19KHc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UQ9mVB7CgQNaKypH2oK9xDqiBad1/HV0vwR5UFniE/JZJbcKGHLh5MTuXpJRGyHrj
	 G3EkdiXEE+Ymsk3WUhf+z0K8GUp7fBSc6F3A24G/hYU9So/yLoklXV9wEDw3Y+rz/D
	 QtJDhJRenW7CslUUvaI3P/iiwr8Oq4k+rdKBZl74=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 428/691] net: atlantic: Avoid warning about potential string truncation
Date: Tue, 15 Oct 2024 13:26:16 +0200
Message-ID: <20241015112457.330416279@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Simon Horman <horms@kernel.org>

[ Upstream commit 5874e0c9f25661c2faefe4809907166defae3d7f ]

W=1 builds with GCC 14.2.0 warn that:

.../aq_ethtool.c:278:59: warning: ‘%d’ directive output may be truncated writing between 1 and 11 bytes into a region of size 6 [-Wformat-truncation=]
  278 |                                 snprintf(tc_string, 8, "TC%d ", tc);
      |                                                           ^~
.../aq_ethtool.c:278:56: note: directive argument in the range [-2147483641, 254]
  278 |                                 snprintf(tc_string, 8, "TC%d ", tc);
      |                                                        ^~~~~~~
.../aq_ethtool.c:278:33: note: ‘snprintf’ output between 5 and 15 bytes into a destination of size 8
  278 |                                 snprintf(tc_string, 8, "TC%d ", tc);
      |                                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

tc is always in the range 0 - cfg->tcs. And as cfg->tcs is a u8,
the range is 0 - 255. Further, on inspecting the code, it seems
that cfg->tcs will never be more than AQ_CFG_TCS_MAX (8), so
the range is actually 0 - 8.

So, it seems that the condition that GCC flags will not occur.
But, nonetheless, it would be nice if it didn't emit the warning.

It seems that this can be achieved by changing the format specifier
from %d to %u, in which case I believe GCC recognises an upper bound
on the range of tc of 0 - 255. After some experimentation I think
this is due to the combination of the use of %u and the type of
cfg->tcs (u8).

Empirically, updating the type of the tc variable to unsigned int
has the same effect.

As both of these changes seem to make sense in relation to what the code
is actually doing - iterating over unsigned values - do both.

Compile tested only.

Signed-off-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20240821-atlantic-str-v1-1-fa2cfe38ca00@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c b/drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c
index 715859cb6560a..df5076540cf1e 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c
@@ -256,7 +256,7 @@ static void aq_ethtool_get_strings(struct net_device *ndev,
 		const int rx_stat_cnt = ARRAY_SIZE(aq_ethtool_queue_rx_stat_names);
 		const int tx_stat_cnt = ARRAY_SIZE(aq_ethtool_queue_tx_stat_names);
 		char tc_string[8];
-		int tc;
+		unsigned int tc;
 
 		memset(tc_string, 0, sizeof(tc_string));
 		memcpy(p, aq_ethtool_stat_names,
@@ -265,7 +265,7 @@ static void aq_ethtool_get_strings(struct net_device *ndev,
 
 		for (tc = 0; tc < cfg->tcs; tc++) {
 			if (cfg->is_qos)
-				snprintf(tc_string, 8, "TC%d ", tc);
+				snprintf(tc_string, 8, "TC%u ", tc);
 
 			for (i = 0; i < cfg->vecs; i++) {
 				for (si = 0; si < rx_stat_cnt; si++) {
-- 
2.43.0



