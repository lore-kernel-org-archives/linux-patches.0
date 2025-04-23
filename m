Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BB7828D831;
	Wed, 23 Apr 2025 15:25:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421913; cv=none; b=Jef3tSSfj1f+P9RcwmAZzv7htwSXYs3rvy8eIWILVEvxsRJeHruPWqtW5j3ShG6Gy3ECbaCkEefSfuaLCKfPmkqFXbtedbOkmi27WWxhl64Diw7ChXSeQ0L5gq8ubN2WNvQKxSkAipRwiMTU6ieGG0a/PcwurXc9LGIY8XxdQ6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421913; c=relaxed/simple;
	bh=xqeFU+74wLhSm9LD2LahRtoXtn874UwR0BO2VQTDQn0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eclNnp5TsQjeqT77ISAop+jfXpjhxkTfykhrAm+SnYNx9ZuEIbNi7J2EmsVtCVF9nrvhnDJT/fbQC0A/77QWG/hggdin31XG1v5htpDjiNlz38Gj2hCrwu791+ot6Ap8Qi3gGHUCIZV4d01WNadqPQ35EdC9GQ+LzxT2VW/ncOg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1tZxBMzT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1tZxBMzT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEF38C4CEE2;
	Wed, 23 Apr 2025 15:25:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421913;
	bh=xqeFU+74wLhSm9LD2LahRtoXtn874UwR0BO2VQTDQn0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1tZxBMzT9Ogmg7jesa2hbFk/jpmmwJlJIyAcfRlNPw4+i5fr2pMcJStCs2O3Dfup7
	 SdoPyXVvgvpKMt3Yblt8CJp2WVhu9FNTLkb1Aupjww5GgGAxPEz7FxgnMSHD2lDnCk
	 emBCT94CRlF6HkTWV4Q7ePICuajkrjqyDEte4WLk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <abdun.nihaal@gmail.com>,
	Michael Nemanov <michael.nemanov@ti.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 244/393] wifi: wl1251: fix memory leak in wl1251_tx_work
Date: Wed, 23 Apr 2025 16:42:20 +0200
Message-ID: <20250423142653.461815508@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142643.246005366@linuxfoundation.org>
References: <20250423142643.246005366@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index e9dc3c72bb110..06dc74cc6cb52 100644
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



