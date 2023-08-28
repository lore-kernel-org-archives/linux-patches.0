Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FAAE11C83
	for <patches@lists.linux.dev>; Mon, 28 Aug 2023 10:48:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F36AC433C7;
	Mon, 28 Aug 2023 10:48:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1693219733;
	bh=e8WhbKoxHgdj4+DQR+1gdLH6K1ifzgb76ed3e0lX6y8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A48qjH4+rhhfjv6Y9HlTmQhkmBKm5V6EY86z6VmTJ7jvkvIyF5PeRTEdHPR1VGe88
	 AKlP5Ycyejhurnjl4vQo8OlSyti85/fkEpK+DrXukCZ2ZGlNJUtYPb79LU/9+DO9yl
	 oouXIccUlIRNmC6cKUL91NqvbNL5+gPUsw4oVuRw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Remi Pommarel <repk@triplefau.lt>,
	Sven Eckelmann <sven@narfation.org>,
	Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 5.10 53/84] batman-adv: Fix batadv_v_ogm_aggr_send memory leak
Date: Mon, 28 Aug 2023 12:14:10 +0200
Message-ID: <20230828101151.062435171@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230828101149.146126827@linuxfoundation.org>
References: <20230828101149.146126827@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Remi Pommarel <repk@triplefau.lt>

commit 421d467dc2d483175bad4fb76a31b9e5a3d744cf upstream.

When batadv_v_ogm_aggr_send is called for an inactive interface, the skb
is silently dropped by batadv_v_ogm_send_to_if() but never freed causing
the following memory leak:

  unreferenced object 0xffff00000c164800 (size 512):
    comm "kworker/u8:1", pid 2648, jiffies 4295122303 (age 97.656s)
    hex dump (first 32 bytes):
      00 80 af 09 00 00 ff ff e1 09 00 00 75 01 60 83  ............u.`.
      1f 00 00 00 b8 00 00 00 15 00 05 00 da e3 d3 64  ...............d
    backtrace:
      [<0000000007ad20f6>] __kmalloc_track_caller+0x1a8/0x310
      [<00000000d1029e55>] kmalloc_reserve.constprop.0+0x70/0x13c
      [<000000008b9d4183>] __alloc_skb+0xec/0x1fc
      [<00000000c7af5051>] __netdev_alloc_skb+0x48/0x23c
      [<00000000642ee5f5>] batadv_v_ogm_aggr_send+0x50/0x36c
      [<0000000088660bd7>] batadv_v_ogm_aggr_work+0x24/0x40
      [<0000000042fc2606>] process_one_work+0x3b0/0x610
      [<000000002f2a0b1c>] worker_thread+0xa0/0x690
      [<0000000059fae5d4>] kthread+0x1fc/0x210
      [<000000000c587d3a>] ret_from_fork+0x10/0x20

Free the skb in that case to fix this leak.

Cc: stable@vger.kernel.org
Fixes: 0da0035942d4 ("batman-adv: OGMv2 - add basic infrastructure")
Signed-off-by: Remi Pommarel <repk@triplefau.lt>
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/batman-adv/bat_v_ogm.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/net/batman-adv/bat_v_ogm.c
+++ b/net/batman-adv/bat_v_ogm.c
@@ -123,8 +123,10 @@ static void batadv_v_ogm_send_to_if(stru
 {
 	struct batadv_priv *bat_priv = netdev_priv(hard_iface->soft_iface);
 
-	if (hard_iface->if_status != BATADV_IF_ACTIVE)
+	if (hard_iface->if_status != BATADV_IF_ACTIVE) {
+		kfree_skb(skb);
 		return;
+	}
 
 	batadv_inc_counter(bat_priv, BATADV_CNT_MGMT_TX);
 	batadv_add_counter(bat_priv, BATADV_CNT_MGMT_TX_BYTES,


