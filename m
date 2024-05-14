Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A42EC85C65;
	Tue, 14 May 2024 11:46:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715687178; cv=none; b=TFVt5bPKLUEsjlGUmUZZRMozYvyxVd7AxNldAkfpMqmax2j0+XaANDgW8vehID/LQRwcuMv/AUt6fHanoyEJPJamcBxicEN7jjVSrDyDoxe06tXqclNepHzU8PP9vH3VFVK/X2sfiONubUEwjcZvomyAnhrPdpkQfDVQXQkbl9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715687178; c=relaxed/simple;
	bh=pJVutvBj1gGSGpIZt3WZWdJbFS6k9x/CDcR+6EPbB60=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Un2kP4diM+65dLlHLStDRlq1VPmTwp0hoXFuMUSfDU2nf9pmfWuzMsu5ySzg4C164itgiU5RIGOO5T5tmGGnjlOOXStALAc9yJ7cK7L8+Vvo0lDvrwF9dAtiLwPCZ4q5qUXoWV6dGblsuy6L84TZLnmGmM+fsV5kpK4iHZD4n/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lZ2knqHM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lZ2knqHM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BBDEC2BD10;
	Tue, 14 May 2024 11:46:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715687178;
	bh=pJVutvBj1gGSGpIZt3WZWdJbFS6k9x/CDcR+6EPbB60=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lZ2knqHMlOu2lHigRkHtJxQcqtp3Vuzhe3c3A0KRRAqZF7JeIyQpM4jySvnuKJRkl
	 mBhE3ylPTwUDKzGppLO1L/Gfo1cM9gNhNUpnYYNChOxEHllnSREf8EJcOkDwIEHA3c
	 HxD2lIFA6Z40DMuiqmsCZFwVFgVU4kpzvrHw5pm0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Asbj=C3=B8rn=20Sloth=20T=C3=B8nnesen?= <ast@fiberby.net>,
	Simon Horman <horms@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 71/84] net: qede: sanitize rc in qede_add_tc_flower_fltr()
Date: Tue, 14 May 2024 12:20:22 +0200
Message-ID: <20240514100954.353250021@linuxfoundation.org>
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

[ Upstream commit e25714466abd9d96901b15efddf82c60a38abd86 ]

Explicitly set 'rc' (return code), before jumping to the
unlock and return path.

By not having any code depend on that 'rc' remains at
it's initial value of -EINVAL, then we can re-use 'rc' for
the return code of function calls in subsequent patches.

Only compile tested.

Signed-off-by: Asbjørn Sloth Tønnesen <ast@fiberby.net>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: fcee2065a178 ("net: qede: use return from qede_parse_flow_attr() for flower")
[ resolved conflict in v5.4, no extack for qede_parse_actions() yet ]
Signed-off-by: Asbjørn Sloth Tønnesen <ast@fiberby.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/qlogic/qede/qede_filter.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qede/qede_filter.c b/drivers/net/ethernet/qlogic/qede/qede_filter.c
index 31223de0c766e..c02938002278f 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_filter.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_filter.c
@@ -1949,8 +1949,8 @@ int qede_add_tc_flower_fltr(struct qede_dev *edev, __be16 proto,
 			    struct flow_cls_offload *f)
 {
 	struct qede_arfs_fltr_node *n;
-	int min_hlen, rc = -EINVAL;
 	struct qede_arfs_tuple t;
+	int min_hlen, rc;
 
 	__qede_lock(edev);
 
@@ -1960,8 +1960,10 @@ int qede_add_tc_flower_fltr(struct qede_dev *edev, __be16 proto,
 	}
 
 	/* parse flower attribute and prepare filter */
-	if (qede_parse_flow_attr(edev, proto, f->rule, &t))
+	if (qede_parse_flow_attr(edev, proto, f->rule, &t)) {
+		rc = -EINVAL;
 		goto unlock;
+	}
 
 	/* Validate profile mode and number of filters */
 	if ((edev->arfs->filter_count && edev->arfs->mode != t.mode) ||
@@ -1969,12 +1971,15 @@ int qede_add_tc_flower_fltr(struct qede_dev *edev, __be16 proto,
 		DP_NOTICE(edev,
 			  "Filter configuration invalidated, filter mode=0x%x, configured mode=0x%x, filter count=0x%x\n",
 			  t.mode, edev->arfs->mode, edev->arfs->filter_count);
+		rc = -EINVAL;
 		goto unlock;
 	}
 
 	/* parse tc actions and get the vf_id */
-	if (qede_parse_actions(edev, &f->rule->action))
+	if (qede_parse_actions(edev, &f->rule->action)) {
+		rc = -EINVAL;
 		goto unlock;
+	}
 
 	if (qede_flow_find_fltr(edev, &t)) {
 		rc = -EEXIST;
-- 
2.43.0



