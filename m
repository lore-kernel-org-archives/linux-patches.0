Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79AB62DC78C;
	Tue, 11 Nov 2025 01:14:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823685; cv=none; b=Ou0SYtdOrGJzY0NV+JzJc512BmM6q+oOhakV/eFKS7DNqeEaoqjcYRql/Am9f4nIrQd4HlgufRRfMoYu7DVin7VBVqvrz0eZC6VUNKxDzMBjOFkuTvMvokE+I62xbvctuKWiBuOxL1DuH7VKSakv+jn6P+WzmNhOfuVmHNupMHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823685; c=relaxed/simple;
	bh=A+mLEOrpyDcpOQwPooW8/ogx3fjFipcfRp2qHJarwQM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DC1HzweAUrPYmrKowsskOQvsPZZM5g/Cbu16ms5AmAM+EtRjd0F8vokLb4J9mdddaFuHeZiIycbq8Gnp9ocKKtxiHmHo9x2jiVuf0NpBiyrgVhmRhfGyZPNspKNydBpUivry9FRRVl+dTCaEtNHzwyIKRhQ8RCQ1QlbJD5fxBcU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vU4yYShY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vU4yYShY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08D7FC113D0;
	Tue, 11 Nov 2025 01:14:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823685;
	bh=A+mLEOrpyDcpOQwPooW8/ogx3fjFipcfRp2qHJarwQM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vU4yYShYvndbKA4mUkxf20TclVFbHCZ3rm0MZ2K4mSCxscrHPhDefvozuobpDyfvo
	 S+hrjlOCxDp2N0rgZqDcfbuGibPKKOOQk5AG1BQue1IlGMyzcKDNPwrSeL9yBidnqH
	 WLvtdTVd6mzXUFqKq39KsplzyXkEHkFNOvR/R+5w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Wajdeczko <michal.wajdeczko@intel.com>,
	John Harrison <John.C.Harrison@Intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Stuart Summers <stuart.summers@intel.com>,
	Julia Filipchuk <julia.filipchuk@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 300/565] drm/xe/guc: Set upper limit of H2G retries over CTB
Date: Tue, 11 Nov 2025 09:42:36 +0900
Message-ID: <20251111004533.627665443@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

From: Michal Wajdeczko <michal.wajdeczko@intel.com>

[ Upstream commit 2506af5f8109a387a5e8e9e3d7c498480b8033db ]

The GuC communication protocol allows GuC to send NO_RESPONSE_RETRY
reply message to indicate that due to some interim condition it can
not handle incoming H2G request and the host shall resend it.

But in some cases, due to errors, this unsatisfied condition might
be final and this could lead to endless retries as it was recently
seen on the CI:

 [drm] GT0: PF: VF1 FLR didn't finish in 5000 ms (-ETIMEDOUT)
 [drm] GT0: PF: VF1 resource sanitizing failed (-ETIMEDOUT)
 [drm] GT0: PF: VF1 FLR failed!
 [drm:guc_ct_send_recv [xe]] GT0: H2G action 0x5503 retrying: reason 0x0
 [drm:guc_ct_send_recv [xe]] GT0: H2G action 0x5503 retrying: reason 0x0
 [drm:guc_ct_send_recv [xe]] GT0: H2G action 0x5503 retrying: reason 0x0
 [drm:guc_ct_send_recv [xe]] GT0: H2G action 0x5503 retrying: reason 0x0

To avoid such dangerous loops allow only limited number of retries
(for now 50) and add some delays (n * 5ms) to slow down the rate of
resending this repeated request.

Signed-off-by: Michal Wajdeczko <michal.wajdeczko@intel.com>
Cc: John Harrison <John.C.Harrison@Intel.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Reviewed-by: Stuart Summers <stuart.summers@intel.com>
Reviewed-by: Julia Filipchuk <julia.filipchuk@intel.com>
Link: https://lore.kernel.org/r/20250903223330.6408-1-michal.wajdeczko@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_guc_ct.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/gpu/drm/xe/xe_guc_ct.c b/drivers/gpu/drm/xe/xe_guc_ct.c
index f1ce4e14dcb5f..d692e279d9fbf 100644
--- a/drivers/gpu/drm/xe/xe_guc_ct.c
+++ b/drivers/gpu/drm/xe/xe_guc_ct.c
@@ -977,11 +977,15 @@ static bool retry_failure(struct xe_guc_ct *ct, int ret)
 	return true;
 }
 
+#define GUC_SEND_RETRY_LIMIT	50
+#define GUC_SEND_RETRY_MSLEEP	5
+
 static int guc_ct_send_recv(struct xe_guc_ct *ct, const u32 *action, u32 len,
 			    u32 *response_buffer, bool no_fail)
 {
 	struct xe_gt *gt = ct_to_gt(ct);
 	struct g2h_fence g2h_fence;
+	unsigned int retries = 0;
 	int ret = 0;
 
 	/*
@@ -1065,6 +1069,12 @@ static int guc_ct_send_recv(struct xe_guc_ct *ct, const u32 *action, u32 len,
 		xe_gt_dbg(gt, "H2G action %#x retrying: reason %#x\n",
 			  action[0], g2h_fence.reason);
 		mutex_unlock(&ct->lock);
+		if (++retries > GUC_SEND_RETRY_LIMIT) {
+			xe_gt_err(gt, "H2G action %#x reached retry limit=%u, aborting\n",
+				  action[0], GUC_SEND_RETRY_LIMIT);
+			return -ELOOP;
+		}
+		msleep(GUC_SEND_RETRY_MSLEEP * retries);
 		goto retry;
 	}
 	if (g2h_fence.fail) {
-- 
2.51.0



