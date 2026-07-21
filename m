Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9AF0415F14;
	Tue, 21 Jul 2026 19:19:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661564; cv=none; b=KgDwIl8jkqTeeEm6nSpDaVHTuUtkO4DHemiZBpapWPoyVZYWzUnENL8xO84c+Qe7D4P5AcbA9VlvKbOVAp3PkC8uny/iB7Po506l02AEjccB7+TFZMNDjeSJHtcZoIl9dgQg84pNbxSQ6JJi/uMC1H/r+UBiPXovkiUncW7A0R8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661564; c=relaxed/simple;
	bh=Nb/JJBdJQOO+H94bVnVZp29kJBzToXBTYN5/p2Pr9Ew=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FQWZFSXvGuaTt3uDyETz9otufTYZvQOlRPqzIWkYB0FhJmedUffw2PUlUfGGD/wKBu0VMljikZLXWNFG7OVJEjJ0XAPS15QNwjX6lU4OsOiB446IrT/bO5crXfuxZofzByDAx3gDaEIbc0ZRZUNV+QLjiF9dkPr5436rsOzWCwQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MGQ/kY/O; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MGQ/kY/O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C9AC1F000E9;
	Tue, 21 Jul 2026 19:19:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661563;
	bh=/FkaRndpTIgebSWBRHyIYgf+NpFc+k/luQHmEr5ryzU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MGQ/kY/OF0rMHX89aqpjxjna4Km/JaR5Uzz73I4wjnZEpNzxioS2xX2Nhi9fmbBEM
	 mLkGvHzXDNmFaGsXdDqMw2TfBq6oKeYMSVcEaRdHvfc9tPHqvx8aeYoELNjEXC6jLk
	 JS8U2f95QH092vQG9+mm3k4nPOxl0PiDAzf4jK84=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stepan Ionichev <sozdayvek@gmail.com>,
	Sudeep Holla <sudeep.holla@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0114/1276] clk: scpi: Unregister child clock providers on remove
Date: Tue, 21 Jul 2026 17:09:17 +0200
Message-ID: <20260721152448.650354401@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 19d530d52e647b..50ac1cd2557857 100644
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



