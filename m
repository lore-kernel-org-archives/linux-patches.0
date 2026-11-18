Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019741;
	b=pFZaN47oOpyZsZnX0F1oISkEJxF9pNd06aodwXIVkmg40tDBwUcVYNiWeAj8nYJtpojx
	 C1cTRAv7JiyAmRotkQblciVuJcyAyOfF/IP9PJUmtuQJfTKW4K6XerN7isJr9IKgO4c+A
	 sADKRztKCsRQKrmDvC00I+KnlS+lbotjRorq+8hgKssvYtVx8mk2bnKzkImAmfdSRKXaX
	 tB3+7X0UhNkbwFuYE8XIxN4eQoMoFb/Z/GSerP0or8kSodUMMNscMf8LeRf28DZEBX3Sj
	 nTG5feSfbka7W7UlODVUJuG8wbaH70nW5GuPGafKXZaXeRxUsJZD/Ow6HRl/5bDzzBg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019741;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gyk//C3bWwM3H9GYTaUQ1JVjRNuKb68sLhBJ19fEcWk=;
	b=tU0n/HanhjSWNuiJexH0Cq0j+hSMQhYQvG6gtK9UV2jLADkSHQmglPmyEyvoCG6C76aL
	 wZcocIsqDfdpufouqw/iGFVCEgalDqPB21J/pOGxV3JuVPH7rmFkQwMCRfBK5Zqn6yfbD
	 44ShXQAJJf3lkLRaFWCktUzU4S68lo1l6ebFnKz9kXIEEl6fpOaZZAwO3rjJwyHJMviTI
	 AzOaXlShdgL1G1VJPkvPL01dcRtJw6hZLelwuXEjjK5lADNlpruRm9gt0R+RJt9vyq7FE
	 8khZqthHV4Y5wRupCpoMMfInK9OkRXr8zqQrt1j6kIW0fetp8fhRwf2E2IPvyMnn8Pg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="A3vj1s/T";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D157606A31C;
	Wed, 18 Nov 2026 16:35:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=A3vj1s/T
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDA5D1F000C4;
	Wed, 18 Nov 2026 16:35:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019741;
	bh=gyk//C3bWwM3H9GYTaUQ1JVjRNuKb68sLhBJ19fEcWk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A3vj1s/TcNw3+M+5Mp+G3CAPK6T0i9p9QLZJie8vAq3chfymrYvfbjCY+oB/yRg9X
	 Ee9naBNTgMDrbgn+O9cdotC9HXHiiBUsj23CZeE47RF+8Ny2XNSEiygHDhwPYm80oX
	 iKnOOZbPinakylqeI4zKrvNgpovDxT6xRAbKSX9U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1664/2651] mtd: rawnand: pl353: fix clk reference leak in pl35x_nfc_setup_interface()
Date: Wed, 18 Nov 2026 15:48:24 +0100
Message-ID: <20261118150347.625189580@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haotian Zhang <vulab@iscas.ac.cn>

[ Upstream commit 1ce45f0e74d60e8279ed380c97047e6c351aee1b ]

pl35x_nfc_setup_interface() obtains a reference to the SMC "memclk" with
of_clk_get_by_name() and only uses it to read the clock rate. The
reference is never released: the function has many early return paths
and no clk_put() call anywhere, so the clock reference is leaked.

The hook is invoked repeatedly by the NAND core (nand_reset(),
nand_setup_interface() and the NAND_DATA_IFACE_CHECK_ONLY mode probing
loops), so the reference count keeps growing.

Release the clock reference with clk_put() as soon as its rate has been
read.

Fixes: 08d8c62164a3 ("mtd: rawnand: pl353: Add support for the ARM PL353 SMC NAND controller")
Assisted-by: DeepSeek-V4.1-Flash
Signed-off-by: Haotian Zhang <vulab@iscas.ac.cn>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/nand/raw/pl35x-nand-controller.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mtd/nand/raw/pl35x-nand-controller.c b/drivers/mtd/nand/raw/pl35x-nand-controller.c
index bd89aaadd1b2f..26b61d856143c 100644
--- a/drivers/mtd/nand/raw/pl35x-nand-controller.c
+++ b/drivers/mtd/nand/raw/pl35x-nand-controller.c
@@ -807,6 +807,7 @@ static int pl35x_nfc_setup_interface(struct nand_chip *chip, int cs,
 	 * macro to convert from one to the other.
 	 */
 	period_ns = NSEC_PER_SEC / clk_get_rate(mclk);
+	clk_put(mclk);
 
 	/*
 	 * PL35X SMC needs one extra read cycle in SDR Mode 5. This is not
-- 
2.53.0



