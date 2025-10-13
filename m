Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3D703128A5;
	Mon, 13 Oct 2025 15:28:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369321; cv=none; b=jkMVQ6pBGkKj/rlLgCf8ji/GdDr4Nz7+vFzS+YU3yD+DYERUdZdBjhc2MjD8XY7t/8pu+OCWqKEW/me3QKh9osiyyeWpXQuV8qHpTtf4LPWSoVm3pNqgwecn94JaPFL1i9voiDM7L77xxSfwLWVDcqVoxoK7ex8+El2CUUdAe18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369321; c=relaxed/simple;
	bh=uWybZ9iENMZk3MS8lLv9dPTwIXTvOwONXaavM3JJDaE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q1LCi2ech1lPyJUoMq8FDThikFbS33cMAgbzx2+1l56vjT8LjPMeQGHyCpcIyf6DiwZkpLL5uH5tzB4jcNkfAb+SRCtfZzNGnx3V6iWtdLXgT61TQUTPV8lT38WCrAkLHy66jiq6aqvWAltlJ9QAlyzrIVDqRAucP7q41uX16wU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EXg1mvfb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EXg1mvfb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 314AAC4CEE7;
	Mon, 13 Oct 2025 15:28:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369321;
	bh=uWybZ9iENMZk3MS8lLv9dPTwIXTvOwONXaavM3JJDaE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EXg1mvfbD2Exm5qJsJQtWmuwQtvYm/5fM1V2IvVtxXgGem52Fr8SaPUpCF9RIemFS
	 NUy8q9M18B7afgYO5Rxtvl5BEgBVmG7IV2RsuIeTWxepBuAMBly28kVOZXKKcVKVHZ
	 B7nZvsOZjneLThemu8kuWXQSmlLYegq4Gk9jjWjA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kohei Ito <ito.kohei@socionext.com>,
	Kunihiko Hayashi <hayashi.kunihiko@socionext.com>,
	Jarkko Nikula <jarkko.nikula@linux.intel.com>,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 206/563] i2c: designware: Add disabling clocks when probe fails
Date: Mon, 13 Oct 2025 16:41:07 +0200
Message-ID: <20251013144418.748116921@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kunihiko Hayashi <hayashi.kunihiko@socionext.com>

[ Upstream commit c149841b069ccc6e480b00e11f35a57b5d88c7bb ]

After an error occurs during probing state, dw_i2c_plat_pm_cleanup() is
called. However, this function doesn't disable clocks and the clock-enable
count keeps increasing. Should disable these clocks explicitly.

Fixes: 7272194ed391f ("i2c-designware: add minimal support for runtime PM")
Co-developed-by: Kohei Ito <ito.kohei@socionext.com>
Signed-off-by: Kohei Ito <ito.kohei@socionext.com>
Signed-off-by: Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
Acked-by: Jarkko Nikula <jarkko.nikula@linux.intel.com>
Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-designware-platdrv.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/i2c/busses/i2c-designware-platdrv.c b/drivers/i2c/busses/i2c-designware-platdrv.c
index b4bfdd2dd35e4..e37210d6c5f26 100644
--- a/drivers/i2c/busses/i2c-designware-platdrv.c
+++ b/drivers/i2c/busses/i2c-designware-platdrv.c
@@ -314,6 +314,7 @@ static int dw_i2c_plat_probe(struct platform_device *pdev)
 
 exit_probe:
 	dw_i2c_plat_pm_cleanup(dev);
+	i2c_dw_prepare_clk(dev, false);
 exit_reset:
 	reset_control_assert(dev->rst);
 	return ret;
-- 
2.51.0



