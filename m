Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65F8E431A4E;
	Tue, 21 Jul 2026 22:52:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784674372; cv=none; b=flVvCMmCt1AFVJN49sT7qNBteop3CgOaVg+8OY6QFOQ8MsJshK8u85/SvOZe5Rxiw9FLZ4anQKO4cNoERKZEqO5yf5E4iHqcKU625F7MD6/RIBJmbDA+rkQT8oSA2XCLrdnLR7Ybr8V5j4PxlCFWWDxSujSUlN6/5HWJMCFALLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784674372; c=relaxed/simple;
	bh=Htyi8ZqJuR5O512/P7QQ+QFfZ55zTTZRv5AImthoOyc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VOPhU5Qv0ziNbO5NkU0+bWyiCGDEOEDvzEhxaIr6O4ffr2eoN7oRY5FkO7vcZlrn3FSLKCx0EQOrlfay8beg1xMvkZZF/cYhPkEc+knBUF6UU0OKorPl68COgLzgznBPgLse0rITACqtBElP6Cz9pqnE6Wfii/SpnYQg39zJ4oE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eZ7fYkbY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eZ7fYkbY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA8741F000E9;
	Tue, 21 Jul 2026 22:52:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784674371;
	bh=uTZlf4zAhJV/qXeMNpTvge0ZARY765moMrJzNIqHW5A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eZ7fYkbYhf4xSG2vg34x4AYW8jKbA9fkSPRMLvUfSzOAagIXSfVWWcVVk0k/kJYAB
	 DCCOWf4Kmd/nnLBbD5n+k3VIXOoNs/0nxIKYe1JMKwBlV+Y6iVrt2/q3+TrhX2REbj
	 kRbUA/2Ay1ydxTZ2w3xqRnVD2CQWH+1M7iXFkRS8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xu Rao <raoxu@uniontech.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.10 516/699] scsi: sg: Report request-table problems when any status is set
Date: Tue, 21 Jul 2026 17:24:35 +0200
Message-ID: <20260721152407.338578531@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -864,10 +864,9 @@ sg_fill_request_table(Sg_fd *sfp, sg_req
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


