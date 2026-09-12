Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0A4136B924;
	Sat, 12 Sep 2026 10:02:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789207328; cv=none; b=DQQvtkYNXh73Nx0qs5h6ahGlaGCahxTo03mpgvsqkjs7o4QJA6iJ0U2Fmc492n/uOXnVTjkfpbcV73pZO43HbsqyWs18QMxznbcwWA9kSkN6RpgOu9EZvTaA4U1JSvFXAnW1LACpJiTE40/6BECIJvEw46Y1VYwTU/M0FXJlCHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789207328; c=relaxed/simple;
	bh=ZoynbUaHS9g2a9xR4R09Olh5Vx6+z8MtkOU756YWlps=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jJQgy0Hu7URTeovoDw3dRo5Ey9XWTvkltc+7R8YsdlK4K1kGTXsjAKIKCpcaDUY+yFRsDrXEJJ4iy0sJAwPzcurr+fycHch9UnZFuWQhDY/TciHSu1RRpbRgNj0ZCXCbjg+j2piR4SgARAvQbcSVtJfCyu0cclQ2Xym4e4jHcKg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vHqs7gAB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vHqs7gAB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 072E41F000FF;
	Sat, 12 Sep 2026 10:02:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789207326;
	bh=RjfNIykSxPcAGREDj0DwGxefbVh8rrPW/qtF2WmkLD8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vHqs7gABp5oETP0C2lLP8pT8k88clklppD6Ay/40ZAQ2hPAO/OG/eOTw0CwyKHtKe
	 FN2JYAXVKjRmESMSdqo02fEsckcLEpBITJUsze3LCJAFqQPNR8tcU/5zTdD5HBM5gg
	 0Gi4fEAX2Y/aQBovbi4QsKM5oxASk0wJt3szF9dI=
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
Subject: [PATCH 6.18 0390/1518] cxl/features: Reject Get Feature count larger than the output buffer
Date: Sat, 12 Sep 2026 08:42:39 +0200
Message-ID: <20260912065632.281181242@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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
index 7b0eeb0788d32..32bded289ebc7 100644
--- a/drivers/cxl/core/features.c
+++ b/drivers/cxl/core/features.c
@@ -471,6 +471,10 @@ static void *cxlctl_get_feature(struct cxl_features_state *cxlfs,
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



