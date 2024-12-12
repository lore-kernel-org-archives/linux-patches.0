Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF821223327;
	Thu, 12 Dec 2024 16:49:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734022178; cv=none; b=SJTZxcymRoj3jln3vOAGOmBnKeQ9ZuriGY4ckvKWwvp0aU5qFE2Wvnfmu5cFgVtwe0x42OTlm29WzG0AT2DmaH8kUF/cEwFo1nG/iJ0NTPuWq5LcBPCBq9FHzr9kLLkXGomUw8hCNwtRGSWVbLmqnq8IKf/1GV5LRCyLcFbWQZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734022178; c=relaxed/simple;
	bh=oMVUU25IOmj2W0t9O+lBYwIrERt+DBYknH5yE/wcDIw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AJnDx5c3yunyo5TYjbOYayMIitDSSPI3qCgys78t9DRAo4aGi0NvKW2p0PhPiStslH55HtEf67zJw9sJBaABKdbPE56Oox6zLw5fYYAEBrp8E+KO0L5q0BrXwrmmywYpumktwI/bR4DsXOsxFzhHBF+z8T4V54bGZ4SCDM+q59I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Co/1ihXS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Co/1ihXS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EB05C4CECE;
	Thu, 12 Dec 2024 16:49:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734022178;
	bh=oMVUU25IOmj2W0t9O+lBYwIrERt+DBYknH5yE/wcDIw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Co/1ihXSChjEgn02g+vtv/yU+Rc7Vhb9KMGQdrS0Me8UOkgjBFmaZKk3+NFwKIMbq
	 44WDV6M3qc77jCvbKT17dofMl+gCs77XKRHWzlMqsj/zLLwaMxwNe46TaLYPzOMchX
	 yVnvrqyPEWiCPfBZolsTgrf100neEo/5/QDZqjD0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Horman <horms@kernel.org>,
	Hangbin Liu <liuhangbin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 170/565] netdevsim: copy addresses for both in and out paths
Date: Thu, 12 Dec 2024 15:56:05 +0100
Message-ID: <20241212144318.193387984@linuxfoundation.org>
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
index 386336a38f349..feca55eef9938 100644
--- a/drivers/net/netdevsim/ipsec.c
+++ b/drivers/net/netdevsim/ipsec.c
@@ -171,14 +171,13 @@ static int nsim_ipsec_add_sa(struct xfrm_state *xs)
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



