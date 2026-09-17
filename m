Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 545D659E355;
	Thu, 17 Sep 2026 15:26:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789658773; cv=none; b=DeapRt4uI0jrz680Szj0qpuB1YHHTydjvaurOT+wt/XF7PlqfEarLnSX7qhOVgKsz7ZXn3J1huHTxZqRISRX/JtTyQaKDLXNBg2V2nqpI89k+dYJuWXGrtvKhKF8ocLq1bdHIULUTsIXlmUf9xiBX4AYFXQuDuDiPbFEbvmm4tE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789658773; c=relaxed/simple;
	bh=/zHM8icV2apeGp7SKngWN8QsQKwp85F7GmS+XyoJ26Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TCWSzI3W/1cBJ5PYrRB+K3NdsMOH7aA+g6kVi5yFvn/wZI7ND17DRNPusyRkSDfE7+yBf3TBJoKZwdu8m3YO6A0iTT/1J58Yj4mU6U9+4cYf0PRi19o1SHKf2dM+9rYae1Jdf9YVQMAQ1PzCDeKAibD7D6emveDZbzX0MOoFN6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0SnLZVaO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0SnLZVaO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A63331F000FF;
	Thu, 17 Sep 2026 15:26:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789658761;
	bh=zfqMhaxqtsq3s0eIhk40/2jkl5nwyvc1SCDLjNcejnc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0SnLZVaOiCVHTPRk5i8utPg+3gMvL33MJNFS9mGDQ7YuK4Qj4r9IT3nKMAfeufc+K
	 K1938lty55wSiPhJmmWXTWnykVvGGuY8tKPpleTU31s1hVRDUtxj65HQvDgcZtrmGx
	 /x1W3Isa73NNbj2ZrETMObkcSzYl8JsTHwp7Rh/8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Taimuraz Kaitmazov <taimuraz@kaitmazov.com>,
	Lizhi Hou <lizhi.hou@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 030/733] accel/amdxdna: reject a command chain that carries no commands
Date: Thu, 17 Sep 2026 16:05:38 +0100
Message-ID: <20260917151351.477907182@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

From: Taimuraz Kaitmazov <taimuraz@kaitmazov.com>

[ Upstream commit ef6d27af71e1dc43181ec797a6aaa77c27c36786 ]

A chain whose command_count is zero passes the payload length check,
because struct_size(payload, data, 0) is just the header. The fill loop
then does not run, so offset stays zero and the request is submitted with
a zero-length buffer.

On firmware without AIE2_NPU_COMMAND that ends at the opcode check, since
op is still ERT_INVALID_CMD and aie2_get_chain_msg_op() answers
MSG_OP_MAX_OPCODE. aie2_get_npu_chain_msg_op() answers
MSG_OP_CHAIN_EXEC_NPU whatever it is given, so there the submission
continues to drm_clflush_virt_range(cmd_buf, 0), which reads the byte
before the buffer and faults on the vmap guard page. EXEC_CMD is
reachable by any process that can open the render node.

Reject the request instead.

Fixes: 8ed8b0239617 ("accel/amdxdna: Add debug prints for command submission")
Signed-off-by: Taimuraz Kaitmazov <taimuraz@kaitmazov.com>
Reviewed-by: Lizhi Hou <lizhi.hou@amd.com>
Signed-off-by: Lizhi Hou <lizhi.hou@amd.com>
Link: https://patch.msgid.link/20260818000019.369366-1-taimuraz@kaitmazov.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/accel/amdxdna/aie2_message.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/accel/amdxdna/aie2_message.c b/drivers/accel/amdxdna/aie2_message.c
index dfe0fbdf066d2..b4c49259a1a23 100644
--- a/drivers/accel/amdxdna/aie2_message.c
+++ b/drivers/accel/amdxdna/aie2_message.c
@@ -994,7 +994,7 @@ int aie2_cmdlist_multi_execbuf(struct amdxdna_hwctx *hwctx,
 	}
 
 	ccnt = payload->command_count;
-	if (payload_len < struct_size(payload, data, ccnt)) {
+	if (!ccnt || payload_len < struct_size(payload, data, ccnt)) {
 		XDNA_DBG(xdna, "Invalid command count %d", ccnt);
 		return -EINVAL;
 	}
-- 
2.53.0



