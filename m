Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 883631487CD;
	Thu, 12 Dec 2024 15:21:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734016908; cv=none; b=gJSKIxnIzYWCNgqGezfO4TXh7kZepuwynMSKHI74Fkn4+pn7i65tQtAR7D47e9jOJExZEpoCuG2XPFBAys5uRTBnDa5Cqpb4JzWOr2AvS1uf3Fg2Xq8XbiFqwrk18F7gmuhKRfvzuEf/m/TEgwqQu92DXsZE5VmgqpnSXtMYzmY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734016908; c=relaxed/simple;
	bh=95y47CyjyY6riJIVPuyKA7GINFbqD1S2hWzDyRf1oeo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MZTpzilGliMgxpDGTKuKXSqLBUZMpjYoU1RWgQ+DLwcNoZNyeXy/fKGGuqDYJn38a5sB8hKNFMVQ2vQrazrpW6V6wdoNLUzHK50wyI0UYLhUcbt/qrS8uGWepp0UDngwoKEZWnlSqtoDM2C+VsjsHSSQ3aRybz1DD4zkxPQrojM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aHwmq75p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aHwmq75p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9F2DC4CECE;
	Thu, 12 Dec 2024 15:21:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734016908;
	bh=95y47CyjyY6riJIVPuyKA7GINFbqD1S2hWzDyRf1oeo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aHwmq75pV8Ni2YCm3HtUrzeuI8+MKcVIxSiXAQOwWOHo1wpO7hpLppMkDpt3F2GZA
	 1RQwaXMBZuUhaJ5MLf5/rfVNBBdz4Qi8LDjLn9GpnF4IcFdBvdwXnpKZDvnD0Ig+Lq
	 JQxBp270UwPkvAbQATSdcB13BoANWkxvn6V5Ppy4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ignat Korchagin <ignat@cloudflare.com>,
	Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 290/466] net: af_can: do not leave a dangling sk pointer in can_create()
Date: Thu, 12 Dec 2024 15:57:39 +0100
Message-ID: <20241212144318.242195832@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ignat Korchagin <ignat@cloudflare.com>

[ Upstream commit 811a7ca7320c062e15d0f5b171fe6ad8592d1434 ]

On error can_create() frees the allocated sk object, but sock_init_data()
has already attached it to the provided sock object. This will leave a
dangling sk pointer in the sock object and may cause use-after-free later.

Signed-off-by: Ignat Korchagin <ignat@cloudflare.com>
Reviewed-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Reviewed-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Reviewed-by: Marc Kleine-Budde <mkl@pengutronix.de>
Link: https://patch.msgid.link/20241014153808.51894-5-ignat@cloudflare.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/can/af_can.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/can/af_can.c b/net/can/af_can.c
index 707576eeeb582..01f3fbb3b67dc 100644
--- a/net/can/af_can.c
+++ b/net/can/af_can.c
@@ -171,6 +171,7 @@ static int can_create(struct net *net, struct socket *sock, int protocol,
 		/* release sk on errors */
 		sock_orphan(sk);
 		sock_put(sk);
+		sock->sk = NULL;
 	}
 
  errout:
-- 
2.43.0



