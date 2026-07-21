Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B41293B4E9B;
	Tue, 21 Jul 2026 20:57:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784667430; cv=none; b=SOj3XQ37SKdr5Af5JLSugktab+NeyicgaEizEQUsr8rNjZlWZz95gbU4gz7g5ibcCEHU9ZupEBcHM2hLOQdnfMiqh4XzUZ6MOwLS1DpnUMHpPL761RaNfgg+k7AEhFLsvGkx2gZEZ0vA4lSruuCfI8lm2lGGRHzi7AenlQwZing=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784667430; c=relaxed/simple;
	bh=/WzfUfGA/ltmTzn+9z65BZRdf+aSw3pOxBCSartK1FQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GryaPuiwvL2w4lEXcIC25kxCUaadVdN9u6dds3wtbaxEOEGtAkbBaC2J/QGr+NGNy7u27aZ4oflC9+k3cYVqq7R6GPBqS0sZgLqP9N3mq0i7rr5YVM45yENsdspHlRiRpnKQDGUWoZkrg6kjx8A52hGs5yNNumW/Q3dDBroP3e8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PY4sFVeJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PY4sFVeJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 256971F000E9;
	Tue, 21 Jul 2026 20:57:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784667429;
	bh=PgAhsNPg4zi8aHgU3KcrKsj6QopnkgkjEn+bGt/hdQw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PY4sFVeJhRGtKMXltqGrNHmT4dUkyq0gtl0sMbVs9Qjk8i76CkPVFGmGQse5xgfFH
	 MSTEqkfudtEBiKwEjNiyyBWG26sb8eu4IiLYq9dyFWful0/t2LXvEnEQKXSKnc3qzw
	 J+8a3csUxjs+rhjZ+BNvJAnOtpDY7DkDcIZtJu2Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <haoxiang_li2024@163.com>,
	Don Brace <don.brace@microchip.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.6 1056/1266] scsi: hpsa: Fix DMA mapping leak on IOACCEL2 reset path
Date: Tue, 21 Jul 2026 17:24:53 +0200
Message-ID: <20260721152505.448796375@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haoxiang Li <haoxiang_li2024@163.com>

commit e166bafc483e927150cb9b5f286c9191ea0df84e upstream.

If phys_disk->in_reset is set, the function returns directly without
undoing the resources acquired for the command. Add the missing error
cleanup by unmapping the IOACCEL2 SG chain block when needed, unmapping
the SCSI command, and dropping the outstanding IOACCEL command count
before returning.

Fixes: c5dfd106414f ("scsi: hpsa: correct device resets")
Cc: stable@vger.kernel.org
Signed-off-by: Haoxiang Li <haoxiang_li2024@163.com>
Acked-by: Don Brace <don.brace@microchip.com>
Link: https://patch.msgid.link/20260622160028.1240496-1-haoxiang_li2024@163.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/hpsa.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -5031,6 +5031,10 @@ static int hpsa_scsi_ioaccel2_queue_comm
 
 	if (phys_disk->in_reset) {
 		cmd->result = DID_RESET << 16;
+		atomic_dec(&phys_disk->ioaccel_cmds_out);
+		scsi_dma_unmap(cmd);
+		if (use_sg > h->ioaccel_maxsg)
+			hpsa_unmap_ioaccel2_sg_chain_block(h, cp);
 		return -1;
 	}
 


