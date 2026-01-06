Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BF02346FB8;
	Tue,  6 Jan 2026 17:25:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767720325; cv=none; b=DdmaB9tqCS/5VrimLNR3CDHoJ1HIAjqT9AxIquFMKLLGcnjT3m0CR4zz2RpDh5e01qxBFQYzZ/VUOR4fj2RDi9itZF5G4hSgBLl1wKPq24iu7OlywT5DU9BBDvFCkqCVI/zXp/hFOqDqMlHW0tXhSaSQJw/wWHmFIjzf5vvtisg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767720325; c=relaxed/simple;
	bh=mkt/F9nfwQbB+Vq8Jwa29r8PyJ7lvoVJymSK4H9mPSo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rd11o30wm8zq8cGEoYHXU4lPzyfcoTsXM9Yq+L14BILzXL8veLGI2Pn5YyCFj79Gc7uV4fopz9CEbB3042eXJiwRkdo/t3MvKAcWsAwB7auXy7UXtY2u3aTsWCGF1vat628SfkLCSedmZFuYozDxqrau04KML/+1RMFxrUclo4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q8AIwpIN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q8AIwpIN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB7CDC19423;
	Tue,  6 Jan 2026 17:25:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767720325;
	bh=mkt/F9nfwQbB+Vq8Jwa29r8PyJ7lvoVJymSK4H9mPSo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q8AIwpINsT4esfGFGolYsE4/2UosYGvMOLCcofYxHeVpGZP6pKlG/Mt4WK9pg6/xx
	 IBmxcNbKxcHucsQslqevyDl90D8w8kok42VryLQKaJZRGQUUR+VM2SUVsCZ/F/liuV
	 UQbgtIayH9RYILy6F+OhchwP0QmGPkxykiYWPq1w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chandrakanth Patil <chandrakanth.patil@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.12 201/567] scsi: mpi3mr: Read missing IOCFacts flag for reply queue full overflow
Date: Tue,  6 Jan 2026 17:59:43 +0100
Message-ID: <20260106170458.760357248@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -160,6 +160,7 @@ struct mpi3_ioc_facts_data {
 #define MPI3_IOCFACTS_FLAGS_SIGNED_NVDATA_REQUIRED            (0x00010000)
 #define MPI3_IOCFACTS_FLAGS_DMA_ADDRESS_WIDTH_MASK            (0x0000ff00)
 #define MPI3_IOCFACTS_FLAGS_DMA_ADDRESS_WIDTH_SHIFT           (8)
+#define MPI3_IOCFACTS_FLAGS_MAX_REQ_PER_REPLY_QUEUE_LIMIT     (0x00000040)
 #define MPI3_IOCFACTS_FLAGS_INITIAL_PORT_ENABLE_MASK          (0x00000030)
 #define MPI3_IOCFACTS_FLAGS_INITIAL_PORT_ENABLE_NOT_STARTED   (0x00000000)
 #define MPI3_IOCFACTS_FLAGS_INITIAL_PORT_ENABLE_IN_PROGRESS   (0x00000010)
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -3135,6 +3135,8 @@ static void mpi3mr_process_factsdata(str
 	mrioc->facts.dma_mask = (facts_flags &
 	    MPI3_IOCFACTS_FLAGS_DMA_ADDRESS_WIDTH_MASK) >>
 	    MPI3_IOCFACTS_FLAGS_DMA_ADDRESS_WIDTH_SHIFT;
+	mrioc->facts.max_req_limit = (facts_flags &
+			MPI3_IOCFACTS_FLAGS_MAX_REQ_PER_REPLY_QUEUE_LIMIT);
 	mrioc->facts.protocol_flags = facts_data->protocol_flags;
 	mrioc->facts.mpi_version = le32_to_cpu(facts_data->mpi_version.word);
 	mrioc->facts.max_reqs = le16_to_cpu(facts_data->max_outstanding_requests);


