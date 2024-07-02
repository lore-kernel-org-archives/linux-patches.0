Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C1D6178381;
	Tue,  2 Jul 2024 17:15:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719940547; cv=none; b=G4IUd8WIxaTtpOi2ca3Xa1tHV+LiNNX6n0WEZzSq4MKefblP8A8/kzK+Lu7dbPtF6/pwKPHUHryog/H0XY9Dtg4SsB3UKKpUDljrCUvEAHdMkNmOhmcYyibmy3Cic5OQtH9/BQX5t56Aoh06gQ5YF289BCuPbaUOPLHVBxnz1uA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719940547; c=relaxed/simple;
	bh=+7hFTAgTWfhPBHWp0D/8EiMx3u3/qny7j2OX+4AZ3AU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j9o5s4GQ2Mlmk99DxlWch3OSblLJji3uj8jy65q3hfE+pNSN1rBhizDXEJm9mdOmzvnRl0neurHk9Gv3kfeYLfxGKBTh1oWeS06/B0wgDcZMvsmloh7il8km+0vN0zz0sH3XV772K2eyo8i/oR1H4rJN0Ca3AuWUWDJAfQ+3cpg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hg1Vk7LM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hg1Vk7LM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AAD0C116B1;
	Tue,  2 Jul 2024 17:15:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719940547;
	bh=+7hFTAgTWfhPBHWp0D/8EiMx3u3/qny7j2OX+4AZ3AU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hg1Vk7LMtZzbjJcz3whzSgzS2JMS4vQBxlGulWKsDcJ/2kfQSv8CI2+UulizZfBgX
	 6BJCk9Oq7JFMYQYrOGapOumjUCufj7S0NSckC4lxl8Hxt68D7sCCq8cz6C6532exe7
	 IJ9gQj/3uKTfTcOPBYmNEEwu8SRu/tN97qEY5E1g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Doug Brown <doug@schmorgal.com>
Subject: [PATCH 6.9 155/222] Revert "serial: core: only stop transmit when HW fifo is empty"
Date: Tue,  2 Jul 2024 19:03:13 +0200
Message-ID: <20240702170249.903686296@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170243.963426416@linuxfoundation.org>
References: <20240702170243.963426416@linuxfoundation.org>
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

From: Doug Brown <doug@schmorgal.com>

commit c5603e2a621dac10c5e21cc430848ebcfa6c7e01 upstream.

This reverts commit 7bfb915a597a301abb892f620fe5c283a9fdbd77.

This commit broke pxa and omap-serial, because it inhibited them from
calling stop_tx() if their TX FIFOs weren't completely empty. This
resulted in these two drivers hanging during transmits because the TX
interrupt would stay enabled, and a new TX interrupt would never fire.

Cc: stable@vger.kernel.org
Fixes: 7bfb915a597a ("serial: core: only stop transmit when HW fifo is empty")
Signed-off-by: Doug Brown <doug@schmorgal.com>
Link: https://lore.kernel.org/r/20240606195632.173255-2-doug@schmorgal.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/serial_core.h |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/include/linux/serial_core.h
+++ b/include/linux/serial_core.h
@@ -789,8 +789,7 @@ enum UART_TX_FLAGS {
 	if (pending < WAKEUP_CHARS) {					      \
 		uart_write_wakeup(__port);				      \
 									      \
-		if (!((flags) & UART_TX_NOSTOP) && pending == 0 &&	      \
-		    __port->ops->tx_empty(__port))			      \
+		if (!((flags) & UART_TX_NOSTOP) && pending == 0)	      \
 			__port->ops->stop_tx(__port);			      \
 	}								      \
 									      \


