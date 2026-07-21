Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 740A246D2CF;
	Tue, 21 Jul 2026 18:37:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659031; cv=none; b=mknfPJeVHGVGPl+rPm2p9RpbnuiesTMW1CzwUvSaADXkMtsZEc2aAIWlrpYeZyS3tVxP7DGt3Pm4+KkZoIjH8HIiDrQwwRcUcR2pQSEZRoqBZ7AhPFQRR3DkzA3NfO6CHM4OY+qwHBZARFxx0HPho4B/LKbb1RirMBV3a766D4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659031; c=relaxed/simple;
	bh=8il1/lthaUjRixm2VhPX8I3QXDNB4l2z+F0P1rlhrrg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=poQW2RO1fx3TiJIqMNXIKhQUFaYjc29tTPAjYD4P/X1PuD5lSuXjLhb8PDvzNfVT2F2xhG1jS3JKMpseiz4BbTriA6Kq6vu+qSaP+385VexsUjyHKxpByT4xmQF0PsBgOK68U5jWMwcyBVH6SJTqjRdP/CvKaxbBS86XAHgIXWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DXdiWQtP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DXdiWQtP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBE311F000E9;
	Tue, 21 Jul 2026 18:37:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659030;
	bh=eVJxGUzgaFbFZ/zgMWWYOMcC0ktOoQW15632pOfpW8k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DXdiWQtPpUcP2piep4ZbvIzEpV/GmiiNUbgyYpEFBGUZyUoY8I9bSobFVeHPztU+9
	 DGKKx7KZj5pm3TAqv/1F4ucabM+Y8oCFtdCzgkuwiHZ+/XN1CyxALltSJ7sTDX/4Pb
	 OI0dg3o3+QVHtWdz6hgn1zyNFsbo29QxHs9kmVi0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xu Rao <raoxu@uniontech.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.18 1367/1611] scsi: sg: Report request-table problems when any status is set
Date: Tue, 21 Jul 2026 17:24:43 +0200
Message-ID: <20260721152546.199430296@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: Xu Rao <raoxu@uniontech.com>

commit 1d3a742afeb761eaead774691bde1ced699e9a5d upstream.

SG_GET_REQUEST_TABLE reports per-request diagnostic state through
sg_req_info::problem. The field is meant to indicate whether there is an
error to report for a completed request.

sg_fill_request_table() currently combines masked_status, host_status
and driver_status with bitwise AND. This only reports a problem when all
three status fields are non-zero at the same time. A normal target check
condition, for example, has masked_status set while host_status and
driver_status may both be zero, so the request is incorrectly reported
as clean.

Use the same condition as sg_new_read(), which sets SG_INFO_CHECK when
any of the three status fields is non-zero.

Cc: stable@vger.kernel.org
Signed-off-by: Xu Rao <raoxu@uniontech.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Link: https://patch.msgid.link/54B60C19F7DB8889+20260707030845.970018-1-raoxu@uniontech.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/sg.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -862,10 +862,9 @@ sg_fill_request_table(Sg_fd *sfp, sg_req
 		if (val >= SG_MAX_QUEUE)
 			break;
 		rinfo[val].req_state = srp->done + 1;
-		rinfo[val].problem =
-			srp->header.masked_status &
-			srp->header.host_status &
-			srp->header.driver_status;
+		rinfo[val].problem = srp->header.masked_status ||
+					     srp->header.host_status ||
+					     srp->header.driver_status;
 		if (srp->done)
 			rinfo[val].duration =
 				srp->header.duration;


