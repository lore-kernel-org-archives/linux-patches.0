Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88F491C6AB;
	Mon,  4 Mar 2024 21:53:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709589202; cv=none; b=bj3snowzX1afeBz5udh3liHVqLR0RzAs+EISPOaGy4TnEqQNHLaedEFupCtYNABaRuwlWMZfRrEXaTRiad6WVrDJjuyDN2CSrXrxPDLldYhH69GvdPdaJXgk5LakY+1j+oN8ZRZ8TX/1LxSX/sLr0SuAa7TRatZd/u63n/xxRt8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709589202; c=relaxed/simple;
	bh=eb3slK7H1to/tnGqqimTI/D/pAP9VfftVmW8h7+aaC8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hSjt8cZNVOUkuY5yXlAY14FVHofH2J1eKnV9+bEautJ1FamoCHhKTpW+ORincz1E0GSxNUesv0LGL6D2QNuCrT95/3/d0i8a6peD+B3pli9iJ6aZ+jgrMRKX66aVLQQH9tPs1NGwWB0AIEGOTETYLn1dLx3sDYLHTbvPIlEu5zk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X6sFBU3v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X6sFBU3v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DF44C433F1;
	Mon,  4 Mar 2024 21:53:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709589202;
	bh=eb3slK7H1to/tnGqqimTI/D/pAP9VfftVmW8h7+aaC8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X6sFBU3vhHvN6aoFEbGCDACOymc0InCGbWLqio1PurkQ9J4jLkVG13uoXuxH2JRwU
	 X2jUCCe11LotCgWhjcw9ITt/4JnA6Fzsj2XTWlcTqcKv+TfCwwaDt8PyskGx/SpWPc
	 WTYcGSVc2AJCw5hKCOWMVBRMf9/hYZ9kzBwdZUZg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yunjian Wang <wangyunjian@huawei.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 05/84] tun: Fix xdp_rxq_infos queue_index when detaching
Date: Mon,  4 Mar 2024 21:23:38 +0000
Message-ID: <20240304211542.521978825@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211542.332206551@linuxfoundation.org>
References: <20240304211542.332206551@linuxfoundation.org>
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

From: Yunjian Wang <wangyunjian@huawei.com>

[ Upstream commit 2a770cdc4382b457ca3d43d03f0f0064f905a0d0 ]

When a queue(tfile) is detached, we only update tfile's queue_index,
but do not update xdp_rxq_info's queue_index. This patch fixes it.

Fixes: 8bf5c4ee1889 ("tun: setup xdp_rxq_info")
Signed-off-by: Yunjian Wang <wangyunjian@huawei.com>
Link: https://lore.kernel.org/r/1708398727-46308-1-git-send-email-wangyunjian@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/tun.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 603530e6cd7b9..42bf0a3ec632e 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -654,6 +654,7 @@ static void __tun_detach(struct tun_file *tfile, bool clean)
 				   tun->tfiles[tun->numqueues - 1]);
 		ntfile = rtnl_dereference(tun->tfiles[index]);
 		ntfile->queue_index = index;
+		ntfile->xdp_rxq.queue_index = index;
 		rcu_assign_pointer(tun->tfiles[tun->numqueues - 1],
 				   NULL);
 
-- 
2.43.0



