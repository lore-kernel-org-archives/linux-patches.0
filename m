Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66CB2414DF6;
	Fri,  4 Sep 2026 05:49:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788500967; cv=none; b=Ja0oh9SJaCVpozoalAoPbzPvqWHGtViz+ulq9LIXPm0dvyXDUi45ezhAzw6Cy1nxv8D+/IfBOavVeGITt+/Lk96dzL1yvTL2NJ4EVMR+sM+Fx9PeuZtSNe5wKcur0l9YnE+r07Ak5KnnGljj+b3hc2BNTdpfLXxm3qXoudRRwdM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788500967; c=relaxed/simple;
	bh=MJL0uVXohwxPK1tiEMbTfwKen73tKZBuAlbd0l2lL4o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BGV1+VNHrCDKYuk8vX1OL+O8H0CxXq0IgUvdBxPE+ZYpTDzq/l9JUpg41v39A7RW1jyZkNzAtDlxzOaX8YGX6GVFud7UzDTbWur2IbTi/9BBkvuyNzJko9jbcJTrQb2ycHEXdd8GRKDQOVWrmJp97/oXB7faCDbH54ae9yP4MY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SXO8X6W+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SXO8X6W+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B77871F00A3D;
	Fri,  4 Sep 2026 05:49:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788500966;
	bh=SBuT+OPhAWZTX99baOw59RVJse/LOn5ZosNZmpUexGA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SXO8X6W+LOeVz/+AHISTuVgNICn8jGUzNk/2/LNCC7nexslFyBWpnoshehaAmbwLT
	 HEPZBR3y2A6FwINsVKgbcNBYegrxjnpLrsDnIIIVn0CX0iWjU6fB2D7rWn7l33+5fJ
	 SzpYkN44JrpZN5+tT5sRnBvnMbCKKX18nQY+hNoI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuhao Jiang <danisjiang@gmail.com>,
	Zhenhao Wan <whi4ed0g@gmail.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Dave Jiang <dave.jiang@intel.com>
Subject: [PATCH 6.18 242/552] cxl/features: bound fwctl command payload to the input buffer
Date: Fri,  4 Sep 2026 06:56:39 +0200
Message-ID: <20260904045754.964945606@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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

From: Zhenhao Wan <whi4ed0g@gmail.com>

commit f687394af983df5660b6afae7e0d06969f3af206 upstream.

fwctl_cmd_rpc() copies cmd->in_len bytes into inbuf = kvzalloc(cmd->in_len)
and passes inbuf and in_len to ->fw_rpc(). The CXL callback cxlctl_fw_rpc()
ignores in_len and never checks the user-controlled op_size against it.

cxlctl_set_feature() bounds op_size only from below
(op_size <= sizeof(feat_in->hdr)) and then reads op_size - sizeof(hdr)
bytes from feat_in->feat_data via cxl_set_feature(). With a small in_len
and a large op_size the first memcpy() already reads past the
kvzalloc(in_len) buffer; the out-of-bounds bytes are placed in the mailbox
payload and sent to the device, and a large enough op_size can walk into
unmapped memory and oops the kernel. The Get paths pin op_size to a fixed
size but likewise read the input struct without checking in_len.

Reject, at the single dispatch point, any request whose fixed header plus
op_size does not fit in the copied-in buffer. The lower-bound test guards
the subtraction and ensures op_size was copied in before it is read.

Fixes: eb5dfcb9e36d ("cxl: Add support to handle user feature commands for set feature")
Reported-by: Yuhao Jiang <danisjiang@gmail.com>
Signed-off-by: Zhenhao Wan <whi4ed0g@gmail.com>
Cc: stable@vger.kernel.org
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Link: https://patch.msgid.link/20260620-cxl-fwctl-oob-v1-1-5758e34d784a@gmail.com
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/cxl/core/features.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/cxl/core/features.c b/drivers/cxl/core/features.c
index 85185af46b72..738a89863ee8 100644
--- a/drivers/cxl/core/features.c
+++ b/drivers/cxl/core/features.c
@@ -649,7 +649,13 @@ static void *cxlctl_fw_rpc(struct fwctl_uctx *uctx, enum fwctl_rpc_scope scope,
 	struct cxl_memdev *cxlmd = fwctl_to_memdev(fwctl_dev);
 	struct cxl_features_state *cxlfs = to_cxlfs(cxlmd->cxlds);
 	const struct fwctl_rpc_cxl *rpc_in = in;
-	u16 opcode = rpc_in->opcode;
+	u16 opcode;
+
+	if (in_len < sizeof(rpc_in->hdr) ||
+	    rpc_in->op_size > in_len - sizeof(rpc_in->hdr))
+		return ERR_PTR(-EINVAL);
+
+	opcode = rpc_in->opcode;
 
 	if (!cxlctl_validate_hw_command(cxlfs, rpc_in, scope, opcode))
 		return ERR_PTR(-EINVAL);
-- 
2.55.0



