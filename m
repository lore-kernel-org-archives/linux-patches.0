Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 652A813DBA0;
	Sun,  7 Jun 2026 10:27:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780828048; cv=none; b=R67VXbtLcxEmIpd3As5AI+Pg4v1WZzQ+p8uhmP7IGtS+r84PyeGZxcw9R0YRa3N9YekRgX/Xu5SNDpIU+6DMKCOj6FlWmvx/+vHOWu/plNTB7ODBm40q2zaz83+SZhAYDqof3gtbmWpdPkY0yBHED+JFA64Xua8CbF6wLOrlKqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780828048; c=relaxed/simple;
	bh=CKgm7a+/mVEt+I4jmm4hy2jd9QSCJN6qC2ZpZAb49io=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=onArpg20zupsM3v9LPGO5HrZ8Q1ibsX9NKjzs8qa88+7G7fRwFM1jgtCSfAeEd7kEYKhoGWCGYLlFNCGHsfobOUPlaTYAhDja28syAwBi9QNHHSqB2OH/hRjuvOk11e3Gcb5hK5bpgYCbBbuUdILgXKId8dTlrsf3H2hosJOf8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q7XoBHia; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q7XoBHia"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7BA21F00893;
	Sun,  7 Jun 2026 10:27:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780828047;
	bh=6CU7yEZt3GoMSgbBf5pDIkAMnW77vt5/GTy+HsFyOj0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=q7XoBHiaqWyI7sTIKx+jnkNsQHNijPpN7pEqVCXgz222FbXs4po1Vk689DWqZ7e1s
	 cEBfKkOGOtGX0CjlTJDTKr1+Gh9b393yAAYWw7o9dGsZAm0ZPhL86EsYzZjGPBmr8C
	 JjvcUNBVY3ZxK/+H6AhIS1APB31HHC8fFha8tIL8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Siwei Zhang <oss@fourdim.xyz>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 7.0 147/332] Bluetooth: L2CAP: fix chan ref leak in l2cap_chan_timeout() on !conn
Date: Sun,  7 Jun 2026 11:58:36 +0200
Message-ID: <20260607095733.493106215@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095728.031258202@linuxfoundation.org>
References: <20260607095728.031258202@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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


