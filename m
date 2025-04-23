Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0A8D27F4F3;
	Wed, 23 Apr 2025 14:46:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745419593; cv=none; b=eS9qa3dHMUCHdNt8KnKtyOq9cZacXRipWYXJj+PrO4H6u67sJu90F31LlwKD0kGX48m6o9mDxofaEvw0FBu4hN6C3k5++B1RGr+xsBTQtrTlqltqF46JpHJUD/+qSyV5NSWyRRbXMfx10+53I7W/wRR/VNrrYgjPn1NFa/3+Pb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745419593; c=relaxed/simple;
	bh=qf0Jf0Z9BFMmBWAF+a55lAm0Z45jJWWVsG6Y5HQpZDE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FKkQPr5T5kuUwslva9Efs+hWgPmkDoZ8VBgAU4Df60KQA9e3cuTEq6YvwMSn5XHJ/HHyk4SRqH/2UcPHChdny42FqjYRgmnafKDhAQ60Bn461RsV+SznQ2zie6c+8934Yo+ig+XeSfVhiiQhuWhKEirNA/n6IeFtTwgjopsuJd0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0+e5im6A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0+e5im6A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3294DC4CEE8;
	Wed, 23 Apr 2025 14:46:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745419593;
	bh=qf0Jf0Z9BFMmBWAF+a55lAm0Z45jJWWVsG6Y5HQpZDE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0+e5im6Att0bYyGGpUxpEYGakwdzXIzLkC65bYlIoE9oCt+R3tFAeMdyiZeaxTm56
	 sB0u0v/Zc79g4M+70eCvWJ24w7kDhjS/IQ33F9NLFXzq2viD0l/g5QbXz8kWf4tpHg
	 fWpvv0XjjRiUxIR+npQ90xuqTdC49yxZk9wlWb1Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <abdun.nihaal@gmail.com>,
	Michael Nemanov <michael.nemanov@ti.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 005/223] wifi: wl1251: fix memory leak in wl1251_tx_work
Date: Wed, 23 Apr 2025 16:41:17 +0200
Message-ID: <20250423142617.338791712@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142617.120834124@linuxfoundation.org>
References: <20250423142617.120834124@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Abdun Nihaal <abdun.nihaal@gmail.com>

[ Upstream commit a0f0dc96de03ffeefc2a177b7f8acde565cb77f4 ]

The skb dequeued from tx_queue is lost when wl1251_ps_elp_wakeup fails
with a -ETIMEDOUT error. Fix that by queueing the skb back to tx_queue.

Fixes: c5483b719363 ("wl12xx: check if elp wakeup failed")
Signed-off-by: Abdun Nihaal <abdun.nihaal@gmail.com>
Reviewed-by: Michael Nemanov <michael.nemanov@ti.com>
Link: https://patch.msgid.link/20250330104532.44935-1-abdun.nihaal@gmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ti/wl1251/tx.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ti/wl1251/tx.c b/drivers/net/wireless/ti/wl1251/tx.c
index 474b603c121cb..adb4840b04893 100644
--- a/drivers/net/wireless/ti/wl1251/tx.c
+++ b/drivers/net/wireless/ti/wl1251/tx.c
@@ -342,8 +342,10 @@ void wl1251_tx_work(struct work_struct *work)
 	while ((skb = skb_dequeue(&wl->tx_queue))) {
 		if (!woken_up) {
 			ret = wl1251_ps_elp_wakeup(wl);
-			if (ret < 0)
+			if (ret < 0) {
+				skb_queue_head(&wl->tx_queue, skb);
 				goto out;
+			}
 			woken_up = true;
 		}
 
-- 
2.39.5



