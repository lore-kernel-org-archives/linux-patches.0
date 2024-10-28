Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CBC818DF88;
	Mon, 28 Oct 2024 06:33:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097199; cv=none; b=mjN9E4t/HbbwhsZFhEZxVyyq2OC2qw0FLO5EtrK49b5gUBWecpqa0lqZqXSXFEARYIROqKG2+rQrcgc/iiiUdmiXCHr6xV2NzkTUTMQ8zWbs7PdBWBbhSIdhD3IT9bLtX0hQtWf5yGZIsm5I1WzdZK+hNSUUAl4mIczCssfEcuk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097199; c=relaxed/simple;
	bh=jiPzlCCrxkyM7+CgJfEWdFAViLnJ/hVGFD9NgXUnpmQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oGTJ2KEOJysgeZw0KY7Jf7FXV+FNS/DJ/zI2FVunXlRjHuYL9tmt5VEownzUwGg0t3VblSaN7xc2E5MEzHOwImqlkdtScElJ1bm9+GJUNMtDvJNaaumZr9k77x0vAy5Nwd0kQ4E3w8ffyACKBBrnM8fexjWvwfelOM0pRzIq6xI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v4gmrw84; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v4gmrw84"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8467C4CEC7;
	Mon, 28 Oct 2024 06:33:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097199;
	bh=jiPzlCCrxkyM7+CgJfEWdFAViLnJ/hVGFD9NgXUnpmQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v4gmrw84XsCDXyPZZpqOfBWzV/UYETa7sHKiMpdojgh8F6+FuOtycMAWG067K7t9d
	 JHxiZCo3UOGgkKLRoIokEoWPj63C+T/l0svMDQBsskcvIjIPzX27rHos76qpLwbgjT
	 3J2tfgeb69s+EqMLnC/QuCxj/XVDNGeoDeaGFMFk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Chandramohan Akula <chandramohan.akula@broadcom.com>,
	Saravanan Vajravel <saravanan.vajravel@broadcom.com>,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 006/137] RDMA/bnxt_re: Fix incorrect AVID type in WQE structure
Date: Mon, 28 Oct 2024 07:24:03 +0100
Message-ID: <20241028062258.884479024@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062258.708872330@linuxfoundation.org>
References: <20241028062258.708872330@linuxfoundation.org>
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

From: Saravanan Vajravel <saravanan.vajravel@broadcom.com>

[ Upstream commit 9ab20f76ae9fad55ebaf36bdff04aea1c2552374 ]

Driver uses internal data structure to construct WQE frame.
It used avid type as u16 which can accommodate up to 64K AVs.
When outstanding AVID crosses 64K, driver truncates AVID and
hence it uses incorrect AVID to WR. This leads to WR failure
due to invalid AV ID and QP is moved to error state with reason
set to 19 (INVALID AVID). When RDMA CM path is used, this issue
hits QP1 and it is moved to error state

Fixes: 1ac5a4047975 ("RDMA/bnxt_re: Add bnxt_re RoCE driver")
Link: https://patch.msgid.link/r/1726715161-18941-3-git-send-email-selvin.xavier@broadcom.com
Reviewed-by: Selvin Xavier <selvin.xavier@broadcom.com>
Reviewed-by: Chandramohan Akula <chandramohan.akula@broadcom.com>
Signed-off-by: Saravanan Vajravel <saravanan.vajravel@broadcom.com>
Signed-off-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
Signed-off-by: Selvin Xavier <selvin.xavier@broadcom.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/bnxt_re/qplib_fp.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/bnxt_re/qplib_fp.h b/drivers/infiniband/hw/bnxt_re/qplib_fp.h
index 4f1a845f9be6c..57a3dae87f659 100644
--- a/drivers/infiniband/hw/bnxt_re/qplib_fp.h
+++ b/drivers/infiniband/hw/bnxt_re/qplib_fp.h
@@ -169,7 +169,7 @@ struct bnxt_qplib_swqe {
 			};
 			u32		q_key;
 			u32		dst_qp;
-			u16		avid;
+			u32		avid;
 		} send;
 
 		/* Send Raw Ethernet and QP1 */
-- 
2.43.0



