Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 603203DAAC8;
	Fri,  4 Sep 2026 05:19:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788499201; cv=none; b=TFjkc8tCi9PxR4yXQGYT7rczCH3kPtnhjRZYFe9vaaXUSXTry5UbsWDB5gIRXNGq8RR2CQVVB4ikSMPABBzCHcBGRelDY1Vebnlpl2MWkQMHamWHkVN6b4loBcgZafS4Ai5JU6BPKUgSzPOYrJ4XhMQ7k/thcnCV3/NOcJpBNKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788499201; c=relaxed/simple;
	bh=2jUYav/4yVwym5x7OgSzX6DTu92h/JP0FdPuJB33bng=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U2YPcqztqDYoTZm8JyqBNffR7VP9ccJBOYLBcw8QjnykkbirC3x5w/Qj2LAgv+MsKNdR6iQRgZx56DiY62DPTRCHDLM/qXdYaKKT83NFtjF/Nqcm1mWLE9oorBi89+vEeclQsMvOP+Hcyr6LmW9sCkQQ4hNqVfbAnTw/5Yj/PxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MLX07sr/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MLX07sr/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3391B1F00A3D;
	Fri,  4 Sep 2026 05:19:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788499199;
	bh=IP3Tpj1tea31dg8kCNUYuxDbEHs4guf5AKTxWHCgKOY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MLX07sr/+0z7mZaA+HHjFuB2kqA2roZLc10HAya6Z2oAPZM7OhZAk9lt8hvSxwO9b
	 WYwP2DAEeaG1D/mO/QzctUDjrbw5Rx5pkt/jrrpb3vR/ClF7Q9xo8PQjF40uhMa9+K
	 ng5H0IJGOGYZtnKCWdKZSMUhW4rKo6rR2wJpgYJ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuhao Jiang <danisjiang@gmail.com>,
	Zhenhao Wan <whi4ed0g@gmail.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Dave Jiang <dave.jiang@intel.com>
Subject: [PATCH 7.2 333/713] cxl/features: bound fwctl command payload to the input buffer
Date: Fri,  4 Sep 2026 06:55:01 +0200
Message-ID: <20260904045811.295293868@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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
 drivers/cxl/core/features.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/cxl/core/features.c
+++ b/drivers/cxl/core/features.c
@@ -649,7 +649,13 @@ static void *cxlctl_fw_rpc(struct fwctl_
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


