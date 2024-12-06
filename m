Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E87961494D9;
	Fri,  6 Dec 2024 14:43:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733496225; cv=none; b=QxwSk73gVqAkC5wRd8WIqeyNHaC6ZOdXfH1lI0UIaMlhZetOa92ZJjXm5k7edphac/0Pbd2V3HNXGJlr3oSCjkncm518UaJLzgo0QRHe9RGW1qzyoLKPGxkWVhn25GxctD4sLazA2vcKGgjVEL4+EVJyGcLqgliYhG700YRcWwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733496225; c=relaxed/simple;
	bh=N5YJr9tdmGMD00tD4gdOPToWNb+ujozG7qjmMvwIXnQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GPuY8ZdQlsLKwwN41x1hOAwtevc8+iFFK9DudjiupJAxIvHfMvnj2Pu+NtfGafunil4aai6Qr3D5q9f884+s+p2squjV8LGu8Gf6iacRAtcfpIHpKH1FZX3A6Ki/oAbIdOyJ5mihlwQjDnToyeU+ZI/e4YXQ+8LdUnm8DSn89xo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MraL8uQN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MraL8uQN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63C9FC4CED1;
	Fri,  6 Dec 2024 14:43:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733496224;
	bh=N5YJr9tdmGMD00tD4gdOPToWNb+ujozG7qjmMvwIXnQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MraL8uQNFvIuX/2Elw62Be2SRaMZUuWevnby9Uz2Q6dW+Z1DSMzGVmOD/jTZnVfA1
	 43/nB89RejPYINFA3ViyWxEVdrwhYD1GHLfg5+oY0UmhMX6tAs7zLmUfT5ZRVhpfpf
	 uckAnAwY1RMsQm+k9+AobnLdH5+d1PhQ0V7I13Y8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Frank Li <Frank.Li@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: [PATCH 6.12 081/146] i3c: master: Fix miss free init_dyn_addr at i3c_master_put_i3c_addrs()
Date: Fri,  6 Dec 2024 15:36:52 +0100
Message-ID: <20241206143530.779769348@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143527.654980698@linuxfoundation.org>
References: <20241206143527.654980698@linuxfoundation.org>
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

From: Frank Li <Frank.Li@nxp.com>

commit 3082990592f7c6d7510a9133afa46e31bbe26533 upstream.

if (dev->boardinfo && dev->boardinfo->init_dyn_addr)
                                      ^^^ here check "init_dyn_addr"
	i3c_bus_set_addr_slot_status(&master->bus, dev->info.dyn_addr, ...)
						             ^^^^
							free "dyn_addr"
Fix copy/paste error "dyn_addr" by replacing it with "init_dyn_addr".

Cc: stable@kernel.org
Fixes: 3a379bbcea0a ("i3c: Add core I3C infrastructure")
Reviewed-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Link: https://lore.kernel.org/r/20241001162608.224039-1-Frank.Li@nxp.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i3c/master.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/i3c/master.c
+++ b/drivers/i3c/master.c
@@ -1417,7 +1417,7 @@ static void i3c_master_put_i3c_addrs(str
 					     I3C_ADDR_SLOT_FREE);
 
 	if (dev->boardinfo && dev->boardinfo->init_dyn_addr)
-		i3c_bus_set_addr_slot_status(&master->bus, dev->info.dyn_addr,
+		i3c_bus_set_addr_slot_status(&master->bus, dev->boardinfo->init_dyn_addr,
 					     I3C_ADDR_SLOT_FREE);
 }
 


