Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016881;
	b=qjWNvY0OKJ4LSvJ3n1Msks1cziNX7dS5Acp94DcDgdnF2QkR3TPU84ii8o/sF7pJtJQk
	 yWCZORVH0GmdqGwwRk2/1xuoms6nCoiUL4AX43VjYC3TBBHDGFDAYjP0x5j3z8S49bS6v
	 hbYpHbyYzWC8flVpe3ORsp/hqCSqntEZhZ7NM6SGuhrHM3MvCtcNS2whicXn5JATQ8nlf
	 go8qORtS4QWZtCiDkgPqCpPf3mk2ggUHsYJwCJHjNtR4h34bUVRZSfMOHEt21GHigMr0D
	 UYsYRB+2m1yDmtXUYXoxxZfpzjlXdHM87eIv0kYXkkfz3K06Doq1x1BgfUw8KrjrB7g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016881;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OAMHdntZq0d8epH9cIpZ2+KWtY1K9tTNDnS0zTMwTEY=;
	b=hophs9QfePIrc0bBMk/9raVMCEOGFtD/23X1NBzMKme00HHMT6npfmcYr0yqEWOQj0VM
	 D3ZdzLy9lUloo1mqbdRJbXvIfxEDJpQYBmBzq9kg86I/Z+Upx0I03s1pod9esULNa5WjK
	 Me7ZnG+C9Wjj88+ut4RYddnqd7tJvvp4yfJ1JJ/ksOeHUbVjlxTQs6Ze+g9VcIW7/OtPS
	 t72jbVJhyNxwpX9sYfe9AAysh35haRluiptRma+tVfACua0LunZ+8F4spsPKGZyXtWfej
	 4BcljvzGGpFKuipjyT+F8mcfX2sf+OCdlsjC/qs4JNOF5SOOC9b7sJGHFeobI7EmxfA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="z65/nklK";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D11F5606A320;
	Wed, 18 Nov 2026 15:48:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=z65/nklK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E62B11F000C4;
	Wed, 18 Nov 2026 15:48:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016881;
	bh=OAMHdntZq0d8epH9cIpZ2+KWtY1K9tTNDnS0zTMwTEY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=z65/nklKN8+Hw7TOLU+ONTP60ZoWMPQX+gZld68rSk5q9d3j5dbAmxArnT7Dlrw68
	 XuMajvOxHQ9Y/MD6MJJD0v8zmeyw83NbFn9IQTNC3nuoxQP5PiuFvbAwODsErKHaZj
	 fyVWtonDgdP45IZUO6mKIW6m2eZTP2m7eDI8szAc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0685/2651] RDMA/cxgb4: Fix skb reference leak in rx_pkt()
Date: Wed, 18 Nov 2026 15:32:05 +0100
Message-ID: <20261118150312.518672815@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Liang <vulab@iscas.ac.cn>

[ Upstream commit 5eb6ecb612841927b5ede554a0e9d88240934282 ]

rx_pkt() takes an extra reference on the received skb so it can be
handed to the firmware completion path via req->cookie.  When the
work request skb allocation in send_fw_pass_open_req() fails the
function returns without releasing that extra reference, leaking
one skb reference.

Free the packet skb before returning when the allocation fails,
matching the cxgb4_ofld_send() failure path.

Fixes: 1cab775c3e75 ("RDMA/cxgb4: Fix LE hash collision bug for passive open connection")
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Link: https://patch.msgid.link/20260916183715.2092663-1-vulab@iscas.ac.cn
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/cxgb4/cm.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/cxgb4/cm.c b/drivers/infiniband/hw/cxgb4/cm.c
index f57a31cf4fc78..a6f520f49d592 100644
--- a/drivers/infiniband/hw/cxgb4/cm.c
+++ b/drivers/infiniband/hw/cxgb4/cm.c
@@ -4006,8 +4006,10 @@ static void send_fw_pass_open_req(struct c4iw_dev *dev, struct sk_buff *skb,
 	int ret;
 
 	req_skb = alloc_skb(sizeof(struct fw_ofld_connection_wr), GFP_KERNEL);
-	if (!req_skb)
+	if (!req_skb) {
+		kfree_skb(skb);
 		return;
+	}
 	req = __skb_put_zero(req_skb, sizeof(*req));
 	req->op_compl = htonl(WR_OP_V(FW_OFLD_CONNECTION_WR) | FW_WR_COMPL_F);
 	req->len16_pkd = htonl(FW_WR_LEN16_V(DIV_ROUND_UP(sizeof(*req), 16)));
-- 
2.53.0



