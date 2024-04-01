Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40DBF1DFF4;
	Mon,  1 Apr 2024 17:04:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711991043; cv=none; b=AtxUK7xkAAs9SLySfBL36+33rth+3fhMCkoYVTWox7c76o9r/ji5SO8av/h5EXyo1jfNl9qdnnvzKAuLkmdjIKCTr4eaFr4ykWXKh9GfGAAXlGGpsaEhoqKanG58WLFC7KJNgkZOinRgAOOuKB9JlhD1WLUqpHh9YKC0WrzY0H0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711991043; c=relaxed/simple;
	bh=HA3zKyGplIXILVAs3tL+JiCM/AcTfRJyAEC9XNE5mxk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=emMDWF9x0fa2iDSELnzsFL2TR6gAx7khqGg+wSEM0+/R13Mc9gtOp413ClssaJdrxY5wZWP54eZNv475KlnfeEpEl92640sBVZyRZruVouIxD2LyCWv7Vcv6hQtk2DN5WcY7CHnJRQ9tIxZGVxU43BLkK+ZxfcwRXJVJDNC/97w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Faz8H6Ty; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Faz8H6Ty"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA240C433C7;
	Mon,  1 Apr 2024 17:04:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711991043;
	bh=HA3zKyGplIXILVAs3tL+JiCM/AcTfRJyAEC9XNE5mxk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Faz8H6TyO9gl3R3E20Nt0PQ7CXGvQmhmDmA3hn5pZZi+c+bjXvxbHZhjcPCvbaQCB
	 1ss8eFV3HsCp6ILBYtM1F58gVNRVdLdgzhTrAlA34a19q2z8Hg7hprbpl+DHzd5RwM
	 Q4AWAmsmt4WdOJdGzWgaJsm6JW1UdPb8SftxbV64=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	valis <sec@valis.email>,
	Jakub Kicinski <kuba@kernel.org>,
	Simon Horman <horms@kernel.org>,
	Sabrina Dubroca <sd@queasysnail.net>,
	"David S. Miller" <davem@davemloft.net>,
	Lee Jones <lee@kernel.org>
Subject: [PATCH 6.1 144/272] tls: fix race between tx work scheduling and socket close
Date: Mon,  1 Apr 2024 17:45:34 +0200
Message-ID: <20240401152535.180080613@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152530.237785232@linuxfoundation.org>
References: <20240401152530.237785232@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Kicinski <kuba@kernel.org>

commit e01e3934a1b2d122919f73bc6ddbe1cdafc4bbdb upstream.

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
[Lee: Fixed merge-conflict in Stable branches linux-6.1.y and older]
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/tls/tls_sw.c |   16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -449,7 +449,6 @@ static void tls_encrypt_done(crypto_comp
 	struct scatterlist *sge;
 	struct sk_msg *msg_en;
 	struct tls_rec *rec;
-	bool ready = false;
 	struct sock *sk;
 
 	rec = container_of(aead_req, struct tls_rec, aead_req);
@@ -486,19 +485,16 @@ static void tls_encrypt_done(crypto_comp
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


