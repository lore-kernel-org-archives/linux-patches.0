Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045882;
	b=wCsCXi7Kkmw2X8tTlo3yW2aw1q0PhhIo3FbXVeZE1yq7tkOl4rewtpHuMKZbM3Lk3qmk
	 sFKFfJtAi5fSL6LSqFFnK8OdcmrMyhvbZht15kf5RVKRzJyWTyOxmxCOuwleeLGxswH2W
	 UUiYoeTyevQIvwOB7NiG2m2SbeIPyCK36ghPEmBqlM7vi7+sjAc06KyVuanvKefIo16iy
	 +upgOIQHR8b8ak3gfp3fRhLX4jrHMqMppzFUEAO5ecZiQiSAPnbkfVsaRmPnJWOjB5gqh
	 6CPdfzrBO6auxdzLihF0Lf8aAA/zQbjPdQfwaFzMb18IUu5D6wTIbS9YfZhqi8c2zDQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045882;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lUznBQIw0VHLbU3uHCAdPJr9ivwOJf7iD+K31894vjY=;
	b=RoHcKsT5kmgukSP0mIt/QeiQAlBuPCNjD+eLmUhnXub0Iv6U5sqg4yugtVWE5oE2o5D5
	 nkF7IB/SdtOrW3O2eOEasyMu8qkyH7gehwQdlK3rQ3MbxWnL0rKJZXq7wXMnUCbrpbzUK
	 BtU4qcUBwOpuxDsd5Vp84v+vmhPSgW6QvnBVBVwAQlm1JrseRbJgv1xxj3eG2VZSlUirD
	 PwB+noRWIaqj5yoUPjMEA9osA+nMCz85osgB2LUhghJFNaJn/OmgpTkjS+hNWNfq1GrMK
	 c4WPHTH33mQOgk3F2UHB54BAD6AQKp7H5f6cjrt6+mbOrpD3CvsVu6932pgt4YTJhUA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xEKlpmP+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15CA060A2604;
	Wed, 18 Nov 2026 23:51:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xEKlpmP+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B9171F000C6;
	Wed, 18 Nov 2026 23:51:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045881;
	bh=lUznBQIw0VHLbU3uHCAdPJr9ivwOJf7iD+K31894vjY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xEKlpmP+ILaphF0TfY7oD15/IEiMcHP3m2vp61TDeaui1LVZ2NYc4PayBmDZyeKg9
	 pD4apznbLQ0cUpn+u/msqg57LfgU+CJGAJp8q8fN8SoZyqfHp1sk7rBm7riDe6WhVj
	 09OOZHHZ/OYlnTU0pyE/oQu3EydmavkOLkahHZ7k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shao Mingyin <shao.mingyin@zte.com.cn>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1083/2857] nvmet-auth: fix error handling on CHALLENGE failure
Date: Wed, 18 Nov 2026 15:35:17 +0100
Message-ID: <20261118150240.613626186@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 454a01fe00f2c..2050f543c171b 100644
--- a/drivers/nvme/target/fabrics-cmd-auth.c
+++ b/drivers/nvme/target/fabrics-cmd-auth.c
@@ -546,10 +546,11 @@ void nvmet_execute_auth_receive(struct nvmet_req *req)
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
 		if (status) {
 			req->sq->dhchap_status = status;
-- 
2.53.0



