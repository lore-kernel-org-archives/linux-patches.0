Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A3986FB0;
	Tue,  5 Dec 2023 03:47:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DfHeQLGx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AF6DC433C8;
	Tue,  5 Dec 2023 03:47:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701748025;
	bh=LzEl0h5i2AdIt8UjX6Za8wsiSmLbb7fsy47vz8Ycvlc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DfHeQLGxtEYjdL4uGtxvDNhXa9NS9RW02SoosztgjXArZDI3BmmkuqoVs9BHGY9dm
	 tjlTeoKY9ab/T/LuhDIAoanb1PS4L3QL2DvdgCA790OTHz+4OzPdGaTsBK8zdcZ9iS
	 FKBx4S4QObY4ccY7xVXFOVsfn5BQObnPWtJyQfAs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Hannes Reinecke <hare@suse.de>,
	Ming Lei <ming.lei@redhat.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 85/94] scsi: core: Introduce the scsi_cmd_to_rq() function
Date: Tue,  5 Dec 2023 12:17:53 +0900
Message-ID: <20231205031527.553410613@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231205031522.815119918@linuxfoundation.org>
References: <20231205031522.815119918@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit 51f3a478892873337c54068d1185bcd797000a52 ]

The 'request' member of struct scsi_cmnd is superfluous. The struct request
and struct scsi_cmnd data structures are adjacent and hence the request
pointer can be derived easily from a scsi_cmnd pointer. Introduce a helper
function that performs that conversion in a type-safe way. This patch is
the first step towards removing the request member from struct
scsi_cmnd. Making that change has the following advantages:

 - This is a performance optimization since adding an offset to a pointer
   takes less time than dereferencing a pointer.

 - struct scsi_cmnd becomes smaller.

Link: https://lore.kernel.org/r/20210809230355.8186-2-bvanassche@acm.org
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Ming Lei <ming.lei@redhat.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Stable-dep-of: 19597cad64d6 ("scsi: qla2xxx: Fix system crash due to bad pointer access")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/scsi/scsi_cmnd.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index 7738a055d9535..dafde3d764d03 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -143,6 +143,12 @@ struct scsi_cmnd {
 	unsigned char tag;	/* SCSI-II queued command tag */
 };
 
+/* Variant of blk_mq_rq_from_pdu() that verifies the type of its argument. */
+static inline struct request *scsi_cmd_to_rq(struct scsi_cmnd *scmd)
+{
+	return blk_mq_rq_from_pdu(scmd);
+}
+
 /*
  * Return the driver private allocation behind the command.
  * Only works if cmd_size is set in the host template.
-- 
2.42.0



