Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B998B2144C4;
	Thu, 12 Dec 2024 16:00:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734019228; cv=none; b=MbdluKIR56ll0+HlHHzlyiqZ0T+ueTtjfA80XBSwgHMjSE+pCUOF6+0gnnVUWEW3ZazNHqkgv4RgYJ88y7kWZHWIV4bys4Mg8nv1n6EbUptrTJK77bTV7nlAFAvpttT1Ymkq/Ayg1D38vhkNBNWp38BqkAatPUaGjJQlzJ7ClZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734019228; c=relaxed/simple;
	bh=Uu1aTUJtRY82/ETFh8HIAqWwr9St32oaYTY5ikFUqBM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cspc+iSG9U+j9TdDHhSN3Por9+vMlPKihQevqKecn0l/2AOe0GSe5POnb733pddKDU6rOCmY4iVvosYODDsWug/FJOFDU3P6BmEciaq+C6vuf+7uQhu6RiAWUMVqTQbt0bxrRIGRTonlLtYeTWGZ/Gz9weOEFcKsF0i/ltTVgH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iS8ldtIz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iS8ldtIz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29576C4CECE;
	Thu, 12 Dec 2024 16:00:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734019228;
	bh=Uu1aTUJtRY82/ETFh8HIAqWwr9St32oaYTY5ikFUqBM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iS8ldtIzoGgIWygjil4S1pMIjPignLcry8bMufZpRRKYOcQf7dTesyWmmkTR2jUjT
	 nZjn41qGVsw2lPMCYxTD+yNCPLKWFRoO0g60YUBpeg2CTe7icPE9vXe0hQ/q4SjgVr
	 Trt89khRGI5ZlZGsP/f1su44ikNhd9tXZoSXyMxM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Horman <horms@kernel.org>,
	Hangbin Liu <liuhangbin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 152/772] netdevsim: copy addresses for both in and out paths
Date: Thu, 12 Dec 2024 15:51:37 +0100
Message-ID: <20241212144356.213810852@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



