Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F98813C9A5;
	Thu, 11 Apr 2024 10:39:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712831986; cv=none; b=gs3TYUQJxH1XWl8AbpA3+RLllxo1ZEGchVl87uQI4v+Knyzu3HbtZyFWKLXVehdGdtCghUs9uZUzNbSrPQ0WwE+z9aCHops/p2n2EzojB0RuzTvRwWWfHR9o02ZgbiyA3NOaIYuCtJ64GIqPBKsLgpWdbRiPGBkJXQlxlPtSo24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712831986; c=relaxed/simple;
	bh=kbU1sUezoK5j6TNHKEuXBMFz8foMMzxO4mlGiMUqtrU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KSBx3qBE519GnLXyqMy20fgvO9iTk2vwk0gQNxVuMiFht8lT/oG0/Mi8wCkPevMghJB0PvQvixi5il6Uu8INlyN70U7wzp7GqijT/n4TsuQQUxDUnyDijQSTDhImYmMm5qbGgoBpPq4QcrQ/xI3gUleSj/1+jHJd7IeG6g51NG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wpjJ1QQj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wpjJ1QQj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0543C433F1;
	Thu, 11 Apr 2024 10:39:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712831986;
	bh=kbU1sUezoK5j6TNHKEuXBMFz8foMMzxO4mlGiMUqtrU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wpjJ1QQj/Q+HDhbn9iU6LofELIjiTJyzENGSUYgXzcVsrrZVYgzi2m5Y9GRV620Lv
	 JrSmQwx69wjPqVdXVbKuChs4d4QJLiQcakjQ6522fFZ15OW4xsAZbEkqt5MQTsIxxv
	 q1I4Nbm3f+TrL7lcAPHwREBng0a32Rp90U49hc4Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mahmoud Adam <mngyadam@amazon.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 194/294] net/rds: fix possible cp null dereference
Date: Thu, 11 Apr 2024 11:55:57 +0200
Message-ID: <20240411095441.452496342@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095435.633465671@linuxfoundation.org>
References: <20240411095435.633465671@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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


