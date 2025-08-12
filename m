Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 374DD2C21E3;
	Tue, 12 Aug 2025 18:49:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755024591; cv=none; b=hItTY0wpVNaFaxq+6oJVQ2V/6SPeNi+YB6zkgfvQp5TDohCp2lEKyjpqEc9I+GLQvEVAKHnRMoLFivme1ZI+LvLK+APDO9CFXCjkZs6LOd7EQJyesHVTg6hGjzVKZMC4d5DhTomcXcXeOEKqqxJ/wN6kFboc2MUm3OgEWNUatfE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755024591; c=relaxed/simple;
	bh=mrgypHEFdMTzjtqCSMuMsQE1UX6czFjoN2yHgSCTrVI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L/+kagn3qHQyJj9h32QQNxnDZ28fE2GEm1jrvsfm34nT500WtMz9rFygROVjs4lvGk30pgnb812nJoNVnV5WRRD7m8O2vDST6eJEl5xu38S6T7gSgOR/DBwlx7Xe4eGFOOpEdV2G3Uaabor5LcBK5khmqgRY+EfRMdSswrXT4+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jknYiS5c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jknYiS5c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 380FEC4CEF0;
	Tue, 12 Aug 2025 18:49:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755024590;
	bh=mrgypHEFdMTzjtqCSMuMsQE1UX6czFjoN2yHgSCTrVI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jknYiS5cSgJHtkiVRo7UEjaDG8NetY3i7m8JOQ3EazQhIh9A7erdpRtlNcZXAYgZ4
	 wI7BZVnKsK8nxsvPp5Ab1VZaZV+GsbN28DKMOlHx0ZPJoNBhK9OZHJkbFX6h6E6Eu7
	 nxf09VKl6FxamoBiDrWtvoImxwkROFpwcIxWKWl0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shiraz Saleem <shirazsaleem@microsoft.com>,
	Konstantin Taranov <kotaranov@microsoft.com>,
	Long Li <longli@microsoft.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 385/627] RDMA/mana_ib: Fix DSCP value in modify QP
Date: Tue, 12 Aug 2025 19:31:20 +0200
Message-ID: <20250812173433.936866937@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shiraz Saleem <shirazsaleem@microsoft.com>

[ Upstream commit 62de0e67328e9503459a24b9343c3358937cdeef ]

Convert the traffic_class in GRH to a DSCP value as required by the HW.

Fixes: e095405b45bb ("RDMA/mana_ib: Modify QP state")
Signed-off-by: Shiraz Saleem <shirazsaleem@microsoft.com>
Signed-off-by: Konstantin Taranov <kotaranov@microsoft.com>
Link: https://patch.msgid.link/1752143085-4169-1-git-send-email-kotaranov@linux.microsoft.com
Reviewed-by: Long Li <longli@microsoft.com>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mana/qp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mana/qp.c b/drivers/infiniband/hw/mana/qp.c
index 14fd7d6c54a2..a6bf4d539e67 100644
--- a/drivers/infiniband/hw/mana/qp.c
+++ b/drivers/infiniband/hw/mana/qp.c
@@ -772,7 +772,7 @@ static int mana_ib_gd_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 		req.ah_attr.dest_port = ROCE_V2_UDP_DPORT;
 		req.ah_attr.src_port = rdma_get_udp_sport(attr->ah_attr.grh.flow_label,
 							  ibqp->qp_num, attr->dest_qp_num);
-		req.ah_attr.traffic_class = attr->ah_attr.grh.traffic_class;
+		req.ah_attr.traffic_class = attr->ah_attr.grh.traffic_class >> 2;
 		req.ah_attr.hop_limit = attr->ah_attr.grh.hop_limit;
 	}
 
-- 
2.39.5



