Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 092264FECCF;
	Wed, 30 Sep 2026 16:51:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790787062; cv=none; b=CatkS3TBsT8vzGZ5zYyVxQcZh+F20j5A2ENmEycCr6eF+CdPIhhCGroFVYYqSNdZ/KsWicmjelXqd8BcyZHFqssZ2db9zE38xVkywVRCvm4SFrE3gnoVfTh89tnFJGc8V+mkzXINnEdOyCzzqmPzMUoWvJLwyUr21P5Ml8o/Kxw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790787062; c=relaxed/simple;
	bh=/qu/O9bAioDkh9+ZP8ipahLBLhhPvkRu3Xa5V/ktQ0A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=p22VC/663ovqcSDjk0yF8wYCInZU6bZ51ou2bVzLP3SDJdi7p4UZW2IZnRsjXh+s4YpggbVaGZnjnCoBPbHyNM0RmKXh3DwjWzQ3akrHRBPW7ii+0DfdOxFv9NbqD4kylZIIitvlyv12J6e7yh1LtIPAfhy8kyhySpZPbzE0W9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s/g5ndb1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s/g5ndb1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F4AB1F000FF;
	Wed, 30 Sep 2026 16:51:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790787060;
	bh=wS0MZ9afM90RcsztUJz1VF1EVfoKrrF2xFLtjM6yiNo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=s/g5ndb1jWij9I9wcIFWCXpTjUzRB61ZlmcersNAFMe1qMffFVNx6ed+R40mYTyeC
	 ykdgeGwI/RDmQzCpgv9ROpubT00Fna6ApOQz05R2EXpCo09uE2gXD7T7Gg/I2bJwEF
	 L1ahDt9nmHgQLo82XtjoelYC9d8NQkzpKSeXgWCQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 097/457] eth: fbnic: Handle maximum standalone channels
Date: Wed, 30 Sep 2026 17:23:22 +0200
Message-ID: <20260930152348.144223053@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Björn Töpel <bjorn@kernel.org>

[ Upstream commit 1f4c73064a50f53d596c6f1d06d2d700f43c4b32 ]

Standalone channels use one NAPI vector for each Tx and Rx queue.
fbnic's allocation path excludes FBNIC_MAX_TXQS from that layout. A
64-Tx/64-Rx configuration therefore records 128 vectors but allocates
only 64, leaving NULL entries that resource setup dereferences.

Include the maximum vector count in standalone allocation.

Fixes: bc6107771bb4 ("eth: fbnic: Allocate a netdevice and napi vectors with queues")
Signed-off-by: Björn Töpel <bjorn@kernel.org>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/178942020457.7700.13129750616387075931.stgit@ahduyck-xeon-server.home.arpa
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/meta/fbnic/fbnic_txrx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/meta/fbnic/fbnic_txrx.c b/drivers/net/ethernet/meta/fbnic/fbnic_txrx.c
index 661dee1661afe..a30aa44508487 100644
--- a/drivers/net/ethernet/meta/fbnic/fbnic_txrx.c
+++ b/drivers/net/ethernet/meta/fbnic/fbnic_txrx.c
@@ -1791,7 +1791,7 @@ int fbnic_alloc_napi_vectors(struct fbnic_net *fbn)
 	int err;
 
 	/* Allocate 1 Tx queue per napi vector */
-	if (num_napi < FBNIC_MAX_TXQS && num_napi == num_tx + num_rx) {
+	if (num_napi <= FBNIC_MAX_TXQS && num_napi == num_tx + num_rx) {
 		while (num_tx) {
 			err = fbnic_alloc_napi_vector(fbd, fbn,
 						      num_napi, v_idx,
-- 
2.53.0



