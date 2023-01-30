Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D80FB28EB
	for <patches@lists.linux.dev>; Mon, 30 Jan 2023 13:55:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D07EC433D2;
	Mon, 30 Jan 2023 13:55:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675086937;
	bh=EZLT0AVsqWKxKUV5hGR5Zz6ojJW7QsNZkPV2uRH0bSY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x8HH0eEqo9+dogiy94/siX/eWRNC/mS/ZGOGQ/f1qCnJ4/GAQyDGW6EGHZm5w2QGv
	 FdDmGEDHEJl+Lq4RoLx/ajaUFZXBJRJEmUwYeSglkKF9f4ekzbPjiooRBtWu0+Gf0y
	 vnzAHOBz4/ytGdxjpARS56HXjFBYsXmzLo8O20WU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dean Luick <dean.luick@cornelisnetworks.com>,
	Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 046/313] IB/hfi1: Reject a zero-length user expected buffer
Date: Mon, 30 Jan 2023 14:48:01 +0100
Message-Id: <20230130134338.833338042@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Dean Luick <dean.luick@cornelisnetworks.com>

[ Upstream commit 0a0a6e80472c98947d73c3d13bcd7d101895f55d ]

A zero length user buffer makes no sense and the code
does not handle it correctly.  Instead, reject a
zero length as invalid.

Fixes: 97736f36dbeb ("IB/hfi1: Validate page aligned for a given virtual addres")
Signed-off-by: Dean Luick <dean.luick@cornelisnetworks.com>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
Link: https://lore.kernel.org/r/167328547120.1472310.6362802432127399257.stgit@awfm-02.cornelisnetworks.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hfi1/user_exp_rcv.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/infiniband/hw/hfi1/user_exp_rcv.c b/drivers/infiniband/hw/hfi1/user_exp_rcv.c
index 186d30291260..3c609b11e71c 100644
--- a/drivers/infiniband/hw/hfi1/user_exp_rcv.c
+++ b/drivers/infiniband/hw/hfi1/user_exp_rcv.c
@@ -256,6 +256,8 @@ int hfi1_user_exp_rcv_setup(struct hfi1_filedata *fd,
 
 	if (!PAGE_ALIGNED(tinfo->vaddr))
 		return -EINVAL;
+	if (tinfo->length == 0)
+		return -EINVAL;
 
 	tidbuf = kzalloc(sizeof(*tidbuf), GFP_KERNEL);
 	if (!tidbuf)
-- 
2.39.0



