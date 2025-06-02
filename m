Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 307282236F4;
	Mon,  2 Jun 2025 14:39:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748875140; cv=none; b=gpQwUDmL2YELOi55LdplSk2Fs5v1ZSxIPXAYr4jKXXSdcyjM9RTyTODNWJicQfI0Ksk3Wki+yhj/MK/ONgM0iDZotWW9xv9HP3u7edrtBasSXB9r3ZVQjnJOu3EeD18n2cAOUHXG8Pl/om9iPFolGNsE2Q880OtmUhQ+83B40c8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748875140; c=relaxed/simple;
	bh=o2z0ye9enXeDaxNSAH6ps4Q+w8/Sw+LU6TthJftTwUI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gKAJQ09XGb5TmDX6VnWBjPGemzvfBx5be49ZswCsg1HTwGgd4/eoeUQ2uqH9CB9rSjbvFIk+EjJbIFNMbbRqCR6Oi9s98LW2vzcqKWRw/qIZled1tRGx1jwS7YKbemT37IPaIjlxpavUQLQneyU6QDGaETkq9LIKqZxdhKnzKOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AhYrYDoj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AhYrYDoj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA899C4CEEB;
	Mon,  2 Jun 2025 14:38:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748875140;
	bh=o2z0ye9enXeDaxNSAH6ps4Q+w8/Sw+LU6TthJftTwUI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AhYrYDojqanT2jPomaKnG4ucNOkfA8Z+tFSlKZWlR58BzHnRp33K5P5yUBSGCK+f1
	 F6DSqfTTMVLtc6uLQyOC9Y57EAsc2vwiwornbKZf7FaQPs5wqo+w+UpM1tBBejLrn2
	 dy2aLNY5mHgoLbZ+NDO4SnESZPXFfDNnC/TFih4M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Mike Christie <michael.christie@oracle.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.10 041/270] scsi: target: Fix WRITE_SAME No Data Buffer crash
Date: Mon,  2 Jun 2025 15:45:26 +0200
Message-ID: <20250602134308.866284745@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134307.195171844@linuxfoundation.org>
References: <20250602134307.195171844@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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


