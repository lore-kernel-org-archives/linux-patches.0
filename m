Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774605;
	b=SkJYotvQv8zv5hw5gkj3SrE7ZEyqRMRG/zoU9pnkePl1pWxtpRF9FrMkq/P4l3CZm1Yc
	 yyU5LwFSXcvC2RTg7iG99rSabuFI76QfVpYITYrmINhIZW9NhpfsVUYLcEgqVQN7ioA+C
	 7eWM+ltXJKQIsXoF1W6+sp2RfYoqr/Hla9uau9Wt7aQPbu6/ImA6hDueR9AYj+rFQ7cwE
	 Z5vVgORzbFYK7EGBSfjPLzGf0STZDvf3RUNKqYr54V6sM+G2daShEI+qCUGpKT7wrDiXk
	 l/RyhRNyNft5Jg0wThvxWAHUS6PUhw+ui9kXYUn7zLxWvkQcl2QChJ/J2nDSoDfzTQA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774605;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UCa/XIOWNj5+OE1ne+oyxOl9QFL5ZjuC155B1ObqWM8=;
	b=CxJvFXfE2wAHmTfsn4DelYOFqSerDf591iIStr5VWO1cIVHhj2cbQZufWNawXYM0ZF7l
	 kigQm+izH2J2ufWagtekseur6JPdHPVZDAWkolWi2kDjb5tYepaMjiTvG7k9GqxFe7Gmv
	 x2JQ6+RkNr/DpdZBW4zTH+D+hmiZ8fU4WOHTpv07TSRb5BF9N+2i15OKv5/p46aQinROW
	 3gERXWfbWTOeatOleM0aPb0HcS5McXmsMfeyG9lFZu7+Fzk/TJuoURSPe2cVnp39H7P1x
	 fl3W3hgQKKnxplymLrijeCdWmIPlkD97Mo2zY18cgaw5VCoWxEuY9DdceCMvGNP0nbg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PURoIkUe;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FB3E606A326;
	Fri, 23 Oct 2026 16:56:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PURoIkUe
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0B611F01825;
	Fri, 23 Oct 2026 16:56:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774605;
	bh=UCa/XIOWNj5+OE1ne+oyxOl9QFL5ZjuC155B1ObqWM8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PURoIkUeOTobpZAKqVx+UfTZsJ9xTSIh8YcXlUxhAgG1RPZLyVXv7h73UbfkQXUY6
	 28hhZgimI9RD/FwM8qUtM3u8YBGkjO7jIpN12duKjXoVjOCmti5LhcGoS3qRqxKRAM
	 OUcFxupy71mlZEWlO/HtX4d9brIfozJ0TAlqzWkg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Sakamoto <o-takashi@sakamocchi.jp>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 098/242] firewire: core: fix race condition in split transaction handling
Date: Fri, 23 Oct 2026 18:39:00 +0200
Message-ID: <20261023163716.100101302@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163713.816071858@linuxfoundation.org>
References: <20261023163713.816071858@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Sakamoto <o-takashi@sakamocchi.jp>

[ Upstream commit 7f9f2d6abc40f79e802b4063859eda343043b85c ]

For a split transaction, either fw_core_handle_response() or
split_transaction_timeout_callback() may manipulate the same transaction
entry in the pending transaction list. The return value of timer_delete()
is used to determine which function handles the entry. If the transaction
is a split transaction and timer_delete() returns zero, the timeout
callback may already be running. In this case, the response handler must
leave the entry in the list for the timeout callback to remove.

A previous code refactoring broke this behavior, introducing a race
condition in which both functions could process the same transaction.
This could lead to a use-after-free on the transaction initiator side.

Fix the regression by ensuring that the response handler does not process
the transaction when timer_delete() returns zero. The timeout callback is
responsible for removing the entry from the pending transaction list.

Fixes: fa2dc2710076 ("firewire: core: code refactoring to find and pop transaction entry")
Link: https://lore.kernel.org/r/20261018025504.290598-1-o-takashi@sakamocchi.jp
Signed-off-by: Takashi Sakamoto <o-takashi@sakamocchi.jp>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firewire/core-transaction.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/firewire/core-transaction.c b/drivers/firewire/core-transaction.c
index 22ae387ae03ca..016070560c742 100644
--- a/drivers/firewire/core-transaction.c
+++ b/drivers/firewire/core-transaction.c
@@ -89,8 +89,12 @@ void fw_cancel_pending_transactions(struct fw_card *card)
 			break;						\
 		}							\
 	}								\
-	if (t && try_cancel_split_timeout(t))				\
-		remove_transaction_entry(card, t);			\
+	if (t) {							\
+		if (try_cancel_split_timeout(t))			\
+			remove_transaction_entry(card, t);		\
+		else							\
+			t = NULL;					\
+	}								\
 	t;								\
 })
 
-- 
2.53.0



