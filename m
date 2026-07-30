Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FDD12D0602;
	Thu, 30 Jul 2026 15:58:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427111; cv=none; b=bB7n63NGZ/r9TegZI7GqVnUvEHKvNZzXqKjLe4vCjhnmYzkF/1xpQOIoL4s0RkyWtObYzR1mnr8oQX8RvFtYsRhk3dzgNG9dSKCf42csYiPnj6LdTn486lisgen63cfQUP0IT5oNVBCr1m/gawfvA/V3jg39ODZaY97H4eRiLZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427111; c=relaxed/simple;
	bh=jJsLnl/mIDB8crOSMppB06lhiVaCPe+8XnhYYoeyaWA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HUD/DywDa13V74Pp60dJbWM3H2QQvutsWLQd3G73yHXsJEupbhOhYxezEoljVOakZ7fFxYi98EdONlAjOmBf51/SfnbQf9Fbs2JAmr4Q4imCcL4t6Y2hJm7Kxcs97Kcguve+qWbVtc6RZl7nF0OlMTAZAEx7gP4ov59CKwqlB+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0Y6HAcCX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0Y6HAcCX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CE391F000E9;
	Thu, 30 Jul 2026 15:58:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785427110;
	bh=w7832UCCNaK8kHqCrJto5d5WfPqsDSEAfEKCVZVPIYY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0Y6HAcCXSZxuzt4u4+QaYUmeJXfPnc72ywuu3QU2mKgnrkLyh4Xta3jUWNBW88SXF
	 MsN+5YFZXeCS4Cj+IGq+TuglmQKohx+9Ict1A5Ys0UHEQLZPqde6H8/Fdq+j7j2cjh
	 Pket3i6WE/8EcwJTyYWN1QJUT5eBYhh5B7xuUNB0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryam Vargas <hexlabsecurity@proton.me>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 055/484] wifi: mac80211_hwsim: clamp virtio RX length before skb_put
Date: Thu, 30 Jul 2026 16:09:12 +0200
Message-ID: <20260730141424.623346790@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
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
 drivers/net/wireless/virtual/mac80211_hwsim.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/virtual/mac80211_hwsim.c b/drivers/net/wireless/virtual/mac80211_hwsim.c
index bf12ff0ab06ab3..c9bfea77d0ecae 100644
--- a/drivers/net/wireless/virtual/mac80211_hwsim.c
+++ b/drivers/net/wireless/virtual/mac80211_hwsim.c
@@ -6383,6 +6383,7 @@ static void hwsim_virtio_rx_work(struct work_struct *work)
 
 	skb->data = skb->head;
 	skb_reset_tail_pointer(skb);
+	len = min(len, skb_end_offset(skb));
 	skb_put(skb, len);
 	hwsim_virtio_handle_cmd(skb);
 
-- 
2.53.0



