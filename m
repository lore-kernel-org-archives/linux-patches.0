Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063352;
	b=qKE2yXZEV86MUWOgUJStOzPW1d3MYptmMLdZaYz7nxPB1NXLkZ3UxwKxCZTuecXHx7Jy
	 ZWs7vwEXlbmH6xK8VTpUVL5JZRGXlz4giPy9Hwd/sjxmZlaEKxE72MCacJvLf7Mc4SmDV
	 sPUM29IuFV/7u7nBc4OmTqqH8pi6k+vz8hJ6jGpcrukzTKZzLLGURjOEWMfAOna82HzfQ
	 lr2ewZFGzeNgwirc7ndT8zWthTYGQer4T8WzVlrRsrJRrfTny9DRYM/d4lk4wFruChZ7A
	 bvlo2L7wLP+rxfFiEIqzzPpkgcVXqDdSKCOPLQ42hWs668h4I5bwT/XyMXSGU5Sbnzw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063352;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xa21/t6bEsrKIr9rN+DO74cyFUBoQrX8LqGliNxTWZw=;
	b=AskqllLuYlOMcoo6U/ZiVvs5UxlALtT9oCInvKIzU2ft26cQo8xaBaErhVMYIWm2+8CP
	 cm4k9EQWR0LbTIJRFRO2JOJ0aGHK0xOkdx3GNcNW9VTDtpO6QMdIU+nLXbJuH84dv58nj
	 I3O/1VeK1ZEcDXTnB1Yr1RLEb3mvq04rrZ7648kB2v6CFq59p20VrSWTRcKYcXdQoIsYK
	 g1NMEY20H78hNZTsmnaIRBnEvPFaDg5nHqT3Wsh+Zty2BFJP+Yx+MFoYRKekt5YfeoNga
	 OwK7MHqbdmAmze3rWHZq2GTbQvHLA1mK8Z+oYDSspT+Vm8JVq95D9O40IR1vJFWsT6A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gnvtUkdb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 529A7606D808;
	Sat,  7 Nov 2026 14:55:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gnvtUkdb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFE8D1F0089F;
	Sat,  7 Nov 2026 14:55:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063352;
	bh=xa21/t6bEsrKIr9rN+DO74cyFUBoQrX8LqGliNxTWZw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gnvtUkdbBh7Oib5QiSrVWN2kQsaS66b+tEc8Bl0ky5L+2cv8CkMz5cV4BtJpyuZwR
	 NFxDs16enWBas0i66stN84apOgiDANTb9hF+OgaxXly6P1IxqACuLoZBFRzfvLLlT7
	 tNmHQyUaiGJhxlLPnfkJNivy8hzvAKaL+RpV29zo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weibin Liu <liuwb@xiaopeng.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 533/869] spi: ljca: validate the response length before copying the data
Date: Sat,  7 Nov 2026 08:53:35 -0500
Message-ID: <20261107134911.526122087@linuxfoundation.org>
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

From: Weibin Liu <liuwb@xiaopeng.com>

[ Upstream commit 0fe4573c822c4c9152e2fd5269ab85410c9e458f ]

ljca_spi_read_write() only checks that the response from the adapter
carries the packet header and a non-zero payload length before copying
r_packet->len bytes from the response into the transfer buffer.

The payload length is taken from the packet the device sent back and is
neither bounded by the number of bytes actually received nor by the
size of the requested transfer: a misbehaving adapter can announce a
payload larger than what it actually sent, and the memcpy then reads
past the end of the 60-byte input buffer and writes past the end of the
caller's transfer buffer.

Check that the response carries the full header before reading
r_packet->len, then reject responses whose payload is not contained in
the data received or is longer than the requested transfer.

Fixes: caee8e38da67 ("spi: Add support for Intel LJCA USB SPI driver")
Cc: stable@vger.kernel.org # 6.8+
Signed-off-by: Weibin Liu <liuwb@xiaopeng.com>
Link: https://patch.msgid.link/20261013031717.3933277-1-liuwb@xiaopeng.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-ljca.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/spi/spi-ljca.c b/drivers/spi/spi-ljca.c
index 3f412cf8f1cd9..1b745a55d8c8a 100644
--- a/drivers/spi/spi-ljca.c
+++ b/drivers/spi/spi-ljca.c
@@ -105,7 +105,12 @@ static int ljca_spi_read_write(struct ljca_spi_dev *ljca_spi, const u8 *w_data,
 			    (u8 *)r_packet, LJCA_SPI_BUF_SIZE);
 	if (ret < 0)
 		return ret;
-	else if (ret < sizeof(*r_packet) || r_packet->len <= 0)
+
+	if (ret < sizeof(*r_packet))
+		return -EIO;
+
+	if (!r_packet->len || ret < sizeof(*r_packet) + r_packet->len ||
+	    r_packet->len > len)
 		return -EIO;
 
 	if (r_data)
-- 
2.53.0



