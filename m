Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9A816FAF
	for <patches@lists.linux.dev>; Mon, 28 Aug 2023 10:19:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59E21C433C7;
	Mon, 28 Aug 2023 10:19:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1693217941;
	bh=oMri1BRhwMl9d0g1ZR9AvkaCs8FXr6zEuXiNFNgCcKU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UoDDJSljNoxjESGMyyNez+UTNqh2y2USQSlJx8hPgxsnDlhG3q6y+D+LM4krzg2Ox
	 L6HReOSSc1qXYCdeZvJJRVOQEmFR4zjoRYQuTxeYEqjwfESOA6ZOJJqJPrsYxPF3wq
	 vvJ5ajeJ4Ep9EooXeMa1yynME441W18Xkq4s9rX8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fiona Ebner <f.ebner@proxmox.com>,
	Siva Reddy Kallam <siva.kallam@broadcom.com>,
	Prashant Sreedharan <prashant@broadcom.com>,
	Michael Chan <mchan@broadcom.com>,
	Bagas Sanjaya <bagasdotme@gmail.com>,
	Kees Cook <keescook@chromium.org>,
	Pavan Chebbi <pavan.chebbi@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 036/129] tg3: Use slab_build_skb() when needed
Date: Mon, 28 Aug 2023 12:11:55 +0200
Message-ID: <20230828101158.583818028@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230828101157.383363777@linuxfoundation.org>
References: <20230828101157.383363777@linuxfoundation.org>
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

6.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kees Cook <keescook@chromium.org>

[ Upstream commit 99b415fe8986803ba0eaf6b8897b16edc8fe7ec2 ]

The tg3 driver will use kmalloc() under some conditions. Check the
frag_size and use slab_build_skb() when frag_size is 0. Silences
the warning introduced by commit ce098da1497c ("skbuff: Introduce
slab_build_skb()"):

	Use slab_build_skb() instead
	...
	tg3_poll_work+0x638/0xf90 [tg3]

Fixes: ce098da1497c ("skbuff: Introduce slab_build_skb()")
Reported-by: Fiona Ebner <f.ebner@proxmox.com>
Closes: https://lore.kernel.org/all/1bd4cb9c-4eb8-3bdb-3e05-8689817242d1@proxmox.com
Cc: Siva Reddy Kallam <siva.kallam@broadcom.com>
Cc: Prashant Sreedharan <prashant@broadcom.com>
Cc: Michael Chan <mchan@broadcom.com>
Cc: Bagas Sanjaya <bagasdotme@gmail.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
Link: https://lore.kernel.org/r/20230818175417.never.273-kees@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/tg3.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/tg3.c b/drivers/net/ethernet/broadcom/tg3.c
index 5ef073a79ce94..cb2810f175ccd 100644
--- a/drivers/net/ethernet/broadcom/tg3.c
+++ b/drivers/net/ethernet/broadcom/tg3.c
@@ -6881,7 +6881,10 @@ static int tg3_rx(struct tg3_napi *tnapi, int budget)
 
 			ri->data = NULL;
 
-			skb = build_skb(data, frag_size);
+			if (frag_size)
+				skb = build_skb(data, frag_size);
+			else
+				skb = slab_build_skb(data);
 			if (!skb) {
 				tg3_frag_free(frag_size != 0, data);
 				goto drop_it_no_recycle;
-- 
2.40.1



