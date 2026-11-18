Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037051;
	b=BsR1NzhAuJo5TJ4/c19iECwmXJTSJ1kpljFfvPvTZCVjbtZLuWGUl89jDlh5e4HstpXd
	 o0n1h1qzt7ChQdus94cw6AMrKB1NJYjkQNzJEUzfMpoOM2oR0uIaZAj80mB9WxHEtl7yg
	 ihGUWkgO4jYMARaaOLIUHCkrrxuBOYmwm7H1glPSv1xbmQ+vU2nyMZ7MjUU9lWZL1s4st
	 kZw/tq769nnP1hDPUDxbR/81mM72gdW8hrNGTFbWOdYomapBmQPgSOYgJhBORrOG0700/
	 OXvlrGngUO6VrCal3HHzYNDpSknQJktEQlvb73xWDARb5WLPxW1fNlF2OwjS4GEI8kw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037051;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FBfk6lLr7bdijqb+lzJsuEJgl1+E9Cejtsn2Tdpp02g=;
	b=XZqCwqwngy62S3c/LtD9pFmtpVHCM32Gu7m+ia9zdguWxv2aORHiolRURJ37teujnSzZ
	 6/6movuD4rBdXxxUnm54/yrFwNb0YVuy0oOAotDFciRoG4fx+zyj6Xziuua4209Os3u4V
	 Kwysgr1Vw08SNm3/JZjEs2FMTRszMkDPLjC9fQs8q9EXEb+XnTCpEYeqZUPSXX8UVCa1Y
	 XdegOr0TpsXgZoyRG9UVlRe3yo02HjZCawLM+PLtKo0m+dRN9B57a3MHaqHEA5WgaoFxN
	 1GYtX2wvpZf2fiH56mX5ebnSZPFKKjIZrT4ie4mG3SEdjl5SAhbBZ4eChTtX3T7P6Bg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="na0l/ody";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B22C606A31C;
	Wed, 18 Nov 2026 21:24:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=na0l/ody
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FB371F000C5;
	Wed, 18 Nov 2026 21:24:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037051;
	bh=FBfk6lLr7bdijqb+lzJsuEJgl1+E9Cejtsn2Tdpp02g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=na0l/ody2qaVpFqlfqfwSdonDLpWGNq9Yilvc2B74KrrlTS/CsCnShiNhjmozGV2c
	 Kzw65mhssjxCGkwteJzZxQrAbzBhUYUbXftLIaZTXIGzdr7R6S8H1KYg7dcIwNmBXR
	 wYxu0ARJDG+B9N/F3Ro59hTibgQy9FOD5Y0Qs9EM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shao Mingyin <shao.mingyin@zte.com.cn>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1275/3318] nvmet-auth: fix error handling on CHALLENGE failure
Date: Wed, 18 Nov 2026 15:31:37 +0100
Message-ID: <20261118150358.485323782@linuxfoundation.org>
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

From: Shao Mingyin <shao.mingyin@zte.com.cn>

[ Upstream commit 96da408bb4a24bf87b366b13f41c2687d3c05671 ]

In nvmet_execute_auth_receive(), when nvmet_auth_challenge() fails (for
example when the initiator-supplied allocation length is shorter than the
DH-HMAC-CHAP challenge response, or the challenge nonce allocation fails),
the error path sets status = NVME_SC_INTERNAL and breaks out of the
switch. The unconditional

    status = nvmet_copy_to_sgl(req, 0, d, al);

after the switch then overwrites the error status (nvmet_copy_to_sgl()
returns 0 on success), so the AUTH_RECEIVE command incorrectly completes
with SUCCESS and the initiator proceeds with a truncated/empty challenge.

Fix this by freeing the buffer and jumping to the common done: label on
CHALLENGE failure, skipping the copy_to_sgl() entirely and preserving the
NVME_SC_INTERNAL status.

Fixes: db1312dd9548 ("nvmet: implement basic In-Band Authentication")
Cc: stable@vger.kernel.org
Signed-off-by: Shao Mingyin <shao.mingyin@zte.com.cn>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/fabrics-cmd-auth.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/nvme/target/fabrics-cmd-auth.c b/drivers/nvme/target/fabrics-cmd-auth.c
index c1d4e068ff721..aed3d4de1133c 100644
--- a/drivers/nvme/target/fabrics-cmd-auth.c
+++ b/drivers/nvme/target/fabrics-cmd-auth.c
@@ -551,10 +551,11 @@ void nvmet_execute_auth_receive(struct nvmet_req *req)
 	switch (req->sq->dhchap_step) {
 	case NVME_AUTH_DHCHAP_MESSAGE_CHALLENGE:
 		if (nvmet_auth_challenge(req, d, al) < 0) {
-			pr_warn("ctrl %d qid %d: challenge error (%d)\n",
-				ctrl->cntlid, req->sq->qid, status);
+			pr_warn("ctrl %d qid %d: challenge error\n",
+				ctrl->cntlid, req->sq->qid);
 			status = NVME_SC_INTERNAL;
-			break;
+			kfree(d);
+			goto done;
 		}
 		req->sq->dhchap_step = NVME_AUTH_DHCHAP_MESSAGE_REPLY;
 		break;
-- 
2.53.0



