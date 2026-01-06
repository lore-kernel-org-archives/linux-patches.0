Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19873355031;
	Tue,  6 Jan 2026 17:49:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767721756; cv=none; b=twT+JsZrz7gLwHdIARYjqceCttQYfgRh5Gkm7KeURd4vuplZwTMcqZoAJTh7VHgRnotIZI24RqXWMp5dRdypvkuIkLGTyZecssOMtJXhRCglBIhK+dyauZNPxK+mDQb9spiD042rY4OV46HNugwgVIKrec0KSclIRlJPvqsFNZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767721756; c=relaxed/simple;
	bh=1X7/dAPq6/5voaT6tOYbcat71nCBiKUMJ7r8c31bAbg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M/3s2XIk6C4fMp5EpzcIf9+QgsdQ6aEQRIeXSsNk7vbpV2NY7vQuRVZOgk29UTMgLo49+3f7hQChDTzoOqItAn9GMlLfEtO8TCZtHGRc+RF1s0kJYZ/FK5HTZDrPFs4yQXp660XzaUobrEE+LEj13JeENqOgf5wbDw67+Kuc0LQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DeJe6HdA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DeJe6HdA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22473C116C6;
	Tue,  6 Jan 2026 17:49:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767721755;
	bh=1X7/dAPq6/5voaT6tOYbcat71nCBiKUMJ7r8c31bAbg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DeJe6HdAo/wgQO9QNEP6lZqDcI3uqRg+oilVrK8+3WsA3Wh9HdgLF3GwnSMweq4SW
	 oHxlTK9T3OU2Fu9Jj9PqzkwgL9mgd3RwlluG8t9ycDxPeLUCLYfgcEVz46Ok+2W0D3
	 4s/mL/rRS3gz0O1UWcksPdD0t+GxljpvKQGqNIyg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fatma Alwasmi <falwasmi@purdue.edu>,
	Pwnverse <stanksal@purdue.edu>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 063/312] net: rose: fix invalid array index in rose_kill_by_device()
Date: Tue,  6 Jan 2026 18:02:17 +0100
Message-ID: <20260106170550.131060601@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170547.832845344@linuxfoundation.org>
References: <20260106170547.832845344@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pwnverse <stanksal@purdue.edu>

[ Upstream commit 6595beb40fb0ec47223d3f6058ee40354694c8e4 ]

rose_kill_by_device() collects sockets into a local array[] and then
iterates over them to disconnect sockets bound to a device being brought
down.

The loop mistakenly indexes array[cnt] instead of array[i]. For cnt <
ARRAY_SIZE(array), this reads an uninitialized entry; for cnt ==
ARRAY_SIZE(array), it is an out-of-bounds read. Either case can lead to
an invalid socket pointer dereference and also leaks references taken
via sock_hold().

Fix the index to use i.

Fixes: 64b8bc7d5f143 ("net/rose: fix races in rose_kill_by_device()")
Co-developed-by: Fatma Alwasmi <falwasmi@purdue.edu>
Signed-off-by: Fatma Alwasmi <falwasmi@purdue.edu>
Signed-off-by: Pwnverse <stanksal@purdue.edu>
Link: https://patch.msgid.link/20251222212227.4116041-1-ritviktanksalkar@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rose/af_rose.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/rose/af_rose.c b/net/rose/af_rose.c
index 543f9e8ebb69..fad6518e6e39 100644
--- a/net/rose/af_rose.c
+++ b/net/rose/af_rose.c
@@ -205,7 +205,7 @@ static void rose_kill_by_device(struct net_device *dev)
 	spin_unlock_bh(&rose_list_lock);
 
 	for (i = 0; i < cnt; i++) {
-		sk = array[cnt];
+		sk = array[i];
 		rose = rose_sk(sk);
 		lock_sock(sk);
 		spin_lock_bh(&rose_list_lock);
-- 
2.51.0



