Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C74195D909;
	Tue, 23 Jan 2024 00:29:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969766; cv=none; b=P1sT4L7DBNkBV1ASrpThrPyk5X3+x92bE8GerlEBePOzjedE+Ypj5yEWGEtizgohvnG+bOoa0zUAycU0Bm4jk2q2V82n4XY64URESGUGI0uNaeR+3/G0JfSMn8WbQbMcPQn8ErIKKb4JovP3eRqROFNk2WL38U5iX8u2mgvvdig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969766; c=relaxed/simple;
	bh=6JMaMJ5LKzmatSmTLrYFXf+fxmWKGs87uaXsMu63bNY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MAmr8aF86jxH2J9ZYi60VNxWngyXIQcH4vNhm47kiSvwDQBZ6CTPS7tf44gjJwFYkiMDeVQoVp1ryu01LjD+RABkYrQgefp2RRH9i5rxwuhAwOfzm2sB8ay9+mBwMEyPgaNH54/qS5JMGh6uxXR18/9grlDYPx6HG7KoJqsZZwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ngHZ98nf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ngHZ98nf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEBA2C433F1;
	Tue, 23 Jan 2024 00:29:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969766;
	bh=6JMaMJ5LKzmatSmTLrYFXf+fxmWKGs87uaXsMu63bNY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ngHZ98nfWfB3surYVM+hF2IIFAyl95GmJbCimjBesgQ/VzRotCQ9p1KxbGw+1nQSJ
	 QzK5HTRREYsixrDn0PaBzeAvyITDOz77c95iYIlHtqN53vFnn1n+86dwTRI+efGgNj
	 DVUWeTlP5PC9CCFKv1E8ITwhouZ5tzuh9LGubWME=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sathya Prakash <sathya.prakash@broadcom.com>,
	Chandrakanth patil <chandrakanth.patil@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.7 437/641] scsi: mpi3mr: Block PEL Enable Command on Controller Reset and Unrecoverable State
Date: Mon, 22 Jan 2024 15:55:41 -0800
Message-ID: <20240122235831.678510456@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chandrakanth patil <chandrakanth.patil@broadcom.com>

commit f8fb3f39148e8010479e4b2003ba4728818ec661 upstream.

If a controller reset is underway or the controller is in an unrecoverable
state, the PEL enable management command will be returned as EAGAIN or
EFAULT.

Cc: <stable@vger.kernel.org> # v6.1+
Co-developed-by: Sathya Prakash <sathya.prakash@broadcom.com>
Signed-off-by: Sathya Prakash <sathya.prakash@broadcom.com>
Signed-off-by: Chandrakanth patil <chandrakanth.patil@broadcom.com>
Link: https://lore.kernel.org/r/20231126053134.10133-4-chandrakanth.patil@broadcom.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/mpi3mr/mpi3mr_app.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

--- a/drivers/scsi/mpi3mr/mpi3mr_app.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_app.c
@@ -223,6 +223,22 @@ static long mpi3mr_bsg_pel_enable(struct
 		return rval;
 	}
 
+	if (mrioc->unrecoverable) {
+		dprint_bsg_err(mrioc, "%s: unrecoverable controller\n",
+			       __func__);
+		return -EFAULT;
+	}
+
+	if (mrioc->reset_in_progress) {
+		dprint_bsg_err(mrioc, "%s: reset in progress\n", __func__);
+		return -EAGAIN;
+	}
+
+	if (mrioc->stop_bsgs) {
+		dprint_bsg_err(mrioc, "%s: bsgs are blocked\n", __func__);
+		return -EAGAIN;
+	}
+
 	sg_copy_to_buffer(job->request_payload.sg_list,
 			  job->request_payload.sg_cnt,
 			  &pel_enable, sizeof(pel_enable));


