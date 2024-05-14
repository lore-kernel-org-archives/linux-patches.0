Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D92735A4C0;
	Tue, 14 May 2024 11:30:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715686231; cv=none; b=W529xAf7b9UbfDT8/sxPr0fC5hklNyZaN3dwxSRzJ0oVAZzfW5GdExEuXCKPZF5ZJ5k2aOV6bm6YbA1xS83RJFHhThee6jAqXKyDQPdeM8YaKb84XxG0jweNPVay3IfmETc8QyTklYJN0p8QAFUsTxfL5T+gJ5/DVMCn+GPwtT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715686231; c=relaxed/simple;
	bh=EPPU0arAxB7GjsvlXnq5VIMMSQsLNpAoDoe5Y304Gvg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=X/7aeOKgh7ZhfViGdFjxTYE06YKWtXGELKQghOlTR1JMWbXZGd9Yb9TPyQ2WYU3NxoDvSlHRiNAXuWwPKH5ny+FmR9tLm/ECgHEPKCmc+42rRkkEwYu0iAk6h7aQhHFWqKTnP3mfIg01jF/2UDRFpMmiGAl/7fBf/WFi48w+8Wo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Mvjv9so0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Mvjv9so0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 605ADC2BD10;
	Tue, 14 May 2024 11:30:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715686231;
	bh=EPPU0arAxB7GjsvlXnq5VIMMSQsLNpAoDoe5Y304Gvg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Mvjv9so08gouTY/UVSJozb7b9QSe2HNxHwVKUCHnpv5vyi3vJ1KJ/LsfiNZ74lo+f
	 T7UQyjFjpdQIc9y0Y1kUKLixT+YpPnm8w/ekrNje6nPs+zYvzgdM2JUUX9R+SS+pwD
	 7+zF0D693OISNlvXKOil7fYi3CLXRvtzFTJodNxE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Asbj=C3=B8rn=20Sloth=20T=C3=B8nnesen?= <ast@fiberby.net>,
	Simon Horman <horms@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 066/236] net: qede: use return from qede_parse_actions()
Date: Tue, 14 May 2024 12:17:08 +0200
Message-ID: <20240514101022.868673563@linuxfoundation.org>
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

[ Upstream commit f26f719a36e56381a1f4230e5364e7ad4d485888 ]

When calling qede_parse_actions() then the
return code was only used for a non-zero check,
and then -EINVAL was returned.

qede_parse_actions() can currently fail with:
* -EINVAL
* -EOPNOTSUPP

This patch changes the code to use the actual
return code, not just return -EINVAL.

The blaimed commit broke the implicit assumption
that only -EINVAL would ever be returned.

Only compile tested.

Fixes: 319a1d19471e ("flow_offload: check for basic action hw stats type")
Signed-off-by: Asbjørn Sloth Tønnesen <ast@fiberby.net>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/qlogic/qede/qede_filter.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qede/qede_filter.c b/drivers/net/ethernet/qlogic/qede/qede_filter.c
index aeff091cdfaee..8871099b99d8a 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_filter.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_filter.c
@@ -1894,10 +1894,9 @@ int qede_add_tc_flower_fltr(struct qede_dev *edev, __be16 proto,
 	}
 
 	/* parse tc actions and get the vf_id */
-	if (qede_parse_actions(edev, &f->rule->action, f->common.extack)) {
-		rc = -EINVAL;
+	rc = qede_parse_actions(edev, &f->rule->action, f->common.extack);
+	if (rc)
 		goto unlock;
-	}
 
 	if (qede_flow_find_fltr(edev, &t)) {
 		rc = -EEXIST;
-- 
2.43.0



