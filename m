Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8A2E2C1594;
	Mon, 17 Aug 2026 14:03:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786975417; cv=none; b=ewvOgPeIwIXtHSkbBPqWpSpkVTssNjzXweXe7iElZ+8Bc8lH7R20HcVwAGwkQzfUt+tRC1Ln463czM4oWB5rGodO2oJ2jtZ4tclDkKW0+EcCtd28IjheD/IUHO0mQQcUtlhfHskXgJ16SONhQfFlNhT+tmDaPUdwDeyS2v+2PsM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786975417; c=relaxed/simple;
	bh=p4n9V7SfV2LPKi/MQ7D4loEOw5Vxtgmo7KIBRJd8rfg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MMF/S+2v3kG/JQznkkM8H1nhdR0gyHIwqDSo/Z4STsyRxy17yJRyHs/tMV+/2bF9C6UdKmi/D69lbKFh/4m+MY1VMe9yXs6ljZ9vWcF3YvBTeBoHKmWPGpWiutb4Rk/IuWOaoydnaWA6RO6gUI4QlZzQE7AHxXOS28gI1bmswuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NKPnGCV8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NKPnGCV8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D3111F000E9;
	Mon, 17 Aug 2026 14:03:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786975415;
	bh=W6K1ZR0TdBoFmX7LPrJ6vaaJjqhm/JjXzKrYgXV8uqI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NKPnGCV8IhPxkFJe/13MIiYPQqYf4o/O+krsfWdAa+Gg9As5dzNKBgjTl/hT5PBs1
	 2NkP2+D8oHB5nBWsObMGeP7jSmL/yCrKet9faQC7ZsDI4JBfcAYfsBvBFa4LXXgZgL
	 gL3U0J+3zq3BO4bV8rOWro1ZVSZk68Bh4iIe+Y/I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryam Vargas <hexlabsecurity@proton.me>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 020/389] wifi: mac80211_hwsim: clamp virtio RX length before skb_put
Date: Mon, 17 Aug 2026 15:27:39 +0200
Message-ID: <20260817132539.672566504@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132538.796021292@linuxfoundation.org>
References: <20260817132538.796021292@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index d8b997859de063..02c31f7fcfd13c 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -4335,6 +4335,7 @@ static void hwsim_virtio_rx_work(struct work_struct *work)
 
 	skb->data = skb->head;
 	skb_reset_tail_pointer(skb);
+	len = min(len, skb_end_offset(skb));
 	skb_put(skb, len);
 	hwsim_virtio_handle_cmd(skb);
 
-- 
2.53.0



