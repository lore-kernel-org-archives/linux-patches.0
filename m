Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 628D9251782;
	Mon, 12 May 2025 17:45:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747071904; cv=none; b=Nq1EkEID+nJhLLkZEPv5akaVFJ76++u3ZXY1Ld9Nu0nT4dgoNoc7BhdCB7Rm8mKQpZpa5rFXnknG6wCKmndtHfvlIsz8oylTAVhqpVvuAqQIMAGVouBkZ2oVBb8UxU5gEIcfvclbDhE2xpCcvNVYDUC3SJItPyAMmcXX3gj9B+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747071904; c=relaxed/simple;
	bh=+owjlmNlPFWaXbBnnd4jVTOkKIZiZpadltErBq+Fomc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fWTbriij/ZRO+M2ZbbCGH8F2HkERekdH1lVDAPSwVk0P7FPQAQQ8ewTMXpHSmCLgbWSne6NYAaqk4le6wpNqafhRrJvqiLRDsZNKPCXQJBq5XzAgcPIh1bjUPHiSTyUBllqyMUi59wild2O3fJjI8yv6aPrlmAbuihMn5zGRhTE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Lq2Fexbg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Lq2Fexbg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7D7FC4CEE9;
	Mon, 12 May 2025 17:45:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747071904;
	bh=+owjlmNlPFWaXbBnnd4jVTOkKIZiZpadltErBq+Fomc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Lq2FexbgnDUn+Z5dxaYMHmsRtFoGlR/6LaBjIjJOov3F0zWWnWCzFYBiNFA/3Dccm
	 wKLyFWivAgj69/kXvRMDoUICETCiRJJuqSCgsutlZQ8KOT5jSP2+lX0+gA3erNXd5W
	 tQmEBOegascMEmUlzlhVAkFwplwVijHcHk+x+MTk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gabriel Shahrouzi <gshahrouzi@gmail.com>
Subject: [PATCH 6.14 072/197] staging: axis-fifo: Correct handling of tx_fifo_depth for size validation
Date: Mon, 12 May 2025 19:38:42 +0200
Message-ID: <20250512172047.312385246@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172044.326436266@linuxfoundation.org>
References: <20250512172044.326436266@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gabriel Shahrouzi <gshahrouzi@gmail.com>

commit 2ca34b508774aaa590fc3698a54204706ecca4ba upstream.

Remove erroneous subtraction of 4 from the total FIFO depth read from
device tree. The stored depth is for checking against total capacity,
not initial vacancy. This prevented writes near the FIFO's full size.

The check performed just before data transfer, which uses live reads of
the TDFV register to determine current vacancy, correctly handles the
initial Depth - 4 hardware state and subsequent FIFO fullness.

Fixes: 4a965c5f89de ("staging: add driver for Xilinx AXI-Stream FIFO v4.1 IP core")
Cc: stable@vger.kernel.org
Signed-off-by: Gabriel Shahrouzi <gshahrouzi@gmail.com>
Link: https://lore.kernel.org/r/20250419012937.674924-1-gshahrouzi@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/axis-fifo/axis-fifo.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/drivers/staging/axis-fifo/axis-fifo.c
+++ b/drivers/staging/axis-fifo/axis-fifo.c
@@ -770,9 +770,6 @@ static int axis_fifo_parse_dt(struct axi
 		goto end;
 	}
 
-	/* IP sets TDFV to fifo depth - 4 so we will do the same */
-	fifo->tx_fifo_depth -= 4;
-
 	ret = get_dts_property(fifo, "xlnx,use-rx-data", &fifo->has_rx_fifo);
 	if (ret) {
 		dev_err(fifo->dt_device, "missing xlnx,use-rx-data property\n");


