Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062643;
	b=nblOj/4o7RX7BVjwhWgw590Vi1wDQNLM7CDy5Zv/zBUXbK3G5+TIgcNUHb5q9+DFnr/b
	 kXuzhnzrgH5S6EQZbHDQXDJlA5GqCGBwD+KTbf9yv5ve1STbaYwCHUkXEPclr01TUfu9o
	 GshIZ4sHlxUVBFu1y0b820kNBqEY5sHWElet38Gwr8E5KpACPR6sNybk0qFWw79SyMOnh
	 W0smB7c+Z66+pu6WG5ODzJezPYkCjtnLgBNsA2cKovZ690d1DKpgTOtPL/hsJOnx+DdKG
	 DwZtElNkGgjviem+VTnqJqKfsC+39EEhDKwnWz8P5MPdsKnrWKZ3ymU1y+awVHfx3Mw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062643;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hhL4t+6oZ9xiRNLJeJatqPnYp/N/lWyEiu3WmxdQL44=;
	b=nub2/OEBxRIvmqD+tBGi0xHUuvjGAE0AeTSsKNoUNCoAUYr5aB5rH7tk8tFsiOs5bgsh
	 vZJsTvjrSHCSuDdoILqrbDnXtNNcUEPM5ZdW6bwNAgTWnydHCYSvaZSE4Xv2hD6K7+A1w
	 oHs8AjXOh3cnmIWD4aIYHA6Iv5+6ETIlSLcpwBIzNXQseBIMFIBgszO9xjA61mMqSOcxk
	 eTw9NQlBFcAIAKPcEiz0YkS4ta8TT9hvxy/W4dodZxauFPMImz+5DiEYTngkGHf+CQ1ac
	 YqHf7S0LO35FB7f70wtmdRHiWP9l1S8/RhJrEaMU3Y53xI0D9eMHjHxXIc3NXr6U9VA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rrZ33RXv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ED0C606A32D;
	Sat,  7 Nov 2026 14:44:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rrZ33RXv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E16401F008A1;
	Sat,  7 Nov 2026 14:44:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062643;
	bh=hhL4t+6oZ9xiRNLJeJatqPnYp/N/lWyEiu3WmxdQL44=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rrZ33RXvPTvAWnW/1uHf4MHfQ6jIm7oWvwHKNk9RI0ncMdgUTeGqRnd0XzzJaYIoQ
	 hb55GqUpFodVWP36y4R3QgINHnRJbtjlw6yOWwr8Shp+LKNQBlZN2B2v5oX2hTzxi4
	 hAuthntbS7Z9/tFMF4f3D5IaVm4TYPWUYaDcbmr0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shao Mingyin <shao.mingyin@zte.com.cn>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1510/1536] nvmet-auth: fix error handling on CHALLENGE failure
Date: Sat,  7 Nov 2026 08:58:46 -0500
Message-ID: <20261107135040.276191383@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index de1a6d1a27a33..72446965028c5 100644
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



