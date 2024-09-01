Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 857A518132A;
	Sun,  1 Sep 2024 16:59:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725209973; cv=none; b=PLRujzy/dUvw4jLOvonVr8KNuwrUA62CzuS2Bj2P4Ewlqr20tMhRNqiOvQHBfYXp9Si2p3Y3ghaQC+mMMuKkud3Kgqj+l3JipZTSRvpv7Gk7rCmNWKI9S4HB5wbSK/ixSRKpWdvVk4EezOexTl1GJjM4n4qwU6WkmG56XPbkVf4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725209973; c=relaxed/simple;
	bh=kQQbfKglmdFtLwVOyzBOA/H/qBHn7IhfTm4DFpVUbKs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hqR9brRsrN3shKirYyix1ta8z9nhYC9lMPOnptszixDzE3E4boxSOCh6ZymlLptFQXgC9zDsmDZfLami8CGo3v7upjBkLsJEGcTJsOQZEJovYxHwyB4KgmK3qvF5rFWoKi33xG4uf8PrDr8WwjOmWKP8eC7DYkfQdSSvAuZNW5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ilKmhV/t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ilKmhV/t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A3E9C4CEC3;
	Sun,  1 Sep 2024 16:59:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725209973;
	bh=kQQbfKglmdFtLwVOyzBOA/H/qBHn7IhfTm4DFpVUbKs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ilKmhV/t99r2CjBK3Lk627n7KD+AUFWx0LLn5+8+W3aeNwT8D94fzGSEOxVSO9zk8
	 cWvM0zBzszpAE9O+e9w1AI7gOz5E2AN302NcskT2lHPydmkarOMWM+J20Po5pHpAar
	 qcHTw8YnDa7gU4OWAvgA9sJvK7S9LC6FycVRD8zg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jarkko Nikula <jarkko.nikula@linux.intel.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 050/215] i3c: mipi-i3c-hci: Remove BUG() when Ring Abort request times out
Date: Sun,  1 Sep 2024 18:16:02 +0200
Message-ID: <20240901160825.245252344@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160823.230213148@linuxfoundation.org>
References: <20240901160823.230213148@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index dd2dc00399600..7ad2edd479157 100644
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



