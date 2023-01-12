Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29D0379C9
	for <patches@lists.linux.dev>; Thu, 12 Jan 2023 14:37:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69E63C4339E;
	Thu, 12 Jan 2023 14:37:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673534277;
	bh=ZQgif84aLLyMaI49Is44k2DoyEMvc/Rfm+h3IyybCxo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LncziVKdTC8MjaOOhTtxBYz1x9ZK5eFOS2WQBnvzpBXE4PByW5CDzG1ebxNrHkj5P
	 04id7kRQmgZwkH0YbCZ3d4rMP1oLnI0aq0cdAkpOO97wlR9pw5gELsKSz6+sJ/5LOp
	 d6X81U7awU2qqFW+Uq6NbzFVuwroXHg/s6f4wP3c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Szymon Heidrich <szymon.heidrich@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 754/783] usb: rndis_host: Secure rndis_query check against int overflow
Date: Thu, 12 Jan 2023 14:57:50 +0100
Message-Id: <20230112135559.317708299@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Szymon Heidrich <szymon.heidrich@gmail.com>

[ Upstream commit c7dd13805f8b8fc1ce3b6d40f6aff47e66b72ad2 ]

Variables off and len typed as uint32 in rndis_query function
are controlled by incoming RNDIS response message thus their
value may be manipulated. Setting off to a unexpectetly large
value will cause the sum with len and 8 to overflow and pass
the implemented validation step. Consequently the response
pointer will be referring to a location past the expected
buffer boundaries allowing information leakage e.g. via
RNDIS_OID_802_3_PERMANENT_ADDRESS OID.

Fixes: ddda08624013 ("USB: rndis_host, various cleanups")
Signed-off-by: Szymon Heidrich <szymon.heidrich@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/rndis_host.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/usb/rndis_host.c b/drivers/net/usb/rndis_host.c
index 1505fe3f87ed..1ff723e15d52 100644
--- a/drivers/net/usb/rndis_host.c
+++ b/drivers/net/usb/rndis_host.c
@@ -255,7 +255,8 @@ static int rndis_query(struct usbnet *dev, struct usb_interface *intf,
 
 	off = le32_to_cpu(u.get_c->offset);
 	len = le32_to_cpu(u.get_c->len);
-	if (unlikely((8 + off + len) > CONTROL_BUFFER_SIZE))
+	if (unlikely((off > CONTROL_BUFFER_SIZE - 8) ||
+		     (len > CONTROL_BUFFER_SIZE - 8 - off)))
 		goto response_error;
 
 	if (*reply_len != -1 && len != *reply_len)
-- 
2.35.1



