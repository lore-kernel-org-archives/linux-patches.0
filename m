Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EB9132B138;
	Tue, 16 Jun 2026 16:47:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781628454; cv=none; b=EpS5V7dJ7NBnQGknsmE8/RVnWZ741Hm58qP/VUP99L2oukRV+z3iOzozkCIJFRjskvCBn3EPWFgwB7CpT2HvkeoOEoJdRZ8IwXiozGKfCpldsY75TBSegOCSYlhCXTNDLfVGIU/b45zUYR9FZIz79b4XLFwLcNYitHzyJahA+7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781628454; c=relaxed/simple;
	bh=Q/BzrTUV2clT6IuCpUpX9YwZLmR4GxzQeHUaJjK2kQs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BJ2/PqQMq3H0kW5CD85sMSPpDMC1L+VeAJJG7vwZHOlshbnXTWmEeuRIhaDIjin7GxlM2kyqVTZXSYmWunQ5aJ8Va+pynvlPow4v9MJT0nXZVeGSQQLinSX09QVW05QwZfKPJB3sJQBJKHLIiwRJZXfIXE5avm7vGQAKKHdeB1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GSwyeDU7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GSwyeDU7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81EAF1F000E9;
	Tue, 16 Jun 2026 16:47:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781628453;
	bh=WzAOEW0sGFTMnOnqDRbciC3J9Wb0O2acefGmR9OeyHY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GSwyeDU7SDgBh8FMfpOxfS7regTGiMHCJJY6xstT5zk6+ll3OLZWhgZqXxMuBFVnB
	 uxNN5Vhrm6ew81lt+P22FtbkiKR3fBLtwyUal6jTmvsxHs1rN8MupZsbaHQ2iJSRLF
	 EVALbIdZwedLSaHgnicbyGMeiEQL1nfKYiwOUJWU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Siwei Zhang <oss@fourdim.xyz>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.6 098/452] Bluetooth: L2CAP: fix chan ref leak in l2cap_chan_timeout() on !conn
Date: Tue, 16 Jun 2026 20:25:25 +0530
Message-ID: <20260616145122.947959292@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145117.796205997@linuxfoundation.org>
References: <20260616145117.796205997@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Siwei Zhang <oss@fourdim.xyz>

commit 9dbd84990394c51f5cee1e8871bb5ff8af5ed939 upstream.

__set_chan_timer() takes a l2cap_chan reference via l2cap_chan_hold()
before scheduling the delayed work.  The normal path in
l2cap_chan_timeout() drops this reference with l2cap_chan_put() at the
end, but the early return when chan->conn is NULL skips the put,
leaking the reference.

Add the missing l2cap_chan_put() before the early return.

Fixes: adf0398cee86 ("Bluetooth: l2cap: fix null-ptr-deref in l2cap_chan_timeout")
Cc: stable@vger.kernel.org
Signed-off-by: Siwei Zhang <oss@fourdim.xyz>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/l2cap_core.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -411,8 +411,10 @@ static void l2cap_chan_timeout(struct wo
 
 	BT_DBG("chan %p state %s", chan, state_to_string(chan->state));
 
-	if (!conn)
+	if (!conn) {
+		l2cap_chan_put(chan);
 		return;
+	}
 
 	mutex_lock(&conn->lock);
 	/* __set_chan_timer() calls l2cap_chan_hold(chan) while scheduling


