Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E10C2D60A;
	Tue, 14 May 2024 11:45:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715687120; cv=none; b=pylWKkPbAjodELJx4naku7XFMrJ93vKmmmd3zvyD/kUXjsrXSMe9r7IUZ2/Um9Ff2O+QLdFsd8pS4Lg97h9Xhv+5LqD7hPkUtNCAgHskYF/qzv+Bee9+uT8VibE88jLOdig7n8TGcZdTjgQHuqfEUgzKhHVin19pqltVCfAOdwY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715687120; c=relaxed/simple;
	bh=DYPQrCAncxBJz1WgZkoHl8T9kUwyGc62VDnTLb+Mo74=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bg3Kni8/zHx73UxQUBqVbJAYIQAH+x3N0pp0y6OcXra2zC1yB0OXsWS8YS2a8LDIF3+VVoP0F1SGu9igTM1zcwijtW55nYsyxNxdYSptsj/w1fS5dyaarSLdc/W/nL1OGj43bwTyjlelUUjonHpYnlZRAVvmLUEyyXvrJLsYM54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IAijF4A+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IAijF4A+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25FEBC2BD10;
	Tue, 14 May 2024 11:45:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715687120;
	bh=DYPQrCAncxBJz1WgZkoHl8T9kUwyGc62VDnTLb+Mo74=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IAijF4A+7yk7UwIJqZ+yA/cI3mr9ZVyT3CFbPKqzLDbO9+gkq3ht8EDLmOBUoMM8n
	 Tn/jW1qaNyEWGhtK7UyoH/bgpOgAdaqEYaL9xOHqw53HpJsuhr+BG8Cy7GLGx83XNL
	 a77RFfPQKXc/n/AVTJcglLGzCN1PIEYtU50ixRHg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Asbj=C3=B8rn=20Sloth=20T=C3=B8nnesen?= <ast@fiberby.net>,
	Simon Horman <horms@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 72/84] net: qede: use return from qede_parse_flow_attr() for flower
Date: Tue, 14 May 2024 12:20:23 +0200
Message-ID: <20240514100954.390790821@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514100951.686412426@linuxfoundation.org>
References: <20240514100951.686412426@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index c02938002278f..3142d92a98f02 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_filter.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_filter.c
@@ -1960,10 +1960,9 @@ int qede_add_tc_flower_fltr(struct qede_dev *edev, __be16 proto,
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



