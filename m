Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75E3320A5E5;
	Fri, 17 Oct 2025 15:28:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760714931; cv=none; b=syXW2DHmYkrkktYqVQfuKDdmleyFpLo556mfs7YX4ABqADyUR8/8XPyLKCb90Lq7T96DPcwRsxePJlwwXYnuT6KsKPMQe1JVy5Csmj3tas7YXGYWRx0mcpgzlws5P7luq4FcNiRRrVpmumnGaaDbabwyx7ZPcGytsg9p20zIy6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760714931; c=relaxed/simple;
	bh=Sm9J04WPl+9X9m7pKUxKHneXEDfsF+VfHWa+Wh7/Kcs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qHtBpMCKZuSBlUqQz9d6MHsxVltnH1g+MzClH3t5gFujc28Yd9IHENsadgDzp7evrucT4fk5dBg+xqkV38l7Z12dRAGZJrDtngai/GwIte8HGq9a6ozKW47++EtUtk68Liuj2KwqaSt+Ax9dUYenoYfwsmPblnAVCkOmzgbhMXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SR+TSRNI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SR+TSRNI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6840C4CEE7;
	Fri, 17 Oct 2025 15:28:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760714931;
	bh=Sm9J04WPl+9X9m7pKUxKHneXEDfsF+VfHWa+Wh7/Kcs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SR+TSRNIFTz4GCjmg0B6m875IHJol77TB4/Gow5rrLxhjZYGTgrIN3YluxbEde42l
	 vuDLXre0QrGaP1PEdCH4aJhKrRmnNAHDHmjWup63SBnRw+Ht6acUh0bBYHiaBGty1K
	 ycOZc4C4R1YRHU295xoDV4xTsV0TGdEuMWpX4ghY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Cl=C3=A9ment=20Le=20Goffic?= <clement.legoffic@foss.st.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 038/371] rtc: optee: fix memory leak on driver removal
Date: Fri, 17 Oct 2025 16:50:13 +0200
Message-ID: <20251017145203.178537568@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Clément Le Goffic <clement.legoffic@foss.st.com>

[ Upstream commit a531350d2fe58f7fc4516e555f22391dee94efd9 ]

Fix a memory leak in case of driver removal.
Free the shared memory used for arguments exchanges between kernel and
OP-TEE RTC PTA.

Fixes: 81c2f059ab90 ("rtc: optee: add RTC driver for OP-TEE RTC PTA")
Signed-off-by: Clément Le Goffic <clement.legoffic@foss.st.com>
Link: https://lore.kernel.org/r/20250715-upstream-optee-rtc-v1-1-e0fdf8aae545@foss.st.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-optee.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/rtc/rtc-optee.c b/drivers/rtc/rtc-optee.c
index 9f8b5d4a8f6b6..6b77c122fdc10 100644
--- a/drivers/rtc/rtc-optee.c
+++ b/drivers/rtc/rtc-optee.c
@@ -320,6 +320,7 @@ static int optee_rtc_remove(struct device *dev)
 {
 	struct optee_rtc *priv = dev_get_drvdata(dev);
 
+	tee_shm_free(priv->shm);
 	tee_client_close_session(priv->ctx, priv->session_id);
 	tee_client_close_context(priv->ctx);
 
-- 
2.51.0



