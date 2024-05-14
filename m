Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16D555A4C0;
	Tue, 14 May 2024 11:30:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715686226; cv=none; b=N3MH+wLf/4oDde8Y+s3+ff0H0cEbWgIBdayVuQUpJWbSHyE5zVDm3Blw1pb2OA1kfiAvdm5ESd3Yra4SBvpjeMjhpkgvx2ogYUqnBDs89Gn0EKm2MwFrufOreUklFeN6WUs2KhEbK72J4RGGvTpqWF9UnNndS8oxvm6ZZFsfse8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715686226; c=relaxed/simple;
	bh=ScnW5RSxpAkr5a/i1FUAjBR5GnNWrOPr7e7VZbSTd3w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YqA7aH7uUfRBhlHfrv9f2mgusK2x3uYv8hE31QX4iL31bVQbDX5vHuVp8WhsAI64Qxd89nEBWs+lnE4T7sSHxrxE0wA+Z06NKAOsBbPOxt1uCj5gSK1fpAu9xNcrbMCO1qZGu2gCUzdRd9ZUJD6Xf2mJS+rkPkcWglr4XbWt3L4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N+sXg+BB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N+sXg+BB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94F75C2BD10;
	Tue, 14 May 2024 11:30:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715686226;
	bh=ScnW5RSxpAkr5a/i1FUAjBR5GnNWrOPr7e7VZbSTd3w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N+sXg+BB0lz/Gd5RVhruqW5n6+0uFVJwDGODEbewDqViEwP87qFSIB6CpYZHS///m
	 yBU7CYizKki3nSjzbyUqfCyAQSRlErL4/51fIIHrAuqsLXVeKnfq/4hNH7dzJSx7Hj
	 7lTTrIlGOwY5uKli9mTzT7INWw8uHgaf58SvH0LM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Asbj=C3=B8rn=20Sloth=20T=C3=B8nnesen?= <ast@fiberby.net>,
	Simon Horman <horms@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 064/236] net: qede: use return from qede_parse_flow_attr() for flower
Date: Tue, 14 May 2024 12:17:06 +0200
Message-ID: <20240514101022.789397792@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101020.320785513@linuxfoundation.org>
References: <20240514101020.320785513@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Asbjørn Sloth Tønnesen <ast@fiberby.net>

[ Upstream commit fcee2065a178f78be6fd516302830378b17dba3d ]

In qede_add_tc_flower_fltr(), when calling
qede_parse_flow_attr() then the return code
was only used for a non-zero check, and then
-EINVAL was returned.

qede_parse_flow_attr() can currently fail with:
* -EINVAL
* -EOPNOTSUPP
* -EPROTONOSUPPORT

This patch changes the code to use the actual
return code, not just return -EINVAL.

The blaimed commit introduced these functions.

Only compile tested.

Fixes: 2ce9c93eaca6 ("qede: Ingress tc flower offload (drop action) support.")
Signed-off-by: Asbjørn Sloth Tønnesen <ast@fiberby.net>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/qlogic/qede/qede_filter.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qede/qede_filter.c b/drivers/net/ethernet/qlogic/qede/qede_filter.c
index 76aa5934e985b..aedb98713bbf2 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_filter.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_filter.c
@@ -1879,10 +1879,9 @@ int qede_add_tc_flower_fltr(struct qede_dev *edev, __be16 proto,
 	}
 
 	/* parse flower attribute and prepare filter */
-	if (qede_parse_flow_attr(edev, proto, f->rule, &t)) {
-		rc = -EINVAL;
+	rc = qede_parse_flow_attr(edev, proto, f->rule, &t);
+	if (rc)
 		goto unlock;
-	}
 
 	/* Validate profile mode and number of filters */
 	if ((edev->arfs->filter_count && edev->arfs->mode != t.mode) ||
-- 
2.43.0



