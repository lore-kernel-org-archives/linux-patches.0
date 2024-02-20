Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D700214A4E6;
	Tue, 20 Feb 2024 21:28:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708464515; cv=none; b=kr0ASVBtYCxfCNn4mGHlO8M4e03NdwGR2dxpELNkP6DTub6spy1p7uMChtUXXugjzs1/K8Lf+5cYhUlAj6e2jCHIPAzoU5agUFd3AzCXmUbSFf3FFe3z92uNHDpS0P33S/S7PbgUiMewosk825/oKOeDWJyRp6IigWWGH1maSmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708464515; c=relaxed/simple;
	bh=2IkZHqt9Qrbp5y54z8Z7ZOO8REqwiQ2nL5wrRIdYEa8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WEYU6b2R3o2KO++TioTKZYGr5nEeNCCHlaf5wfJ/C8x/OzPDS60d8PoLSHaf0qnoofuInB0elr4f+crVC5ShMEoKPWKIkXpJMft6SHBtnUWJgTC2nO01lReh6dC7lug48j2RfdHA/WjjdOCyU9X3Wsl3DBMjKQffB42aMK6Okyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=odxemw9h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="odxemw9h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47FA7C433F1;
	Tue, 20 Feb 2024 21:28:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708464515;
	bh=2IkZHqt9Qrbp5y54z8Z7ZOO8REqwiQ2nL5wrRIdYEa8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=odxemw9hHecY5rpkKLnFNCPe7agphrWDS1K7RdxnPhyBfWmFMHRNcdJ1BQesFp+vr
	 yQ7eVdjcJml1Uh3K+0IgMXRe8+aZLnR5BI1a2g2PTHdEBD845j/m95DCOgXcwuwZR9
	 rb6G3KM+3V3KlTkRuy4GjcPbw2QN3koPHOh+w/DA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	valis <sec@valis.email>,
	Jakub Kicinski <kuba@kernel.org>,
	Simon Horman <horms@kernel.org>,
	Sabrina Dubroca <sd@queasysnail.net>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 049/309] tls: fix race between tx work scheduling and socket close
Date: Tue, 20 Feb 2024 21:53:28 +0100
Message-ID: <20240220205634.727040027@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205633.096363225@linuxfoundation.org>
References: <20240220205633.096363225@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit e01e3934a1b2d122919f73bc6ddbe1cdafc4bbdb ]

Similarly to previous commit, the submitting thread (recvmsg/sendmsg)
may exit as soon as the async crypto handler calls complete().
Reorder scheduling the work before calling complete().
This seems more logical in the first place, as it's
the inverse order of what the submitting thread will do.

Reported-by: valis <sec@valis.email>
Fixes: a42055e8d2c3 ("net/tls: Add support for async encryption of records for performance")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Reviewed-by: Simon Horman <horms@kernel.org>
Reviewed-by: Sabrina Dubroca <sd@queasysnail.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tls/tls_sw.c | 16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index 635305bebfef..9374a61cef00 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -447,7 +447,6 @@ static void tls_encrypt_done(void *data, int err)
 	struct tls_rec *rec = data;
 	struct scatterlist *sge;
 	struct sk_msg *msg_en;
-	bool ready = false;
 	struct sock *sk;
 
 	msg_en = &rec->msg_encrypted;
@@ -483,19 +482,16 @@ static void tls_encrypt_done(void *data, int err)
 		/* If received record is at head of tx_list, schedule tx */
 		first_rec = list_first_entry(&ctx->tx_list,
 					     struct tls_rec, list);
-		if (rec == first_rec)
-			ready = true;
+		if (rec == first_rec) {
+			/* Schedule the transmission */
+			if (!test_and_set_bit(BIT_TX_SCHEDULED,
+					      &ctx->tx_bitmask))
+				schedule_delayed_work(&ctx->tx_work.work, 1);
+		}
 	}
 
 	if (atomic_dec_and_test(&ctx->encrypt_pending))
 		complete(&ctx->async_wait.completion);
-
-	if (!ready)
-		return;
-
-	/* Schedule the transmission */
-	if (!test_and_set_bit(BIT_TX_SCHEDULED, &ctx->tx_bitmask))
-		schedule_delayed_work(&ctx->tx_work.work, 1);
 }
 
 static int tls_encrypt_async_wait(struct tls_sw_context_tx *ctx)
-- 
2.43.0



