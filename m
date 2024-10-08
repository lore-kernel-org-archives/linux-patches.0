Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D69E21DFD1;
	Tue,  8 Oct 2024 13:04:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728392680; cv=none; b=Unyh44+2kkn/cZ4xeTQaFoHj7LE3wDv5HeK7trn5ZvxyPxCqcUyYy01J4oeoPn4ifOLB9SLKA9ByusXXUlo9kfOra4MA8X/aJ/G+CUvJK3OpaFqZ5FiQSGByXjofDGjv+1sMmqvpbSEGCDPzrg4yttA/Vk34RvZr0gQVIPX8SuY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728392680; c=relaxed/simple;
	bh=W9Dcg5rA/3vKLdffeDJKsgctEc5ARfNjtnbSwjY2xEE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y4vlyu6/zm5UUAbCbRVkDmYWVPmveI/qnjNk5osfgz40gmb9HpNRoIu14yfFWLkE3WXwCXK+riWZcuNhePIislhokjC1dwxpiT0IpI+bbxyLVsWRpK1r6YSCFcicIRKSkHHGaT1rmxrCPEq3Ty0GOvfo3Xkwz8brTS/fGIrh4Yg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=094pb1/9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="094pb1/9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58651C4CEC7;
	Tue,  8 Oct 2024 13:04:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728392680;
	bh=W9Dcg5rA/3vKLdffeDJKsgctEc5ARfNjtnbSwjY2xEE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=094pb1/9ZCp6KQf2W90N3IijVLbV2gsQm4B2LBcLFjy+sI2avhGk3lTlsEbSrqbjH
	 U1CPQ+jLpl72yDgVXJDlrmRUtVT+F3xjtWeE2ePe26fKW+MyfW0ruW0zLxe9EAPu4t
	 fAlZotguChduaHOF96J980ER7tmRQz7OC5eZ1I+Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Tissoires <bentiss@kernel.org>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 6.11 488/558] HID: bpf: fix cfi stubs for hid_bpf_ops
Date: Tue,  8 Oct 2024 14:08:38 +0200
Message-ID: <20241008115721.436678872@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Tissoires <bentiss@kernel.org>

commit acd5f76fd5292c91628e04da83e8b78c986cfa2b upstream.

With the introduction of commit e42ac1418055 ("bpf: Check unsupported ops
from the bpf_struct_ops's cfi_stubs"), a HID-BPF struct_ops containing
a .hid_hw_request() or a .hid_hw_output_report() was failing to load
as the cfi stubs were not defined.

Fix that by defining those simple static functions and restore HID-BPF
functionality.

This was detected with the HID selftests suddenly failing on Linus' tree.

Cc: stable@vger.kernel.org # v6.11+
Fixes: 9286675a2aed ("HID: bpf: add HID-BPF hooks for hid_hw_output_report")
Fixes: 8bd0488b5ea5 ("HID: bpf: add HID-BPF hooks for hid_hw_raw_requests")
Signed-off-by: Benjamin Tissoires <bentiss@kernel.org>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/bpf/hid_bpf_struct_ops.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/hid/bpf/hid_bpf_struct_ops.c b/drivers/hid/bpf/hid_bpf_struct_ops.c
index cd696c59ba0f..702c22fae136 100644
--- a/drivers/hid/bpf/hid_bpf_struct_ops.c
+++ b/drivers/hid/bpf/hid_bpf_struct_ops.c
@@ -276,9 +276,23 @@ static int __hid_bpf_rdesc_fixup(struct hid_bpf_ctx *ctx)
 	return 0;
 }
 
+static int __hid_bpf_hw_request(struct hid_bpf_ctx *ctx, unsigned char reportnum,
+				enum hid_report_type rtype, enum hid_class_request reqtype,
+				u64 source)
+{
+	return 0;
+}
+
+static int __hid_bpf_hw_output_report(struct hid_bpf_ctx *ctx, u64 source)
+{
+	return 0;
+}
+
 static struct hid_bpf_ops __bpf_hid_bpf_ops = {
 	.hid_device_event = __hid_bpf_device_event,
 	.hid_rdesc_fixup = __hid_bpf_rdesc_fixup,
+	.hid_hw_request = __hid_bpf_hw_request,
+	.hid_hw_output_report = __hid_bpf_hw_output_report,
 };
 
 static struct bpf_struct_ops bpf_hid_bpf_ops = {
-- 
2.46.2



