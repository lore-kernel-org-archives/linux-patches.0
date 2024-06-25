Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 629771465A8;
	Tue, 25 Jun 2024 09:47:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719308836; cv=none; b=aaShlK7Uqx9iOWGMgJFRogCy/u8Z287QLENHWQ4x7tQDDIYDc8kiPIht8KyD8LDTSz4GucnfHxNtp+Sl6Bf49ElNF3T2CzXGgXrNK9QS46kWg6UvPifKG9TdpvGW+KN6opO3PV45LDLaYOOUD67aMic1gSCv6goqhciOd9p2NyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719308836; c=relaxed/simple;
	bh=kBohpD91IW0VPhIigxSuoVDTsBOGQeOOwto+WpoNKoM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dKBcujy1zWT5bca6XopDfR4TOr0Zf3kvHDC35rpoDcNSUP+kVO6o8p21SoY5r5dg0yhrqOZQ0zd1hXwmyLeUZWDb9YLSBAGnxgyV43QRzAxLKr2TXitiMCIumPfB7CrHWwgcZjWVL7zmIU1Avl4+sjrTNiirVUKLVfuXbqicW3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Nq0QR98Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Nq0QR98Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9B6BC32789;
	Tue, 25 Jun 2024 09:47:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719308836;
	bh=kBohpD91IW0VPhIigxSuoVDTsBOGQeOOwto+WpoNKoM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Nq0QR98QdsN9q07qD4XZTQtWku1NW5OhOxHXFNX+LvANbQJtxB7kTB6wzzgD3k5LM
	 DG4vkdHAofSSj9zILN2Ys91MpuRb9aK8iE+Ud/jxERq0CJdNGywDC4fcxtx2n5qUbx
	 gP7Ov40t7H1YpWXKubx014vEMMJxfjNvT/MmQ5d0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Patrice Chotard <patrice.chotard@foss.st.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.9 237/250] spi: stm32: qspi: Clamp stm32_qspi_get_mode() output to CCR_BUSWIDTH_4
Date: Tue, 25 Jun 2024 11:33:15 +0200
Message-ID: <20240625085557.152689990@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085548.033507125@linuxfoundation.org>
References: <20240625085548.033507125@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Patrice Chotard <patrice.chotard@foss.st.com>

commit 63deee52811b2f84ed2da55ad47252f0e8145d62 upstream.

In case usage of OCTAL mode, buswidth parameter can take the value 8.
As return value of stm32_qspi_get_mode() is used to configure fields
of CCR registers that are 2 bits only (fields IMODE, ADMODE, ADSIZE,
 DMODE), clamp return value of stm32_qspi_get_mode() to 4.

Fixes: a557fca630cc ("spi: stm32_qspi: Add transfer_one_message() spi callback")
Cc: stable@vger.kernel.org
Signed-off-by: Patrice Chotard <patrice.chotard@foss.st.com>
Link: https://msgid.link/r/20240618132951.2743935-3-patrice.chotard@foss.st.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-stm32-qspi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/spi/spi-stm32-qspi.c
+++ b/drivers/spi/spi-stm32-qspi.c
@@ -349,7 +349,7 @@ static int stm32_qspi_wait_poll_status(s
 
 static int stm32_qspi_get_mode(u8 buswidth)
 {
-	if (buswidth == 4)
+	if (buswidth >= 4)
 		return CCR_BUSWIDTH_4;
 
 	return buswidth;


