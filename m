Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22BE527D786;
	Mon, 17 Aug 2026 14:22:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786976558; cv=none; b=nntevmeZRzJKdLFC/U8h7YVrbymi9kUxWqWjc6xtd2vMaiBd1l1oo059WCHwWH0d0CCxaYmf1qo51iOIuMlpjvpfT1pe61pnq0nBMeQLaG9pOpFXuLK88N4nva5vSLayl0nXR2v1Sf8FhDIUakh318MFdCGfkOBMrAx5cakn5Pw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786976558; c=relaxed/simple;
	bh=zOt1qmrpii7ZWU8vLuQ9pWJsfsqjfi935RB+3lIZJX8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CTBEzKNqKzxV1RgKy3QZW4CIujBlXDLVp25+54N4oTGW4QnOFmwps6FzYM44LWLgIddz1ILCWbm1r5RESMWt/lCn6gvuLJ9oLfv2BSbJ1Z7xiygILG2frz2f9TjHK9pf0WlPWBrzSAzoeuakCT8xpZYrxYeT4sRw9FsaeiaxTsA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pfKjGnoA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pfKjGnoA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BF541F00A3A;
	Mon, 17 Aug 2026 14:22:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786976557;
	bh=5xpZO0Sl/HX839mfM9hhacKkS1ERU4ZQ/Nno5GCyB28=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pfKjGnoA6jnXuIgL1excLE/FVpEEU41G6aAJ9wpMQVQZoFP9GKp3hLKnInvysJqzP
	 VXVzreYJgJpSOkcGZnR8PolLN7hOq/VFc086cjysZB9ovDygoD1auRIeqVLz+LlUN2
	 eTTZcsGR2Kk0SeM5peNUziXa5UtqKDmciXGAxCaQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryam Vargas <hexlabsecurity@proton.me>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 025/456] wifi: mac80211_hwsim: clamp virtio RX length before skb_put
Date: Mon, 17 Aug 2026 15:26:55 +0200
Message-ID: <20260817132540.963506650@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
References: <20260817132539.792407575@linuxfoundation.org>
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
index ed4d83775fe705..9c102c25a5332f 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -4332,6 +4332,7 @@ static void hwsim_virtio_rx_work(struct work_struct *work)
 
 	skb->data = skb->head;
 	skb_reset_tail_pointer(skb);
+	len = min(len, skb_end_offset(skb));
 	skb_put(skb, len);
 	hwsim_virtio_handle_cmd(skb);
 
-- 
2.53.0



