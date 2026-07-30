Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26E6E44331B;
	Thu, 30 Jul 2026 14:21:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785421292; cv=none; b=JvZz5wuGh8z3vo6Etv58/LdsuyseJ30MF+h6j6UrfyYvmN5LyItG6QTlQ+ACiooZ0BWMVbOxIlveqlNiZNwoBSCgh1k3lKziMWHqPmbx49CmMmFTfkvEyAvwZtB0Ips9XJmasjl1c+ur0sQ6fXwjgY9NUtLgWVO3Nnd1/EeqRQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785421292; c=relaxed/simple;
	bh=i98lV0+D0putd1VocSUVICLMUDRQ1gAb1mWtkbN3LLE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aMtZEdXtXddIInZPvjt69ACMkSdlUpuHw3iUWzhp3CR3KPAHrd+Cma1LbORwgbJ0kkbj9qVmrt+YFcM/KvD9Lx9kZvIkHtoxF4sQxtO/Bt/bXAUkghNIBvVXDLhI8ILJKvZVtkIoQZGCRCT43ogXv0w/rPo+9BSapXZg3iM44mc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WgOXeVk9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WgOXeVk9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1149E1F000E9;
	Thu, 30 Jul 2026 14:21:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785421287;
	bh=6jkroXt1Hyu9IND87GrJEPz2vwyzomTX8RzxFxe3jhs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WgOXeVk9n9jl30OD3zXzbE5EK1u1dss1DkdUpdLkh2AXFh48D3KGNJ7N9esU7kSGE
	 KRx3omuin+sEt/JtNM3P/jLgWH96W5ja98ceTfEo56WVinpRy3Sk7D6iOvrgNuAadR
	 9YUBrwXTd0SlNNh56bHRL7MDKQKuEFQaG0QLTE58=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryam Vargas <hexlabsecurity@proton.me>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 053/744] wifi: mac80211_hwsim: clamp virtio RX length before skb_put
Date: Thu, 30 Jul 2026 16:05:26 +0200
Message-ID: <20260730141445.405690716@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index 1fcf5d0d2e13fe..17bf8e547b25be 100644
--- a/drivers/net/wireless/virtual/mac80211_hwsim.c
+++ b/drivers/net/wireless/virtual/mac80211_hwsim.c
@@ -7122,6 +7122,7 @@ static void hwsim_virtio_rx_work(struct work_struct *work)
 
 	skb->data = skb->head;
 	skb_reset_tail_pointer(skb);
+	len = min(len, skb_end_offset(skb));
 	skb_put(skb, len);
 	hwsim_virtio_handle_cmd(skb);
 
-- 
2.53.0



