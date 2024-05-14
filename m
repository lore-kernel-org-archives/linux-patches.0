Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F236C84D26;
	Tue, 14 May 2024 11:30:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715686229; cv=none; b=XUC3Ewq/lCmMB9nBfGAE+YFyC6Vmu0cUZ2SNDr/dshw/SZ0OgDjPeJN9h/g25LppqjXEGWOn1TBy1mXUMKFHoUghzwZGpzSPdT9taUP9gSS8PNuZaCxLw0sSP4FANSVMHRuuqrkxPKE2SBYgMofFY2NAURE4wDqW4+gFKM7FWt8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715686229; c=relaxed/simple;
	bh=HKA6CaahibWf4vtjsWEDc4HY0SID1D/Vpglj4ee2NmI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=geu3dtiy02LB1uCe1BmCMBZC9nt7/u9IChuihxduScyVImiy5Ne3Rmd4Lc55Qv8qzlKsWQCp/0jLjKIn9diNzca3yD4Gq2/o45kBkhTqoWKobd+N6klQiu3pUJvscziDYWyXvKovdPFwOVEMJfK0kleeDvcBHOUroUSeQePWACs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tY+qKqrM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tY+qKqrM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76C85C2BD10;
	Tue, 14 May 2024 11:30:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715686228;
	bh=HKA6CaahibWf4vtjsWEDc4HY0SID1D/Vpglj4ee2NmI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tY+qKqrM++zl1eoZ4Gb0FtJzz1cYA6ZveQR6YaoRUpxtVOqNmG+Auk/3SfnpXE9/6
	 S/XyShJXrr6OY1lLLcfffr6J4pDWmunBpQbxA9mMYdsSgNm4X9E3rPgPMGrwPK+TmE
	 Whg+RnRpO3NoEjz3OSfTb1MzKumdqTKm54Kubxfw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Asbj=C3=B8rn=20Sloth=20T=C3=B8nnesen?= <ast@fiberby.net>,
	Simon Horman <horms@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 065/236] net: qede: use return from qede_parse_flow_attr() for flow_spec
Date: Tue, 14 May 2024 12:17:07 +0200
Message-ID: <20240514101022.829175567@linuxfoundation.org>
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

[ Upstream commit 27b44414a34b108c5a37cd5b4894f606061d86e7 ]

In qede_flow_spec_to_rule(), when calling
qede_parse_flow_attr() then the return code
was only used for a non-zero check, and then
-EINVAL was returned.

qede_parse_flow_attr() can currently fail with:
* -EINVAL
* -EOPNOTSUPP
* -EPROTONOSUPPORT

This patch changes the code to use the actual
return code, not just return -EINVAL.

The blaimed commit introduced qede_flow_spec_to_rule(),
and this call to qede_parse_flow_attr(), it looks
like it just duplicated how it was already used.

Only compile tested.

Fixes: 37c5d3efd7f8 ("qede: use ethtool_rx_flow_rule() to remove duplicated parser code")
Signed-off-by: Asbjørn Sloth Tønnesen <ast@fiberby.net>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/qlogic/qede/qede_filter.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qede/qede_filter.c b/drivers/net/ethernet/qlogic/qede/qede_filter.c
index aedb98713bbf2..aeff091cdfaee 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_filter.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_filter.c
@@ -2002,10 +2002,9 @@ static int qede_flow_spec_to_rule(struct qede_dev *edev,
 	if (IS_ERR(flow))
 		return PTR_ERR(flow);
 
-	if (qede_parse_flow_attr(edev, proto, flow->rule, t)) {
-		err = -EINVAL;
+	err = qede_parse_flow_attr(edev, proto, flow->rule, t);
+	if (err)
 		goto err_out;
-	}
 
 	/* Make sure location is valid and filter isn't already set */
 	err = qede_flow_spec_validate(edev, &flow->rule->action, t,
-- 
2.43.0



