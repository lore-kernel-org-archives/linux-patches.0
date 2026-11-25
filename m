Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621171;
	b=zbYsSJJPFwRqDjExTBtebxYWjtYgdsOlDKqOXaacYGzBKXjomebEbV6JJj6ZRaj/TU9h
	 JYbgkzpX+DCOudq4zlyITfXYedNcqhj7U6ymvnBR1mvrjNdnftH9nO4uyoc8DtXIAWE2z
	 x7Dkx9RJ51jJNGQF1KOXYrLiU1nW0oVFqJeic7AiZ90EBIbrBOy51ILHLZV7drkmYk/vS
	 rgusoE4zYzBeCPIFDGhNNGD4e25zLXippNWVgylaYys574LR4J/Hk8LBstR6Nw+vD/Ee4
	 1K3za1YDBVbBtqnPcxON42TmtrHoBKL2cS+Rzbr+9m6oT4EqPvJkKjq8AnwoLtv3hpg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621171;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ygWLWgdiy+CbAjUV4cAdrAZHh8QGOhSZBI8ALHUjAv0=;
	b=YuVbQr+8gjE0f7wVYWGJwWH/Oybw2kSGZ9j3BThaqAunN3vs5Bhsg+dRIQuO5prnC56+
	 pq5qhzD/SXhLzM+eSCI7dH0uxyqNtqjjr9ljLP7Z5DHvL4ZqOdm5LHI6vhnZkGfFzIOPz
	 B9yiVBAGV2Pcm5pbssz5SPwEB4fDlHVpVAXyb1qk0d8GR9UlNIxgHpHlQjiLoIdfGTFRU
	 J+1EE6399kaxxdvov9FxndlKchBB1Fy68nSsuqYUj6qHrULjKm6HNVa+AnaMlDpWkWM6q
	 1dPIUc+dPi7gulxQaRRA8XQUF6CH5DAyQ3oO/Af70A2ncxaHJ7v7UPd7TEJSC0EUJ8Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Fakrewiu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42908606A6A3;
	Wed, 25 Nov 2026 15:39:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Fakrewiu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 891A61F000D1;
	Wed, 25 Nov 2026 15:39:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621171;
	bh=ygWLWgdiy+CbAjUV4cAdrAZHh8QGOhSZBI8ALHUjAv0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FakrewiuuurN6DcixHQzFJWm1gPuFsRTnM5kcrTjV7Nbc3Gdi6RUatZ0BCLvNw5hF
	 JosNcHSl+rT4Cr4qTALlm2OFme6179HqigPVHeKnvCJBHHzl9VdFsa8qKwwgTk/Sor
	 VVKHqk+TgC6utNIctYZS5J1IgTwI2Qe1mZgMlquk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Giuseppe Piscitelli <ooonea@gmail.com>,
	Niklas Cassel <cassel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 143/990] ata: libata-core: Check device support before querying power state
Date: Wed, 25 Nov 2026 15:25:10 +0100
Message-ID: <20261125143825.434970578@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

From: Giuseppe Piscitelli <ooonea@gmail.com>

[ Upstream commit ec585ac78742527f80495dd8f451dcda7e9e7f59 ]

The standby path queries the power state before checking whether the
device accepts ATA power-management commands. This sends CHECK POWER MODE
to ATAPI devices, including the QEMU DVD-ROM, which rejects it.

Run the existing taskfile initialization and device-class check first,
as the active-power path already does.

Fixes: 9cec467d0502 ("ata: libata-core: Do not call ata_dev_power_set_standby() twice")
Signed-off-by: Giuseppe Piscitelli <ooonea@gmail.com>
Reviewed-by: Niklas Cassel <cassel@kernel.org>
Link: https://lore.kernel.org/r/20261026202513.669084-1-ooonea@gmail.com
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/libata-core.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 29394d18e7e83..209bd48ee8615 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -2046,6 +2046,10 @@ void ata_dev_power_set_standby(struct ata_device *dev)
 	struct ata_taskfile tf;
 	unsigned int err_mask;
 
+	/* Issue STANDBY IMMEDIATE command only if supported by the device */
+	if (!ata_dev_power_init_tf(dev, &tf, false))
+		return;
+
 	/* If the device is already sleeping or in standby, do nothing. */
 	if ((dev->flags & ATA_DFLAG_SLEEPING) ||
 	    !ata_dev_power_is_active(dev))
@@ -2064,10 +2068,6 @@ void ata_dev_power_set_standby(struct ata_device *dev)
 	    system_entering_hibernation())
 		return;
 
-	/* Issue STANDBY IMMEDIATE command only if supported by the device */
-	if (!ata_dev_power_init_tf(dev, &tf, false))
-		return;
-
 	ata_dev_notice(dev, "Entering standby power mode\n");
 
 	err_mask = ata_exec_internal(dev, &tf, NULL, DMA_NONE, NULL, 0, 0);
-- 
2.53.0



