Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BECBA280A27;
	Wed, 23 Apr 2025 14:47:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745419676; cv=none; b=SgWE/HdEFOgO35273Pdw7zAX7sga+lqsEVaJrlCcE6QtFDhDT57/1RL9pX9M7haPhacXICBjUGBdMD+4NgqnQwFMoOxUSoTk0H4DOCVM+bjamM8eJv1MoxP/INpXJTk56owE42SmzgbSzWJv56UtYH5a6rKD5OVYQy0jcdtH7r8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745419676; c=relaxed/simple;
	bh=PCeyVXi3nl2N2+D2VnAO7Sbc9YyK9pOwKMl+aSPpfJY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bjrnjeJiQdJSktR8crEJjHLwBKPTzWN0sWS6UBz6D7Aay9HzvD4mvAjCezV73c3uF7GZHC+7HwZlNS9oWl6Vv3kgiIH83To6QBvlsKjiDdC+2ThTeCLQyScuhq/fcU+B3zDo3gnlNbGDi8+LH58QYwx0Nn4IidCwe9yJLuj3ONY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BRyPS7vI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BRyPS7vI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6C88C4CEE2;
	Wed, 23 Apr 2025 14:47:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745419676;
	bh=PCeyVXi3nl2N2+D2VnAO7Sbc9YyK9pOwKMl+aSPpfJY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BRyPS7vI9tIqifjgx/b//6FtxcPk8neHwStL4XcwAf9577rK5a9a60QF6TyiJTdMO
	 HR4abzrCBEDpmYNvDgFvQ3lMBXscOldKvNiunfpfnsQ6X1rtkGz1skDqz5Ya1gLxUf
	 6CcQNIdydSnw4GuHznD92B2rAw/wYjYJ2LeN/Ws4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <abdun.nihaal@gmail.com>,
	Michael Nemanov <michael.nemanov@ti.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 006/241] wifi: wl1251: fix memory leak in wl1251_tx_work
Date: Wed, 23 Apr 2025 16:41:10 +0200
Message-ID: <20250423142620.786485767@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142620.525425242@linuxfoundation.org>
References: <20250423142620.525425242@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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



