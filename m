Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1474F1A072D;
	Tue, 27 Aug 2024 15:22:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724772134; cv=none; b=hel0wfFJ38OMQkx153SXH1GDAC2gYZlhmQ/iPzuqWgBI5gIyWV9NQ68BfiKWU44Y8ooBi3Jkz60rso5Tee3nwSD3he4RtyfB7KWSar0j7QAIvvp6mJNjn3YF0iUoZKZKRXFKMlpse6kEBnkD8wF+DXAiOqLvfJW0wrOztD6TUEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724772134; c=relaxed/simple;
	bh=Hyzkf3KI0jcJR6a4nJ4Nio8UFaMMpyiQL1xbqN2sRDk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uWG9dPoOzwQ86UhxUZj4YUFgB+S38xz+KF3nWp1UIGT2BIVOrq0Kxsq9F12rJAstHzQi1OKOeZqsFDIpo+uXkq+zZ9tkql4Ebdcvz0y83CH1IslP3vnK3KqYzFkgDqXHTOwK+GM+8pYx5nihzuUzmCDn6/w/lI0eq9AaiAVGIJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c/fZCT+o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c/fZCT+o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39745C4FE0B;
	Tue, 27 Aug 2024 15:22:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724772133;
	bh=Hyzkf3KI0jcJR6a4nJ4Nio8UFaMMpyiQL1xbqN2sRDk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c/fZCT+oa87mMnTf3dBMWKgcH1n7NlwoVoXwwSd+CMJgpj/r4fokhVoQzhWKjeSw/
	 9odMWz452ftUJzYMOcRpjPeZWzHGdZyP2I7Q7naYKV1/tn8dYPGY+qiv5D2NYlfx9d
	 bj7XdVCtbpdD0Zp7wNmKARzGvV49rO3zi7tba7+I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jarkko Nikula <jarkko.nikula@linux.intel.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 123/321] i3c: mipi-i3c-hci: Remove BUG() when Ring Abort request times out
Date: Tue, 27 Aug 2024 16:37:11 +0200
Message-ID: <20240827143842.926807744@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143838.192435816@linuxfoundation.org>
References: <20240827143838.192435816@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



