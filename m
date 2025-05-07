Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66A832144C1;
	Wed,  7 May 2025 19:09:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746644987; cv=none; b=r7jbI/1Cq9LV0ZoZEaIDkyH+R7L4wTG6JVagVz7UwrilJeIcetfOzMFT//RX35pO3RShsJU5oa8jX7dhj2ZFg0LGv47UMXnlEwU9PW5AjcrWLt3DO2x1hSIQTrwylHPlQpM5EGjgnKPqtHtwEnb7PShAgKhtQXSPNGdw7k/Rjo0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746644987; c=relaxed/simple;
	bh=F0GvGfYGwYagaN8CrlZrTLN0O3FSKkBUaH2Uo5Hc/10=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rN1uyk64AFhyE5k93bt1D6m/zTkC/OoDiPTcbxJ96CGcQzUVJ5ySgGI3CA1aA41z0DoGXva4AWJcbiQvz1xu2Ez51iW/PsW3I+vhhPLQXDwB/qhVON9YigA8RfXmERIST3hwSdFEiyov+oj8XX/gVQh7BIGXQXHKxx2mFdq6DdA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xjzk91c7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xjzk91c7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9A74C4CEE2;
	Wed,  7 May 2025 19:09:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746644987;
	bh=F0GvGfYGwYagaN8CrlZrTLN0O3FSKkBUaH2Uo5Hc/10=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xjzk91c7CKXRiVzh06VwTVyoQ5jf5PCWsTulWlkner0ZQQ4gfuuEZ11XcnUwjal6B
	 cH6hfkD8y7+KZ10LrhCVGevccUAWSrpVMyLkH5kpD/jYkGLhraIyFJbXCbhP4+gjpo
	 U3L5IUQdIjltOJ+S+msmUBTWffZRYl4czZhvmjck=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aaron Kling <webgeek1234@gmail.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.6 018/129] spi: tegra114: Dont fail set_cs_timing when delays are zero
Date: Wed,  7 May 2025 20:39:14 +0200
Message-ID: <20250507183814.273940534@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183813.500572371@linuxfoundation.org>
References: <20250507183813.500572371@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aaron Kling <webgeek1234@gmail.com>

commit 4426e6b4ecf632bb75d973051e1179b8bfac2320 upstream.

The original code would skip null delay pointers, but when the pointers
were converted to point within the spi_device struct, the check was not
updated to skip delays of zero. Hence all spi devices that didn't set
delays would fail to probe.

Fixes: 04e6bb0d6bb1 ("spi: modify set_cs_timing parameter")
Cc: stable@vger.kernel.org
Signed-off-by: Aaron Kling <webgeek1234@gmail.com>
Link: https://patch.msgid.link/20250423-spi-tegra114-v1-1-2d608bcc12f9@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-tegra114.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/spi/spi-tegra114.c
+++ b/drivers/spi/spi-tegra114.c
@@ -728,9 +728,9 @@ static int tegra_spi_set_hw_cs_timing(st
 	u32 inactive_cycles;
 	u8 cs_state;
 
-	if (setup->unit != SPI_DELAY_UNIT_SCK ||
-	    hold->unit != SPI_DELAY_UNIT_SCK ||
-	    inactive->unit != SPI_DELAY_UNIT_SCK) {
+	if ((setup->unit && setup->unit != SPI_DELAY_UNIT_SCK) ||
+	    (hold->unit && hold->unit != SPI_DELAY_UNIT_SCK) ||
+	    (inactive->unit && inactive->unit != SPI_DELAY_UNIT_SCK)) {
 		dev_err(&spi->dev,
 			"Invalid delay unit %d, should be SPI_DELAY_UNIT_SCK\n",
 			SPI_DELAY_UNIT_SCK);


