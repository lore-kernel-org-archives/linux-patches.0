Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAE7020371A;
	Thu, 13 Feb 2025 14:45:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739457931; cv=none; b=QYenY2+DtAj3AXJgUPKoMVCTsPW/Q6e0IdVk7MnyFYeS+iBKXaV6XX8QnZnr2SI8AQQkwzLdRhVhAPjEarO/ywx+fFOjt46P1dSE0XToVDKoTPbqsw89s7s3o1gvMJlzeYUaL+yQS9RVFnWst3tmLk4k4+KfDYU5GHQ/Dgh26Bs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739457931; c=relaxed/simple;
	bh=CrO0fH9+VBIIjGzqBkCpUIoer/8H2sI7mH5v9daUX4g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JvE74S+eeiBOpSYjthnImtnBicepcYVSe+KM2WQnbiEsuZMjp6ckR//hBSXJVDFx3DeVyZqRuiHUoIv0uZ8WN1tb/xMMgq0ONlk142cTGfFxpndqF+Nh2rBKydcdWIbCSJTPDaz+b7cqyQ1Bfvp2O/nprIQr+pb8Qg0uJ6zC5Rg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C1yzmwXy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C1yzmwXy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C542C4CEE2;
	Thu, 13 Feb 2025 14:45:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739457930;
	bh=CrO0fH9+VBIIjGzqBkCpUIoer/8H2sI7mH5v9daUX4g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C1yzmwXyjzBloyHkaXmVUMGc5zX4LEBeIKHY/n9PagfqBc6Wx3bgGKZoIdgWhB5qm
	 2i4uORs2udvzYm/HLb9cJghwln1qQtMx9WKDXe47tOxhD5c2wu90k7m9PIka4IGhGD
	 g1CIjupT8rKev01W4OkpkhhsXAwUwlNvrLDtVH/o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.12 254/422] scsi: st: Dont set pos_unknown just after device recognition
Date: Thu, 13 Feb 2025 15:26:43 +0100
Message-ID: <20250213142446.343391731@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142436.408121546@linuxfoundation.org>
References: <20250213142436.408121546@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kai Mäkisara <Kai.Makisara@kolumbus.fi>

commit 98b37881b7492ae9048ad48260cc8a6ee9eb39fd upstream.

Commit 9604eea5bd3a ("scsi: st: Add third party poweron reset handling") in
v6.6 added new code to handle the Power On/Reset Unit Attention (POR UA)
sense data. This was in addition to the existing method. When this Unit
Attention is received, the driver blocks attempts to read, write and some
other operations because the reset may have rewinded the tape. Because of
the added code, also the initial POR UA resulted in blocking operations,
including those that are used to set the driver options after the device is
recognized. Also, reading and writing are refused, whereas they succeeded
before this commit.

Add code to not set pos_unknown to block operations if the POR UA is
received from the first test_ready() call after the st device has been
created. This restores the behavior before v6.6.

Signed-off-by: Kai Mäkisara <Kai.Makisara@kolumbus.fi>
Link: https://lore.kernel.org/r/20241216113755.30415-1-Kai.Makisara@kolumbus.fi
Fixes: 9604eea5bd3a ("scsi: st: Add third party poweron reset handling")
CC: stable@vger.kernel.org
Closes: https://lore.kernel.org/linux-scsi/2201CF73-4795-4D3B-9A79-6EE5215CF58D@kolumbus.fi/
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/st.c |    6 ++++++
 drivers/scsi/st.h |    1 +
 2 files changed, 7 insertions(+)

--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -1027,6 +1027,11 @@ static int test_ready(struct scsi_tape *
 			retval = new_session ? CHKRES_NEW_SESSION : CHKRES_READY;
 		break;
 	}
+	if (STp->first_tur) {
+		/* Don't set pos_unknown right after device recognition */
+		STp->pos_unknown = 0;
+		STp->first_tur = 0;
+	}
 
 	if (SRpnt != NULL)
 		st_release_request(SRpnt);
@@ -4325,6 +4330,7 @@ static int st_probe(struct device *dev)
 	blk_queue_rq_timeout(tpnt->device->request_queue, ST_TIMEOUT);
 	tpnt->long_timeout = ST_LONG_TIMEOUT;
 	tpnt->try_dio = try_direct_io;
+	tpnt->first_tur = 1;
 
 	for (i = 0; i < ST_NBR_MODES; i++) {
 		STm = &(tpnt->modes[i]);
--- a/drivers/scsi/st.h
+++ b/drivers/scsi/st.h
@@ -170,6 +170,7 @@ struct scsi_tape {
 	unsigned char rew_at_close;  /* rewind necessary at close */
 	unsigned char inited;
 	unsigned char cleaning_req;  /* cleaning requested? */
+	unsigned char first_tur;     /* first TEST UNIT READY */
 	int block_size;
 	int min_block;
 	int max_block;


