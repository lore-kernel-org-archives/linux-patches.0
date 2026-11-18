Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031374;
	b=XGMmEj6MDstPcyBhijn16/aT7Ym5qhLTUOeaArGFm0PjTlW4AJD9SDs402GkbTFwlyT7
	 FQq7QO3tty3H4QnCUXjX1fC4S60xHnB48RXcGHc7VDf989tIfyqNwjN8cff8O3mFiIVuQ
	 HwkrSw+MZ6CtV30CQ9Y+kv30DBSFx2cvwaHzKWsKhhvKGaM64BOzBdFgvKAL2s9r1HIh2
	 ripCFjlxFAiblunRklYcD30zuS7H3/CLX/DzfdSH7+lDObOYCZXJrfh6jBp76pCYUZur/
	 oEqjHSG2Oh4/s8RIPelkgBeJJZqzUZhEtiD7YAR+4r1DSOdvfGxp2UuJVBL+Z/zXXgQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031374;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7YVUOASYoCC8WUCDbe69i8DbwYlrasJGKBGBNSCedkc=;
	b=QwU9YMz10t95zMFRDiuoHSWrKq5vkloUkTgVnTsfYLtBLXlUNYesPJhng5lKiQncpbfT
	 AvjU60NR9z9kvKE3LgRkHpZxKm/pPGuo0KArXBgI8ljln0M3HKg+hnJkMAumMU88hzF4V
	 76CydubaFm3jCIPilHmV/3Xp7D0P3rayeQLaHIYHCmVIZ8XSZ+uC5JHKNowckHMD3+09U
	 B43Biw1N9UIPN+Ds8WsX9dBtQQLUpNptJ4da2YrC294k/JYWi74+ETwMiTK/UdAPrmD7F
	 ZpoR0e391pXqeT91IzxudzK1Fq+/1al9vuOTwB5o5EZUe3bxerg1qfJ6ZC40XKV7/wQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eDfnLL1j;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6AEA606A320;
	Wed, 18 Nov 2026 19:49:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eDfnLL1j
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BFB41F000CB;
	Wed, 18 Nov 2026 19:49:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031374;
	bh=7YVUOASYoCC8WUCDbe69i8DbwYlrasJGKBGBNSCedkc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eDfnLL1jNt6SZQ46q/AkEKLH6SjYHzRRWxoNQZRmeYcGeAAywiuMzksbW+M9lFRFl
	 XJ65fhGgkmzIllOTB1WEPtAiaFBUl4oKOfiusHRcubvNk9hw49Y1RqzNO2Ioux4Mcg
	 4aQ+k1rszYaY7Iy+UCCHVWwStOyK41IK8hmHEzoA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leon Romanovsky <leonro@nvidia.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Tushar Dave <tdave@nvidia.com>,
	Logan Gunthorpe <logang@deltatee.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1036/1756] PCI/P2PDMA: Safely terminate ACS redirect lists
Date: Wed, 18 Nov 2026 15:52:43 +0100
Message-ID: <20261118150051.303472025@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Leon Romanovsky <leonro@nvidia.com>

[ Upstream commit fa291d6429ebc1efb7fab011f643b842ae5f23f1 ]

seq_buf marks an overflow by setting len to size + 1. The ACS diagnostic
path unconditionally writes a terminator to buffer[len - 1], so a path with
enough ACS ports to fill the 128-byte buffer writes one byte beyond the
buffer when verbose diagnostics are requested.

Use seq_buf_str() to terminate truncated output safely and remove the final
semicolon only when the buffer did not overflow.

Fixes: 52916982af48 ("PCI/P2PDMA: Support peer-to-peer memory")
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Tested-by: Tushar Dave <tdave@nvidia.com>
Reviewed-by: Logan Gunthorpe <logang@deltatee.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Link: https://patch.msgid.link/20260830-batch-p2p-fixes-v1-4-5044e8dfbe2e@nvidia.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/p2pdma.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/p2pdma.c b/drivers/pci/p2pdma.c
index ec53b2b0d57fe..3c2aff7a48a22 100644
--- a/drivers/pci/p2pdma.c
+++ b/drivers/pci/p2pdma.c
@@ -641,11 +641,13 @@ calc_map_type_and_dist(struct pci_dev *provider, struct pci_dev *client,
 	}
 
 	if (verbose) {
-		acs_list.buffer[acs_list.len-1] = 0; /* drop final semicolon */
+		/* Drop the final semicolon; the list is not empty here */
+		if (!seq_buf_has_overflowed(&acs_list))
+			acs_list.buffer[acs_list.len - 1] = '\0';
 		pci_warn(client, "ACS redirect is set between the client and provider (%s)\n",
 			 pci_name(provider));
 		pci_warn(client, "to disable ACS redirect for this path, add the kernel parameter: pci=disable_acs_redir=%s\n",
-			 acs_list.buffer);
+			 seq_buf_str(&acs_list));
 	}
 	acs_redirects = true;
 
-- 
2.53.0



