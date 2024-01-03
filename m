Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 994151BDF1;
	Wed,  3 Jan 2024 17:11:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hF177HFq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18BA7C433C8;
	Wed,  3 Jan 2024 17:11:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704301900;
	bh=aOlvJ/rcEOzbaheA4ITr0T3gZBhHORquwtPuwXHB17Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hF177HFqu4KIp3LP83cyS4c37FFFlhxRHR3C5NXvG4e+I175f7JZu7H1FIEsF4jyM
	 9E8vftUK4rG77w3JLW7e7FR+I+wJHRq0Nr/z2jbcspgk4FbNTGrWgtvmcJ3N6d8wTL
	 5cnijhTNiK2PdEpuURswY04D2lzI1ukrjXN0O/rE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bart Van Assche <bvanassche@acm.org>,
	Benjamin Block <bblock@linux.ibm.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 62/75] scsi: core: Add scsi_prot_ref_tag() helper
Date: Wed,  3 Jan 2024 17:55:43 +0100
Message-ID: <20240103164852.521338420@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240103164842.953224409@linuxfoundation.org>
References: <20240103164842.953224409@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Martin K. Petersen <martin.petersen@oracle.com>

[ Upstream commit 7ba46799d34695534666a3f71a2be10ea85ece6c ]

We are about to remove the request pointer from struct scsi_cmnd and that
will complicate getting to the ref_tag via t10_pi_ref_tag() in the various
drivers. Introduce a helper function to retrieve the reference tag so
drivers will not have to worry about the details.

Link: https://lore.kernel.org/r/20210609033929.3815-2-martin.petersen@oracle.com
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Benjamin Block <bblock@linux.ibm.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Message-Id: <20210609033929.3815-2-martin.petersen@oracle.com>
Stable-dep-of: 066c5b46b6ea ("scsi: core: Always send batch on reset or error handling command")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/scsi/scsi_cmnd.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index b1c9b52876f3c..6630464635330 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -291,6 +291,13 @@ static inline sector_t scsi_get_lba(struct scsi_cmnd *scmd)
 	return blk_rq_pos(scmd->request);
 }
 
+static inline u32 scsi_prot_ref_tag(struct scsi_cmnd *scmd)
+{
+	struct request *rq = blk_mq_rq_from_pdu(scmd);
+
+	return t10_pi_ref_tag(rq);
+}
+
 static inline unsigned int scsi_prot_interval(struct scsi_cmnd *scmd)
 {
 	return scmd->device->sector_size;
-- 
2.43.0



