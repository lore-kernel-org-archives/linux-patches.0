Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 570813B530C;
	Thu, 15 Jan 2026 16:57:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496279; cv=none; b=c2cuB6g9vFd+rasVqR5QRVw4VhU7imDfxWjGK45PXpiMu1sKxsiq03j7mwfixabEttEWPOFiAYqAWDKvdXocpkeY0wNyOMSdLPzsQYWfceEbPUJ9bbzFGnK79U7u5UX2iZyJw5u+sCGwjoOCeS9vny0pwGRScUY4UCpGKNWg4xA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496279; c=relaxed/simple;
	bh=3hkNJClqifqTgwf2szeuL5GqqSABnGYavzeM5YK/Og4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=klXqBCzRktWZfN/NWtD8haqZ8wqshpIH25iDnkwV5swyyeMIRvLMwZwrL4AzLnlWU0Q1mge2M7WhY04He221ShgUAepvqn2gubeJaEGXwbCn6TabP9L8zH7MhdlJuTeiDLpofI5UdxQPsC/S1LUsQkqb+yTww9hKxqsGplZ68+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Pnqy0ye0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Pnqy0ye0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6D81C116D0;
	Thu, 15 Jan 2026 16:57:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496279;
	bh=3hkNJClqifqTgwf2szeuL5GqqSABnGYavzeM5YK/Og4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Pnqy0ye0xjaDmSuNR6xMueQTzxunif36RDIsc656Wy4kLwjQdB+7Xdx226TI4qMIM
	 249PoH87oCV5GKZyKCNEgXKpaamuR3UNTF6pWsjfC1hIXgmKFPdjMocLRCoAIijVtC
	 jyiHqh/Nk2KM4BiDLjunhDBPqDSAhkOMiuXmWE3A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 139/181] net: sfp: return the number of written bytes for smbus single byte access
Date: Thu, 15 Jan 2026 17:47:56 +0100
Message-ID: <20260115164207.336330865@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164202.305475649@linuxfoundation.org>
References: <20260115164202.305475649@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maxime Chevallier <maxime.chevallier@bootlin.com>

[ Upstream commit 13ff3e724207f579d3c814ee05516fefcb4f32e8 ]

We expect the SFP write accessors to return the number of written bytes.
We fail to do so for single-byte smbus accesses, which may cause errors
when setting a module's high-power state and for some cotsworks modules.

Let's return the amount of written bytes, as expected.

Fixes: 7662abf4db94 ("net: phy: sfp: Add support for SMBus module access")
Signed-off-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://patch.msgid.link/20260105151840.144552-1-maxime.chevallier@bootlin.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/sfp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
index 0401fa6b24d25..6b4dd906b804f 100644
--- a/drivers/net/phy/sfp.c
+++ b/drivers/net/phy/sfp.c
@@ -763,7 +763,7 @@ static int sfp_smbus_byte_write(struct sfp *sfp, bool a2, u8 dev_addr,
 		dev_addr++;
 	}
 
-	return 0;
+	return data - (u8 *)buf;
 }
 
 static int sfp_i2c_configure(struct sfp *sfp, struct i2c_adapter *i2c)
-- 
2.51.0



