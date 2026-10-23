Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774509;
	b=NoZZUx7MXBrcE4ETHGdANRAo3lRdUPNifTEg/tG4J+aymj6EDVrSWXkf8+mHhy2ATpOP
	 YoBHp+akhNBVGYsNNVW01v7HQTlZgcQP7H5jjaPvKKxUQNQdxc9SSyUTba0DrpQw0Luqn
	 FPNMqQKFR3qNkctdjizs+1l4YVA00oPnrSbPWwkB2pznbeMYOYfhl7dvXlus33saNm85q
	 yEaL0JI4ppH3RN7nxkEFx7552fPI7j9Ygju+WYLxqvAnsdqs92wfXVluI5QnW4356Pauv
	 zWa4HJrV6D+KTpAVwtW2pQr87h7lkkgcYT3ErjtvkvEpI73PFpVCTJzkZDh4jPrAnVA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774509;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=frxvBfEXdIst9+fMqkndYyjlzcmwZ3gaHtHMC7m4AMA=;
	b=2ky1vdmjkvDSvNLRmECj2a4Kyvzm3dATW6kkXHRyc9XveK4Cdt3TZUI8YosMFiJOJpdQ
	 8ABkBn1hQCXkDgM2kj0FB9DeA2agXvRA5XZup2RrHO9z5EAUF96992XduEjCgx5lN9I9E
	 o5iRyNwxLwFZSslGeByR2ZHLzf513Qufyi+D6STAtF/XwkxwZrHgQjQek222I1DyAiv0o
	 iya3u2leZ74BDlxPgWAOOvMBeLircjb9hsBYdlls5prxsxP4jRxu7AiuLAQQIfPnmfui2
	 AWgfy90NSqyFDm5TKG7nBWmWOA/VmG1lbSY+6HMXixOmTyjaYAzGXrzFZElU8IYJysg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="u0u/Pdc7";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58530606A31A;
	Fri, 23 Oct 2026 16:55:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=u0u/Pdc7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0241F1F01825;
	Fri, 23 Oct 2026 16:55:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774508;
	bh=frxvBfEXdIst9+fMqkndYyjlzcmwZ3gaHtHMC7m4AMA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=u0u/Pdc7+A81GvU5uyUiGx2EwLz9tDs1hlqFO00hyTE9T+kWtKZSIJdhQ1Or/3JfH
	 E3MZTfWJgpMDsBJKjyBrmSVIhDSrTIYmuJrbkJ0pl0STqeLgMP4WyFh70LlRH9h5F7
	 t4uQ0bWItGlcMVDtEe9hRkrbNlUqxYk+39XPtn5Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Carlos Jones Jr <carlosjr.jones@analog.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 047/242] spi: tegra114: assert CS GPIO for every transfer in a message
Date: Fri, 23 Oct 2026 18:38:09 +0200
Message-ID: <20261023163714.890224591@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163713.816071858@linuxfoundation.org>
References: <20261023163713.816071858@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Carlos Jones Jr <carlosjr.jones@analog.com>

[ Upstream commit 8980bc573ae2d2b9d86d76aeb86c76e1597070bf ]

The driver provides its own transfer_one_message() and therefore drives
the chip-select GPIO itself rather than through the SPI core. The GPIO is
asserted only in the is_first_of_msg path of
tegra_spi_setup_transfer_one(), but tegra_spi_transfer_end() deasserts it
whenever a transfer has cs_change set. For a multi-transfer message whose
earlier transfers request cs_change -- for example a register read that
sends the address in one transfer and clocks the data back in the next --
the CS GPIO is released after the first transfer and never re-asserted,
so the remaining transfers are clocked with chip-select inactive and the
peripheral never drives the bus.

This was observed with an ADIS16470 IMU (adis16475 driver), whose
register read is a two-transfer, cs_change-framed exchange: a logic
analyzer showed the data frame clocked with CS high, and the driver read
0 while the device drove 0x4056 on the wire.

Re-assert the CS GPIO for every transfer so that multi-transfer messages
keep chip-select active across the whole message. gpiod_set_value() is
idempotent and polarity-aware, so this is a no-op for the first transfer
and for messages that keep CS asserted throughout.

Fixes: 63c1440596ff ("spi: tegra114: add support for gpio based CS")
Signed-off-by: Carlos Jones Jr <carlosjr.jones@analog.com>
Link: https://patch.msgid.link/20261002085540.1625-1-carlosjr.jones@analog.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-tegra114.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/spi/spi-tegra114.c b/drivers/spi/spi-tegra114.c
index aa44ffd09e61b..976bf735378a2 100644
--- a/drivers/spi/spi-tegra114.c
+++ b/drivers/spi/spi-tegra114.c
@@ -859,6 +859,13 @@ static u32 tegra_spi_setup_transfer_one(struct spi_device *spi,
 		command1 |= SPI_BIT_LENGTH(bits_per_word - 1);
 	}
 
+	/*
+	 * Re-assert the CS GPIO for every transfer: transfer_end() drops it
+	 * on cs_change, and the assert above only covers is_first_of_msg.
+	 */
+	if (spi_get_csgpiod(spi, 0))
+		gpiod_set_value(spi_get_csgpiod(spi, 0), 1);
+
 	return command1;
 }
 
-- 
2.53.0



