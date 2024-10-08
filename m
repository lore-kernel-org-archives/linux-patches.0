Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E3C41DED60;
	Tue,  8 Oct 2024 13:15:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728393344; cv=none; b=kDeKS9zXVJVDYLUSGA1d5SF7VRuu/Rt9rsIhUz6upDsfEwj5oazEeDu1mZ8YBJ7oPn8WRmbeTOxiIErCZk8MjWeNxleML4EUqeB3yAQ8i3Pf6eQBfjfUWLZl/UUG1keeHTY121OU/DzV4R3bHtUCtrUFqSkwvY4QVkaiuTjqp1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728393344; c=relaxed/simple;
	bh=cT4QLHrTjnuSMZtVBOf4MIzUSrvCESSzPQFt3XyX9qQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CZkR3UfMraQvfntlNoz+g2bZIA7yYcCtjRl3xjeewOB28jg1RqB4Shb6RZ03DuofRTT9V6Ul4CVUH24t5GabLJ5LZRCpD9wn58TJLw5tfgdpVefjagjcoerzdFeAFulIA3hMKnEu9IrjUQe9eBg+dfBymXDTQpcfe3hmThxGRgg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pdO2a0C9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pdO2a0C9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E176C4CEC7;
	Tue,  8 Oct 2024 13:15:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728393344;
	bh=cT4QLHrTjnuSMZtVBOf4MIzUSrvCESSzPQFt3XyX9qQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pdO2a0C9+NNcOB+8Iaf0BvbXXvqJvqEFl3fPhxazjPD0XO6fo/0dpZEBoecJTZFWP
	 IelCGC+5/m6Y2m0MCTblVmGYA12XfN1cZWqiGK4u0zpsc/rN5JEaIEcXfrO8vsmG1J
	 NMNc2IMrprCaC3qKHjTNQA/DyxpUop6tJvAS0jAM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 092/386] net: atlantic: Avoid warning about potential string truncation
Date: Tue,  8 Oct 2024 14:05:37 +0200
Message-ID: <20241008115633.071822584@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115629.309157387@linuxfoundation.org>
References: <20241008115629.309157387@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index ac4ea93bd8dda..eaef14ea5dd2e 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c
@@ -265,7 +265,7 @@ static void aq_ethtool_get_strings(struct net_device *ndev,
 		const int rx_stat_cnt = ARRAY_SIZE(aq_ethtool_queue_rx_stat_names);
 		const int tx_stat_cnt = ARRAY_SIZE(aq_ethtool_queue_tx_stat_names);
 		char tc_string[8];
-		int tc;
+		unsigned int tc;
 
 		memset(tc_string, 0, sizeof(tc_string));
 		memcpy(p, aq_ethtool_stat_names,
@@ -274,7 +274,7 @@ static void aq_ethtool_get_strings(struct net_device *ndev,
 
 		for (tc = 0; tc < cfg->tcs; tc++) {
 			if (cfg->is_qos)
-				snprintf(tc_string, 8, "TC%d ", tc);
+				snprintf(tc_string, 8, "TC%u ", tc);
 
 			for (i = 0; i < cfg->vecs; i++) {
 				for (si = 0; si < rx_stat_cnt; si++) {
-- 
2.43.0



