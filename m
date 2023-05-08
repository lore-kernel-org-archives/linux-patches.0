Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC1D1168AD
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:17:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7360AC433EF;
	Mon,  8 May 2023 10:17:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683541071;
	bh=avuZ7CNRUuycwGqEdv+cv+nqbobALlkFCLvjpLhUfyc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eSXXdw8eeZu+9nYhEvt+ooD6CrhKXhs5Aptjm2ISL2zaA9fruZTNRtBXTzXqBTAQI
	 zRpSvo+ND8McbrLgd+OlHMgdq0ovUQx1IkBWttQQWktp9Gz97oeCSTMNsiZSCY/BIW
	 TUFIoxMt7q/CQyw4TeSkFwGLNcrib2jK2d4DoNGw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin Liska <mliska@suse.cz>,
	Edward Cree <ecree.xilinx@gmail.com>,
	Martin Habets <habetsm.xilinx@gmail.com>,
	"Jiri Slaby (SUSE)" <jirislaby@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 605/611] sfc (gcc13): synchronize ef100_enqueue_skb()s return type
Date: Mon,  8 May 2023 11:47:27 +0200
Message-Id: <20230508094441.566520685@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094421.513073170@linuxfoundation.org>
References: <20230508094421.513073170@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jiri Slaby (SUSE) <jirislaby@kernel.org>

commit 3319dbb3e755398f254c3daa04b9030197137efe upstream.

ef100_enqueue_skb() generates a valid warning with gcc-13:
  drivers/net/ethernet/sfc/ef100_tx.c:370:5: error: conflicting types for 'ef100_enqueue_skb' due to enum/integer mismatch; have 'int(struct efx_tx_queue *, struct sk_buff *)'
  drivers/net/ethernet/sfc/ef100_tx.h:25:13: note: previous declaration of 'ef100_enqueue_skb' with type 'netdev_tx_t(struct efx_tx_queue *, struct sk_buff *)'

I.e. the type of the ef100_enqueue_skb()'s return value in the declaration is
int, while the definition spells enum netdev_tx_t. Synchronize them to the
latter.

Cc: Martin Liska <mliska@suse.cz>
Cc: Edward Cree <ecree.xilinx@gmail.com>
Cc: Martin Habets <habetsm.xilinx@gmail.com>
Signed-off-by: Jiri Slaby (SUSE) <jirislaby@kernel.org>
Link: https://lore.kernel.org/r/20221031114440.10461-1-jirislaby@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/sfc/ef100_tx.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/sfc/ef100_tx.c
+++ b/drivers/net/ethernet/sfc/ef100_tx.c
@@ -367,7 +367,8 @@ void ef100_ev_tx(struct efx_channel *cha
  * Returns 0 on success, error code otherwise. In case of an error this
  * function will free the SKB.
  */
-int ef100_enqueue_skb(struct efx_tx_queue *tx_queue, struct sk_buff *skb)
+netdev_tx_t ef100_enqueue_skb(struct efx_tx_queue *tx_queue,
+			      struct sk_buff *skb)
 {
 	return __ef100_enqueue_skb(tx_queue, skb, NULL);
 }


