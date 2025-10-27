Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFC0E218EB1;
	Mon, 27 Oct 2025 18:40:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761590401; cv=none; b=NdEuL23YmW1c4smZfdvVgC/whNwyWS70OE2cukrDJnGdte/YytXVcBWdBWbCXdspEb2lu6+eZCC4NSMdbsyvlokwuAwsNV2ENaLauxIS3eiLsnwG1r/GXOC4HRG89TwG2bin/N0+2Bq+yJn0kHvO/aEgclF+72XRVFIdpQHaW6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761590401; c=relaxed/simple;
	bh=lgnaPq9Cyz2rTUASZfjHT8J9ulVM7b7itUYLADg126Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aNulDuUcJ1nQiOsNp3m2iQChMyK0B+IbJ7WdX28kZwHpdOLGtfeRaqg6b9AeQ1LpRTk8dxsv6JrwB9/9jLZr1t8LQ5uZOGteAendHaaWff6sIfjo4//QUceogudNaRw15n91k7H5tCh4ct1tgE0CRNi0fIzaPhFcqzsQtEDjkug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q4Db4IN/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q4Db4IN/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45FB6C4CEF1;
	Mon, 27 Oct 2025 18:40:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761590401;
	bh=lgnaPq9Cyz2rTUASZfjHT8J9ulVM7b7itUYLADg126Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q4Db4IN/fYXWJS7yBYa/Zd9aquvbSex7G6wzmV2MgsBYjE9VBkN2JUsxkWH9t9Y7G
	 13qEgKaWms9YmN41/xvRvrZVWr8pVUrVrMla/JvULlPP5goMW4H+zBHk9UAdR9HlnZ
	 3bEi65xG4h+wF5GuE6L1rHkK5CGvLjPtP3PvyBq8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kohei Ito <ito.kohei@socionext.com>,
	Kunihiko Hayashi <hayashi.kunihiko@socionext.com>,
	Jarkko Nikula <jarkko.nikula@linux.intel.com>,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 030/224] i2c: designware: Add disabling clocks when probe fails
Date: Mon, 27 Oct 2025 19:32:56 +0100
Message-ID: <20251027183509.811101159@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183508.963233542@linuxfoundation.org>
References: <20251027183508.963233542@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 75313c80f132f..fd5ffe13c7033 100644
--- a/drivers/i2c/busses/i2c-designware-platdrv.c
+++ b/drivers/i2c/busses/i2c-designware-platdrv.c
@@ -414,6 +414,7 @@ static int dw_i2c_plat_probe(struct platform_device *pdev)
 
 exit_probe:
 	dw_i2c_plat_pm_cleanup(dev);
+	i2c_dw_prepare_clk(dev, false);
 exit_reset:
 	reset_control_assert(dev->rst);
 	return ret;
-- 
2.51.0



