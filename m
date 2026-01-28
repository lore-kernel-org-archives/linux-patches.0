Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E23D530EF7B;
	Wed, 28 Jan 2026 15:51:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769615487; cv=none; b=tQ4PPcnxs6/PSUvSdOzUzs2L1p7uC9315G2ZCTofgGqonLa36yp3oIF3q2YQWBBEAX/KhH2Cani7+6pkDH9lNXcBOlal5d5psnNpuu7cdK5IuJDKAQRtGZTJhZByUfP+7+YJo5ohSx4LEVexhCUIQG989YaZtbIG1eRGnxELpaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769615487; c=relaxed/simple;
	bh=oCJR6/+6kLBvOP+Lc0Pqf2zHO9wQ/5EyuvPYxaEhxRo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kvuYGKQsUKf9ack4oNh2IzuJBmzDTiiMM13KyWXUFPf0+KkT6U6rJnoHMBR3kA0JlUoby75/gFCyjnkaCbMYfdnFOoZAzYrysOJiC5rNoOtWUptzFSQpPo0EieQUpNQn8Mqhy33JeOWUZFtJ+jkb0B6AwtmTAyFdT4tzJDDyOVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qmRaVyT4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qmRaVyT4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 722CBC2BC9E;
	Wed, 28 Jan 2026 15:51:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769615486;
	bh=oCJR6/+6kLBvOP+Lc0Pqf2zHO9wQ/5EyuvPYxaEhxRo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qmRaVyT4QnnRjXOTqtOHStBqeWb9sS00faTx4umFkf8BrgNTAK8ZVGz6+sTiYO0qx
	 6QngeGSRWNHxfKR2KnKmNDd6UzCJQTXGOr+31rDQX1cWe3kqeNzzHlnQgyOBKv27yc
	 fFSvvMBxCcACZwlDL+VR2bZTmIDDojX/hNvA9TYc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ding Hui <dinghui@sangfor.com.cn>,
	Simon Horman <horms@kernel.org>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Rinitha S <sx.rinitha@intel.com>
Subject: [PATCH 6.18 023/227] ice: Fix incorrect timeout ice_release_res()
Date: Wed, 28 Jan 2026 16:21:08 +0100
Message-ID: <20260128145345.179311346@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.331957407@linuxfoundation.org>
References: <20260128145344.331957407@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ding Hui <dinghui@sangfor.com.cn>

[ Upstream commit 01139a2ce532d77379e1593230127caa261a8036 ]

The commit 5f6df173f92e ("ice: implement and use rd32_poll_timeout for
ice_sq_done timeout") converted ICE_CTL_Q_SQ_CMD_TIMEOUT from jiffies
to microseconds.

But the ice_release_res() function was missed, and its logic still
treats ICE_CTL_Q_SQ_CMD_TIMEOUT as a jiffies value.

So correct the issue by usecs_to_jiffies().

Found by inspection of the DDP downloading process.
Compile and modprobe tested only.

Fixes: 5f6df173f92e ("ice: implement and use rd32_poll_timeout for ice_sq_done timeout")
Signed-off-by: Ding Hui <dinghui@sangfor.com.cn>
Reviewed-by: Simon Horman <horms@kernel.org>
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>
Tested-by: Rinitha S <sx.rinitha@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_common.c b/drivers/net/ethernet/intel/ice/ice_common.c
index 6edeb06b4dce2..eb148c8d9e083 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.c
+++ b/drivers/net/ethernet/intel/ice/ice_common.c
@@ -2251,7 +2251,7 @@ void ice_release_res(struct ice_hw *hw, enum ice_aq_res_ids res)
 	/* there are some rare cases when trying to release the resource
 	 * results in an admin queue timeout, so handle them correctly
 	 */
-	timeout = jiffies + 10 * ICE_CTL_Q_SQ_CMD_TIMEOUT;
+	timeout = jiffies + 10 * usecs_to_jiffies(ICE_CTL_Q_SQ_CMD_TIMEOUT);
 	do {
 		status = ice_aq_release_res(hw, res, 0, NULL);
 		if (status != -EIO)
-- 
2.51.0



