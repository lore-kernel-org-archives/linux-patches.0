Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97D931C6AB;
	Mon,  4 Mar 2024 21:54:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709589254; cv=none; b=tsANnQYrE6AjVouzZq2Sjf1F14d68+5J/KreQs/BhxDcZ4zqYeSu5kdLnrNd5ebeuNEnKKneEOurmPlpzi2rDi6MvS9ueu7XM9MrQj8mC+FoT/tBcG23mxgEj0TUL3cosVnbqHuZ88p55jpI0pdu9/3RPdDHCvTlG3AnkbSVgzo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709589254; c=relaxed/simple;
	bh=+LX5Mu0sUHQ8K1wH/YobFag4YadmlP2HZBaCR0WqU7Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qQPouUhXi9OPxiUjkF/oWbxNbkCBEoHOwoDKKh5z2Soi3lxxrI6VoLT7KT/RDmlE1+1aDYuDW+vQN/aPOxFcaoYH8WzmKIYuf/UpVGV+ta71+vZEGHTnBLikphNsYRyDF1HmIy7aHT3k9fiAThi0GQouyGN17qslnYOqJcJbZAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1GjzEUrZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1GjzEUrZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAF28C433C7;
	Mon,  4 Mar 2024 21:54:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709589254;
	bh=+LX5Mu0sUHQ8K1wH/YobFag4YadmlP2HZBaCR0WqU7Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1GjzEUrZDC8wZdu03lO65zDw/PiuhJCoMG59BSpRGtoxYZIzJswDLc/7UC2pDUgla
	 USzGXQR1cqrA8HnX1cdw78uZ4QB8bCrpYxfc1litiPDmyj/jc/CY9Fe3NaImvdBRwy
	 RGx6rdbTEJzEMsdMSIBGW/gveMRjTzDxu4KzdpRM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 38/84] tls: rx: assume crypto always calls our callback
Date: Mon,  4 Mar 2024 21:24:11 +0000
Message-ID: <20240304211543.606057511@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211542.332206551@linuxfoundation.org>
References: <20240304211542.332206551@linuxfoundation.org>
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

[ Upstream commit 1c699ffa48a15710746989c36a82cbfb07e8d17f ]

If crypto didn't always invoke our callback for async
we'd not be clearing skb->sk and would crash in the
skb core when freeing it. This if must be dead code.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: f7fa16d49837 ("tls: decrement decrypt_pending if no async completion will be called")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tls/tls_sw.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index 85fa49170b4e5..27ac27daec868 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -277,9 +277,6 @@ static int tls_do_decryption(struct sock *sk,
 	if (ret == -EBADMSG)
 		TLS_INC_STATS(sock_net(sk), LINUX_MIB_TLSDECRYPTERROR);
 
-	if (async)
-		atomic_dec(&ctx->decrypt_pending);
-
 	return ret;
 }
 
-- 
2.43.0



