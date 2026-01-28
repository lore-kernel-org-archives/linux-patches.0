Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52E3B2E542C;
	Wed, 28 Jan 2026 15:41:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769614901; cv=none; b=g2/QgrD8hSEhVPpIGxkvtCCxKAYaWA7bZMdj+Pka0K0bzi5s5bNOS7JQ3Qfh13dB538Prk8NJI5KrJpknXPJwy5SjVvDBnVpVWPHrG6xY6ss15r6gTpTUMWp5aN7G8gPlRMgUQoXhjilZpVC/gUGLGKU1u+FaSsiIM9O2mjdQmI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769614901; c=relaxed/simple;
	bh=ZzoQyi8Wud3DaFRjd5X1/gU532lV0Puvyt7zwZWIBmA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tfNzQw7u5MJqbFGMa1uZ15rF7vq1ik9aOJ6l+KdGXBI0xm9GOjFLX54/gb13VmgD4EQvjiSM2ikPNIY8tMDdFHKwhhXzrdmSAGKH4UWuRsVlk+Burx5SGLgNNSftThksdCVo6kvkvOKqbY/MuLPV/U1nY0WxeZE+yUKRHDhklNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LhfLCh9i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LhfLCh9i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B54E0C4CEF1;
	Wed, 28 Jan 2026 15:41:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769614901;
	bh=ZzoQyi8Wud3DaFRjd5X1/gU532lV0Puvyt7zwZWIBmA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LhfLCh9i8gvX7WZ9OKSVJY2GfDJfAWyIQzQcg+EzLl94D2UHRHz2FSpQG2z4QBGvX
	 ZKLfJBBg5HxRK5mkl4qjYdWtOhWobesO8SuIfXbCr0UkLHHmaFjeDsK1uPMVDoSb4z
	 aRf6wDRSnnIvxTl7TDV2z0NXzrzBSGsNVlTcXgHo=
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
Subject: [PATCH 6.12 021/169] ice: Fix incorrect timeout ice_release_res()
Date: Wed, 28 Jan 2026 16:21:44 +0100
Message-ID: <20260128145334.782823689@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145334.006287341@linuxfoundation.org>
References: <20260128145334.006287341@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 068a467de1d56..36b3912761870 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.c
+++ b/drivers/net/ethernet/intel/ice/ice_common.c
@@ -1951,7 +1951,7 @@ void ice_release_res(struct ice_hw *hw, enum ice_aq_res_ids res)
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



