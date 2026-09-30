Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15392509F06;
	Wed, 30 Sep 2026 18:01:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790791302; cv=none; b=rt4MbIYg95DocPGLy75cu5kayA0UyH6DoJHme94Z8MkzyRjwP2536XR5UFeUd6ALxtj+Jj/V14ItC0ITQVigFQA+YKHbKaPmv6S71pFhXW6G2xIqgsb2gqAAOCZYJ2z2l3ntTfZCqAhXKS/OCoNL/9sYjVD85E8ljYdDxy4I9FY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790791302; c=relaxed/simple;
	bh=RILgKvOJcx3VFOh6O1ak0h76jjIpvSieT6tO2+UqVQ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R/yo9JFLzfniQhnjfVRCMZBtr0gBTtu6jZwP7qXnFjLaBGqS+y7w1mgkk2EjbKKAQCTxFnBkk6KITxdaz3gia/HKlQ4HNq0/gfqQMzfyvHxTmQqRIPUCNfWRIXraDTIGU98CXl0VJPA4fDie4cGsnKdGHftG+NTBlROBJnxTV54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Dq8Kr2aQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Dq8Kr2aQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 703B21F000FF;
	Wed, 30 Sep 2026 18:01:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790791301;
	bh=r3PTdu8cKkoTA8Lon/uDhGCHNxrFOjK4f9TTC/wCQaU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Dq8Kr2aQLAt9lIkvPV6x+DG57RvRFJGVuaPy0aUXArHJuB7B6UHMXlUPGpUn7p+oN
	 Z4sWQ4fGxu7zpG8h5+vB3K2rJTFg9Z3XHcOqDV+rBaH8pURoCserdpkqZBJtPT4Ut7
	 qNjYjz/+8S+8xIB72Dlcy+XIiQ5DVhYsnQg1ikpk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pauli Virtanen <pav@iki.fi>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 253/752] Bluetooth: L2CAP: clear FLAG_DEFER_SETUP only for same PID/PSM
Date: Wed, 30 Sep 2026 17:22:03 +0200
Message-ID: <20260930152403.754951954@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pauli Virtanen <pav@iki.fi>

[ Upstream commit 0d77683237270702fa93489ca759c89b4e970554 ]

l2cap_ecred_defer_connect() clears FLAG_DEFER_SETUP also for channels
with different PID/PSM, which will not be added to the same
ECRED_CONN_REQ in any case. Consequently, only one ECRED connection
group can work at a time although it appears intended they would be
separate for each PID/PSM combination.

Fix by clearing FLAG_DEFER_SETUP only for the connections that could be
added in the request. Retain test_bit(FLAG_DEFER_SETUP) before calling
get_peer_pid as it may be NULL otherwise.

Fixes: da49b602f7f7 ("Bluetooth: L2CAP: Use DEFER_SETUP to group ECRED connections")
Signed-off-by: Pauli Virtanen <pav@iki.fi>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/l2cap_core.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
index 350aee916b175..ece7d37339c46 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -1451,7 +1451,7 @@ static void l2cap_ecred_defer_connect(struct l2cap_chan *chan, void *data)
 	if (chan == conn->chan)
 		return;
 
-	if (!test_and_clear_bit(FLAG_DEFER_SETUP, &chan->flags))
+	if (!test_bit(FLAG_DEFER_SETUP, &chan->flags))
 		return;
 
 	pid = chan->ops->get_peer_pid(chan);
@@ -1461,6 +1461,9 @@ static void l2cap_ecred_defer_connect(struct l2cap_chan *chan, void *data)
 	    chan->mode != L2CAP_MODE_EXT_FLOWCTL || chan->state != BT_CONNECT)
 		return;
 
+	if (!test_and_clear_bit(FLAG_DEFER_SETUP, &chan->flags))
+		return;
+
 	if (test_and_set_bit(FLAG_ECRED_CONN_REQ_SENT, &chan->flags))
 		return;
 
-- 
2.53.0



