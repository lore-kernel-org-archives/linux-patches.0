Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D6A4330B05;
	Mon, 29 Dec 2025 16:29:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025761; cv=none; b=HLlZ+lhFz0mJNb1AYr76PVEgNKm/xGmyW3N9FgwHoDUI9+bUwCmW9EYbS3q/AzfOm2RsXsMK2KSfSlmmxbNNMJ85Fg+YKAxHvwoup+aQQInIbT0bpugqQqrYymW1Orv0oHVX+FLQkIfi0xI3dEFVGXQuXLDl/kse4+tWmJjC1KM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025761; c=relaxed/simple;
	bh=TUHzXw5wAwJBvCENSMD/6Zyu8FwJiqQ6nPRRUGbhx4s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bKQbuMhFPD3KClD2veIqNkK0qNnMf+W4vjI8Jh+5sdY/C5/+tBMGaknJNeahKXuqK2K+7+Mn1kX3X66axsL6rSmDzu0NtwKVswhQAVLsy+lP7bqkT1coJH1ifWAZ8pMm/9cwx4A3QtmgW0XZLEcLVI0Dv9Q7VdQ9dnN0PYjEPIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DiYjMXFN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DiYjMXFN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F927C4CEF7;
	Mon, 29 Dec 2025 16:29:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025761;
	bh=TUHzXw5wAwJBvCENSMD/6Zyu8FwJiqQ6nPRRUGbhx4s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DiYjMXFNRdIKq8FK/cZhqh2zXQS4T1cT7FH7nRqhx0euLZeEHd+VTLuwnwguUVpYw
	 /RDGsdvUauev+yun/i9ClTSqf0LwdUHCURofgOPf7gyZpEAz7oemUcYqfAOVNMrHlA
	 Wcdxne3b/wxHGMdQfI1u0cUVy7D2f1zgjdBCFiFA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chandrakanth Patil <chandrakanth.patil@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.18 310/430] scsi: mpi3mr: Read missing IOCFacts flag for reply queue full overflow
Date: Mon, 29 Dec 2025 17:11:52 +0100
Message-ID: <20251229160735.741390479@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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

From: Chandrakanth Patil <chandrakanth.patil@broadcom.com>

commit d373163194982f43b92c552c138c29d9f0b79553 upstream.

The driver was not reading the MAX_REQ_PER_REPLY_QUEUE_LIMIT IOCFacts
flag, so the reply-queue-full handling was never enabled, even on
firmware that supports it. Reading this flag enables the feature and
prevents reply queue overflow.

Fixes: f08b24d82749 ("scsi: mpi3mr: Avoid reply queue full condition")
Cc: stable@vger.kernel.org
Signed-off-by: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
Link: https://patch.msgid.link/20251211002929.22071-1-chandrakanth.patil@broadcom.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/mpi3mr/mpi/mpi30_ioc.h |    1 +
 drivers/scsi/mpi3mr/mpi3mr_fw.c     |    2 ++
 2 files changed, 3 insertions(+)

--- a/drivers/scsi/mpi3mr/mpi/mpi30_ioc.h
+++ b/drivers/scsi/mpi3mr/mpi/mpi30_ioc.h
@@ -166,6 +166,7 @@ struct mpi3_ioc_facts_data {
 #define MPI3_IOCFACTS_FLAGS_SIGNED_NVDATA_REQUIRED            (0x00010000)
 #define MPI3_IOCFACTS_FLAGS_DMA_ADDRESS_WIDTH_MASK            (0x0000ff00)
 #define MPI3_IOCFACTS_FLAGS_DMA_ADDRESS_WIDTH_SHIFT           (8)
+#define MPI3_IOCFACTS_FLAGS_MAX_REQ_PER_REPLY_QUEUE_LIMIT     (0x00000040)
 #define MPI3_IOCFACTS_FLAGS_INITIAL_PORT_ENABLE_MASK          (0x00000030)
 #define MPI3_IOCFACTS_FLAGS_INITIAL_PORT_ENABLE_SHIFT		(4)
 #define MPI3_IOCFACTS_FLAGS_INITIAL_PORT_ENABLE_NOT_STARTED   (0x00000000)
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -3158,6 +3158,8 @@ static void mpi3mr_process_factsdata(str
 	mrioc->facts.dma_mask = (facts_flags &
 	    MPI3_IOCFACTS_FLAGS_DMA_ADDRESS_WIDTH_MASK) >>
 	    MPI3_IOCFACTS_FLAGS_DMA_ADDRESS_WIDTH_SHIFT;
+	mrioc->facts.max_req_limit = (facts_flags &
+			MPI3_IOCFACTS_FLAGS_MAX_REQ_PER_REPLY_QUEUE_LIMIT);
 	mrioc->facts.protocol_flags = facts_data->protocol_flags;
 	mrioc->facts.mpi_version = le32_to_cpu(facts_data->mpi_version.word);
 	mrioc->facts.max_reqs = le16_to_cpu(facts_data->max_outstanding_requests);


