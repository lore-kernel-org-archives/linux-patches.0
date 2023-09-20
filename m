Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A036B2E63B
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 12:12:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25D5DC433CA;
	Wed, 20 Sep 2023 12:12:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695211939;
	bh=8YHdEDzc1bqH6tF6K6Z2yabx8kcr57XeSM9uOeFJZGE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mYv5dlzoHpcVuUYl0ARN7suwppXOd4HOQZTDzRZosRo7JaZ4MtzjvGgxhWB9czu6G
	 0CkFxwQ29/9aSFdaeRm5CPtZPkA6wHjccpSJSRYQ0Oo+YRZZiKlbzMkklK8ApHpZiy
	 cN4971qxIeHk5CYgJs8aVzrOJydJ8VKccChKfqAM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fedor Pchelkin <pchelkin@ispras.ru>,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
	Kalle Valo <quic_kvalo@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 065/273] wifi: ath9k: fix races between ath9k_wmi_cmd and ath9k_wmi_ctrl_rx
Date: Wed, 20 Sep 2023 13:28:25 +0200
Message-ID: <20230920112848.471489794@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112846.440597133@linuxfoundation.org>
References: <20230920112846.440597133@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fedor Pchelkin <pchelkin@ispras.ru>

[ Upstream commit b674fb513e2e7a514fcde287c0f73915d393fdb6 ]

Currently, the synchronization between ath9k_wmi_cmd() and
ath9k_wmi_ctrl_rx() is exposed to a race condition which, although being
rather unlikely, can lead to invalid behaviour of ath9k_wmi_cmd().

Consider the following scenario:

CPU0					CPU1

ath9k_wmi_cmd(...)
  mutex_lock(&wmi->op_mutex)
  ath9k_wmi_cmd_issue(...)
  wait_for_completion_timeout(...)
  ---
  timeout
  ---
					/* the callback is being processed
					 * before last_seq_id became zero
					 */
					ath9k_wmi_ctrl_rx(...)
					  spin_lock_irqsave(...)
					  /* wmi->last_seq_id check here
					   * doesn't detect timeout yet
					   */
					  spin_unlock_irqrestore(...)
  /* last_seq_id is zeroed to
   * indicate there was a timeout
   */
  wmi->last_seq_id = 0
  mutex_unlock(&wmi->op_mutex)
  return -ETIMEDOUT

ath9k_wmi_cmd(...)
  mutex_lock(&wmi->op_mutex)
  /* the buffer is replaced with
   * another one
   */
  wmi->cmd_rsp_buf = rsp_buf
  wmi->cmd_rsp_len = rsp_len
  ath9k_wmi_cmd_issue(...)
    spin_lock_irqsave(...)
    spin_unlock_irqrestore(...)
  wait_for_completion_timeout(...)
					/* the continuation of the
					 * callback left after the first
					 * ath9k_wmi_cmd call
					 */
					  ath9k_wmi_rsp_callback(...)
					    /* copying data designated
					     * to already timeouted
					     * WMI command into an
					     * inappropriate wmi_cmd_buf
					     */
					    memcpy(...)
					    complete(&wmi->cmd_wait)
  /* awakened by the bogus callback
   * => invalid return result
   */
  mutex_unlock(&wmi->op_mutex)
  return 0

To fix this, update last_seq_id on timeout path inside ath9k_wmi_cmd()
under the wmi_lock. Move ath9k_wmi_rsp_callback() under wmi_lock inside
ath9k_wmi_ctrl_rx() so that the wmi->cmd_wait can be completed only for
initially designated wmi_cmd call, otherwise the path would be rejected
with last_seq_id check.

Found by Linux Verification Center (linuxtesting.org) with Syzkaller.

Fixes: fb9987d0f748 ("ath9k_htc: Support for AR9271 chipset.")
Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
Acked-by: Toke Høiland-Jørgensen <toke@toke.dk>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://lore.kernel.org/r/20230425192607.18015-1-pchelkin@ispras.ru
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath9k/wmi.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/wmi.c b/drivers/net/wireless/ath/ath9k/wmi.c
index 5e2a610df61cf..44faa12a7205c 100644
--- a/drivers/net/wireless/ath/ath9k/wmi.c
+++ b/drivers/net/wireless/ath/ath9k/wmi.c
@@ -239,10 +239,10 @@ static void ath9k_wmi_ctrl_rx(void *priv, struct sk_buff *skb,
 		spin_unlock_irqrestore(&wmi->wmi_lock, flags);
 		goto free_skb;
 	}
-	spin_unlock_irqrestore(&wmi->wmi_lock, flags);
 
 	/* WMI command response */
 	ath9k_wmi_rsp_callback(wmi, skb);
+	spin_unlock_irqrestore(&wmi->wmi_lock, flags);
 
 free_skb:
 	kfree_skb(skb);
@@ -305,8 +305,8 @@ int ath9k_wmi_cmd(struct wmi *wmi, enum wmi_cmd_id cmd_id,
 	struct ath_common *common = ath9k_hw_common(ah);
 	u16 headroom = sizeof(struct htc_frame_hdr) +
 		       sizeof(struct wmi_cmd_hdr);
+	unsigned long time_left, flags;
 	struct sk_buff *skb;
-	unsigned long time_left;
 	int ret = 0;
 
 	if (ah->ah_flags & AH_UNPLUGGED)
@@ -342,7 +342,9 @@ int ath9k_wmi_cmd(struct wmi *wmi, enum wmi_cmd_id cmd_id,
 	if (!time_left) {
 		ath_dbg(common, WMI, "Timeout waiting for WMI command: %s\n",
 			wmi_cmd_to_name(cmd_id));
+		spin_lock_irqsave(&wmi->wmi_lock, flags);
 		wmi->last_seq_id = 0;
+		spin_unlock_irqrestore(&wmi->wmi_lock, flags);
 		mutex_unlock(&wmi->op_mutex);
 		kfree_skb(skb);
 		return -ETIMEDOUT;
-- 
2.40.1



