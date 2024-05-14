Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 872D22B9AD;
	Tue, 14 May 2024 11:55:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715687719; cv=none; b=slCnB8A0vFCtxlnAqTZTEy3qptIcZkQ8gIfuypmKf6gDkaTncxv6hgl2YlGDhaHSa0v2kmgTpi5QGyYsLeMmC/BB6a9CATctr7YE5M5GJ41aApCsNaapI41Zj7gJKIqlhhMhbQPNqbaDqpSaPgJQxshzbZUrmCUnjWg718w92iM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715687719; c=relaxed/simple;
	bh=/w90sZYYV6jP5QbXfUU/PXFgvDklHQFeG92Wu/Js8RM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IStKQ7Nb3DTIWtpm0QmsiHOty8PKG3rqvXWFLxX43+PM1q6kdIdj+HAhFLbHSaVukfYqLl9/eoyBP6oNyw9b5YwcRCc7CoQB/En/Ly2lHWpbP/Ct4D9rRFAdV7iOBULB1VEaUTNqkY+nsS0KMQrGuCsjfDRpbKGbukOQJCRCnTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zY8RY7V9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zY8RY7V9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1080AC2BD10;
	Tue, 14 May 2024 11:55:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715687719;
	bh=/w90sZYYV6jP5QbXfUU/PXFgvDklHQFeG92Wu/Js8RM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zY8RY7V9ePiHMYdVafVz5o5e2q0uW4kEl1KcEVc5XShjs9ahIIzVRLEIEcsG+R6/d
	 vxfASt1faCwfQ9a+Ay1399aJYo5PgTVE+S08zVq0aLc3hJQcGrDzoqL5BXdQqod6bn
	 KivtmM2bhr6V7oEWprBf51sh0L5AmnBFKgl2I5Yw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Asbj=C3=B8rn=20Sloth=20T=C3=B8nnesen?= <ast@fiberby.net>,
	Simon Horman <horms@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 040/168] net: qede: use return from qede_parse_flow_attr() for flow_spec
Date: Tue, 14 May 2024 12:18:58 +0200
Message-ID: <20240514101008.204474267@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101006.678521560@linuxfoundation.org>
References: <20240514101006.678521560@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



