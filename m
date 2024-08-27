Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9BD944C8C;
	Tue, 27 Aug 2024 14:46:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724770019; cv=none; b=IQ2YX1t0IDIAehzr/UuWZC8rLkItHZQUEs7fu3c2/NOXPnMcG+EkC5CCwBwkErhFz4J4oooHNTW8wKXCmWTnPWxdoR/7irTaspjnkY8lGQiK7DVNMP9APmCUfMNudWJQs5Ud7wUQpug1BAMwthXo9LrORuYya7kzuFHtkZEWlJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724770019; c=relaxed/simple;
	bh=WVPXzaoEjWRpi99ksEl59J9/UzpHEe0QRHXs0CID0fs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i0e+4VVAAYwYrgW9E0ITSl826B+DeliWiAmMjstI/xP5YbPO7PjdWPQ6KRTr1VdyCk/GzYSRvqAOeou+El8ptIlFnElFqqP8G6mMEbqyMqFZKNEdfpwtbKJrqUoUGczGq59ezZz2dyk6LT32jp0m/vEySaKfcjMtgHpiKzRdcjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hUoUHlFN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hUoUHlFN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11DB5C6106D;
	Tue, 27 Aug 2024 14:46:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724770019;
	bh=WVPXzaoEjWRpi99ksEl59J9/UzpHEe0QRHXs0CID0fs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hUoUHlFNAavo693Vb8Ax6ci5fgAjwY2sras7Z6nOiVf2LJGnh9jHxgfje3s22V+0q
	 wnKUrkeluyDVT9TYTekiKscVNPaQGz1X4tXDn7RqhunAncCNaHC6YGB5Q4xghZ/Ejh
	 RznndzA1U3ac7SQS9dTzdfeXRUWteiy9URr3a6d0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jarkko Nikula <jarkko.nikula@linux.intel.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 103/341] i3c: mipi-i3c-hci: Remove BUG() when Ring Abort request times out
Date: Tue, 27 Aug 2024 16:35:34 +0200
Message-ID: <20240827143847.328664676@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jarkko Nikula <jarkko.nikula@linux.intel.com>

[ Upstream commit 361acacaf7c706223968c8186f0d3b6e214e7403 ]

Ring Abort request will timeout in case there is an error in the Host
Controller interrupt delivery or Ring Header configuration. Using BUG()
makes hard to debug those cases.

Make it less severe and turn BUG() to WARN_ON().

Signed-off-by: Jarkko Nikula <jarkko.nikula@linux.intel.com>
Link: https://lore.kernel.org/r/20230921055704.1087277-6-jarkko.nikula@linux.intel.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i3c/master/mipi-i3c-hci/dma.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/i3c/master/mipi-i3c-hci/dma.c b/drivers/i3c/master/mipi-i3c-hci/dma.c
index 71b5dbe45c45c..a28ff177022ce 100644
--- a/drivers/i3c/master/mipi-i3c-hci/dma.c
+++ b/drivers/i3c/master/mipi-i3c-hci/dma.c
@@ -450,10 +450,9 @@ static bool hci_dma_dequeue_xfer(struct i3c_hci *hci,
 		/*
 		 * We're deep in it if ever this condition is ever met.
 		 * Hardware might still be writing to memory, etc.
-		 * Better suspend the world than risking silent corruption.
 		 */
 		dev_crit(&hci->master.dev, "unable to abort the ring\n");
-		BUG();
+		WARN_ON(1);
 	}
 
 	for (i = 0; i < n; i++) {
-- 
2.43.0



