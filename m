Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063735;
	b=uiCjDhn8H4SdHVkAQ28unphPqjPwrrvHp8Fnrnkmt3i/E9+HBuBZJUAuGHpNOofD8YS1
	 PiGJEfAd4mL9JHRQzdFiIfok3EvbHnRZgngfls2hgneG+4X/AVVi8fWOQoNv83zAtCeyO
	 2VNztb84shiLceDpxbrBaXFOnsj9/BIjL0c2+bc0PUw9LXfCbwdMMBVZOJXUd1b7LufrU
	 LYzR56iHoICa9dT3cRB8Prh7C2cP2XtxKybp8yOCkA8OZc+Q7vcflLjMlJMNfvsOCuW/D
	 VLJzHxsDByyNQx5ECcHuZPU3kTm1QNfqMi8woU2TeAymooNY36pv74I2l6GHwyh5a1g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063735;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2+l9UgXODUfpKcy8ykx5LTW+lSJbg+dHbNMj0EzXv5g=;
	b=BHG2tkY1uckPkIqyxBa5mLDePXG7oPZWOWDA4K52+N5wLJV6CKPwA+8JUMC8cIdTKiga
	 Y1iPJ/NZ5cLnbYsnFg2NRFxRvAlyS2Gm9ciMWCa0Y5uVQgyjr3olWws3TiXG/ZFoyjhp5
	 53XygQVN4D76o4lVK7gG6WqCSBIDzPuC+bFXnD3tmZU/aoECeYMfn6uJzxu54tOMTPd6x
	 tDG5lXd9eIFTBD9e7I5hulfo9NEhgaIMcIPd/EMusS6xBpGWQZZ0nZYbX1Mhjr18PoTE+
	 vibZl3BCCkj0G/X5OeyhXReK1QMM2/sNSLPLQ/RPujcNh3pcJvJtb8PNkHiNk7HJ2xQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YvKLXeko;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4FE7606A32D;
	Sat,  7 Nov 2026 15:02:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YvKLXeko
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51D591F0089F;
	Sat,  7 Nov 2026 15:02:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063735;
	bh=2+l9UgXODUfpKcy8ykx5LTW+lSJbg+dHbNMj0EzXv5g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YvKLXekoWxlc7nQKaqiooNu3DQAwS0EJr0bHhqmoAUEpzsZwGg8/IQ0ilITBNFGIW
	 2XmDngPJ1qUKFAyOPreNvh8EtniGmtX7r06+0KgdfiRRTJQiVb/hBcVQXf+vFl6QEv
	 di9g4OrDD8VnXkbp26biLBsR8rHo/NX8iUSrxrzQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shao Mingyin <shao.mingyin@zte.com.cn>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 832/869] nvmet-auth: fix error handling on CHALLENGE failure
Date: Sat,  7 Nov 2026 08:58:34 -0500
Message-ID: <20261107134921.127596731@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 20a2dfcbbc57f..fc50fde2947d4 100644
--- a/drivers/nvme/target/fabrics-cmd-auth.c
+++ b/drivers/nvme/target/fabrics-cmd-auth.c
@@ -601,10 +601,11 @@ void nvmet_execute_auth_receive(struct nvmet_req *req)
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



