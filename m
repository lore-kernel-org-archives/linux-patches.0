Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5FAB2DF73;
	Mon,  8 Apr 2024 13:06:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712581585; cv=none; b=BqM83Mdmqj0mut3GY3+HVopEOPqFoB19morsw3gVzLA5vsA+53fG0tfHaXxen3HWVlrIxQgbSz1JNmozv3+upuKkvOSq7WDBO84oUuY18WyZ3vc9gPoBrgUrk2oJqU2LBS0+fBy424Cy0u/wZyJ51/dVtHEIe+adtaqXwP+Rq98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712581585; c=relaxed/simple;
	bh=MddQ+DGLXQ+JJXN/9mHBE2V3F9WZGAS81LvzOvJy7xs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PdQfz7Hq/kxiK+KWd8a+EcUeUQbp7HxPpy6hXAq9A2dTAvn5zd+KUXUXi5lgauAy+/+iuRJGyVgQxw5bukT28E2i0mw/je1crs0533lilbYei5WND0wo5PaIeEDmIuyTlJ1tGyT1NEj9m5oZR5s8XpOl+6qEmIZQ/FsuKqnG3bI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q1mI/tch; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q1mI/tch"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FF29C433F1;
	Mon,  8 Apr 2024 13:06:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712581585;
	bh=MddQ+DGLXQ+JJXN/9mHBE2V3F9WZGAS81LvzOvJy7xs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q1mI/tchFf1S0EUggtDaj+ZPpQJXwYgHYyeN2MOPB7hCgl+kaDabcB5W2UALr5DWA
	 d2mA7flVFcn9cxT2eSDQ52c4gfNvkJeIunGxptK2jpaGOtKsTu4Z5MwU1nt76N4T7U
	 1GfBZJd7yWGb5JFiWTQBYqcIflhBlpmpcYaMMtDY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mahmoud Adam <mngyadam@amazon.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 036/138] net/rds: fix possible cp null dereference
Date: Mon,  8 Apr 2024 14:57:30 +0200
Message-ID: <20240408125257.346681762@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125256.218368873@linuxfoundation.org>
References: <20240408125256.218368873@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mahmoud Adam <mngyadam@amazon.com>

commit 62fc3357e079a07a22465b9b6ef71bb6ea75ee4b upstream.

cp might be null, calling cp->cp_conn would produce null dereference

[Simon Horman adds:]

Analysis:

* cp is a parameter of __rds_rdma_map and is not reassigned.

* The following call-sites pass a NULL cp argument to __rds_rdma_map()

  - rds_get_mr()
  - rds_get_mr_for_dest

* Prior to the code above, the following assumes that cp may be NULL
  (which is indicative, but could itself be unnecessary)

	trans_private = rs->rs_transport->get_mr(
		sg, nents, rs, &mr->r_key, cp ? cp->cp_conn : NULL,
		args->vec.addr, args->vec.bytes,
		need_odp ? ODP_ZEROBASED : ODP_NOT_NEEDED);

* The code modified by this patch is guarded by IS_ERR(trans_private),
  where trans_private is assigned as per the previous point in this analysis.

  The only implementation of get_mr that I could locate is rds_ib_get_mr()
  which can return an ERR_PTR if the conn (4th) argument is NULL.

* ret is set to PTR_ERR(trans_private).
  rds_ib_get_mr can return ERR_PTR(-ENODEV) if the conn (4th) argument is NULL.
  Thus ret may be -ENODEV in which case the code in question will execute.

Conclusion:
* cp may be NULL at the point where this patch adds a check;
  this patch does seem to address a possible bug

Fixes: c055fc00c07b ("net/rds: fix WARNING in rds_conn_connect_if_down")
Cc: stable@vger.kernel.org # v4.19+
Signed-off-by: Mahmoud Adam <mngyadam@amazon.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://lore.kernel.org/r/20240326153132.55580-1-mngyadam@amazon.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/rds/rdma.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/rds/rdma.c
+++ b/net/rds/rdma.c
@@ -302,7 +302,7 @@ static int __rds_rdma_map(struct rds_soc
 		}
 		ret = PTR_ERR(trans_private);
 		/* Trigger connection so that its ready for the next retry */
-		if (ret == -ENODEV)
+		if (ret == -ENODEV && cp)
 			rds_conn_connect_if_down(cp->cp_conn);
 		goto out;
 	}


