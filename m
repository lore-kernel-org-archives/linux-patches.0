Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D313D24C07D;
	Wed,  5 Mar 2025 18:13:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741198421; cv=none; b=GwhznDvvBJxLm0+6qEeFRyBPwfPs4CHraSxQXEoQveMXiSqvlf9lX94SUBZW8dlanaU6QEdRNWjsTz1zWjvQvcbOYPeXGW18VZjUBhlaqwVVVCCBscvXi6ATU03rIfkNhEHkcR6xGLE5bMlC0SsnQawdOPnar8Xdj9AmvoEAFio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741198421; c=relaxed/simple;
	bh=TU1vbfwQGDBcnF5GOajjKHaT1NVRz1lqydJAFbNgTnA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BGJU/Nywp3ejiDrnuhXWcUfqhir43PPZZR09wB5kl/D1USBouBsupd9G18BIQOuKoUnlTqwQUKTXWIASCfg8W1in3E2Yf2dB36YHSW4ksEXieFClIvrTO8/m/2318zaZ4ywlq9+rnmQ2DPWQ9W4Aix74/qVmTJXV69nBw6A4amU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mbrlwrgl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mbrlwrgl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F769C4CED1;
	Wed,  5 Mar 2025 18:13:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741198421;
	bh=TU1vbfwQGDBcnF5GOajjKHaT1NVRz1lqydJAFbNgTnA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mbrlwrgls3veGIqrTJvsSlEdY3giDpC4l3QXdXMMF3yaQ5hxoasfBhSuUcux01mp/
	 PPfDJ6RzU7rXuF8RpWFKiIr/nyG4jDBUOWFwQBGauPalSkumhSkyd5GHhsYayIG4ya
	 Wb9VUq4J1m0j+6XVjCWJb+RVKvaRABzvAh6JRlQY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shiraz Saleem <shirazsaleem@microsoft.com>,
	Konstantin Taranov <kotaranov@microsoft.com>,
	Long Li <longli@microsoft.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 005/157] RDMA/mana_ib: Allocate PAGE aligned doorbell index
Date: Wed,  5 Mar 2025 18:47:21 +0100
Message-ID: <20250305174505.494358062@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174505.268725418@linuxfoundation.org>
References: <20250305174505.268725418@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konstantin Taranov <kotaranov@microsoft.com>

[ Upstream commit 29b7bb98234cc287cebef9bccf638c2e3f39be71 ]

Allocate a PAGE aligned doorbell index to ensure each process gets a
separate PAGE sized doorbell area space remapped to it in mana_ib_mmap

Fixes: 0266a177631d ("RDMA/mana_ib: Add a driver for Microsoft Azure Network Adapter")
Signed-off-by: Shiraz Saleem <shirazsaleem@microsoft.com>
Signed-off-by: Konstantin Taranov <kotaranov@microsoft.com>
Link: https://patch.msgid.link/1738751405-15041-1-git-send-email-kotaranov@linux.microsoft.com
Reviewed-by: Long Li <longli@microsoft.com>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mana/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mana/main.c b/drivers/infiniband/hw/mana/main.c
index 67c2d43135a8a..457cea6d99095 100644
--- a/drivers/infiniband/hw/mana/main.c
+++ b/drivers/infiniband/hw/mana/main.c
@@ -174,7 +174,7 @@ static int mana_gd_allocate_doorbell_page(struct gdma_context *gc,
 
 	req.resource_type = GDMA_RESOURCE_DOORBELL_PAGE;
 	req.num_resources = 1;
-	req.alignment = 1;
+	req.alignment = PAGE_SIZE / MANA_PAGE_SIZE;
 
 	/* Have GDMA start searching from 0 */
 	req.allocated_resources = 0;
-- 
2.39.5



