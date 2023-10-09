Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 653F31A593
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:17:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RQupcGO1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1AB2C433CA;
	Mon,  9 Oct 2023 13:17:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696857425;
	bh=TuAFA1QSCxBKHVxIL/8maocEgrEtGzypiXKVQVb339U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RQupcGO1bYRrHHQS9IzhehSScbgQVJh/mYxhK9H2wiV3Mh1q3+x2p4a576+mNbMnG
	 6JUoRnIZmiO0hIOB601PUDMEXbwJE9mMGP3FO1WqJTE5GYwWbrotIki+O1QPIPbkCy
	 jSFvMrNBKZvNrblJ6+lxKWVbJESm/HwLYa9+sBhg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>,
	Lorenzo Colitti <lorenzo@google.com>,
	David Ahern <dsahern@kernel.org>,
	Simon Horman <horms@kernel.org>,
	Patrick Rohr <prohr@google.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 6.1 041/162] net: release reference to inet6_dev pointer
Date: Mon,  9 Oct 2023 15:00:22 +0200
Message-ID: <20231009130124.075780260@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231009130122.946357448@linuxfoundation.org>
References: <20231009130122.946357448@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Patrick Rohr <prohr@google.com>

commit 5cb249686e67dbef3ffe53887fa725eefc5a7144 upstream.

addrconf_prefix_rcv returned early without releasing the inet6_dev
pointer when the PIO lifetime is less than accept_ra_min_lft.

Fixes: 5027d54a9c30 ("net: change accept_ra_min_rtr_lft to affect all RA lifetimes")
Cc: Maciej Żenczykowski <maze@google.com>
Cc: Lorenzo Colitti <lorenzo@google.com>
Cc: David Ahern <dsahern@kernel.org>
Cc: Simon Horman <horms@kernel.org>
Reviewed-by: Simon Horman <horms@kernel.org>
Reviewed-by: Maciej Żenczykowski <maze@google.com>
Signed-off-by: Patrick Rohr <prohr@google.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/addrconf.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -2734,7 +2734,7 @@ void addrconf_prefix_rcv(struct net_devi
 	}
 
 	if (valid_lft != 0 && valid_lft < in6_dev->cnf.accept_ra_min_lft)
-		return;
+		goto put;
 
 	/*
 	 *	Two things going on here:


