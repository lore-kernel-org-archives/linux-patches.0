Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44FB525BAAA;
	Tue, 11 Mar 2025 15:21:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741706500; cv=none; b=G9weyOUwfcL3eMppmwOX9wlmtaELplYMI0UdQg7VJar+5bQhQIHu+jTgO76TRQqWO8C/7Zxt09D41Wk7i/EdtCvSuK9YSTBux9UAsAUTvTHQQpI8RCfaXxkqwWlf9FtR9q1bFd4b3c3sPBLncKy/0SQnDoq9CzTPtbEvfPeOFi4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741706500; c=relaxed/simple;
	bh=9uE7DrzWvaCOIqC/e48xCRUsfrKB6WABTvvJjy1Qdjk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NtAKSIDsvd09w5OgoXSpwr/KX0W0AVMTohzXgl4emfQITmZQl0wT9oYe6QRgjjSkHhPOdfE5OyoEPYPJjO8X6uNmVw8nFHZ5+VpkuYqGLMtei0IuSrb+Zi/ODZJ/aXUrw75//h+ZicikQnkpTGG7Q9q89S9xVLP5wF0WUavu00M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hZN0E1Rm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hZN0E1Rm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3F1AC4CEED;
	Tue, 11 Mar 2025 15:21:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741706500;
	bh=9uE7DrzWvaCOIqC/e48xCRUsfrKB6WABTvvJjy1Qdjk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hZN0E1RmIgwcgmWSouS0MUfjZddO8tVw5e9cG1SgvcCvZu6XFgfeojYhR9WafGxhZ
	 IOwzDM2Ce9YB3u0Z/ZH8JIEo04PAQwd4VoFseHO/qGrrFqNS8oG8p2jwOz/b7ewW5I
	 exMXFSNzNbxs9bKXl5C/HnzwwMj4BWTKUpYufbgg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 069/462] rdma/cxgb4: Prevent potential integer overflow on 32bit
Date: Tue, 11 Mar 2025 15:55:35 +0100
Message-ID: <20250311145801.077451856@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit bd96a3935e89486304461a21752f824fc25e0f0b ]

The "gl->tot_len" variable is controlled by the user.  It comes from
process_responses().  On 32bit systems, the "gl->tot_len + sizeof(struct
cpl_pass_accept_req) + sizeof(struct rss_header)" addition could have an
integer wrapping bug.  Use size_add() to prevent this.

Fixes: 1cab775c3e75 ("RDMA/cxgb4: Fix LE hash collision bug for passive open connection")
Link: https://patch.msgid.link/r/86b404e1-4a75-4a35-a34e-e3054fa554c7@stanley.mountain
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/cxgb4/device.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/device.c b/drivers/infiniband/hw/cxgb4/device.c
index 541dbcf22d0eb..13e4b2c40d835 100644
--- a/drivers/infiniband/hw/cxgb4/device.c
+++ b/drivers/infiniband/hw/cxgb4/device.c
@@ -1114,8 +1114,10 @@ static inline struct sk_buff *copy_gl_to_skb_pkt(const struct pkt_gl *gl,
 	 * The math here assumes sizeof cpl_pass_accept_req >= sizeof
 	 * cpl_rx_pkt.
 	 */
-	skb = alloc_skb(gl->tot_len + sizeof(struct cpl_pass_accept_req) +
-			sizeof(struct rss_header) - pktshift, GFP_ATOMIC);
+	skb = alloc_skb(size_add(gl->tot_len,
+				 sizeof(struct cpl_pass_accept_req) +
+				 sizeof(struct rss_header)) - pktshift,
+			GFP_ATOMIC);
 	if (unlikely(!skb))
 		return NULL;
 
-- 
2.39.5



