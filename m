Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C88E3191461;
	Wed,  6 Nov 2024 13:17:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730899023; cv=none; b=qtRhmnimoFLF7JsFilbgAftAGxnp7a+ikLASuwQpA4rKBo1zOU+PTWhvqGAa8Z4BhGHbdtJ6xDYpJkmcp2e/QEEx0WnnDW6QlgQFPbph8NJBe1Xoqz6fubBb8RVc2PNaE9csPRo5PsLUSMMx/12/bdLf/l+KzPtw/mhGbMzkySA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730899023; c=relaxed/simple;
	bh=5LMIgG887xFMF+c4RKDt+Kj8U5slHudq8vDFfnp8Z6Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pw8b/jdLiMZDerNFrJVKHnmYianJtuRySihcScWeLWO8BN9bK5fn7GbeHVyewTF398FmVBI1fUZqAyli7MV9L3qnhShL4Z+bhZg9/+hCmboEGH2L7SHn/Kc3L5VzB4yqBZ0iMaXDIQWeFx95ENIMOvLxVZh9f1hHimD/dpmgm9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HDPQkosx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HDPQkosx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2760CC4CED3;
	Wed,  6 Nov 2024 13:17:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730899023;
	bh=5LMIgG887xFMF+c4RKDt+Kj8U5slHudq8vDFfnp8Z6Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HDPQkosxzN0nRW8t+Nv9HNjIcvoTnJHoFbf1uZC7Mu3GLYUWDQ3uZ4EBidzB1PBwb
	 D+Dt6uqRfJ4WT1ZJflpg2m0bQknZmtsXzYcuOPFwD8G7Vq4eaLNHak2DDEJrFxoJGV
	 Qux2ioTFpFAi415ZkrqtTwnJG09ln4BiYsq9UCtQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pau Espin Pedrol <pespin@sysmocom.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Oliver Smith <osmith@sysmocom.de>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 436/462] gtp: allow -1 to be specified as file description from userspace
Date: Wed,  6 Nov 2024 13:05:29 +0100
Message-ID: <20241106120342.273270621@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit 7515e37bce5c428a56a9b04ea7e96b3f53f17150 ]

Existing user space applications maintained by the Osmocom project are
breaking since a recent fix that addresses incorrect error checking.

Restore operation for user space programs that specify -1 as file
descriptor to skip GTPv0 or GTPv1 only sockets.

Fixes: defd8b3c37b0 ("gtp: fix a potential NULL pointer dereference")
Reported-by: Pau Espin Pedrol <pespin@sysmocom.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Tested-by: Oliver Smith <osmith@sysmocom.de>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20241022144825.66740-1-pablo@netfilter.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/gtp.c | 22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff --git a/drivers/net/gtp.c b/drivers/net/gtp.c
index 9c62bc277ae86..f85f4e3d28215 100644
--- a/drivers/net/gtp.c
+++ b/drivers/net/gtp.c
@@ -848,20 +848,24 @@ static int gtp_encap_enable(struct gtp_dev *gtp, struct nlattr *data[])
 	unsigned int role = GTP_ROLE_GGSN;
 
 	if (data[IFLA_GTP_FD0]) {
-		u32 fd0 = nla_get_u32(data[IFLA_GTP_FD0]);
+		int fd0 = nla_get_u32(data[IFLA_GTP_FD0]);
 
-		sk0 = gtp_encap_enable_socket(fd0, UDP_ENCAP_GTP0, gtp);
-		if (IS_ERR(sk0))
-			return PTR_ERR(sk0);
+		if (fd0 >= 0) {
+			sk0 = gtp_encap_enable_socket(fd0, UDP_ENCAP_GTP0, gtp);
+			if (IS_ERR(sk0))
+				return PTR_ERR(sk0);
+		}
 	}
 
 	if (data[IFLA_GTP_FD1]) {
-		u32 fd1 = nla_get_u32(data[IFLA_GTP_FD1]);
+		int fd1 = nla_get_u32(data[IFLA_GTP_FD1]);
 
-		sk1u = gtp_encap_enable_socket(fd1, UDP_ENCAP_GTP1U, gtp);
-		if (IS_ERR(sk1u)) {
-			gtp_encap_disable_sock(sk0);
-			return PTR_ERR(sk1u);
+		if (fd1 >= 0) {
+			sk1u = gtp_encap_enable_socket(fd1, UDP_ENCAP_GTP1U, gtp);
+			if (IS_ERR(sk1u)) {
+				gtp_encap_disable_sock(sk0);
+				return PTR_ERR(sk1u);
+			}
 		}
 	}
 
-- 
2.43.0



