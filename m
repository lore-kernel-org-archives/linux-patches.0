Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23FA913A25F;
	Tue,  9 Jul 2024 11:24:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720524296; cv=none; b=LsvyEsfCVaPrrO9WgVN8U1QnsXT+aNfQrntMTwxjVDA6zJii/TmT1W28fMHkwxthGPZW7WO7IuxGyHXRMmqpztZ4YRfah/2Tze7XFshf+rXwISL42N16GJKXCiFRb83hUuhz2JuL0+4Yb9pBMV+04+npE6ZPoTAAMh9cOcez+I8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720524296; c=relaxed/simple;
	bh=9MnC+4RJOvA76dyt0dJDobwQ0hzTQzX/8dDYTkjfVWo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oF86dsBDrcPtIxSsQm/Qec0peqRi5L4+wgUZmpk9ketSQ5vUd0zJGPfQshDWMJgY7CudGRtqyfunKlmG+O6jjPJv9oLJdOi4ZeNG5jvbsIvfDDuVxXaybyPhdUX4HfRnbdg67r0d7nvhTN52QE6nEy7lbFleD6V3FaOfIMiJ8JU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YytkdmU8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YytkdmU8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DF1FC3277B;
	Tue,  9 Jul 2024 11:24:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720524296;
	bh=9MnC+4RJOvA76dyt0dJDobwQ0hzTQzX/8dDYTkjfVWo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YytkdmU8rtVSYMwu4V6u0H3VTjkNvPpqhwO85erhMaGaHu/mNiui7QQYzXA85HTd7
	 UCCtKgRtX0Rby/bLflGrJMJiylNicCHnqZgJC6yFKviaUUaZAplAFfrIPEM51ui1yF
	 adn6HnLSbkvnCS1Pa/eHR9eJV5ycjLgwl5BqchMo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Andy Gospodarek <andrew.gospodarek@broadcom.com>,
	Pavan Chebbi <pavan.chebbi@broadcom.com>,
	Michael Chan <michael.chan@broadcom.com>,
	Simon Horman <horms@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 129/197] bnxt_en: Fix the resource check condition for RSS contexts
Date: Tue,  9 Jul 2024 13:09:43 +0200
Message-ID: <20240709110713.945360143@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110708.903245467@linuxfoundation.org>
References: <20240709110708.903245467@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pavan Chebbi <pavan.chebbi@broadcom.com>

[ Upstream commit 5d350dc3429b3eb6f2b1b8ccb78ed4ec6c4d4a4f ]

While creating a new RSS context, bnxt_rfs_capable() currently
makes a strict check to see if the required VNICs are already
available.  If the current VNICs are not what is required,
either too many or not enough, it will call the firmware to
reserve the exact number required.

There is a bug in the firmware when the driver tries to
relinquish some reserved VNICs and RSS contexts.  It will
cause the default VNIC to lose its RSS configuration and
cause receive packets to be placed incorrectly.

Workaround this problem by skipping the resource reduction.
The driver will not reduce the VNIC and RSS context reservations
when a context is deleted.  The resources will be available for
use when new contexts are created later.

Potentially, this workaround can cause us to run out of VNIC
and RSS contexts if there are a lot of VF functions creating
and deleting RSS contexts.  In the future, we will conditionally
disable this workaround when the firmware fix is available.

Fixes: 438ba39b25fe ("bnxt_en: Improve RSS context reservation infrastructure")
Reported-by: Jakub Kicinski <kuba@kernel.org>
Link: https://lore.kernel.org/netdev/20240625010210.2002310-1-kuba@kernel.org/
Reviewed-by: Andy Gospodarek <andrew.gospodarek@broadcom.com>
Signed-off-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20240703180112.78590-1-michael.chan@broadcom.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 0fab62a56f3b3..2b7936b3fb3ef 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -12436,7 +12436,11 @@ static bool bnxt_rfs_capable(struct bnxt *bp)
 	if (!BNXT_NEW_RM(bp))
 		return true;
 
-	if (hwr.vnic == bp->hw_resc.resv_vnics &&
+	/* Do not reduce VNIC and RSS ctx reservations.  There is a FW
+	 * issue that will mess up the default VNIC if we reduce the
+	 * reservations.
+	 */
+	if (hwr.vnic <= bp->hw_resc.resv_vnics &&
 	    hwr.rss_ctx <= bp->hw_resc.resv_rsscos_ctxs)
 		return true;
 
-- 
2.43.0



