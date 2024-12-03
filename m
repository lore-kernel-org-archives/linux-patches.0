Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FEF91DAC9F;
	Tue,  3 Dec 2024 15:48:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240929; cv=none; b=VqJdQMy4EvzxUCa1W8VSawuG0dddrZ3COownVJTT/m3MiHNk5UZuHGlyk1vwCJavTCVUOsABsV6tHzWLa9wjuamgk2zzUmupfFYiiy+klmOJkiJrPZ9HD73ejbtrVjK0ni1nnryJO8qza8V0kzu7BdXA5/FC4JJAHTc/kWGhhec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240929; c=relaxed/simple;
	bh=oMqbbhhE9JYsLSYW2pIPPfoCRBhXavXzrcmRkEMealU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J5vJRHLXPHDNP+mbUEhAzvCxtjWqFTaqv2h2rjVtF4VkPVlkqyIEbGfZ2kdBRMQsYS3CY1wP764ehgvS6Ua3eZQNXmNd4+TdzAXiLzg5IyynOiINWRMqDuLW7/jwjIFmVaajOx9cfyIhzf/ww6CKAsJz1Lr7FzoZRFWquPt3N/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BTZcJwvR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BTZcJwvR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E119C4CECF;
	Tue,  3 Dec 2024 15:48:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240928;
	bh=oMqbbhhE9JYsLSYW2pIPPfoCRBhXavXzrcmRkEMealU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BTZcJwvRy+vdldFxBDusxdstARdG1MjIHn3u5+eioCZKyepecQaF8jLZMKz8QvEBQ
	 9tw8vAUrDJ5fbSpqXjqHhG4yDT+dhF+pqbh4QmiWyFeSPhbwMxcbwtpmxxCjweyBHg
	 hYyxXuOQTB5EnnkNIoaWoRVDtt1sLk/ZAsB3SSv0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Horman <horms@kernel.org>,
	Hangbin Liu <liuhangbin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 246/826] netdevsim: copy addresses for both in and out paths
Date: Tue,  3 Dec 2024 15:39:33 +0100
Message-ID: <20241203144753.361788722@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

From: Hangbin Liu <liuhangbin@gmail.com>

[ Upstream commit 2cf567f421dbfe7e53b7e5ddee9400da10efb75d ]

The current code only copies the address for the in path, leaving the out
path address set to 0. This patch corrects the issue by copying the addresses
for both the in and out paths. Before this patch:

  # cat /sys/kernel/debug/netdevsim/netdevsim0/ports/0/ipsec
  SA count=2 tx=20
  sa[0] tx ipaddr=0.0.0.0
  sa[0]    spi=0x00000100 proto=0x32 salt=0x0adecc3a crypt=1
  sa[0]    key=0x3167608a ca4f1397 43565909 941fa627
  sa[1] rx ipaddr=192.168.0.1
  sa[1]    spi=0x00000101 proto=0x32 salt=0x0adecc3a crypt=1
  sa[1]    key=0x3167608a ca4f1397 43565909 941fa627

After this patch:

  = cat /sys/kernel/debug/netdevsim/netdevsim0/ports/0/ipsec
  SA count=2 tx=20
  sa[0] tx ipaddr=192.168.0.2
  sa[0]    spi=0x00000100 proto=0x32 salt=0x0adecc3a crypt=1
  sa[0]    key=0x3167608a ca4f1397 43565909 941fa627
  sa[1] rx ipaddr=192.168.0.1
  sa[1]    spi=0x00000101 proto=0x32 salt=0x0adecc3a crypt=1
  sa[1]    key=0x3167608a ca4f1397 43565909 941fa627

Fixes: 7699353da875 ("netdevsim: add ipsec offload testing")
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
Link: https://patch.msgid.link/20241010040027.21440-3-liuhangbin@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/netdevsim/ipsec.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/net/netdevsim/ipsec.c b/drivers/net/netdevsim/ipsec.c
index f0d58092e7e96..3612b0633bd17 100644
--- a/drivers/net/netdevsim/ipsec.c
+++ b/drivers/net/netdevsim/ipsec.c
@@ -176,14 +176,13 @@ static int nsim_ipsec_add_sa(struct xfrm_state *xs,
 		return ret;
 	}
 
-	if (xs->xso.dir == XFRM_DEV_OFFLOAD_IN) {
+	if (xs->xso.dir == XFRM_DEV_OFFLOAD_IN)
 		sa.rx = true;
 
-		if (xs->props.family == AF_INET6)
-			memcpy(sa.ipaddr, &xs->id.daddr.a6, 16);
-		else
-			memcpy(&sa.ipaddr[3], &xs->id.daddr.a4, 4);
-	}
+	if (xs->props.family == AF_INET6)
+		memcpy(sa.ipaddr, &xs->id.daddr.a6, 16);
+	else
+		memcpy(&sa.ipaddr[3], &xs->id.daddr.a4, 4);
 
 	/* the preparations worked, so save the info */
 	memcpy(&ipsec->sa[sa_idx], &sa, sizeof(sa));
-- 
2.43.0



