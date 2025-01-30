Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A59051E47B4;
	Thu, 30 Jan 2025 14:02:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738245766; cv=none; b=mOyxsgUGJlUGxu4NFKGw3/N2bzv65YwLb1VnAOX5Q3NYF23LX1y9+js5e8h9xPvKyyLXnmepi5D4wOrMvTYgzQYoLKP/ldyzdmAPiNIkDgtBHKBJYHqD/IKfm9Bs15SJxz8EBIdrpqeuCWl/tRU181/IY3Qa80Vqg+WX18ewRiw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738245766; c=relaxed/simple;
	bh=IP0ruFvqMl7BuVbld4MZ3F/YzBp2XziHT/trF6XKCu0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=El63Vuz/NrPHUVZYjlXteryqQG6i37wawF8GRtKfPiH03mPZgz2pPe3A/wZLrB4ITjB8LdAYDoDw/IhhSfwcetUzrGMylpzXtSDwTdNOPVu5x04TwG5xlQWRQ7tK3eR6E46ZqPcP7rVJvGMoq9UWzBWuKVUygaYWGqW+BW3ffSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RNhsWD+n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RNhsWD+n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D680C4CED2;
	Thu, 30 Jan 2025 14:02:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738245766;
	bh=IP0ruFvqMl7BuVbld4MZ3F/YzBp2XziHT/trF6XKCu0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RNhsWD+ntH91S1O2q/Kq3R37vp+IuHCMJX+s4S0rHiyP8GFSJCQ2NAuBef4kvyMc6
	 D7rY7sGQLKgKohCWsyBrU4TdPI8gwYocJ0wXQR4QEmsG2UpYMbWKVmysXhOTWzHSXy
	 vJ3zFSsmy2xdqijuJwLnn50EoKnNa3HMkOUAKzgs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Chandramohan Akula <chandramohan.akula@broadcom.com>,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Alva Lan <alvalan9@foxmail.com>
Subject: [PATCH 6.6 13/43] RDMA/bnxt_re: Avoid CPU lockups due fifo occupancy check loop
Date: Thu, 30 Jan 2025 14:59:20 +0100
Message-ID: <20250130133459.436063588@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130133458.903274626@linuxfoundation.org>
References: <20250130133458.903274626@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Selvin Xavier <selvin.xavier@broadcom.com>

commit 8be3e5b0c96beeefe9d5486b96575d104d3e7d17 upstream.

Driver waits indefinitely for the fifo occupancy to go below a threshold
as soon as the pacing interrupt is received. This can cause soft lockup on
one of the processors, if the rate of DB is very high.

Add a loop count for FPGA and exit the __wait_for_fifo_occupancy_below_th
if the loop is taking more time. Pacing will be continuing until the
occupancy is below the threshold. This is ensured by the checks in
bnxt_re_pacing_timer_exp and further scheduling the work for pacing based
on the fifo occupancy.

Fixes: 2ad4e6303a6d ("RDMA/bnxt_re: Implement doorbell pacing algorithm")
Link: https://patch.msgid.link/r/1728373302-19530-7-git-send-email-selvin.xavier@broadcom.com
Reviewed-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
Reviewed-by: Chandramohan Akula <chandramohan.akula@broadcom.com>
Signed-off-by: Selvin Xavier <selvin.xavier@broadcom.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
[ Add the declaration of variable pacing_data to make it work on 6.6.y ]
Signed-off-by: Alva Lan <alvalan9@foxmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/infiniband/hw/bnxt_re/main.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/drivers/infiniband/hw/bnxt_re/main.c
+++ b/drivers/infiniband/hw/bnxt_re/main.c
@@ -485,6 +485,8 @@ static void bnxt_re_set_default_pacing_d
 static void __wait_for_fifo_occupancy_below_th(struct bnxt_re_dev *rdev)
 {
 	u32 read_val, fifo_occup;
+	struct bnxt_qplib_db_pacing_data *pacing_data = rdev->qplib_res.pacing_data;
+	u32 retry_fifo_check = 1000;
 
 	/* loop shouldn't run infintely as the occupancy usually goes
 	 * below pacing algo threshold as soon as pacing kicks in.
@@ -500,6 +502,14 @@ static void __wait_for_fifo_occupancy_be
 
 		if (fifo_occup < rdev->qplib_res.pacing_data->pacing_th)
 			break;
+		if (!retry_fifo_check--) {
+			dev_info_once(rdev_to_dev(rdev),
+				      "%s: fifo_occup = 0x%xfifo_max_depth = 0x%x pacing_th = 0x%x\n",
+				      __func__, fifo_occup, pacing_data->fifo_max_depth,
+					pacing_data->pacing_th);
+			break;
+		}
+
 	}
 }
 


