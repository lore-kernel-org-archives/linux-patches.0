Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F3C3403B13;
	Tue, 21 Jul 2026 20:28:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784665699; cv=none; b=V1cQYNbsRwQTwLqR6swQxxN1bsRirN4qaPP8+zk+HlS8Ev6s0bVtq6Q+egAkrEmhLwMrW/lVv9Dvus0ITqEqeOTOMxNdaQGy43eMG0bjCrJpHj05Su3VaauU9Rd0JprgmkUUXsXLxl9TscvIc3rZurjBofCMeRcLdyObbTfTXGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784665699; c=relaxed/simple;
	bh=V/TnjtvxBOTn3qaMwuUlK2MKXLE3wHe4FpFHXZBZoHI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Es9kG8yFU2CrpzR6Fo9GqdEwL/sA5TuVEFqC09H2spPgEPkwg5dM5JWqcl6UC3S2iF7Cx3A8K1J2TGxoBfGE4ipMQn/jp/UZi9Axl55wOj0kWk6h2GGV0wRHGKUf1MV5AgN5DqRO4YG2zTu168jNKw8xoTkRWZ9teshTw0N+1vU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Jtp182Cq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Jtp182Cq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F4D41F000E9;
	Tue, 21 Jul 2026 20:28:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784665694;
	bh=lle9S/zDgDybyjyKllCwDr8d+1QtZPBVUuB+QTG3Qyg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Jtp182CqrGiFJD7J292ZlEO5YS4Zz3P33nmxm3UkRn0jh81OMwrGrELTnvjeMG3Bj
	 N0fkLs4ZGf0VBD0/V166d7cwkbx/A89ca0yxij2fphYyPxbze9uzb1Je+BGWn7v2J3
	 Yj0UVTf0Ncb8d+F58mXRRnhHrrcUMpc4VfvSNL0c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stepan Ionichev <sozdayvek@gmail.com>,
	Sudeep Holla <sudeep.holla@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0400/1266] clk: scpi: Unregister child clock providers on remove
Date: Tue, 21 Jul 2026 17:13:57 +0200
Message-ID: <20260721152450.781990661@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stepan Ionichev <sozdayvek@gmail.com>

[ Upstream commit b79d9b5747d961516c35ef4d5e91efa579fd3e9a ]

SCPI clock providers are registered for each child node in
scpi_clk_add(), but scpi_clocks_remove() unregisters the parent node on
each iteration.

of_clk_del_provider() matches providers by the node used at registration
time, so passing the parent node leaves the child providers registered.
This leaks the provider allocations and the node references held by the
clock provider core.

Pass the child node to of_clk_del_provider() so the remove path matches
the probe path.

Fixes: cd52c2a4b5c4 ("clk: add support for clocks provided by SCP(System Control Processor)")
Signed-off-by: Stepan Ionichev <sozdayvek@gmail.com>
Link: https://patch.msgid.link/20260513090900.5323-1-sozdayvek@gmail.com
(sudeep.holla: Updated commit title and message a bit)
Signed-off-by: Sudeep Holla <sudeep.holla@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/clk-scpi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/clk-scpi.c b/drivers/clk/clk-scpi.c
index 108b697bd317dc..5ab46a537b5d31 100644
--- a/drivers/clk/clk-scpi.c
+++ b/drivers/clk/clk-scpi.c
@@ -256,7 +256,7 @@ static void scpi_clocks_remove(struct platform_device *pdev)
 	}
 
 	for_each_available_child_of_node(np, child)
-		of_clk_del_provider(np);
+		of_clk_del_provider(child);
 }
 
 static int scpi_clocks_probe(struct platform_device *pdev)
-- 
2.53.0



