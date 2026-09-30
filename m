Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C42A514753;
	Wed, 30 Sep 2026 18:26:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790792813; cv=none; b=EFHIccq46cSt1PKYFPdi4eH0HJPiRapZDO3qeorUTSTUpM5NXmXFjl74j78xmTmkoQENaoGcDSDU618g6/HdcuFXF3iKBj4G0Vuchay+WXYjClf9I56o2rugkL5rRewXBTV8CHTDZ+qmrjkR80LclM7X1ab1thurEznZLr3nUGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790792813; c=relaxed/simple;
	bh=GgvMFkgC4oF4hnoI+5xlg3QsMlp6u7FQnqdeKHPPvVY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B9WLFnmS6f1WfHDiYFGR/pF0Z+o+u9mbABqLpWCexJi6Ehi+S9oAQkVijOD9ti0NVLZlFtfnslMytS/AlMab3KmoSu0la2qZrmk8GdHOxJYBaAbpDZEhzwRT9rhSwkf1OukIRp4dQcKjeXVbAmvHXyiWVcee/STKTldgeGuuj24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mWXprLSo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mWXprLSo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1C811F00898;
	Wed, 30 Sep 2026 18:26:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790792812;
	bh=dzvfXikJhKwQ1cjalc3C5FgmuRi4d9NDyuQI3CVfvPI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mWXprLSo6tuuWBUE3anLbgRN4cTkoBehopUBEeiOOlu6pEDusfhqThpgrRenOk8D9
	 Sovh+hy5NHl1RYAhT/RNga6ZrGif9eWe3tLc0OfUlzrtj6KscKF/yiLiLNlLlucKBH
	 3mYp72xfv61Lg8AdN5kHuURPUYC1fbqamaqMnhaY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Tissoires <bentiss@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 027/395] HID: bpf: fix __hid_bpf_hw_check_params report length
Date: Wed, 30 Sep 2026 17:24:49 +0200
Message-ID: <20260930152341.207565997@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152340.591469096@linuxfoundation.org>
References: <20260930152340.591469096@linuxfoundation.org>
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
index e6cf551b41e8e..9fbbf59cefa16 100644
--- a/drivers/hid/bpf/hid_bpf_dispatch.c
+++ b/drivers/hid/bpf/hid_bpf_dispatch.c
@@ -362,7 +362,7 @@ hid_bpf_release_context(struct hid_bpf_ctx *ctx)
 
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
 
@@ -423,7 +427,7 @@ hid_bpf_hw_request(struct hid_bpf_ctx *ctx, __u8 *buf, size_t buf__sz,
 		return -EDEADLOCK;
 
 	/* check arguments */
-	ret = __hid_bpf_hw_check_params(ctx, buf, &size, rtype);
+	ret = __hid_bpf_hw_check_params(ctx, buf, &size, rtype, true);
 	if (ret)
 		return ret;
 
@@ -483,7 +487,7 @@ hid_bpf_hw_output_report(struct hid_bpf_ctx *ctx, __u8 *buf, size_t buf__sz)
 		return -EDEADLOCK;
 
 	/* check arguments */
-	ret = __hid_bpf_hw_check_params(ctx, buf, &size, HID_OUTPUT_REPORT);
+	ret = __hid_bpf_hw_check_params(ctx, buf, &size, HID_OUTPUT_REPORT, true);
 	if (ret)
 		return ret;
 
@@ -509,7 +513,7 @@ __hid_bpf_input_report(struct hid_bpf_ctx *ctx, enum hid_report_type type, u8 *b
 		return -EDEADLOCK;
 
 	/* check arguments */
-	ret = __hid_bpf_hw_check_params(ctx, buf, &size, type);
+	ret = __hid_bpf_hw_check_params(ctx, buf, &size, type, false);
 	if (ret)
 		return ret;
 
-- 
2.53.0



