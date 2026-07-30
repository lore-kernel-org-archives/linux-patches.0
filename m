Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48C2744CAC1;
	Thu, 30 Jul 2026 15:30:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785425405; cv=none; b=FM0Q11QWNMafiagpwfvbulmDw+xKzTpugNs18AUTOGOVjN0ImCP0cgw2QSF1vwgaOL4oWSOOs9SbJqhrteAzeXeDI0+83ah57WT4S5xYC/50zRX/8SSsZsBVENA1gaVG8VHK65F9n/+2mZ4OPRQt0IhS2V18msS12MfBSL8YqU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785425405; c=relaxed/simple;
	bh=eTYf6DQA/9UgnWkhBHI2ArmFVSutDFPTO197Src4r7s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q8ggGXMDRfIGwmCG1Y21ABh4inZ+CzbA82vuRNmnzpsIlV5UjwxevqSV8OYFvFc/0suiAdF6xwO66maYh2sB8LK3chuNa4PV7AkjNpk1okm211KW2ADPHbwHux6TZW6+yoDveIHbWwdBopabr8qZ6NSO1KK9FoBIC/OTGHmTNPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kJZBLDSX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kJZBLDSX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2581D1F00A3D;
	Thu, 30 Jul 2026 15:29:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785425400;
	bh=nIfb1HB/hbIc4LYzkwBv/+UiflvVEiKKYYvEOXL55XY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kJZBLDSX1uASSLOJc2I6lMNaMjrxacWjtptEZTJUslRZlYRGFNMVG+bY9EMqbRMIi
	 UmKazlP3iy38SXC54WMB51NeoCrv0Y6RJ2YZ2vdDA1uCp+5+/a8QKaiPBxPXZYlfud
	 hh3ofBB4JE/CxIMwzT0KHuYCeOqsrI2zIbfsh6kk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryam Vargas <hexlabsecurity@proton.me>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 057/602] wifi: mac80211_hwsim: clamp virtio RX length before skb_put
Date: Thu, 30 Jul 2026 16:07:29 +0200
Message-ID: <20260730141437.201690605@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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
index e992e59b591892..63fae67c816225 100644
--- a/drivers/net/wireless/virtual/mac80211_hwsim.c
+++ b/drivers/net/wireless/virtual/mac80211_hwsim.c
@@ -6605,6 +6605,7 @@ static void hwsim_virtio_rx_work(struct work_struct *work)
 
 	skb->data = skb->head;
 	skb_reset_tail_pointer(skb);
+	len = min(len, skb_end_offset(skb));
 	skb_put(skb, len);
 	hwsim_virtio_handle_cmd(skb);
 
-- 
2.53.0



