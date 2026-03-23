Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0791133CE9A;
	Mon, 23 Mar 2026 14:44:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774277066; cv=none; b=UJgMMTJirdRzgdFL5cAEUc2r3F8JHGDxWcu/WXXsBy7KvetNnouFeHPmeUoWtqFqfOv7l+oIZ5HP0pwh3xDJEuLfdx10u9yJVVn/dXBFJtb+MWx2NrfiajeIA7suT9Jo6BuAILTZl6sDeZr490xqN4h/n91rJyU9RMKBHMXhauI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774277066; c=relaxed/simple;
	bh=rMjDvjNuXTxCXlKP8HyA+rWF+DSX1KXdZa88VSNJFBk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ufwzTc3NPtVjatafHZsKlzFkjNHlhUsdvX6SXEVHFrnWLXOI6SDqtd1cIdJiLSKQca9zt1NRP6F2v1AGeF47aCttjd4oci1WwmOIXIFX9vpnsIjEpF4AFLlmwogVhgC0YP6aRAxoLgJZwD5lD3Jvcsu49eQBlGa6T9x0HC+pczI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yr3Ge8th; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yr3Ge8th"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95635C4CEF7;
	Mon, 23 Mar 2026 14:44:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774277065;
	bh=rMjDvjNuXTxCXlKP8HyA+rWF+DSX1KXdZa88VSNJFBk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yr3Ge8th+mgvoM0bbLJ8PjXzcNNrH8u2hK30x1oId5Kn8FTVdxfB1vCTaBHWEDdp8
	 k14dCMyrcw37fKRGSDZipH+EsvWflGaWRIuFkJ3xldmNStWrHVpeQeFtcjxPWU/boD
	 5cA1FKJGfhHkfC2t7Yv8RCclUPBsmwGQvstEi5Xw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Jiri Kosina <jkosina@suse.com>,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Benjamin Tissoires <bentiss@kernel.org>
Subject: [PATCH 6.12 308/460] selftests/hid: fix compilation when bpf_wq and hid_device are not exported
Date: Mon, 23 Mar 2026 14:45:04 +0100
Message-ID: <20260323134534.061719162@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134526.647552166@linuxfoundation.org>
References: <20260323134526.647552166@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Tissoires <bentiss@kernel.org>

commit 5d4c6c132ea9a967d48890dd03e6a786c060e968 upstream.

This can happen in situations when CONFIG_HID_SUPPORT is set to no, or
some complex situations where struct bpf_wq is not exported.

So do the usual dance of hiding them before including vmlinux.h, and
then redefining them and make use of CO-RE to have the correct offsets.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202603111558.KLCIxsZB-lkp@intel.com/
Fixes: fe8d561db3e8 ("selftests/hid: add wq test for hid_bpf_input_report()")
Cc: stable@vger.kernel.org
Acked-by: Jiri Kosina <jkosina@suse.com>
Reviewed-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Signed-off-by: Benjamin Tissoires <bentiss@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/hid/progs/hid_bpf_helpers.h |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/tools/testing/selftests/hid/progs/hid_bpf_helpers.h
+++ b/tools/testing/selftests/hid/progs/hid_bpf_helpers.h
@@ -6,8 +6,10 @@
 #define __HID_BPF_HELPERS_H
 
 /* "undefine" structs and enums in vmlinux.h, because we "override" them below */
+#define bpf_wq bpf_wq___not_used
 #define hid_bpf_ctx hid_bpf_ctx___not_used
 #define hid_bpf_ops hid_bpf_ops___not_used
+#define hid_device hid_device___not_used
 #define hid_report_type hid_report_type___not_used
 #define hid_class_request hid_class_request___not_used
 #define hid_bpf_attach_flags hid_bpf_attach_flags___not_used
@@ -24,8 +26,10 @@
 
 #include "vmlinux.h"
 
+#undef bpf_wq
 #undef hid_bpf_ctx
 #undef hid_bpf_ops
+#undef hid_device
 #undef hid_report_type
 #undef hid_class_request
 #undef hid_bpf_attach_flags
@@ -52,6 +56,14 @@ enum hid_report_type {
 	HID_REPORT_TYPES,
 };
 
+struct hid_device {
+	unsigned int id;
+} __attribute__((preserve_access_index));
+
+struct bpf_wq {
+	__u64 __opaque[2];
+};
+
 struct hid_bpf_ctx {
 	struct hid_device *hid;
 	__u32 allocated_size;


