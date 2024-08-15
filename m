Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C494E1A00CF;
	Thu, 15 Aug 2024 14:04:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723730677; cv=none; b=sUurpIuCy8fl0pIPv1tD7Ko+OrbOQGeIT9d3mIj3GgCqrYnBRzNfc2zs7OJTWrznI+aZ+n3EVaOLZtfyLzZiBdoGwwj+gdRApO3j0ySbwZsr+OgSvb3yINGvtoR5V6a9FHxxAsM1Iscm+cvM+zXPdp+emXRgdJS5DCKz1NMg+RA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723730677; c=relaxed/simple;
	bh=jgTLgYSgSKxUsYpJYwEpkpnclye5UzwvtyeIyP0RG9g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JaDAEf/UgerF+8zDTmNrXxOBaJZSfpviXZM1FovsP7FWvILKbzChvIbeU6VRfsabRFourhLigsGvelPtSb7w39ZmCl9ZmnI/0/ZOS4XlPOsOxBp52gbY/SErqiOYqAutDGUxgQHnTMJPoiFvHMS8QUV4C4XV4AbrA4kBvOtd304=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cda2o6cC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cda2o6cC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD7BFC32786;
	Thu, 15 Aug 2024 14:04:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723730677;
	bh=jgTLgYSgSKxUsYpJYwEpkpnclye5UzwvtyeIyP0RG9g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cda2o6cCKlhNSeKgwUKSwWuZcvJ6Ow69P7+RY7wSCahL89u8Ce3a626ASlhylPSvr
	 MLblK3uOfhayK9rMRkYTgW6WaqO0BdlxBJ+FJAYon0F+yK2sfY18WS/23QI04Y+6sb
	 5dGL+EN/ehD8VmdsbxNg/EDwBFWeE/aK8lpZq7xw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	valis <sec@valis.email>,
	Jakub Kicinski <kuba@kernel.org>,
	Simon Horman <horms@kernel.org>,
	Sabrina Dubroca <sd@queasysnail.net>,
	"David S. Miller" <davem@davemloft.net>,
	Lee Jones <lee@kernel.org>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Subject: [PATCH 5.15 465/484] tls: fix race between tx work scheduling and socket close
Date: Thu, 15 Aug 2024 15:25:23 +0200
Message-ID: <20240815131959.438868589@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
[ Lee: Fixed merge-conflict in Stable branches linux-6.1.y and older ]
Signed-off-by: Lee Jones <lee@kernel.org>
[ Harshit: bp to 5.15.y, minor conflict resolutin due to missing commit:
  8ae187386420 ("tls: Only use data field in crypto completion function")
  in 5.15.y]
Signed-off-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/tls/tls_sw.c |   16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -468,7 +468,6 @@ static void tls_encrypt_done(struct cryp
 	struct scatterlist *sge;
 	struct sk_msg *msg_en;
 	struct tls_rec *rec;
-	bool ready = false;
 
 	if (err == -EINPROGRESS) /* see the comment in tls_decrypt_done() */
 		return;
@@ -502,19 +501,16 @@ static void tls_encrypt_done(struct cryp
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


