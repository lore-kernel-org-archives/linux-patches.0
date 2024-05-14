Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30F1112AACA;
	Tue, 14 May 2024 11:47:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715687245; cv=none; b=HILmxkk09bJJYjTz8Z/KbEW62vlT/0HmNzwUniQ+wq5dtzCPlrTs/yOJKWqs/EwBwGhRhlW0drcwoS6GhEiCdgW+eHHSHkDe+7htrRrSw1R7fG4EXrIbhpiOZZDpyEa9l+eDPlNi6V8XZNxiXrz0CNzBg0u++Ynn5wwBeuCKVhQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715687245; c=relaxed/simple;
	bh=4IQB+e5ZjX0viwTuDYrAC8uFpgR4jfn4IfqhWJMj4ys=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hviRbdmwdUOkLE15BW+I0b8GNoGiH+F8GobpufYoxhxog5vR8ATur/17baaw3KNZ84MVG8nI3DkOrmJ14gsct/GFBeO7vAKwDFb0IaNGemp0HGIsR0T3QEBgkcKa5KDEGWzpp+/7KYpkJ24kFN52TtRDSN9ee1qC7cBCYMdFeOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ukbHCnpu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ukbHCnpu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A43E3C2BD10;
	Tue, 14 May 2024 11:47:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715687245;
	bh=4IQB+e5ZjX0viwTuDYrAC8uFpgR4jfn4IfqhWJMj4ys=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ukbHCnpu15zNMmowt49WxRnoWJhc4gp+qjPKx5VwpMyydMBwcUWOVjIgkceGjFRFM
	 7I80eo9jldI5avLck/o97CvaeLXGazouoysB1C5kJeVSmz5CQscZi/3nNQaKQlI/f3
	 WIZxqzNEDo5muXIu675uh6jgZhDMYhAMV3eGfnW8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Asbj=C3=B8rn=20Sloth=20T=C3=B8nnesen?= <ast@fiberby.net>,
	Simon Horman <horms@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 030/111] net: qede: use return from qede_parse_actions()
Date: Tue, 14 May 2024 12:19:28 +0200
Message-ID: <20240514100958.271237055@linuxfoundation.org>
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
index 6e2913f2a791a..5f4962d90022e 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_filter.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_filter.c
@@ -1903,10 +1903,9 @@ int qede_add_tc_flower_fltr(struct qede_dev *edev, __be16 proto,
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



