Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 136483FF1A2;
	Fri, 15 May 2026 15:52:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778860364; cv=none; b=doaeCmOshbEsHMJ4LpFT1DCYulPoE3eTqg+32r14gz3/4d6TsSpFpk3R1vWWzy06ihftsUVaZqcLn84Qk5I3VNx2tjZq3BS0XarPIoJJmW+1sPsAUhmXWNQ2ZOnEd/JuogW+jiRXBnDPCvMmCniY8c2KVRWPu3YgfbluBL/9Uug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778860364; c=relaxed/simple;
	bh=QJpT6uB3u5K9lvDn3GrmGX+pnHLv9ZfE6cm+mRyJRpA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RfGQRZMJ9KD9aaFrMj95y3Te2SXbgv7iBxzQsKHKbbtCX4ezW4g8GwrUecuxlbXrKZKHh4srjOoqik/N/xDaeIRF6fPF+P5z81JAZwyyAp9flNIjHHl3ScT9mh5IXzUyvRH+l+j1E1P/KjWdGbrOstIrMEVWJ60lXyib5ivsLEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nq3psumB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nq3psumB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BF48C2BCB0;
	Fri, 15 May 2026 15:52:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778860364;
	bh=QJpT6uB3u5K9lvDn3GrmGX+pnHLv9ZfE6cm+mRyJRpA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nq3psumBFXJybj3jW2BVTYSZLnZce5575JUjn7I0nIyGX1UkJH1xq50blHcyPEzNT
	 T0Jxk/MuyhVgunqyOn9SAdvLNH2wr1O/7hv+5K+9PvEfZDbOCsd93qkxOssGHjjuwc
	 cwyXZq0wkZ91A3A5JGp0UZs+KsXTFU5M6k/MkrTE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Russell King <rmk+kernel@arm.linux.org.uk>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.12 058/144] spi: orion: fix runtime pm leak on unbind
Date: Fri, 15 May 2026 17:48:04 +0200
Message-ID: <20260515154654.896029707@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154653.469907118@linuxfoundation.org>
References: <20260515154653.469907118@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit 97b17dd8266d2e26d9ee3c75a0fa34ecde6944f0 upstream.

Make sure to balance the runtime PM usage count on driver unbind so that
the controller can be suspended when a driver is rebound.

Also restore the autosuspend setting.

This issue was flagged by Sashiko when reviewing a controller
deregistration fix.

Fixes: 5c6786945b4e ("spi: spi-orion: add runtime PM support")
Cc: stable@vger.kernel.org	# 3.17
Cc: Russell King <rmk+kernel@arm.linux.org.uk>
Link: https://sashiko.dev/#/patchset/20260414134319.978196-1-johan%40kernel.org?part=6
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20260421130211.1537628-2-johan@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-orion.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/spi/spi-orion.c
+++ b/drivers/spi/spi-orion.c
@@ -812,6 +812,9 @@ static void orion_spi_remove(struct plat
 	spi_controller_put(host);
 
 	pm_runtime_disable(&pdev->dev);
+	pm_runtime_put_noidle(&pdev->dev);
+	pm_runtime_set_suspended(&pdev->dev);
+	pm_runtime_dont_use_autosuspend(&pdev->dev);
 }
 
 MODULE_ALIAS("platform:" DRIVER_NAME);


