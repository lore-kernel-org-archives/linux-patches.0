Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E099359A89;
	Thu,  2 Jul 2026 16:50:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783011040; cv=none; b=IVZ7H+A6UY0q6on0XzMlkZzOPy/tWvXB9lP4qLtofv3E01SUyDdC4UdvNcpqiEfv3xYNVso9tcNzdQiA9Z/bmjAlkGFIhYCp2uxdKOsINcYbvM9EUygpi40h/C3QqYeD104wPdmmBC6I4T4OAacSDtZ03EYwd81QeC0qUTWiEjo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783011040; c=relaxed/simple;
	bh=1ygfi+gBC2yeh6qNeaJx1sqlkQzIiULU8aZNbdbNaDE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=keiSxyGKJ7xsZHJ2Uex//HbNoKF8tl5T0aBYYmH2hhWHuKpGEyYa8KZSVv1e0vFqcgALVKuHF14ZFQYmhkKYiDFuYXqmHFHhST3maxrPgC8eBWSOH3sDQcd9rMf2WBmNKg98PFpT1OiJsyqNyU+01fyvS88ik96YOjRPRM5Couw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=smrcky4+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="smrcky4+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 935601F000E9;
	Thu,  2 Jul 2026 16:50:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783011039;
	bh=oCK0HJBdhARqbdMapbP6RYL2Td7l8NoHfyLgq1VWaZk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=smrcky4+9ujbFNsNeKIW8Jdq5MijwMt0a9+WRECMuz/4KJ6BSuG5Nrktw1TgXtWfx
	 ZUpQ7wsIhCgIz2FT8lKzxQR8bYEaTiqNtgdbSXaR5lFYl+OPenVrXFhzznRvdUIgmo
	 Yd7pJm0xiVAx5JP8isy7a6IqiwbeAnTolZXjuPc0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Sven Eckelmann <sven@narfation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 096/175] batman-adv: tp_meter: fix fast recovery precondition
Date: Thu,  2 Jul 2026 18:19:57 +0200
Message-ID: <20260702155117.797747555@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155115.766838875@linuxfoundation.org>
References: <20260702155115.766838875@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sven Eckelmann <sven@narfation.org>

commit 2b0d08f08ed3b2174f05c43089ec65f3543a025b upstream.

The fast recovery precondition checks if the recover (initialized to
BATADV_TP_FIRST_SEQ) is bigger than the received ack. But since recover is
only updated when this check is successful, it will never enter the fast
recovery mode.

According to RFC6582 Section 3.2 step 2, the check should actually be
different:

> When the third duplicate ACK is received, the TCP sender first
> checks the value of recover to see if the Cumulative
> Acknowledgment field covers more than recover

The precondition must therefore check if recover is smaller than the
received ack - basically swapping the operands of the current check.

Cc: stable@kernel.org
Fixes: 33a3bb4a3345 ("batman-adv: throughput meter implementation")
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/batman-adv/tp_meter.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/batman-adv/tp_meter.c b/net/batman-adv/tp_meter.c
index 4ff80e4214ff0a..c79352cfddc4ae 100644
--- a/net/batman-adv/tp_meter.c
+++ b/net/batman-adv/tp_meter.c
@@ -733,7 +733,7 @@ static void batadv_tp_recv_ack(struct batadv_priv *bat_priv,
 		if (atomic_read(&tp_vars->dup_acks) != 3)
 			goto out;
 
-		if (recv_ack >= tp_vars->recover)
+		if (tp_vars->recover >= recv_ack)
 			goto out;
 
 		/* if this is the third duplicate ACK do Fast Retransmit */
-- 
2.53.0



