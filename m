Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06BC1298CC4;
	Tue, 21 Jul 2026 22:22:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784672538; cv=none; b=vEqo5Px7/tv1dIbxDAEbw7z80u/fwhYRqbQFge5pek5q3NGaR2YH9B3p8s2M93ykwnLss1TJUhhPABDst8kl5bQQFQFgOlcHlOsC7SqOzj+UCFxrMjwcocT3PrpKxwuvcVVGaDSNU/N73beVU2ZTEz23FXWeUm8Sdla1DxXqf3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784672538; c=relaxed/simple;
	bh=WpVnThGhQvRJWJSboGi5DebB8wK+LNS1GR3QttPPUHo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gIcfBjftqNqbjy8ezZ+dhZmH3Gwn77T0E7Y+BWCzLcqmUBX2wPFm6tbA7k5ppdRCFVowhBsV8xMue3CpZGWMEcFmuwdhmSr6C0M8Gv1SI7SbIjJQtgtj87A39baWDaYxGIW5asKLbs/V8WTBaKOr9Ldhu5siPQL1nmt9t6WXGgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PE2cPw3i; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PE2cPw3i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B5761F000E9;
	Tue, 21 Jul 2026 22:22:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784672536;
	bh=TUm0GJeTUls6pZgSUPhJ7un9imINmYVJy98411n6L7Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PE2cPw3igJkx74UhbwWqqEJnyttxSEmUXmqIJ8amSOt2fh2d0GyeF237f8dWgpNBT
	 iZckus1iIHS0OJIHRJGOxLbgPEHLDBbsw0N4VirAfxMEbQLhVzvKL7y3CTzMrRI8xK
	 3EaQOC1p8IpoSInzrwr0WiUZGa8qjNG6DGBohlZY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xu Rao <raoxu@uniontech.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.15 661/843] scsi: sg: Report request-table problems when any status is set
Date: Tue, 21 Jul 2026 17:24:56 +0200
Message-ID: <20260721152420.933490242@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -867,10 +867,9 @@ sg_fill_request_table(Sg_fd *sfp, sg_req
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


