Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 312FB1C6FE1;
	Tue, 11 Nov 2025 00:58:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822720; cv=none; b=n9QnFZYoe6N1UJpkmMVANnOMvmKDkN8XDjazhAir9oocXnpX60kFINE/DXwj+gOTF9DNtp720L+NAMXDsLnR3VWPdDcLCfMeQbgQ0Fu5h7ijkHM+PBeNP7WW9zBNZIqpWAJJIdcg4I+4MBRMyRfz8zGi4gXNF0FjJ8hvBaxs0JM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822720; c=relaxed/simple;
	bh=kAVxVOjgVrgH1XYJKKDIvewkFgRF9+v6ypsWWgw/IIk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ry1ecgoa6+ZIwyPYLRpNy3Pa1iWnG1kd1r5WT4hvVWRrG9UjVCJZvVz+h2aQdEpOzk3FYbTGUesYlk5WMcZ3xyL2djXZsXBowc+mk1w4k/W3LuVzaYdHKI6pdKAWNjc7lA7ame1BVSY00rBktaemMw+upEuloBvwIPIhgmGvX4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LpPt0Dgp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LpPt0Dgp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF077C4CEF5;
	Tue, 11 Nov 2025 00:58:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822720;
	bh=kAVxVOjgVrgH1XYJKKDIvewkFgRF9+v6ypsWWgw/IIk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LpPt0DgpXJZPmef98d/CMf1OdAozLHWi5RFhFFEfjyz2aYPU1aCeQLkFBVXg+ePKT
	 JrF9pXrc3pZrr6X1jy3BTidJO6awnUYMDXhS3o3oVT7mF8sbzrrVOPOQh7M6QciUkE
	 OmgzSsbDLq+ZSl5PZjtxxsuIIxZpBd9prgAXVQ5g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Nishanth Menon <nm@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 092/565] soc: ti: pruss: dont use %pK through printk
Date: Tue, 11 Nov 2025 09:39:08 +0900
Message-ID: <20251111004529.034571818@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Weißschuh <thomas.weissschuh@linutronix.de>

[ Upstream commit a5039648f86424885aae37f03dc39bc9cb972ecb ]

In the past %pK was preferable to %p as it would not leak raw pointer
values into the kernel log.
Since commit ad67b74d2469 ("printk: hash addresses printed with %p")
the regular %p has been improved to avoid this issue.
Furthermore, restricted pointers ("%pK") were never meant to be used
through printk(). They can still unintentionally leak raw pointers or
acquire sleeping locks in atomic contexts.

Switch to the regular pointer formatting which is safer and
easier to reason about.

Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Link: https://lore.kernel.org/r/20250811-restricted-pointers-soc-v2-1-7af7ed993546@linutronix.de
Signed-off-by: Nishanth Menon <nm@ti.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/ti/pruss.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/soc/ti/pruss.c b/drivers/soc/ti/pruss.c
index 3ec758f50e248..f588153e8178d 100644
--- a/drivers/soc/ti/pruss.c
+++ b/drivers/soc/ti/pruss.c
@@ -449,7 +449,7 @@ static int pruss_of_setup_memories(struct device *dev, struct pruss *pruss)
 		pruss->mem_regions[i].pa = res.start;
 		pruss->mem_regions[i].size = resource_size(&res);
 
-		dev_dbg(dev, "memory %8s: pa %pa size 0x%zx va %pK\n",
+		dev_dbg(dev, "memory %8s: pa %pa size 0x%zx va %p\n",
 			mem_names[i], &pruss->mem_regions[i].pa,
 			pruss->mem_regions[i].size, pruss->mem_regions[i].va);
 	}
-- 
2.51.0



