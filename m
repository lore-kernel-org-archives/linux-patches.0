Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4FC612F588;
	Tue, 14 May 2024 10:26:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715682418; cv=none; b=EXkDgckEDHqyFXIqj1pzJ3D0ZeZC6RqWQbeQIbTtFSJ4avKlm9jOYMJUIQ26QKam8PR/4RSqqT6gjP5Vl4SgxZQ5lMk2auYXyB9QzjtAaSrjzmxUGixN79w5AAUSuERkpeEQC7eTop+6/treaf1mG96FL1nDJQMvy9MPBWXx6r4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715682418; c=relaxed/simple;
	bh=li98+w/SJH8r8oHq9UpDW0EPkroB+5iX4xHPvAE+yA8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=X4Hk7QKvtRkOyKm8RADvpozAR/a7VbaFtjJocOwJMlsceefpJQkRYL/LbjlRVehq1C03KwfzeyoFFcRo9TZ8HFdzht6c100Oeeni/pshgpFllp0D7A7RbmJWSitSLuwT4gKnWiyblKRZ4MsbtZVmlGRRR3mpY++Octi3fceS/5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2dLQCRe0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2dLQCRe0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92EBDC2BD10;
	Tue, 14 May 2024 10:26:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715682417;
	bh=li98+w/SJH8r8oHq9UpDW0EPkroB+5iX4xHPvAE+yA8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2dLQCRe0q4trUvJZm8DTAxeHVp7XHJsq0hCmGutnEbII9DQz6oFQl/Mldctp2W9Pc
	 A/UAJcPNRdKa0guFEZTd90l9+dK3+MkDPVF+qj0PE3JkaKifQZaOA3oSqO78y4qlJU
	 6UaZEIk7ANDQkgaUwkWRrXhCsj/WixV0hH0WcMfw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Asbj=C3=B8rn=20Sloth=20T=C3=B8nnesen?= <ast@fiberby.net>,
	Simon Horman <horms@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 058/336] net: qede: use return from qede_parse_flow_attr() for flower
Date: Tue, 14 May 2024 12:14:22 +0200
Message-ID: <20240514101040.796847459@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101038.595152603@linuxfoundation.org>
References: <20240514101038.595152603@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
index 8ecdfa36a6854..25ef0f4258cb1 100644
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



