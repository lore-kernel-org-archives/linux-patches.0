Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0672A329E7E;
	Sun,  7 Jun 2026 10:35:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780828515; cv=none; b=bNYvf69oeOA8BZ5ox8Gc2zctauBajQa6DNkODyQE1l9GYuHXTv5a94aBKf+/TpEYudTSIBPFcHcGIF6EruLNs3GAQN72s3SO0tsl1cMdMhz+0wPU6bisfPd4YYJBE+fAqXMiFPl49VHgLZMjVr+Yhtjuqr16Wna5y49Gf9jP0yA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780828515; c=relaxed/simple;
	bh=Fm9Dt2AbKwMXV1SL6QCBB9FhmI7Pt0wzyA4QXRz4B/8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U2B1JpyTPFZlawjCmrYL7asYBRZLXc6VFXo0u77XZqNm2bRuIY6Mi4sz7slK9o6M+w3reWfUG49+wssjXQJnuGNHL0Sm0pmm3YJu/NeZAt8FQND8TbRfflqB0AjmYGus8qdSpf3wguast3JVwhmnF/VyMCchse1uvQ366ck2TLw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ShWOvbiT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ShWOvbiT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9E131F00893;
	Sun,  7 Jun 2026 10:35:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780828513;
	bh=Hp0Bo085WA4X6FMcxhmXGhByi5h8KEZ3+izdpwdi6Io=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ShWOvbiTvXcc3M40xMPuj7/BResmCZsWs4m+l6riz0gH3rkpAz8IUHw8V9vAsW7bg
	 P0ElS5TEFCi7nYvBC9Z3/htuswSzgyB5uJpxosqZWu7auT5fN/lo45PlhA2chcZv0K
	 znSBXne9ZaO6vzWMdSBIWVurDbaIgLniV1wtc+9o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Siwei Zhang <oss@fourdim.xyz>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.12 144/307] Bluetooth: L2CAP: fix chan ref leak in l2cap_chan_timeout() on !conn
Date: Sun,  7 Jun 2026 11:59:01 +0200
Message-ID: <20260607095733.023358594@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.647295505@linuxfoundation.org>
References: <20260607095727.647295505@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


