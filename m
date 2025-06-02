Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 224F92C324D;
	Mon,  2 Jun 2025 14:27:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748874468; cv=none; b=rnIatPmT6toEoc1xSp3oqNgE6s8qiaqxrmmbQBFQpsIJQcBIn9LS0OaOQSAX0ySLlsgCvSsalqgBySq/Exq2gHzQd4SQnH5//31i6t97gsfyU+AcVluXQckkpstvaQVy2wkYyMk9UlxnrOxt+HOtGiqqTYPqNZhwxxblYTvkCps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748874468; c=relaxed/simple;
	bh=ugXuCbbbwH1+VU73Ag/YUHkUfIcfOJkH60yJBk29iyk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bWZJ7vjsRk0zXBVJZMlY2EYO/UnuSKdNWHWqh6R+0Yd2BwxsZtl0ONdeQaGm7pOaGNpCCC5qYiOs/YccfRSj8ylx98rjEazkWLtdJMhSMidwbBKM2rBEmmehqlZPd0imEKYV/6F1T2y2OErK/6yi8DOop4sH3dUM2RYYRtpbjQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ww6m0b4P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ww6m0b4P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A583EC4CEEE;
	Mon,  2 Jun 2025 14:27:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748874468;
	bh=ugXuCbbbwH1+VU73Ag/YUHkUfIcfOJkH60yJBk29iyk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ww6m0b4PId5J43wrOZwIoskHfuRiKUENTJm3610PPAQXFsCclGr3NZyenNJ8Nst+9
	 pQCPpR2G3qiZCbncIKgqmt6W68Y3CdyLyLDiQUWOGbymiHrvlJfMPOJEZqbtnD81k+
	 58X1pWohSl67Vdj05QE+VIXVXWpVhwHyEA+8qpVs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Mike Christie <michael.christie@oracle.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.4 033/204] scsi: target: Fix WRITE_SAME No Data Buffer crash
Date: Mon,  2 Jun 2025 15:46:06 +0200
Message-ID: <20250602134256.980762579@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134255.449974357@linuxfoundation.org>
References: <20250602134255.449974357@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mike Christie <michael.christie@oracle.com>

commit ccd3f449052449a917a3e577d8ba0368f43b8f29 upstream.

In newer version of the SBC specs, we have a NDOB bit that indicates there
is no data buffer that gets written out. If this bit is set using commands
like "sg_write_same --ndob" we will crash in target_core_iblock/file's
execute_write_same handlers when we go to access the se_cmd->t_data_sg
because its NULL.

This patch adds a check for the NDOB bit in the common WRITE SAME code
because we don't support it. And, it adds a check for zero SG elements in
each handler in case the initiator tries to send a normal WRITE SAME with
no data buffer.

Link: https://lore.kernel.org/r/20220628022325.14627-2-michael.christie@oracle.com
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Mike Christie <michael.christie@oracle.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/target/target_core_file.c   |    3 +++
 drivers/target/target_core_iblock.c |    4 ++++
 drivers/target/target_core_sbc.c    |    6 ++++++
 3 files changed, 13 insertions(+)

--- a/drivers/target/target_core_file.c
+++ b/drivers/target/target_core_file.c
@@ -455,6 +455,9 @@ fd_execute_write_same(struct se_cmd *cmd
 		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 	}
 
+	if (!cmd->t_data_nents)
+		return TCM_INVALID_CDB_FIELD;
+
 	if (cmd->t_data_nents > 1 ||
 	    cmd->t_data_sg[0].length != cmd->se_dev->dev_attrib.block_size) {
 		pr_err("WRITE_SAME: Illegal SGL t_data_nents: %u length: %u"
--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -458,6 +458,10 @@ iblock_execute_write_same(struct se_cmd
 		       " backends not supported\n");
 		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 	}
+
+	if (!cmd->t_data_nents)
+		return TCM_INVALID_CDB_FIELD;
+
 	sg = &cmd->t_data_sg[0];
 
 	if (cmd->t_data_nents > 1 ||
--- a/drivers/target/target_core_sbc.c
+++ b/drivers/target/target_core_sbc.c
@@ -312,6 +312,12 @@ sbc_setup_write_same(struct se_cmd *cmd,
 		pr_warn("WRITE SAME with ANCHOR not supported\n");
 		return TCM_INVALID_CDB_FIELD;
 	}
+
+	if (flags & 0x01) {
+		pr_warn("WRITE SAME with NDOB not supported\n");
+		return TCM_INVALID_CDB_FIELD;
+	}
+
 	/*
 	 * Special case for WRITE_SAME w/ UNMAP=1 that ends up getting
 	 * translated into block discard requests within backend code.


