Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0C4838910F;
	Tue, 21 Jul 2026 18:54:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660080; cv=none; b=ApvoWgrwbCDqEbOs/G1G6yzRfNGDs5uGnAwcQhzUNG0BE6b+I9zcuJi2VkwF8lz9XkkeUs/Wt9JITJC/XRfDBKNB/bnVw9rXUzN9ZlJ1uRN6+uNS4/z8UmAPw1mwbQSUxKXRvBgidKlIZDS9GvHArAy5Ikw6AHbumCS+YbTbNGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660080; c=relaxed/simple;
	bh=pEK+4TJOXFITUNSMI4oXkNyZ0Xqb8N0sT4NCX3jC9e0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mKSQ8rzHG/cSQqhWNI3MUkn7bgLyGco4W2kDnSQDVGArtmB6508mA6Tf+9030v43oz2vU4iIeqzzd0l21T+qpZ9aXgzJr0Yfh1zY+UzUhp9RxT+uPCO5m1AkZ+CiOVE+9OX8499j+22NbLH92me6IahqKu8ciIpIEXVkXRunhVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SeCK7Lsi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SeCK7Lsi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CDFA1F00A3A;
	Tue, 21 Jul 2026 18:54:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660079;
	bh=haCChNHiT1kHDuBPE65NxiQIlVC9OgnmhJe1xyW/PWw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SeCK7LsisjnR/IlDaRafr5gWGTy58YyvcJG+pJiNFtP2FjIzfqInCoPB1OIq1yuRC
	 ryj/8I8D8WjOha+m36OWcifIPaboS57NzeDoNllOiqaxkmBeVfd3VZewxiGKVpRZcI
	 C9GebVz4+7vzse56EXuE5q+G8h5NBzHOsQ+NMHd4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gui-Dong Han <hanguidong02@gmail.com>,
	Dominique Martinet <asmadeus@codewreck.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0827/2077] 9p: Add missing read barrier in virtio zero-copy path
Date: Tue, 21 Jul 2026 17:08:20 +0200
Message-ID: <20260721152612.294386114@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gui-Dong Han <hanguidong02@gmail.com>

[ Upstream commit aa88278693cbfaf7a2acf961379973fbb63b165c ]

Commit 2b6e72ed747f ("9P: Add memory barriers to protect request
fields over cb/rpc threads handoff") added a read barrier after
p9_client_rpc() waits for req->status, pairing with the write barrier in
p9_client_cb(). The virtio zero-copy wait path was missed.

Add the same read barrier after the zero-copy wait before reading the
completed request.

Fixes: 2b6e72ed747f ("9P: Add memory barriers to protect request fields over cb/rpc threads handoff")
Signed-off-by: Gui-Dong Han <hanguidong02@gmail.com>
Message-ID: <20260529075441.233369-1-hanguidong02@gmail.com>
Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/9p/trans_virtio.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/9p/trans_virtio.c b/net/9p/trans_virtio.c
index 4cdab7094b273a..b0d0094ec8e2c8 100644
--- a/net/9p/trans_virtio.c
+++ b/net/9p/trans_virtio.c
@@ -532,6 +532,11 @@ p9_virtio_zc_request(struct p9_client *client, struct p9_req_t *req,
 	p9_debug(P9_DEBUG_TRANS, "virtio request kicked\n");
 	err = io_wait_event_killable(req->wq,
 				     READ_ONCE(req->status) >= REQ_STATUS_RCVD);
+	/*
+	 * Make sure our req is coherent with regard to updates in other
+	 * threads - echoes to wmb() in the callback
+	 */
+	smp_rmb();
 	// RERROR needs reply (== error string) in static data
 	if (READ_ONCE(req->status) == REQ_STATUS_RCVD &&
 	    unlikely(req->rc.sdata[4] == P9_RERROR))
-- 
2.53.0



