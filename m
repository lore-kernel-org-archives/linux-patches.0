Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62C4A44CF2E;
	Tue, 16 Jun 2026 15:37:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781624240; cv=none; b=ieCIosjth5NWZlGi1eUmaKw0Iqoj3i7ck2ToCX0aaaHuC15KHl3oQerSoP3ys1C1ihGora3y3fyOfwfO2R+9ATILVX6kDwQZ4XPpmY3ObpK/VmHqhrKRNl+9SulBFq0qrzp8iRLQdoZmtccB0Rzg7eQN9s7TpFfTmvfiidMmWBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781624240; c=relaxed/simple;
	bh=vdx5y4PfP6jnJ6eHgQX+Ga4Q5apdNPX7WBfzB48+TkA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ICnvM7ru/1O7iiojsx/9TlRNQNSAnHd/gRIbGjSByyxMuy/jm4qcxIVtj/4GxIn7Ku6y38EmYY2g3Eb1YIOmoVypdD5GApVxRvxYGFUMfL2IxEQVuQ1NcmG5QF6H/I5Z/YZ5aLC1TeKYWqy57lXOHjgbpWE2qC6mbA1lo26NKpw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HCf1g0Qk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HCf1g0Qk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA3131F000E9;
	Tue, 16 Jun 2026 15:37:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781624239;
	bh=btjDXi4O8zxD6KpLr0Ej2XAcESRaL8BkNcpfE++AcdA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HCf1g0Qk6JqKvHWcy4EEtlvwOk3YUXaoR8z2JMkE2w6pmnWYSQjmeIpx/VTORCk0C
	 jFyL2AaqLyZGEsggtiRkaZihKd19A6WYTuU7BKmlpsoHzRucVD++0AbqrAAhrvuSqR
	 guzp3KW8n1qVhBcP993+tiDKMslU7bDDsSLzTa40=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Judith Mendez <jm@ti.com>,
	Linus Walleij <linusw@kernel.org>
Subject: [PATCH 7.0 297/378] pinctrl: mcp23s08: Read spi-present-mask as u8 not u32
Date: Tue, 16 Jun 2026 20:28:48 +0530
Message-ID: <20260616145125.701849870@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145109.744539446@linuxfoundation.org>
References: <20260616145109.744539446@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Judith Mendez <jm@ti.com>

commit b0c13ec17438577f90b379d448dfed1233e2c0a4 upstream.

The binding (microchip,mcp23s08) specifies microchip,spi-present-mask
as uint8, but driver would read u32, causing type mismatch. Use
device_property_read_u8 to match binding spec, hardware (8 chips max),
& prevent probe failure.

Cc: stable@vger.kernel.org
Fixes: 3ad8d3ec6d87 ("dt-bindings: pinctrl: convert pinctrl-mcp23s08.txt to yaml format")
Signed-off-by: Judith Mendez <jm@ti.com>
Signed-off-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pinctrl/pinctrl-mcp23s08_spi.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/pinctrl/pinctrl-mcp23s08_spi.c
+++ b/drivers/pinctrl/pinctrl-mcp23s08_spi.c
@@ -144,13 +144,13 @@ static int mcp23s08_probe(struct spi_dev
 	unsigned int addr;
 	int chips;
 	int ret;
-	u32 v;
+	u8 v;
 
 	info = spi_get_device_match_data(spi);
 
-	ret = device_property_read_u32(dev, "microchip,spi-present-mask", &v);
+	ret = device_property_read_u8(dev, "microchip,spi-present-mask", &v);
 	if (ret) {
-		ret = device_property_read_u32(dev, "mcp,spi-present-mask", &v);
+		ret = device_property_read_u8(dev, "mcp,spi-present-mask", &v);
 		if (ret) {
 			dev_err(dev, "missing spi-present-mask");
 			return ret;


