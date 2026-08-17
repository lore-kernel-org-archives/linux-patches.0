Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76F1D2D2495;
	Mon, 17 Aug 2026 15:01:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786978910; cv=none; b=kc+LIr1TxC2CPzIcxornNjKsQvavWrH3VVGanS/dsPMp3WoW8CFAN26qiVyYaxliVw3eUt4IwSzKhxdqFOv36BqWSMTTpS9GVGxzJrf9lZ+WaRLwZnW+U6xz3YGyuhGhbGYha/gpWA4mdyZ8S0LxEWVt98DAB178/SLz5h+OhkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786978910; c=relaxed/simple;
	bh=UVBL86edsPvlK5dojKiWcBC0io7iL5jWj5YnFUyhtBs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RZ1G6Grw1GtrWZvWSq9XBXpJgGxkfRh9+dbp8i8zeXNmjbjTyqQpbGDKUkAvFWCSkJMvw/aaZe/dwwxpkp5EGv8bgvGo3ebz+QlrNBE60SYRyCzkf31e0Titj/kG4JtEuqP3nmA7ArYgojBtwA3tqmWk+oCN3VcqXDcqnz30P5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WWh7UQ1b; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WWh7UQ1b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D22C21F000E9;
	Mon, 17 Aug 2026 15:01:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786978909;
	bh=gzj6ix9qEEqPT8HDiTwBAFWZ101WmrxIDfeQwOOg1CI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WWh7UQ1b7KJILtwxpTmqnHbpPMno6jQbedisg3UuJtoyoq4CPjoauBdd+WE43JqR7
	 8aC0kk3wPsaeGrbGOscNZaJL+H9m6qcB2vUFSXBkS6R39NnyQXClBJrYAa6tm5Wd+K
	 HHPVf0cWbcMu1JJlX0TOUlWwvVooLr5rdPw3GnW4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryam Vargas <hexlabsecurity@proton.me>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 042/609] wifi: mac80211_hwsim: clamp virtio RX length before skb_put
Date: Mon, 17 Aug 2026 15:25:38 +0200
Message-ID: <20260817132544.719503107@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bryam Vargas <hexlabsecurity@proton.me>

[ Upstream commit 10a2b430f8f06ae14b9590b6f6faa6b588ef0654 ]

hwsim_virtio_rx_work() passes the virtqueue used-ring length reported by
the device straight to skb_put() on a fixed-size receive skb. A backend
reporting a length larger than the skb tailroom drives skb_put() past the
buffer end and hits skb_over_panic() -- a host-triggerable guest panic
(denial of service).

Clamp the length to the skb's available room before skb_put(). A
conforming device never reports more than the posted buffer size, so valid
frames are unaffected; a truncated over-report then fails the
length/header checks in hwsim_virtio_handle_cmd() and is dropped, so
truncating rather than dropping here cannot be turned into a parsing
problem.

Fixes: 5d44fe7c9808 ("mac80211_hwsim: add frame transmission support over virtio")
Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>
Link: https://patch.msgid.link/20260620-b4-disp-474bee37-v1-1-1a4d37f3e2d4@proton.me
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mac80211_hwsim.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 316b5f56b6e53f..bb9dabbf1f22c6 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -5564,6 +5564,7 @@ static void hwsim_virtio_rx_work(struct work_struct *work)
 
 	skb->data = skb->head;
 	skb_reset_tail_pointer(skb);
+	len = min(len, skb_end_offset(skb));
 	skb_put(skb, len);
 	hwsim_virtio_handle_cmd(skb);
 
-- 
2.53.0



