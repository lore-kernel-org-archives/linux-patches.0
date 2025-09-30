Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E5DC1E3DF2;
	Tue, 30 Sep 2025 14:51:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759243884; cv=none; b=pK4Llh7oCqgwy0UXI+kYCX4y0gCvsR1OmeYR2ohCfSQDGMPk58ct/B4xZOW/spfZbfI7Splx759BxG78o5ci16EX8eVBDmH0Nhoci4GChNdIxMA16iUpx6/RzgQMkmb9ZtBS11r98kiM14AHTeMIdfO76TtGIJVLJeZt7TiOfRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759243884; c=relaxed/simple;
	bh=C8oX14rncySQ24zJKKm1uDj4Aeg4XaPyP0fwwDxdo00=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=de69kdoNH66jyb/q7B4zIeVEML5yaHWNxZktZb0iEaupJ47/1raGdH12ZhNMZG1LYnZ1Xmm4h0p+6oIevN0KdFjb5MrRRHfHP2FqvuLPrUzgjx+zY22UNQKwekj2aV9BlZFJAS3zDmml8ay2CDJEQFB15rsAx6Karn+Z2tHIYoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y+PSrFMX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y+PSrFMX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F3E2C4CEF0;
	Tue, 30 Sep 2025 14:51:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759243884;
	bh=C8oX14rncySQ24zJKKm1uDj4Aeg4XaPyP0fwwDxdo00=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y+PSrFMXLfM9IJ8mIHH1Pt8CASBV8HuqRRCBCPAWM5od6JulART/7pHMaJEIMJH+V
	 90UGp5bgAHIhkP43s58Z1768zX+dix/8ZqWKo85o4HoeglhxeJH35ocJWCeQ8KKONe
	 cpMbHdlW6FpDqHOnHePNRUNKc2c19RAb3Edifqdg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?H=C3=A5kon=20Bugge?= <haakon.bugge@oracle.com>,
	Allison Henderson <allison.henderson@oracle.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.4 45/81] rds: ib: Increment i_fastreg_wrs before bailing out
Date: Tue, 30 Sep 2025 16:46:47 +0200
Message-ID: <20250930143821.562108824@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143819.654157320@linuxfoundation.org>
References: <20250930143819.654157320@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
 


