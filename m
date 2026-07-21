Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 769CE43F8DE;
	Tue, 21 Jul 2026 20:59:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784667568; cv=none; b=F7b/C/9R9DJxI1lu3dyytEVg3DpKo/ZPq2VFynUKh+OPHjRWf/JKQQZD7OfQI4qVquoj1oz2Akd0BFjduEsGtVBkIUjODln8wsT6Xc8FNYU0R6AB5m/81fzX36fqSc5bQPk834MkjuQgXKBKtPjXTYTdVvugXzDyob22hpj2YmA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784667568; c=relaxed/simple;
	bh=AJHz4DM6HhIi4teuT/VpcGPcySCxGMlV/6JJbos8WaY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QefJV95QzvL95wXw4eomdi+f2KXbHzyw/p4Nt5JqkFPLlhno87hd6na6rW3vY2NOClzJOKP12XSyY3K6MqLbPCIINm2xNNJXSFIHev82mHzj46lZmNBQal/s5BnIV5rHsnR02xQHP59L3fJzu/dfQDGvxpAEq1uWmQSHPd9G+2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DoRo5CV9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DoRo5CV9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE32C1F000E9;
	Tue, 21 Jul 2026 20:59:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784667567;
	bh=drVaXDq4SZVwsEG//qewz4wgDsTE8/pYOT9VpJ51LpY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DoRo5CV9ytdM73LTvZVm25MUQ/NRlNgejGn18pEDqSYxuG2olmBaJHAtGuxWQ+rzB
	 KTaNaVXZ607RBqR7qi4dYLP+iQjI8pxZwMpdBdMr6kHVc2bK8JEBjSHq+7PAJxZPyg
	 aTLMEQ2M05H2DPdx1Ru3QMCZoQ0RbGJFn14LT9uo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xu Rao <raoxu@uniontech.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.6 1058/1266] scsi: sg: Report request-table problems when any status is set
Date: Tue, 21 Jul 2026 17:24:55 +0200
Message-ID: <20260721152505.495157626@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


