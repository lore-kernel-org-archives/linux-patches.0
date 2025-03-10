Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE96722D786;
	Mon, 10 Mar 2025 17:09:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741626558; cv=none; b=OVzX+Ktuv5hZNMlwGoAGpw+RoQs24WgVLEwZhnUKjMpwQrPaMbdeCeYwjZ+YRoML4ajNgBZOx7EX7ce8opjjtLCKUgBmKqBKJ2iWAFRD01vytTYq596FoygKJM+Mi8relWfCGa1gVzFXPjW7L9BS/yv0EdHGd+gxx7nMvpsNRHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741626558; c=relaxed/simple;
	bh=CocNOnSpbDink+FwxRazvx2YSdbXcJ3d8dc5gjA+ydg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lF8qkFlskyyvRT1W9gyRXWhXGg4zS87VYe0rp49QmyMgJvWoLE/Xpw3NfPJNXiQI8U2Z7xulsnVZTPQ6tC+VNFg7ag71haBTyrkgPbtrBVHT/dgkRVqcFwGlhiTyakzlv6y/E31+X8k9RmcoAtcYj7vRJyGC/obfBHYx6Ondr3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s1OE4rt0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s1OE4rt0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 330F7C4CEE5;
	Mon, 10 Mar 2025 17:09:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741626558;
	bh=CocNOnSpbDink+FwxRazvx2YSdbXcJ3d8dc5gjA+ydg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s1OE4rt0qPHSLCksTEA31BfG+2okJmXnU9yRWO+RwOSgVtV7ZN0Szrc7b4ylCum6c
	 ypOQi9HifcXxIRULOrpsT6zKr3yloizyKx0Gu75hNHzuROT1uuNXi3uUKDanriIx1P
	 EtXEIncB/KBc1qP/p2qEH/+6WcLjpBaXQuKxSM+A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	andreas.stuehrk@yaxi.tech,
	Nikunj A Dadhania <nikunj@amd.com>,
	Alexey Kardashevskiy <aik@amd.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>
Subject: [PATCH 6.13 032/207] virt: sev-guest: Allocate request data dynamically
Date: Mon, 10 Mar 2025 18:03:45 +0100
Message-ID: <20250310170449.053128699@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170447.729440535@linuxfoundation.org>
References: <20250310170447.729440535@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nikunj A Dadhania <nikunj@amd.com>

commit ac7c06acaa3738b38e83815ac0f07140ad320f13 upstream.

Commit

  ae596615d93d ("virt: sev-guest: Reduce the scope of SNP command mutex")

narrowed the command mutex scope to snp_send_guest_request().  However,
GET_REPORT, GET_DERIVED_KEY, and GET_EXT_REPORT share the req structure in
snp_guest_dev. Without the mutex protection, concurrent requests can overwrite
each other's data. Fix it by dynamically allocating the request structure.

Fixes: ae596615d93d ("virt: sev-guest: Reduce the scope of SNP command mutex")
Closes: https://github.com/AMDESE/AMDSEV/issues/265
Reported-by: andreas.stuehrk@yaxi.tech
Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
Signed-off-by: Alexey Kardashevskiy <aik@amd.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20250307013700.437505-2-aik@amd.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/virt/coco/sev-guest/sev-guest.c |   24 +++++++++++++++---------
 1 file changed, 15 insertions(+), 9 deletions(-)

--- a/drivers/virt/coco/sev-guest/sev-guest.c
+++ b/drivers/virt/coco/sev-guest/sev-guest.c
@@ -41,12 +41,6 @@ struct snp_guest_dev {
 	struct miscdevice misc;
 
 	struct snp_msg_desc *msg_desc;
-
-	union {
-		struct snp_report_req report;
-		struct snp_derived_key_req derived_key;
-		struct snp_ext_report_req ext_report;
-	} req;
 };
 
 /*
@@ -390,7 +384,7 @@ struct snp_req_resp {
 
 static int get_report(struct snp_guest_dev *snp_dev, struct snp_guest_request_ioctl *arg)
 {
-	struct snp_report_req *report_req = &snp_dev->req.report;
+	struct snp_report_req *report_req __free(kfree) = NULL;
 	struct snp_msg_desc *mdesc = snp_dev->msg_desc;
 	struct snp_report_resp *report_resp;
 	struct snp_guest_req req = {};
@@ -399,6 +393,10 @@ static int get_report(struct snp_guest_d
 	if (!arg->req_data || !arg->resp_data)
 		return -EINVAL;
 
+	report_req = kzalloc(sizeof(*report_req), GFP_KERNEL_ACCOUNT);
+	if (!report_req)
+		return -ENOMEM;
+
 	if (copy_from_user(report_req, (void __user *)arg->req_data, sizeof(*report_req)))
 		return -EFAULT;
 
@@ -435,7 +433,7 @@ e_free:
 
 static int get_derived_key(struct snp_guest_dev *snp_dev, struct snp_guest_request_ioctl *arg)
 {
-	struct snp_derived_key_req *derived_key_req = &snp_dev->req.derived_key;
+	struct snp_derived_key_req *derived_key_req __free(kfree) = NULL;
 	struct snp_derived_key_resp derived_key_resp = {0};
 	struct snp_msg_desc *mdesc = snp_dev->msg_desc;
 	struct snp_guest_req req = {};
@@ -455,6 +453,10 @@ static int get_derived_key(struct snp_gu
 	if (sizeof(buf) < resp_len)
 		return -ENOMEM;
 
+	derived_key_req = kzalloc(sizeof(*derived_key_req), GFP_KERNEL_ACCOUNT);
+	if (!derived_key_req)
+		return -ENOMEM;
+
 	if (copy_from_user(derived_key_req, (void __user *)arg->req_data,
 			   sizeof(*derived_key_req)))
 		return -EFAULT;
@@ -487,7 +489,7 @@ static int get_ext_report(struct snp_gue
 			  struct snp_req_resp *io)
 
 {
-	struct snp_ext_report_req *report_req = &snp_dev->req.ext_report;
+	struct snp_ext_report_req *report_req __free(kfree) = NULL;
 	struct snp_msg_desc *mdesc = snp_dev->msg_desc;
 	struct snp_report_resp *report_resp;
 	struct snp_guest_req req = {};
@@ -497,6 +499,10 @@ static int get_ext_report(struct snp_gue
 	if (sockptr_is_null(io->req_data) || sockptr_is_null(io->resp_data))
 		return -EINVAL;
 
+	report_req = kzalloc(sizeof(*report_req), GFP_KERNEL_ACCOUNT);
+	if (!report_req)
+		return -ENOMEM;
+
 	if (copy_from_sockptr(report_req, io->req_data, sizeof(*report_req)))
 		return -EFAULT;
 


