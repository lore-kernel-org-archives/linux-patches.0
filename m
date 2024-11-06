Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 958E21E048E;
	Wed,  6 Nov 2024 12:41:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896898; cv=none; b=q1HMIkcgt8VFrQeKb3oR3FYSmYON8IqxCUbcQogRR+76GPzSLNctqfC6SuYar01D0DClt6/CncQoSDpsXDl2D/ElTP8WKVshlVjLtjwPhJFxlQZ4jmRK2va/xT53/Lc1sPh+rmtFMAYdfa+0vWS1hxU03fX2FWZj7H9Qwa57q0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896898; c=relaxed/simple;
	bh=svp5yqLIZ00nnXnf7CgjuKRq5mbMIl2/ykNlE9qpuIg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mv87aJgKlc5E355St2P1BSLyyJ0F3Ub/YPDHfsV5gkgSoPjaydL65+UAyySFTGZgG6pRvwYwIEyycpoZBUvrcw9LvMBQLCM6JWd7+ASI9qhRbteWEaoPSe6HToMd9AXOyll2Jgf4BCI+Gjan6IWwsNmOMhtK4HVy3NZPhWemgug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P2H1edCB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P2H1edCB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8E3EC4CECD;
	Wed,  6 Nov 2024 12:41:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730896898;
	bh=svp5yqLIZ00nnXnf7CgjuKRq5mbMIl2/ykNlE9qpuIg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P2H1edCBoOlGV1ktXwalaTagXnEZuJ5oEFeR60nDPtswxOg5+QIEsb528oiN89YLM
	 ccSk3yO+TUoVaA3CSglsdmKeXROIV+dwFMfSN5zbTXsGMF47zaJxuh3EwUX9PcBTTj
	 zibtww4CiB0Eh4WZDDHLakD++otkM8Jdk1+Tq5g0=
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
Subject: [PATCH 5.10 072/110] gtp: allow -1 to be specified as file description from userspace
Date: Wed,  6 Nov 2024 13:04:38 +0100
Message-ID: <20241106120305.176653379@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120303.135636370@linuxfoundation.org>
References: <20241106120303.135636370@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 24cb7b97e4fcc..42839cb853f83 100644
--- a/drivers/net/gtp.c
+++ b/drivers/net/gtp.c
@@ -842,20 +842,24 @@ static int gtp_encap_enable(struct gtp_dev *gtp, struct nlattr *data[])
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



