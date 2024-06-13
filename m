Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DC4F6EB56;
	Thu, 13 Jun 2024 12:10:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718280600; cv=none; b=OqdUja1d7ze6XamNotKP/p69AbPkrMuTN/zMMxHZiLTeHdN6OJh8UAzxiM16fG2iMEJ+OwWzHcVLuRpN1cRJmvbuBsyCzUzDq7pdb4Sl1QueKG+29AGv0PEWd4NJtUp8hc+52d/jWVDkWRseQ31ey0+4GEF8VWAF6xhrqVaAgDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718280600; c=relaxed/simple;
	bh=7A4WEph/uQWLr4s7S+ZWYn+2h5QeFH/4eBEuO/Y+7h4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qM8F2Jqr3b1rTw+Pq7TPR058DOt/WQzaxiLZbLACkwe6g4l/6xj2jBDIQqQSDzsf3lHvjfnQ8/J1fDJgwKK3rHaVL8RkgSAzsdqqQ+njyYGiQb90km3fkYEiK1EhG1TAvpMhXVbrkikMWjvklGjdxX9Siorm910uAP2s4v9X6h8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qC7zRPtr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qC7zRPtr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA74FC2BBFC;
	Thu, 13 Jun 2024 12:09:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718280600;
	bh=7A4WEph/uQWLr4s7S+ZWYn+2h5QeFH/4eBEuO/Y+7h4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qC7zRPtrZKsV+N5Q8tsjods5ds/vM/+LXbPZn1/2lBpMgu6E3/OcUvjayVXHmM8Do
	 f4tvHKxQ4wfHJ2gVRC5263Ekh5uzIYz+oCkdfVRr6S1LaIvBQIhJboS6e2BpPRWlDW
	 6pe5/Xj9bWFs4JL1Y/+kFwLDYDtLSrVx8xoCfwek=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Schneider <pschneider1968@googlemail.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.6 078/137] scsi: core: Handle devices which return an unusually large VPD page count
Date: Thu, 13 Jun 2024 13:34:18 +0200
Message-ID: <20240613113226.321851578@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113223.281378087@linuxfoundation.org>
References: <20240613113223.281378087@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


