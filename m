Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA1791DF265;
	Tue,  8 Oct 2024 12:53:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728392012; cv=none; b=FpN0xkP/fEgsKGka1yZYrir16BNh4ReNdz5ngijykXCgkqGnA8iboYfNMQy+dvd7CAWsrMc98yMy+vkaNmYrRh0XWIPaOEhD7qMqfvL4ImbVfvJBpUCKAigBkQsGwnyUSMoT75ORoxMmz3ThEkDrJE8dHNcKgDN6Jb2Iguub0LM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728392012; c=relaxed/simple;
	bh=FrWj1nSZGzbZvT/MangkpWs/ni2Effe3Pb7V4Cdh5io=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j60NwgOGmSQwqS8MhvyvEBE7HD5wtLi4OruVxTr4nm7Y4WT0jmpJdBFvPkWrLEDMyzYVpFTL3iW/4UCw+9zcSPn6Ghxe8bBDHwPjppk3ii8MIO/vSD7pLqHRpnlHpQt4N9foJxIsOCNR9ovXv01vbzQIwFdp2msNuJnnxQhgLhQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xvmgk8Y/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xvmgk8Y/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F90BC4CECC;
	Tue,  8 Oct 2024 12:53:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728392012;
	bh=FrWj1nSZGzbZvT/MangkpWs/ni2Effe3Pb7V4Cdh5io=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xvmgk8Y/1OZiojtlt5LsMjfdtH8O4qxPyvusUwrVkG1CTckd1M0jkU/Kv9bFQclyO
	 x1m1aC6OXvXsmJsOfYx51rYw869VbPc5fnRBrb/zCPHwCA9aLcfSqIH7GlXAdbahVQ
	 j1eLiOawlMvubr65af6XfauWeyMOpmZEJHMIulqk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 291/558] of/irq: Refer to actual buffer size in of_irq_parse_one()
Date: Tue,  8 Oct 2024 14:05:21 +0200
Message-ID: <20241008115713.775608943@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit 39ab331ab5d377a18fbf5a0e0b228205edfcc7f4 ]

Replace two open-coded calculations of the buffer size by invocations of
sizeof() on the buffer itself, to make sure the code will always use the
actual buffer size.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/r/817c0b9626fd30790fc488c472a3398324cfcc0c.1724156125.git.geert+renesas@glider.be
Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/of/irq.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/of/irq.c b/drivers/of/irq.c
index 8fd63100ba8f0..d67b69cb84bfe 100644
--- a/drivers/of/irq.c
+++ b/drivers/of/irq.c
@@ -357,8 +357,8 @@ int of_irq_parse_one(struct device_node *device, int index, struct of_phandle_ar
 	addr = of_get_property(device, "reg", &addr_len);
 
 	/* Prevent out-of-bounds read in case of longer interrupt parent address size */
-	if (addr_len > (3 * sizeof(__be32)))
-		addr_len = 3 * sizeof(__be32);
+	if (addr_len > sizeof(addr_buf))
+		addr_len = sizeof(addr_buf);
 	if (addr)
 		memcpy(addr_buf, addr, addr_len);
 
-- 
2.43.0



