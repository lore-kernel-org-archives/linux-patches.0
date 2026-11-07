Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062801;
	b=RYbuerKzZuBRp+1buY2QsNWDVtpKa7pQWvhIsyKghQAs7pPHn2eFpRVPpgadjjZFMAjZ
	 UfWeADubK2Af/fykAdkVjebeYSngpXmTc8r13iLRB5clOsDuYT15dkLj6osRGmcam9gc5
	 5KlPJhN5FIP8Axb2Z69NeOh2ggtbFkOIJFe0wJ6o/SsL+IymtG5+eiqxZwqAE57Q2XPgx
	 niD+lOL75tz0NSCfMeLe7DDutFH7LYuY3PXmsXb5W48fxDUm24srGdZRioAMGr9B/+VG4
	 n7BbjezlMJyjhB9TXHA0BjSKe947L79jBn36Y+VN+uJ2LSVHiSSP+Y11iAm8WSoxyDA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062801;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+CPyJduai6Z6gtd5XhD4v8g3MSI9iiZYS6njOpLHHRM=;
	b=bps8ty2zSJxI1sa8eLLWdmP1v7QOzjFF5t52xzdrcLrfMY5+LMdCN4KKoMaWV1q3WC09
	 HReKPBaa6aw4Jm5XwiaORfXLTp3fcB+tJXy3i59cGHGrpfpDqMndYKEXTNW18yZPxcqds
	 iPEetFaprEEJ0Q7e7ypJrV2iLSGzXjKV2t21xJpuJwruJQ2E4s4tLLb0EovewasCPVijz
	 G+jt8hjZrDuan1kz7eglgwLFWSZBQzpRf97AD75dqZpM02rcGOmtAPpqsCVgxS93kobvX
	 weZ4MybEYw6qUNWGXirjtSiGCULeJfNXQZtijxz/OSRDutOLB6krmZk6qkRyWl6yLuw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=S8iw5AZi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34706606D811;
	Sat,  7 Nov 2026 14:46:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=S8iw5AZi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D88D51F008A1;
	Sat,  7 Nov 2026 14:46:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062801;
	bh=+CPyJduai6Z6gtd5XhD4v8g3MSI9iiZYS6njOpLHHRM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S8iw5AZiKuCdM7kdf+yned6SYSewTRayWO4G5Yz+C5dfanx/uf+qvYiLKtKR/6UgM
	 o4Rr8OKZR96+CWvGxy6Muk59k/4ogjXrvIAg1NOhdEVaFx4pi8KyihUETm8PWJn2jj
	 0ReKKS5eXg3qGEzME64Y0aR1o1uc/vwGLv3l4ZeQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Hilliard <james.hilliard1@gmail.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 103/869] mtd: rawnand: sunxi: reject ECC maximization on small pages
Date: Sat,  7 Nov 2026 08:46:25 -0500
Message-ID: <20261107134856.125828497@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: James Hilliard <james.hilliard1@gmail.com>

[ Upstream commit a3c84084a73e170374b7dd493947efdef4ee57bc ]

When nand-ecc-maximize is set, the driver selects a 1024-byte ECC step
and divides the available OOB bytes by the resulting number of steps. A
NAND with a smaller page therefore produces zero steps and a division by
zero.

The older controllers also provide a 512-byte ECC block mode, but the
hardware documentation describes that as an ECC block size within NAND
pages whose supported sizes start at 1024 bytes. It does not document a
512-byte NAND page mode.

Reject pages smaller than 1024 bytes before deriving the step count. This
prevents the division by zero at the point where the incompatible
maximized geometry is selected without changing explicitly configured
512-byte ECC block handling.

Fixes: 4796d8655915 ("mtd: nand: sunxi: Support ECC maximization")
Cc: stable@vger.kernel.org
Signed-off-by: James Hilliard <james.hilliard1@gmail.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/nand/raw/sunxi_nand.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/mtd/nand/raw/sunxi_nand.c b/drivers/mtd/nand/raw/sunxi_nand.c
index 75db1713e6177..f9b72671c5253 100644
--- a/drivers/mtd/nand/raw/sunxi_nand.c
+++ b/drivers/mtd/nand/raw/sunxi_nand.c
@@ -1631,6 +1631,9 @@ static int sunxi_nand_hw_ecc_ctrl_init(struct nand_chip *nand,
 	if (nanddev->ecc.user_conf.flags & NAND_ECC_MAXIMIZE_STRENGTH) {
 		int bytes;
 
+		if (mtd->writesize < 1024)
+			return -EINVAL;
+
 		ecc->size = 1024;
 		nsectors = mtd->writesize / ecc->size;
 
-- 
2.53.0



