Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A25293EF0A2;
	Tue, 31 Mar 2026 16:56:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774976199; cv=none; b=RVuvtfzG/FLmym6H1d+sUr6uGhd1eFFddlLlcpnmaktAvSt9VQa0SntMUmd3bIuuuXkqSjqqUSghxdrL7Cfeibi2yPoybcmAI+B2Jw8YlXI74Be/JEK6/rteArGbOGH7ENI2Amunvqio16DCu2Ve2fkYw6M69/4yUECT6i7Df4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774976199; c=relaxed/simple;
	bh=z2FObEen1Ipuf1YPj0BJaCfLY+bu1ZOzgevmOBxB2yo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=av3FkiA0xGHGQaEcyFvbJvlVRNNQ77r9N9xlR7GxeINKYu/iKf864RjuyNLMw368A9AxtrlWfyNZkcrhjkjFl5zAdyz7MySocvzRXXjhnUBz0vmAQkeFHgbHqR3hF6YvYLckgxsnJrr/SYb8Uai6deJ6fEQNttzAu810Rl3pVoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VfZTsxLm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VfZTsxLm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37B76C2BCB4;
	Tue, 31 Mar 2026 16:56:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774976199;
	bh=z2FObEen1Ipuf1YPj0BJaCfLY+bu1ZOzgevmOBxB2yo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VfZTsxLmtIUWdupMMKS3L++cMg/r3x2qUPPSgWeYPQrU5latdZ4hDFpRP/RuGmGo9
	 oaa/rGQq+DRVWkKOhIKKdZGEpqX/G9yA+M2sfMuQsMsDVsJFOXgY3QX1OOFr04NpMo
	 9069br/DqJV8G3cTQM99ruLuqJaE00zzS3UleNcU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zubin Mithra <zsm@google.com>,
	Dan Williams <dan.j.williams@intel.com>,
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>,
	Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
Subject: [PATCH 6.12 213/244] virt: tdx-guest: Fix handling of host controlled quote buffer length
Date: Tue, 31 Mar 2026 18:22:43 +0200
Message-ID: <20260331161749.624266154@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161741.651718120@linuxfoundation.org>
References: <20260331161741.651718120@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zubin Mithra <zsm@google.com>

commit c3fd16c3b98ed726294feab2f94f876290bf7b61 upstream.

Validate host controlled value `quote_buf->out_len` that determines how
many bytes of the quote are copied out to guest userspace. In TDX
environments with remote attestation, quotes are not considered private,
and can be forwarded to an attestation server.

Catch scenarios where the host specifies a response length larger than
the guest's allocation, or otherwise races modifying the response while
the guest consumes it.

This prevents contents beyond the pages allocated for `quote_buf`
(up to TSM_REPORT_OUTBLOB_MAX) from being read out to guest userspace,
and possibly forwarded in attestation requests.

Recall that some deployments want per-container configs-tsm-report
interfaces, so the leak may cross container protection boundaries, not
just local root.

Fixes: f4738f56d1dc ("virt: tdx-guest: Add Quote generation support using TSM_REPORTS")
Cc: stable@vger.kernel.org
Signed-off-by: Zubin Mithra <zsm@google.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Reviewed-by: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Zubin Mithra <zsm@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/virt/coco/tdx-guest/tdx-guest.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

--- a/drivers/virt/coco/tdx-guest/tdx-guest.c
+++ b/drivers/virt/coco/tdx-guest/tdx-guest.c
@@ -35,6 +35,8 @@
 #define GET_QUOTE_SUCCESS		0
 #define GET_QUOTE_IN_FLIGHT		0xffffffffffffffff
 
+#define TDX_QUOTE_MAX_LEN              (GET_QUOTE_BUF_SIZE - sizeof(struct tdx_quote_buf))
+
 /* struct tdx_quote_buf: Format of Quote request buffer.
  * @version: Quote format version, filled by TD.
  * @status: Status code of Quote request, filled by VMM.
@@ -162,6 +164,7 @@ static int tdx_report_new(struct tsm_rep
 	u8 *buf, *reportdata = NULL, *tdreport = NULL;
 	struct tdx_quote_buf *quote_buf = quote_data;
 	struct tsm_desc *desc = &report->desc;
+	u32 out_len;
 	int ret;
 	u64 err;
 
@@ -226,14 +229,21 @@ static int tdx_report_new(struct tsm_rep
 		goto done;
 	}
 
-	buf = kvmemdup(quote_buf->data, quote_buf->out_len, GFP_KERNEL);
+	out_len = READ_ONCE(quote_buf->out_len);
+
+	if (out_len > TDX_QUOTE_MAX_LEN) {
+		ret = -EFBIG;
+		goto done;
+	}
+
+	buf = kvmemdup(quote_buf->data, out_len, GFP_KERNEL);
 	if (!buf) {
 		ret = -ENOMEM;
 		goto done;
 	}
 
 	report->outblob = buf;
-	report->outblob_len = quote_buf->out_len;
+	report->outblob_len = out_len;
 
 	/*
 	 * TODO: parse the PEM-formatted cert chain out of the quote buffer when


