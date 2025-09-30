Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37D2C30505E;
	Tue, 30 Sep 2025 14:56:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759244216; cv=none; b=vBVJVwLFzZBs+GxST6uxKEHEe/+JaRyQFUBvUDo2C/+uqwZNFop6E7nKFPQ89FrUs7kVQXcLBMCEcxQvQfsc1dvWerMrGxOlMPAOwCWJnYDWPofRBs1F/kK/qqbDNSA+4h0yaLhismUQ2aXuYeLvJu7Gz+r/Gw+d8XYpTOw8rZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759244216; c=relaxed/simple;
	bh=0NyEqFh4GGnW02lGcwLSfBPQNHMW5A00YFMJtjkQoQw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fGpYuyxJ5f3M3iq4f250Odo6FedKtPPoCYm7byVrDZ9czS7w+UDDLeLlkYPgxcvpdLHHzzeyb9kz9wTHrYBTRzU/i/MR8IRsVo/kY3ZYbEcuKq+vL/0n5+tBEAEbd5yFt/eBVwfXHoUxM9HmuZit5G5TN43io3Nb5Ws00JLYDIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wCsBhz4c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wCsBhz4c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 693C7C116B1;
	Tue, 30 Sep 2025 14:56:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759244215;
	bh=0NyEqFh4GGnW02lGcwLSfBPQNHMW5A00YFMJtjkQoQw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wCsBhz4cODOAUH+rQmyViS4KUPQMeY7QTtJsSNDXoHdmszqmOqD6bhc6udqoyeHOh
	 ZUDGh9ztlkFnxYAFDLiZa0qoQE8Q20nm2z9wiNfwoCwGm3tv+gfuVY+JfEb4pNoNtc
	 sOwd/GAiiS8GLcbXsmvInBLMTBGZ6vZWKNHR+Qzk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?H=C3=A5kon=20Bugge?= <haakon.bugge@oracle.com>,
	Allison Henderson <allison.henderson@oracle.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 063/122] rds: ib: Increment i_fastreg_wrs before bailing out
Date: Tue, 30 Sep 2025 16:46:34 +0200
Message-ID: <20250930143825.582166813@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143822.939301999@linuxfoundation.org>
References: <20250930143822.939301999@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
 


