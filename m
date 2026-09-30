Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8809A4F7CCF;
	Wed, 30 Sep 2026 17:23:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790788989; cv=none; b=qjqUZBk2MwE/PnwBq1G7bpf06Wzktd6N4blOkxjphepval5k+PCHH7SnVwb7g2vmP9GbJAO0gy2PkaTPzcEkEmVhFKMwYNkcVBDnVtdq7rA/tuVyRUCIbjADWbENDMGQ6uqxRJiaoel8WJphKNGLDAAHpWBSEiE0Hu+86ZAv540=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790788989; c=relaxed/simple;
	bh=iUd9Ujiypy4n89uc9nQ0Wl+a1WCiKZTe/Ixlq7jmwkM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PpvUvr5jBo8Lz177owQAVZyWKHSkgVhTqAoH8sHc8MF51yCxPEfUEMNTN6RwhYFMKkmE/bA2QNbpgmlf+uz8syr4aV36+rcASw85Cn82SON5W8A1VXveY3QrhdKrouHU+kLnkBgPxSe7q53xRoO1e1rtQdyOZuvzfEiuRHNkC+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Oh56qS8b; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Oh56qS8b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E35811F000FF;
	Wed, 30 Sep 2026 17:23:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790788988;
	bh=6AlqalGIChc7Vlb6x02IkZY1MKukgdbs4xmH3WyoXX4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Oh56qS8bAtU8okUtUhWdM3LM98f0rgf9f1srK54qFA3XMvFxhgXwVqSdF9lb6iGo/
	 AyXtrFlI3/+zVYjWmYdpHiJxsbAmlmXGzOZSeY4YvW+ybTz2Mz5kbjKWXU2XQSStZS
	 cjrW/3kwcaUh6ZEhQivDM6Os8T/kDxGTQ08rXWhE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Tissoires <bentiss@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 320/877] HID: bpf: fix __hid_bpf_hw_check_params report length
Date: Wed, 30 Sep 2026 17:20:31 +0200
Message-ID: <20260930152421.591892255@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

From: Benjamin Tissoires <bentiss@kernel.org>

[ Upstream commit c4afa4862b878d56e0cc1021298794ac1b45bc49 ]

Turns out that USB, I2C and other transport drivers (except uhid which
just passes the data) still need to have the report ID in the first
byte.

Because they expect the first byte to be the report ID or 0, when the
report ID is 0, they strip that first byte before forwarding to the
device. This means that the transport layer forwards a buffer of size
N-1 to the device, which gets rejected.

Fixes: 5599f8019661 ("HID: bpf: export hid_hw_output_report as a BPF kfunc")
Signed-off-by: Benjamin Tissoires <bentiss@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/bpf/hid_bpf_dispatch.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/hid/bpf/hid_bpf_dispatch.c b/drivers/hid/bpf/hid_bpf_dispatch.c
index 1de6a7e0af7b4..a421fecce9dd1 100644
--- a/drivers/hid/bpf/hid_bpf_dispatch.c
+++ b/drivers/hid/bpf/hid_bpf_dispatch.c
@@ -359,7 +359,7 @@ hid_bpf_release_context(struct hid_bpf_ctx *ctx)
 
 static int
 __hid_bpf_hw_check_params(struct hid_bpf_ctx *ctx, __u8 *buf, size_t *buf__sz,
-			  enum hid_report_type rtype)
+			  enum hid_report_type rtype, bool hw_request)
 {
 	struct hid_report_enum *report_enum;
 	struct hid_report *report;
@@ -391,6 +391,10 @@ __hid_bpf_hw_check_params(struct hid_bpf_ctx *ctx, __u8 *buf, size_t *buf__sz,
 
 	report_len = hid_report_len(report);
 
+	/* unnumbered reports need to have a report ID reserved in the first byte */
+	if (hw_request && report_enum->numbered == 0)
+		report_len += 1;
+
 	if (*buf__sz > report_len)
 		*buf__sz = report_len;
 
@@ -424,7 +428,7 @@ hid_bpf_hw_request(struct hid_bpf_ctx *ctx, __u8 *buf, size_t buf__sz,
 		return -EDEADLOCK;
 
 	/* check arguments */
-	ret = __hid_bpf_hw_check_params(ctx, buf, &size, rtype);
+	ret = __hid_bpf_hw_check_params(ctx, buf, &size, rtype, true);
 	if (ret)
 		return ret;
 
@@ -487,7 +491,7 @@ hid_bpf_hw_output_report(struct hid_bpf_ctx *ctx, __u8 *buf, size_t buf__sz)
 		return -EDEADLOCK;
 
 	/* check arguments */
-	ret = __hid_bpf_hw_check_params(ctx, buf, &size, HID_OUTPUT_REPORT);
+	ret = __hid_bpf_hw_check_params(ctx, buf, &size, HID_OUTPUT_REPORT, true);
 	if (ret)
 		return ret;
 
@@ -515,7 +519,7 @@ __hid_bpf_input_report(struct hid_bpf_ctx *ctx, enum hid_report_type type, u8 *b
 		return -EDEADLOCK;
 
 	/* check arguments */
-	ret = __hid_bpf_hw_check_params(ctx, buf, &size, type);
+	ret = __hid_bpf_hw_check_params(ctx, buf, &size, type, false);
 	if (ret)
 		return ret;
 
-- 
2.53.0



