Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD96317E919;
	Sun,  1 Sep 2024 16:50:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725209458; cv=none; b=Miq+Sz2vKvZZL4A4FMjKsHVsm7hLdkmLeNFD8V6Tma1jBhzdUGHyJffVy1n6IcwE8nw7ro62X3QQycbKvI21MXwXR/klu+UV/6xfSfw/U6+EHqnpScHjjhbndGdJOKeajsh88eYMIr0ZYoklkLHFSAFnc13owBksqFQgsA51zhg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725209458; c=relaxed/simple;
	bh=DncSpSoL/GZqhhrjMaGxqz3yObdOaDbPjYFUmhBfNvY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lzcAE7hhRycxuhLgz3p+4hf6rUhgJRmZmOcJhSFLTvfi/lPGqN9qheayNSaQ4cSWSh5qLCCZ3fjA5l7GCr9sQb8TdL30ONSZALX7ptkvsimA+CYT8QNEzGr+lwt4WPlr89y7X8Fd+e1c8PwJ7FWvWk1OoVw6CxQiOUnKlIRC9Hk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i+x7cK3k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i+x7cK3k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42B63C4CEC3;
	Sun,  1 Sep 2024 16:50:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725209458;
	bh=DncSpSoL/GZqhhrjMaGxqz3yObdOaDbPjYFUmhBfNvY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i+x7cK3k2YmkZLieGU2nZKfiXCouDcvqCFSCX93+IlGgcLb+n5uancq738awcHv4l
	 Jqj0k3VeeHc5NRoFHeLfm2Gek2wLqG5ja6Srg3MIDCCUf5C+WkNAZz6kXj0tEN565+
	 hGBYKDX2K7yN4n7qipvZusUvoshSOibhIwCZa/lw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Christie <michael.christie@oracle.com>,
	Christoph Hellwig <hch@lst.de>,
	John Garry <john.g.garry@oracle.com>,
	Martin Wilck <mwilck@suse.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 043/151] scsi: spi: Fix sshdr use
Date: Sun,  1 Sep 2024 18:16:43 +0200
Message-ID: <20240901160815.728505564@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160814.090297276@linuxfoundation.org>
References: <20240901160814.090297276@linuxfoundation.org>
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

From: Mike Christie <michael.christie@oracle.com>

[ Upstream commit 0b149cee836aa53989ea089af1cb9d90d7c6ac9e ]

If scsi_execute_cmd returns < 0, it doesn't initialize the sshdr, so we
shouldn't access the sshdr. If it returns 0, then the cmd executed
successfully, so there is no need to check the sshdr. This has us access
the sshdr when we get a return value > 0.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Link: https://lore.kernel.org/r/20231004210013.5601-7-michael.christie@oracle.com
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: John Garry <john.g.garry@oracle.com>
Reviewed-by: Martin Wilck <mwilck@suse.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/scsi_transport_spi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_transport_spi.c b/drivers/scsi/scsi_transport_spi.c
index c37dd15d16d24..83f2576ed2aa0 100644
--- a/drivers/scsi/scsi_transport_spi.c
+++ b/drivers/scsi/scsi_transport_spi.c
@@ -677,10 +677,10 @@ spi_dv_device_echo_buffer(struct scsi_device *sdev, u8 *buffer,
 	for (r = 0; r < retries; r++) {
 		result = spi_execute(sdev, spi_write_buffer, DMA_TO_DEVICE,
 				     buffer, len, &sshdr);
-		if(result || !scsi_device_online(sdev)) {
+		if (result || !scsi_device_online(sdev)) {
 
 			scsi_device_set_state(sdev, SDEV_QUIESCE);
-			if (scsi_sense_valid(&sshdr)
+			if (result > 0 && scsi_sense_valid(&sshdr)
 			    && sshdr.sense_key == ILLEGAL_REQUEST
 			    /* INVALID FIELD IN CDB */
 			    && sshdr.asc == 0x24 && sshdr.ascq == 0x00)
-- 
2.43.0



