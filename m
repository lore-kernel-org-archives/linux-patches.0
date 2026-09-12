Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2300C4D5A1;
	Sat, 12 Sep 2026 07:36:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789198610; cv=none; b=HYtMZ8nt7SOplBf/Jiyci6CAxBKMxpC/WRKiwo8/LRKXvOyNDQ3e3KQC+aTOi4MJKttse7aqblE2exXHgk+jB+fNk3Vdrn28E7QJ/3Sv8oZdbmc4j4tsYOxzo19Z2rQIgMmcK9BM3/MFlZMwKGp6iO7FyoZeWjBiu+oXX2D6jl4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789198610; c=relaxed/simple;
	bh=+E0qjgaJG7OpLbfQOxm9/pT6CSD0surI98mhtBewB5s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ecrZjDYjpB1u2KUljZr9XMK8QqeTC8o71BIdRed78+c85X/0amny00U3VsKHQZ0jsqLJt7pPsoEdC+qxivjQZtirFdcewC5EhKKh9Zk/e18eqWIB7MShC0iszlWGdLQlLSuZk3dz3nvQ/wtGEUEErePIX4tASkfS+lLtgoiKy20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hTpCd9fV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hTpCd9fV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E2061F000FF;
	Sat, 12 Sep 2026 07:36:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789198609;
	bh=tDKlxX5r1qcGVpiud35iEKjS/jzEBe48kFpXNTKkDWk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hTpCd9fVdIT4syWkeKSIHnM43GsoMFfpI2H5GTxnL9rEuMQ+G+foUbapH9wtC7Pv+
	 vcAwREdFhaxsd/cesP6hJfY/WZ/Dy2dMRXaXHgrPoT2b5CfIt/BTqOj2N0GKPlKVbH
	 YkiHRUkWIsBFIvfLj62KDoGG+JYk/0ItcsIkjFPU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kai-Heng Feng <kaihengf@nvidia.com>,
	Koba Ko <kobak@nvidia.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Richard Cheng <icheng@nvidia.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0409/1815] cxl/features: Reject Get Feature count larger than the output buffer
Date: Sat, 12 Sep 2026 08:35:59 +0200
Message-ID: <20260912065658.495244402@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Richard Cheng <icheng@nvidia.com>

[ Upstream commit 4bf6bac375076ced2fa4b3fef8739bd985f93456 ]

cxlctl_get_feature() sizes its output buffer from the user's
fwctl_rpc.out_len, but the device is told to write
cxl_mbox_get_feat_in.count bytes into rpc_out->payload, which is a
separate user-controlled value. Nothing bounds count against out_len, so
a small out_len with a large count overflows the kvzalloc()'d buffer.
A heap OOB write reachable from FWCTL_RPC.

Reject requests where count exceeds the available payload room, before
allocating.

Fixes: 5908f3ed6dc2 ("cxl: Add support to handle user feature commands for get feature")
Reviewed-by: Kai-Heng Feng <kaihengf@nvidia.com>
Reviewed-by: Koba Ko <kobak@nvidia.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Richard Cheng <icheng@nvidia.com>
Reviewed-by: Alison Schofield <alison.schofield@intel.com>
Link: https://patch.msgid.link/20260626104102.53892-2-icheng@nvidia.com
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cxl/core/features.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/cxl/core/features.c b/drivers/cxl/core/features.c
index 8731b95dd0b5e..d50e6b58d8fdb 100644
--- a/drivers/cxl/core/features.c
+++ b/drivers/cxl/core/features.c
@@ -474,6 +474,10 @@ static void *cxlctl_get_feature(struct cxl_features_state *cxlfs,
 	if (!count)
 		return ERR_PTR(-EINVAL);
 
+	if (out_size < offsetof(struct fwctl_rpc_cxl_out, payload) ||
+	    count > out_size - offsetof(struct fwctl_rpc_cxl_out, payload))
+		return ERR_PTR(-EINVAL);
+
 	struct fwctl_rpc_cxl_out *rpc_out __free(kvfree) =
 		kvzalloc(out_size, GFP_KERNEL);
 	if (!rpc_out)
-- 
2.53.0



