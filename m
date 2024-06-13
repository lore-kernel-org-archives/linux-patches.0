Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B013C1482F1;
	Thu, 13 Jun 2024 11:50:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718279454; cv=none; b=ecXDYcujkfN9segrT14A4eX+p+QbJbVYqcCx2xHTAk7p7iXgsMLb4kqIAjnh7rtTLrEs9LasDsbomdJJU3k1JVwGHjVBGS23YE7TPyFKkZRfobS1sgCt4LjTj9IfddfScad1YZO+JLJOftlSTU9jUS+Uwqj5/s53r+lVvMDgIhg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718279454; c=relaxed/simple;
	bh=3bUm49nbfAYMaI40hY2k4iBl+2HAwWNuJnkIHp8R9sA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d5eggWKwABPLDzSo3Z5Yxg5JgTX3lZRwkqLfjPnSXuM2Sgi4SuCoIa2o1CCJ/y2CVMqjyJ7021YI0K6Vhbj7yEoHJc3lL/KjzWIEEvB3RG2zYSSbx/qDUaDykgwYGnQPMOzCLaOS484aWPG+gdax/aQtxI4gdA6LkRJEfjR5V6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SkG+vRN1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SkG+vRN1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35020C4AF1A;
	Thu, 13 Jun 2024 11:50:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718279454;
	bh=3bUm49nbfAYMaI40hY2k4iBl+2HAwWNuJnkIHp8R9sA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SkG+vRN1ZOXgvGx94mx53PwWR+UZvGrxcybngS8le/UfbwQX6KyiWvYvz+DVkd5Vy
	 9oCjC0b+CKoX0gwHn1P/wz0ZwBFQPmZfoFdTURtlnoKi8i36s6TtyKSDS2Hg7qp5Ra
	 rmzCrvSIh31+zYHFmqPADhRNla14mPMsYCYv23wo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Schneider <pschneider1968@googlemail.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.9 081/157] scsi: core: Handle devices which return an unusually large VPD page count
Date: Thu, 13 Jun 2024 13:33:26 +0200
Message-ID: <20240613113230.558219998@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.389465891@linuxfoundation.org>
References: <20240613113227.389465891@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Martin K. Petersen <martin.petersen@oracle.com>

commit d09c05aa35909adb7d29f92f0cd79fdcd1338ef0 upstream.

Peter Schneider reported that a system would no longer boot after
updating to 6.8.4.  Peter bisected the issue and identified commit
b5fc07a5fb56 ("scsi: core: Consult supported VPD page list prior to
fetching page") as being the culprit.

Turns out the enclosure device in Peter's system reports a byteswapped
page length for VPD page 0. It reports "02 00" as page length instead
of "00 02". This causes us to attempt to access 516 bytes (page length
+ header) of information despite only 2 pages being present.

Limit the page search scope to the size of our VPD buffer to guard
against devices returning a larger page count than requested.

Link: https://lore.kernel.org/r/20240521023040.2703884-1-martin.petersen@oracle.com
Fixes: b5fc07a5fb56 ("scsi: core: Consult supported VPD page list prior to fetching page")
Cc: stable@vger.kernel.org
Reported-by: Peter Schneider <pschneider1968@googlemail.com>
Closes: https://lore.kernel.org/all/eec6ebbf-061b-4a7b-96dc-ea748aa4d035@googlemail.com/
Tested-by: Peter Schneider <pschneider1968@googlemail.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/scsi.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -350,6 +350,13 @@ static int scsi_get_vpd_size(struct scsi
 		if (result < SCSI_VPD_HEADER_SIZE)
 			return 0;
 
+		if (result > sizeof(vpd)) {
+			dev_warn_once(&sdev->sdev_gendev,
+				      "%s: long VPD page 0 length: %d bytes\n",
+				      __func__, result);
+			result = sizeof(vpd);
+		}
+
 		result -= SCSI_VPD_HEADER_SIZE;
 		if (!memchr(&vpd[SCSI_VPD_HEADER_SIZE], page, result))
 			return 0;


