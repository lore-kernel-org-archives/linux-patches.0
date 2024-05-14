Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FB5F40862;
	Tue, 14 May 2024 11:48:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715687331; cv=none; b=UgJD/UMexpOLySpdBaITfEn1dEafR67Pf/krReqMjeuUp8V4/LNZW79+tsXUUHkVKuoZTdEak7AWqLoC1crDPyifefJtXN6CbIqv7JaIj0+pNnUVZaSYKBoN6yEMl9u1OQSqCQSSvXy+r3/2zQ94H61YqumflE5V9LiEH2Hsdak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715687331; c=relaxed/simple;
	bh=PGW9dae9YX5wifXeYBWSYjbym6Yo5iEyhkm5RzsimZY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uXyYPSy/5hQj3lJD7hnPLXlgMocQPBC5dGrwUajzCr6hZC1VCEAgR2DHpY1i670Cr0se9rvELVRALBdjMXvlwGZk4hMxv97hwaYC8SEHgeMTkNaE+4a7zIpCWI2FBvaCXdgd4KpanPuR5LnvpO/cbYznHm267NGO6HZnK8OBxaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u8Jw1j9b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u8Jw1j9b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE974C2BD10;
	Tue, 14 May 2024 11:48:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715687331;
	bh=PGW9dae9YX5wifXeYBWSYjbym6Yo5iEyhkm5RzsimZY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u8Jw1j9br2V92ReQw/nOh0URzJCy1GIu1DovTw2eCrDbu4/rezu2feQ4XLA+DdGMZ
	 K6aX6kR/Fi6/CqrqAG3PmOsgyLDjBtBOfqMv4HxtO9aSLTpWFvaVGBI9QLPPrhbZkV
	 +Eeq9C+kwB29qE4Lgjz4JZYJAEq9mdDlv63nNHEQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Asbj=C3=B8rn=20Sloth=20T=C3=B8nnesen?= <ast@fiberby.net>,
	Simon Horman <horms@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 028/111] net: qede: use return from qede_parse_flow_attr() for flower
Date: Tue, 14 May 2024 12:19:26 +0200
Message-ID: <20240514100958.195725259@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514100957.114746054@linuxfoundation.org>
References: <20240514100957.114746054@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index ba28381c26bbf..413e8331a0ce6 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_filter.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_filter.c
@@ -1888,10 +1888,9 @@ int qede_add_tc_flower_fltr(struct qede_dev *edev, __be16 proto,
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



