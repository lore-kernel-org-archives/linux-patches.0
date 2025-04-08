Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3FAC26980C;
	Tue,  8 Apr 2025 12:26:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744115166; cv=none; b=LmWdf/bSITFElJPNyMNhOuSMQ2DiTcKdQdzqsAJOKXJL2/C4HLm6GmjvrUyfd5x07jpqTAVAXt+omxF5nhVDLTrfVJ0LGqbE8j/D6pi5k4Tq+8uiwfBGHdfYG+aQvVZrKGEjPAd5WTseQvoTSQE7f8wmkoEqdItGqU67gKOtl48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744115166; c=relaxed/simple;
	bh=mQN8tUcQcIWzAFDRyGiUUH+5BYymYXayfoDe16q59YQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o1t3Rg/86RQvP9TzisvQ1cqAjTmtAJ9UXqP0NQ+L4acSRxHWpAvphdjAQIULcjaE3EWMG7cCheDakL55/iNx0V9jOOoK0dLInVAVAzQa7YvWV7eP8bgVkDTTKnE48l71+CWpTjbXJ+aL6V2sjmahd6spcCk0fwy/hcBNp+OCwj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jcokFR6f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jcokFR6f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FFFAC4CEE7;
	Tue,  8 Apr 2025 12:26:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744115166;
	bh=mQN8tUcQcIWzAFDRyGiUUH+5BYymYXayfoDe16q59YQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jcokFR6f3/Ekv3/sj3jayVYiPX+RNhelvzmlpHAD2XDjbf+8c53pJIv8ibfL3NEli
	 ghN4YlwzuzVJV4OIEcIm2mLnlZrsBUzyoEVR8lhEB0axb7X4RpCtgHjETLESIcqUwb
	 vMKIOqstJU3aYjfTXGzKJoleAiX0AtJeQl+Z9B2Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 373/499] spi: cadence: Fix out-of-bounds array access in cdns_mrvl_xspi_setup_clock()
Date: Tue,  8 Apr 2025 12:49:45 +0200
Message-ID: <20250408104900.532295633@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josh Poimboeuf <jpoimboe@kernel.org>

[ Upstream commit 7ba0847fa1c22e7801cebfe5f7b75aee4fae317e ]

If requested_clk > 128, cdns_mrvl_xspi_setup_clock() iterates over the
entire cdns_mrvl_xspi_clk_div_list array without breaking out early,
causing 'i' to go beyond the array bounds.

Fix that by stopping the loop when it gets to the last entry, clamping
the clock to the minimum 6.25 MHz.

Fixes the following warning with an UBSAN kernel:

  vmlinux.o: warning: objtool: cdns_mrvl_xspi_setup_clock: unexpected end of section .text.cdns_mrvl_xspi_setup_clock

Fixes: 26d34fdc4971 ("spi: cadence: Add clock configuration for Marvell xSPI overlay")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202503282236.UhfRsF3B-lkp@intel.com/
Link: https://lore.kernel.org/r/gs2ooxfkblnee6cc5yfcxh7nu4wvoqnuv4lrllkhccxgcac2jg@7snmwd73jkhs
Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
Link: https://patch.msgid.link/h6bef6wof6zpjfp3jbhrkigqsnykdfy6j4qmmvb6gsabhianhj@k57a7hwpa3bj
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-cadence-xspi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/spi/spi-cadence-xspi.c b/drivers/spi/spi-cadence-xspi.c
index aed98ab143346..6dcba0e0ddaa3 100644
--- a/drivers/spi/spi-cadence-xspi.c
+++ b/drivers/spi/spi-cadence-xspi.c
@@ -432,7 +432,7 @@ static bool cdns_mrvl_xspi_setup_clock(struct cdns_xspi_dev *cdns_xspi,
 	u32 clk_reg;
 	bool update_clk = false;
 
-	while (i < ARRAY_SIZE(cdns_mrvl_xspi_clk_div_list)) {
+	while (i < (ARRAY_SIZE(cdns_mrvl_xspi_clk_div_list) - 1)) {
 		clk_val = MRVL_XSPI_CLOCK_DIVIDED(
 				cdns_mrvl_xspi_clk_div_list[i]);
 		if (clk_val <= requested_clk)
-- 
2.39.5



