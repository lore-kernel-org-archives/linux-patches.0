Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD0CB2628D;
	Sat, 30 May 2026 17:53:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780163595; cv=none; b=jMshcm3jF8GaN6q7BcYh3/7iyvx9VnMTX1yXmjqeOnhRmJCjhNjz8C2Kr2yq+DmLiHOACaJx+7UlqZYNmzzPS6y40YuOQHnJCcb0odJGIwFb7+IohymPv3Wp4TGinQCVp36mqZw8APy3TRYse4km4PYsLUe8ISOzJUYzqis/9RE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780163595; c=relaxed/simple;
	bh=Ft6PnKICmDhabOTJzE4ThXduhY8GSxh3rDItmoasoB4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KJ82Jm2wlozEjrVpk+Dnuh8YPZ25SE2vSuwVN2F54XDRI0v+d2VejK/eyiP7GRQMosNjZqP/3dDEimu5r0kV+N40k0IAINi/Yt/zUmU9NBLywEp3FW9NbI0CZuSu6ZTiWI5kkHVZx/p56ygZk2UjuHrEUtHTG5Ue5v3imqKCn8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rDUErdEk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rDUErdEk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C79D1F00893;
	Sat, 30 May 2026 17:53:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780163594;
	bh=UN0w7Lv/LbJW1pv0kyjkoUpL0DuKUZudggnqkmQnH6w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rDUErdEk4Zd2jv23Kw0RJG2/NulTXR/psxVhifIU0U3ze4ALyZtAaqG1496r7L2Ua
	 BB1V+WCMagH0r0l8CpdG79Nnk+gzrR83bcJ5CazZDT1Ci4Iij6Wwbzws+gVlNffG3y
	 KuhsfuII5a+xJav0Um2WiWN2aoQ5/u9E8lVfgRUo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Siwei Zhang <oss@fourdim.xyz>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 5.15 306/776] Bluetooth: L2CAP: Fix null-ptr-deref in l2cap_sock_state_change_cb()
Date: Sat, 30 May 2026 18:00:20 +0200
Message-ID: <20260530160248.476924260@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

From: Siwei Zhang <oss@fourdim.xyz>

commit 2ff1a41a912de8517b4482e946dd951b7d80edbf upstream.

Add the same NULL guard already present in
l2cap_sock_resume_cb() and l2cap_sock_ready_cb().

Fixes: 89bc500e41fc ("Bluetooth: Add state tracking to struct l2cap_chan")
Cc: stable@kernel.org
Signed-off-by: Siwei Zhang <oss@fourdim.xyz>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/l2cap_sock.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/bluetooth/l2cap_sock.c
+++ b/net/bluetooth/l2cap_sock.c
@@ -1611,6 +1611,9 @@ static void l2cap_sock_state_change_cb(s
 {
 	struct sock *sk = chan->data;
 
+	if (!sk)
+		return;
+
 	sk->sk_state = state;
 
 	if (err)


