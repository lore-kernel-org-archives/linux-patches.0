Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046802;
	b=CBt7G/2wl0CIjKCPN88GizWeWxe+dHn6woRwavxDJaquu7TumxoomrIvifqJSTIajmgl
	 d4310oZDy6YjUwZKwOWtF51026mdSL5j22Jf2++CPraxzjafxnT8cSU/UCeYP5kclL2OE
	 NBsV1HtvygUCTUMwwtOh9mzC0K8b614t3966fLeAbZa/rTPfplT3a24IoTHhcrIQUA2gC
	 EB304IFjq6tH9w/Kj3TtD3BiRzDgtkSGwZQWumDoKGZ95CAiv+37BZyuLJNQlwgitFkIM
	 7ofuT/f+PzbzJVLwopdzoL0yqgOu7uycoczbyAHI02/JzF8DYF9+LZrrxwq7+UYjtWg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046802;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=TPtjB/VpES5zRVS2OKWDP9g1OQNHudrh8nO0t4CDOV8=;
	b=BEJkJJ0CjOdCwCQTEdBdlqfJyhtq4Wi9GjEUvdSeGaM1/3Y/RfFfZxJf+a9shYL9zUll
	 z16fcnBhE3xmXqvbz1QLm6MeoW5Z3KL7lJz4tt716YFV9JHg6kzlk9Wd01plAoNl4or7v
	 kOEy2Sto4CmR+ymWTx3rFCJSLCflZqgI1VdX82N9rKUeN3CuiFT5MNSJJshe6Ddv2GP8K
	 qFvYb2Z+GEdaMkCkg6d4V7oeYu42mqC4GI7gvQb5yUi6QZ0/qr+PLsa2F3CvKSjrn2bI5
	 GRe7Jrue/NO8l15gbCIrP2vX8ZGOk8FLKAmW/sfP4604tPzkYZ6SnTOh+CtTglLxPEg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="S/NCCxe9";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EBF3606A32A;
	Thu, 19 Nov 2026 00:06:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=S/NCCxe9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED8321F000C4;
	Thu, 19 Nov 2026 00:06:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046802;
	bh=TPtjB/VpES5zRVS2OKWDP9g1OQNHudrh8nO0t4CDOV8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S/NCCxe9l8I+8xpGS4yfE294eyD6/BN7DTroK5cgOufS7FQruKaeupLJ91yh2gXEZ
	 D3wUjqp01CfwQ2/ZC4wr7OSNCo2J3TBokMPuwWNkpQ6kwI+Cno3kPQXPOm5NuUr77P
	 e60V4I3aINktkaile8pUcq7ZrUmpNj+73A2Sx6g8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sagi Grimberg <sagi@grimberg.me>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Hannes Reinecke <hare@suse.de>,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1410/2857] nvme-auth: check chap ctrl_key once constructed
Date: Wed, 18 Nov 2026 15:40:44 +0100
Message-ID: <20261118150252.107168915@linuxfoundation.org>
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

From: Sagi Grimberg <sagi@grimberg.me>

[ Upstream commit 546dea18c99928bb81392de63092da0e25d07b10 ]

ctrl ctrl_key member may be overwritten from a sysfs context driven
by the user. Once a queue local copy was created, use that instead
to minimize checks on a shared resource.

Signed-off-by: Sagi Grimberg <sagi@grimberg.me>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Stable-dep-of: f9e43d924bc7 ("nvme-auth: fail when the controller does not authenticate itself")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/auth.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/nvme/host/auth.c b/drivers/nvme/host/auth.c
index 69aef668f1056..c741539afa55c 100644
--- a/drivers/nvme/host/auth.c
+++ b/drivers/nvme/host/auth.c
@@ -344,7 +344,7 @@ static int nvme_auth_process_dhchap_success1(struct nvme_ctrl *ctrl,
 	struct nvmf_auth_dhchap_success1_data *data = chap->buf;
 	size_t size = sizeof(*data);
 
-	if (ctrl->ctrl_key)
+	if (chap->ctrl_key)
 		size += chap->hash_len;
 
 	if (chap->buf_size < size) {
@@ -819,7 +819,7 @@ static void nvme_queue_auth_work(struct work_struct *work)
 		goto fail2;
 	}
 
-	if (ctrl->ctrl_key) {
+	if (chap->ctrl_key) {
 		/* DH-HMAC-CHAP Step 5: send success2 */
 		dev_dbg(ctrl->device, "%s: qid %d send success2\n",
 			__func__, chap->qid);
-- 
2.53.0



