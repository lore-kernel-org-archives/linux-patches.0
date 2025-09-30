Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02B0B2F5301;
	Tue, 30 Sep 2025 15:12:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759245170; cv=none; b=KLGM1lsJF15PFOQuZ/71fdy0Z7tb5FrU8/LuEICDatzfvyuqE+5D3bltW5LswZuyRyQZ+eZESZTr9AAZQfws2l6NT2lLYcrHh9Yknfu7tLyoyRwiRDOG+NHUtvqp+o6mH42jCUELNpP29rECihC2eLSZGvb9HLYUVsa3KAuWBDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759245170; c=relaxed/simple;
	bh=47OCKyN/xg+cDJ0ftXVS+yiBlcCWiysrgVO089qTyH0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ssRJgZRhvEhpbEvUKu8UuL6vbYF8TPNqDpKvj2tAZ1psvURUVusHOQXBGskTFCIHq9YXENiS9zK/1ZSDgp8xxo2esQ/rSVgHDFy7tasaHVGxpSfxozp0Eu/vx2q7wLYmOuWgvs5/Qo2mUzw05iSVyKM4BEGt/qqjOB2oQpNmT4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HOQL6Aq+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HOQL6Aq+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 382FDC4CEF0;
	Tue, 30 Sep 2025 15:12:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759245167;
	bh=47OCKyN/xg+cDJ0ftXVS+yiBlcCWiysrgVO089qTyH0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HOQL6Aq+eSL9a+X6RzdwsEhLUCOS//hTm8xXr0XwClbHbjEFSiaJwAt3w6OXzg5LV
	 mEcQXXslaGrke1GGtmNHP4vpAAbNfJ5VoxSODSFxVfRVnLTUmIKXbJQ44cImCjJBWJ
	 WkNnx7P+8em9g2kknxYEmYm2BZgj+gjWVkrWK1pc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?H=C3=A5kon=20Bugge?= <haakon.bugge@oracle.com>,
	Allison Henderson <allison.henderson@oracle.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 084/151] rds: ib: Increment i_fastreg_wrs before bailing out
Date: Tue, 30 Sep 2025 16:46:54 +0200
Message-ID: <20250930143830.941554724@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143827.587035735@linuxfoundation.org>
References: <20250930143827.587035735@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Håkon Bugge <haakon.bugge@oracle.com>

commit 4351ca3fcb3ffecf12631b4996bf085a2dad0db6 upstream.

We need to increment i_fastreg_wrs before we bail out from
rds_ib_post_reg_frmr().

We have a fixed budget of how many FRWR operations that can be
outstanding using the dedicated QP used for memory registrations and
de-registrations. This budget is enforced by the atomic_t
i_fastreg_wrs. If we bail out early in rds_ib_post_reg_frmr(), we will
"leak" the possibility of posting an FRWR operation, and if that
accumulates, no FRWR operation can be carried out.

Fixes: 1659185fb4d0 ("RDS: IB: Support Fastreg MR (FRMR) memory registration mode")
Fixes: 3a2886cca703 ("net/rds: Keep track of and wait for FRWR segments in use upon shutdown")
Cc: stable@vger.kernel.org
Signed-off-by: Håkon Bugge <haakon.bugge@oracle.com>
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
Link: https://patch.msgid.link/20250911133336.451212-1-haakon.bugge@oracle.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/rds/ib_frmr.c |   20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

--- a/net/rds/ib_frmr.c
+++ b/net/rds/ib_frmr.c
@@ -133,12 +133,15 @@ static int rds_ib_post_reg_frmr(struct r
 
 	ret = ib_map_mr_sg_zbva(frmr->mr, ibmr->sg, ibmr->sg_dma_len,
 				&off, PAGE_SIZE);
-	if (unlikely(ret != ibmr->sg_dma_len))
-		return ret < 0 ? ret : -EINVAL;
+	if (unlikely(ret != ibmr->sg_dma_len)) {
+		ret = ret < 0 ? ret : -EINVAL;
+		goto out_inc;
+	}
 
-	if (cmpxchg(&frmr->fr_state,
-		    FRMR_IS_FREE, FRMR_IS_INUSE) != FRMR_IS_FREE)
-		return -EBUSY;
+	if (cmpxchg(&frmr->fr_state, FRMR_IS_FREE, FRMR_IS_INUSE) != FRMR_IS_FREE) {
+		ret = -EBUSY;
+		goto out_inc;
+	}
 
 	atomic_inc(&ibmr->ic->i_fastreg_inuse_count);
 
@@ -166,11 +169,10 @@ static int rds_ib_post_reg_frmr(struct r
 		/* Failure here can be because of -ENOMEM as well */
 		rds_transition_frwr_state(ibmr, FRMR_IS_INUSE, FRMR_IS_STALE);
 
-		atomic_inc(&ibmr->ic->i_fastreg_wrs);
 		if (printk_ratelimit())
 			pr_warn("RDS/IB: %s returned error(%d)\n",
 				__func__, ret);
-		goto out;
+		goto out_inc;
 	}
 
 	/* Wait for the registration to complete in order to prevent an invalid
@@ -179,8 +181,10 @@ static int rds_ib_post_reg_frmr(struct r
 	 */
 	wait_event(frmr->fr_reg_done, !frmr->fr_reg);
 
-out:
+	return ret;
 
+out_inc:
+	atomic_inc(&ibmr->ic->i_fastreg_wrs);
 	return ret;
 }
 


