Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4937014D280;
	Tue, 10 Sep 2024 10:35:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725964508; cv=none; b=QM7o8hIR6oEUwc3BT5aWH8ujiEAxCJCb6oNYDmXDKn5eweidoSR4HVKTUUzsaGFf4bwhwHP4vF/2a1dU8CklIl5bb4lsd9E6HOk11Bqsk9exNhDmyvDxdhKbDBc7ELuNQTWTWtjYE9xi9WhP3gNAIipbY2XLRCHASraB2AtVIuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725964508; c=relaxed/simple;
	bh=wlbYxBbTT4zmNCcfSeCmc9ivwRXfU9Zr9fsFnVe8Lpg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ULkh+RPJ7qcqTnDs7/SrkfUY72PW9oxtbbWRRD+YAhszK4QsZm1ZiP0Tz/XB1F6mcP1cDYl3ftGCpLq9+66EZID2sTwtW8Q8Z5LNkGoYjYas4P3Ek3PrfdaDgbUvbNrhoUewQFW3tdYGSebqfr8C/3Mh+D3v9LIQujWr+oxeucQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WQ0TGY1L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WQ0TGY1L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8726C4CEC3;
	Tue, 10 Sep 2024 10:35:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725964508;
	bh=wlbYxBbTT4zmNCcfSeCmc9ivwRXfU9Zr9fsFnVe8Lpg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WQ0TGY1LdHChHu0u3aKQb/VpZuqNjMeumhupI76WDz1mIUaquvgR5UZ8k74U+ILg/
	 zFjrPqDl9FdgG/tOy3yUwqU0qiDsdJLzyYS4RBV1BtjEoJGtg35jY9aMmH9pukxIix
	 jUjrRwLFTo7+Mxqlln11D51iGm5OqDZHio7zxImM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jarkko Nikula <jarkko.nikula@linux.intel.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 179/269] i3c: mipi-i3c-hci: Error out instead on BUG_ON() in IBI DMA setup
Date: Tue, 10 Sep 2024 11:32:46 +0200
Message-ID: <20240910092614.537212824@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092608.225137854@linuxfoundation.org>
References: <20240910092608.225137854@linuxfoundation.org>
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

[ Upstream commit 8a2be2f1db268ec735419e53ef04ca039fc027dc ]

Definitely condition dma_get_cache_alignment * defined value > 256
during driver initialization is not reason to BUG_ON(). Turn that to
graceful error out with -EINVAL.

Signed-off-by: Jarkko Nikula <jarkko.nikula@linux.intel.com>
Link: https://lore.kernel.org/r/20240628131559.502822-3-jarkko.nikula@linux.intel.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i3c/master/mipi-i3c-hci/dma.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/i3c/master/mipi-i3c-hci/dma.c b/drivers/i3c/master/mipi-i3c-hci/dma.c
index 337c95d43f3f..edc3a69bfe31 100644
--- a/drivers/i3c/master/mipi-i3c-hci/dma.c
+++ b/drivers/i3c/master/mipi-i3c-hci/dma.c
@@ -291,7 +291,10 @@ static int hci_dma_init(struct i3c_hci *hci)
 
 		rh->ibi_chunk_sz = dma_get_cache_alignment();
 		rh->ibi_chunk_sz *= IBI_CHUNK_CACHELINES;
-		BUG_ON(rh->ibi_chunk_sz > 256);
+		if (rh->ibi_chunk_sz > 256) {
+			ret = -EINVAL;
+			goto err_out;
+		}
 
 		ibi_status_ring_sz = rh->ibi_status_sz * rh->ibi_status_entries;
 		ibi_data_ring_sz = rh->ibi_chunk_sz * rh->ibi_chunks_total;
-- 
2.43.0



