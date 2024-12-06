Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7599353A7;
	Fri,  6 Dec 2024 15:03:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733497422; cv=none; b=W2acA5j8VlH9M+4CPKsHmsrlbAhs1UlfTCR/NnSKc3YCyd3NbWMcWh8JpJrLW+y4gsPwn5W6F4Nn8S4AbebxT49Ri95mWkWrtZfNYlBJRH3iV6JdiLJPfu8jTQWflh+KlguHGt/YxLasJrYpd06x04Jeptp2e+wry3qwQBv9V0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733497422; c=relaxed/simple;
	bh=vkdVqJONkcs8GcsK80E+ZEe7FX88bBaWIMPC52wo2Fs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YnVUpNF/Ak+5Vf2HaAxQjZC3hsTjRCkCmmyKUokHfkeEkVG25X51KT1aM/FgMM/Mf3DYc5yYfdXPXqlVX0WL8q/PM83kx7GViyc6Q/5c5qWygqETcb+NFMGz6JdQWakN/fJkMoG/13m10mBJ1UV5znl9ITQRflyomFqP5T/N9Zw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YEOEiPns; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YEOEiPns"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB2A5C4CED1;
	Fri,  6 Dec 2024 15:03:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733497422;
	bh=vkdVqJONkcs8GcsK80E+ZEe7FX88bBaWIMPC52wo2Fs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YEOEiPnsn9ltiUhzJBG0JTWk9RR7Hj2ptTdkQnoKm0nehO6UU6FMHY5Wdx7uxA+MF
	 Y3+/hXUyy9GL3JpcH1D1gSdVbjDTpHuFS6l9zygPgUIshX1914r+hQ4H7W83Y/lkvY
	 60o+Q8Jwh8zgePOisXpAp2gOtWn0pdAA2ARnAwyI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liu Jian <liujian56@huawei.com>,
	Zhu Yanjun <yanjun.zhu@linux.dev>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 288/676] RDMA/rxe: Set queue pair cur_qp_state when being queried
Date: Fri,  6 Dec 2024 15:31:47 +0100
Message-ID: <20241206143704.589986997@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Liu Jian <liujian56@huawei.com>

[ Upstream commit 775e6d3c8fda41083b16c26d05163fd69f029a62 ]

Same with commit e375b9c92985 ("RDMA/cxgb4: Set queue pair state when
 being queried"). The API for ib_query_qp requires the driver to set
cur_qp_state on return, add the missing set.

Fixes: 8700e3e7c485 ("Soft RoCE driver")
Signed-off-by: Liu Jian <liujian56@huawei.com>
Link: https://patch.msgid.link/20241031092019.2138467-1-liujian56@huawei.com
Reviewed-by: Zhu Yanjun <yanjun.zhu@linux.dev>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/rxe/rxe_qp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/infiniband/sw/rxe/rxe_qp.c b/drivers/infiniband/sw/rxe/rxe_qp.c
index 28e379c108bce..3767d7fc0aac8 100644
--- a/drivers/infiniband/sw/rxe/rxe_qp.c
+++ b/drivers/infiniband/sw/rxe/rxe_qp.c
@@ -781,6 +781,7 @@ int rxe_qp_to_attr(struct rxe_qp *qp, struct ib_qp_attr *attr, int mask)
 	 * Yield the processor
 	 */
 	spin_lock_irqsave(&qp->state_lock, flags);
+	attr->cur_qp_state = qp_state(qp);
 	if (qp->attr.sq_draining) {
 		spin_unlock_irqrestore(&qp->state_lock, flags);
 		cond_resched();
-- 
2.43.0



