Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036652;
	b=DcrmosHG6WkGXJSN7vZfohFsnzlxjvZ0svkSgqB+yspb5s2zj/KaBtWYi8dhd6PSdBUm
	 FVIRVbojC2iuIvcRIjMqRka+sSP7DngyQ1X70Cs+h9hDG+PYNZE79ZZ9jyl6BNXugsMN9
	 Cgjs4ys5YjB1Yk9fmVkYOBlq/JwP7npSKGX9/4rJN1tMj7sEf+4pW4O7vPssAU1ayWgnx
	 nlyl9WWnCNXo+HBjuLmA/lMLVqgx1hnkIgndpOIsmvXXT5y7TjfDXaKAzzUtvU923nWCh
	 xggMZpDklTWOOG2/gcNOhbLAtHPD+6g/Jj1Tuquu0M2arIV+Z8UzrQEXmwsg4HZvMSA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036652;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=h2FJ48NoTt6vRPcXkY43wWxmTuOANf/Qf0MBFK7Z5rI=;
	b=QT0QM+5lGRQlT5+w/yyNnmzy/b1tF7UikDlrMiSIcyiNt1VAkMuRSyTITsTEbsI0iL5a
	 5aF1OM+hjkCufzDmlN0YNabrMrITxwNexrHGxpDL6fbkwG2RAYy2qahyWfQgwvACUpvF+
	 3BhGmn94iVPHUQZw0ggIlmusEtYmI/rV39j62Ehm2gfAIMQeqzDYvDRVPOdObhGQKLdti
	 LgReOLuqL+2NMzCh4Dh1MGyRLPPsrvnLN8wTNttbYLL1tGMn3GVnL/JYYEqY4KzfzRhzP
	 6N9EeiBw1iwZVT5cIwKoK27tbl4T0yQlledN7sBHJr9srJehIrybrD4WmsEgK10R00g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vQU+4dMU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81ED460A2601;
	Wed, 18 Nov 2026 21:17:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vQU+4dMU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4D661F000C4;
	Wed, 18 Nov 2026 21:17:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036652;
	bh=h2FJ48NoTt6vRPcXkY43wWxmTuOANf/Qf0MBFK7Z5rI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vQU+4dMUVkPoy1m6nnV7QqF5NELMd2Om1kisxCXaWAIk4S6s4jn1vt/GB+dQJ5mKm
	 +Xz9VeK+F2SWwxliP6D/0hk/6YeY5O+zS9cuf8cwDqzQH/vFuZ5CCcKh6np/3SfcPz
	 0pHsU+4jWbILRJ5Q1BL114jvxx5aMH65KtSudkT0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tim Douglas <me@timdoug.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1109/3318] serial: pmac_zilog: push received data to the port that received it
Date: Wed, 18 Nov 2026 15:28:51 +0100
Message-ID: <20261118150353.269991435@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tim Douglas <me@timdoug.com>

[ Upstream commit f3dc727da3af64abc12b625bbf1eb68d55d882cc ]

pmz_interrupt() drains both channels but, since commit 2e124b4a390c
("TTY: switch tty_flip_buffer_push"), pushes the flip buffer of the
port whose handler is running rather than the port that was drained.
With both ports open, data received on the other port can be left in
its flip buffer until something else pushes it, so its reader may not
see it.

Fixes: 2e124b4a390c ("TTY: switch tty_flip_buffer_push")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Tim Douglas <me@timdoug.com>
Link: https://patch.msgid.link/20261013013541.4535-2-me@timdoug.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/pmac_zilog.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/serial/pmac_zilog.c b/drivers/tty/serial/pmac_zilog.c
index 29bc80d39e8b7..6fc6b9b93e0f1 100644
--- a/drivers/tty/serial/pmac_zilog.c
+++ b/drivers/tty/serial/pmac_zilog.c
@@ -444,7 +444,7 @@ static irqreturn_t pmz_interrupt(int irq, void *dev_id)
  skip_a:
 	spin_unlock(&uap_a->port.lock);
 	if (push)
-		tty_flip_buffer_push(&uap->port.state->port);
+		tty_flip_buffer_push(&uap_a->port.state->port);
 
 	if (!uap_b)
 		goto out;
@@ -469,7 +469,7 @@ static irqreturn_t pmz_interrupt(int irq, void *dev_id)
  skip_b:
 	spin_unlock(&uap_b->port.lock);
 	if (push)
-		tty_flip_buffer_push(&uap->port.state->port);
+		tty_flip_buffer_push(&uap_b->port.state->port);
 
  out:
 	return rc;
-- 
2.53.0



