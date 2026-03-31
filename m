Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B70A3016EE;
	Tue, 31 Mar 2026 17:06:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774976815; cv=none; b=GQuM5KByvAv3JnYWahl1+KFVgsBlkAFyzaAsDW82o1GVu5UkA4Wf/OKY32b3SfYn7ZV9dv07jF1Qp+L6x8wcWWPHmrgZrxyRfm2dWiCDThzZlM2qcwTTx4cjO3u//isBiZ+PmDyPKqmuvWaDcZcV1gITs4N04wtH820oKNWL3to=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774976815; c=relaxed/simple;
	bh=9DJYOPGs3iFof8TgVhpTRBzbT9XP0vs3NHAZZdpyh24=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OxapsdiTSpNzLzM9FH6R1mIg4v6CSmofKlC1cMJzGT9dUtQeIvp5oIe+fuW1hC3qoB+NOYUwgNLGX9q05PfPyA8x1Q2fDE4t02arv/+OQVS9kyLsI9+3xcmJWFGuNYKwhVk7wKW5rLxnBxtXpEoMAKCpnraILttANiPe2+TzbLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Nkha4swV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Nkha4swV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2B84C19423;
	Tue, 31 Mar 2026 17:06:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774976815;
	bh=9DJYOPGs3iFof8TgVhpTRBzbT9XP0vs3NHAZZdpyh24=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Nkha4swVQyRAtFs44jmCQeCt55bUuyW00SOeWC/3ghbZCI0w7qKZHswGZmKkA5Z4Q
	 4fNfmbGwGgGuitJCIfl48aHI41k4i+OB9xI8wr1L6Yb5syfRZoFQlrxYkyJPRUnsG3
	 sz1pyhrdOKDB2TAwVLe2GfXD+iCgEL2dkC+T0bxM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zubin Mithra <zsm@google.com>,
	Dan Williams <dan.j.williams@intel.com>,
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>,
	Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
Subject: [PATCH 6.18 206/309] virt: tdx-guest: Fix handling of host controlled quote buffer length
Date: Tue, 31 Mar 2026 18:21:49 +0200
Message-ID: <20260331161801.034019919@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161753.468533260@linuxfoundation.org>
References: <20260331161753.468533260@linuxfoundation.org>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/virt/coco/tdx-guest/tdx-guest.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

--- a/drivers/virt/coco/tdx-guest/tdx-guest.c
+++ b/drivers/virt/coco/tdx-guest/tdx-guest.c
@@ -169,6 +169,8 @@ static void tdx_mr_deinit(const struct a
 #define GET_QUOTE_SUCCESS		0
 #define GET_QUOTE_IN_FLIGHT		0xffffffffffffffff
 
+#define TDX_QUOTE_MAX_LEN		(GET_QUOTE_BUF_SIZE - sizeof(struct tdx_quote_buf))
+
 /* struct tdx_quote_buf: Format of Quote request buffer.
  * @version: Quote format version, filled by TD.
  * @status: Status code of Quote request, filled by VMM.
@@ -267,6 +269,7 @@ static int tdx_report_new_locked(struct
 	u8 *buf;
 	struct tdx_quote_buf *quote_buf = quote_data;
 	struct tsm_report_desc *desc = &report->desc;
+	u32 out_len;
 	int ret;
 	u64 err;
 
@@ -304,12 +307,17 @@ static int tdx_report_new_locked(struct
 		return ret;
 	}
 
-	buf = kvmemdup(quote_buf->data, quote_buf->out_len, GFP_KERNEL);
+	out_len = READ_ONCE(quote_buf->out_len);
+
+	if (out_len > TDX_QUOTE_MAX_LEN)
+		return -EFBIG;
+
+	buf = kvmemdup(quote_buf->data, out_len, GFP_KERNEL);
 	if (!buf)
 		return -ENOMEM;
 
 	report->outblob = buf;
-	report->outblob_len = quote_buf->out_len;
+	report->outblob_len = out_len;
 
 	/*
 	 * TODO: parse the PEM-formatted cert chain out of the quote buffer when


