Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DFD4470EB6;
	Thu, 17 Sep 2026 18:49:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789670969; cv=none; b=HubbnotxZVBo2a2+eblVfhubX5hIZ6xQjBXkzf1jS9wZfnJyAkCbPSp/n1Vm2y0dw46PIoXX9iPGgok/GHmZy8I/HftAqWMA434hvJ4U9Iazgu5RYcqaOr0CHBZjzZd/A9DkTJ2Petnl3q3kkdNd+0nTD7MRNp9sF1MJ3OzRSOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789670969; c=relaxed/simple;
	bh=qhhnnrkw3XDpE3wvxllzmZYfnmMI0zOT9mDJrwFu8pE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ra+MMamfCxkevLa5BBDVv07faIL7kpqhY5EeyhCVrJt0jI6MJjStS0jHzGTxzH2b1Rqj8UGrDBCsPiPXxm2WG7xwpR/KaKIJm6vW3xrTFkoPWzYwbDVFMvVnnxSFeIzyndisoInC3t8S7tc/3RKsL8BxNzkT8psVn5pUYGwhf64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=egD7v2Wt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="egD7v2Wt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6C391F00893;
	Thu, 17 Sep 2026 18:49:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789670968;
	bh=W7oIIa2tr/WG9hf8ccKe+PUkmxg+v6Ql1VcLic51TxQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=egD7v2WtqHQm1RgiCQ67Gd0fML5LVROAiskH0jcv1GDuA+ii6KppW1P0rhtY4oUfb
	 kCBnBZ6wnwxM7nrwCpjLxWW6ODqB+d/CyL0uKlFwqVS0g64wvuQXIoY1ciqXRta+O3
	 gUbBn23iq0yn68z5jlgDRiPk2P+z3Ipk3OThTFYo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Dawid Osuchowski <dawid.osuchowski@linux.intel.com>,
	Karol Wachowski <karol.wachowski@linux.intel.com>
Subject: [PATCH 6.12 0827/1102] accel/ivpu: Limit firmware log name prints to field size
Date: Thu, 17 Sep 2026 16:12:50 +0100
Message-ID: <20260917151601.271567454@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

From: Dawid Osuchowski <dawid.osuchowski@linux.intel.com>

commit 95bf070f3225dc7175725438c916ad321d42fe45 upstream.

The name in struct vpu_tracing_buffer_header is a fixed-size array
populated by the NPU firmware. It is expected to be NUL-terminated,
but nothing on the host side enforces this, so printing it with an
unbounded string conversion would read past the field if the
terminator is ever missing and expose adjacent bytes of the shared
tracing BO through dmesg and the debugfs FW log output.

Print at most as many characters as the name field holds, so the output
never runs past it even if the string is not NUL-terminated.

Cc: stable@vger.kernel.org
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260827102339.281799-1-dawid.osuchowski@linux.intel.com?part=2
Fixes: d4e4257afa6e ("accel/ivpu: Add firmware tracing support")
Signed-off-by: Dawid Osuchowski <dawid.osuchowski@linux.intel.com>
Reviewed-by: Karol Wachowski <karol.wachowski@linux.intel.com>
Signed-off-by: Karol Wachowski <karol.wachowski@linux.intel.com>
Link: https://patch.msgid.link/20260901125749.404338-4-dawid.osuchowski@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/accel/ivpu/ivpu_fw_log.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

--- a/drivers/accel/ivpu/ivpu_fw_log.c
+++ b/drivers/accel/ivpu/ivpu_fw_log.c
@@ -69,9 +69,9 @@ static int fw_log_from_bo(struct ivpu_de
 	*offset += size;
 
 	ivpu_dbg(vdev, FW_BOOT,
-		 "FW log name \"%s\", write offset 0x%x size 0x%x, wrap count %d, hdr version %d size %d format %d, alignment %d",
-		 log->name, log->write_index, size, log->wrap_count, log->header_version,
-		 header_size, log->format, log->alignment);
+		 "FW log name \"%.*s\", write offset 0x%x size 0x%x, wrap count %d, hdr version %d size %d format %d, alignment %d",
+		 (int)ARRAY_SIZE(log->name), log->name, log->write_index, size, log->wrap_count,
+		 log->header_version, header_size, log->format, log->alignment);
 
 	return 0;
 }
@@ -123,7 +123,8 @@ static void fw_log_print_buffer(struct i
 
 	if (log->wrap_count == log->read_wrap_count) {
 		if (log_end <= log_start) {
-			drm_printf(p, "==== %s \"%s\" log empty ====\n", prefix, log->name);
+			drm_printf(p, "==== %s \"%.*s\" log empty ====\n", prefix,
+				   (int)ARRAY_SIZE(log->name), log->name);
 			return;
 		}
 	} else if (log->wrap_count == log->read_wrap_count + 1) {
@@ -133,7 +134,8 @@ static void fw_log_print_buffer(struct i
 		log_start = log_end;
 	}
 
-	drm_printf(p, "==== %s \"%s\" log start ====\n", prefix, log->name);
+	drm_printf(p, "==== %s \"%.*s\" log start ====\n", prefix, (int)ARRAY_SIZE(log->name),
+		   log->name);
 	if (log_end > log_start) {
 		fw_log_print_lines(log_data + log_start, log_end - log_start, p);
 	} else {
@@ -141,7 +143,8 @@ static void fw_log_print_buffer(struct i
 		fw_log_print_lines(log_data, log_end, p);
 	}
 	drm_printf(p, "\n\x1b[0m"); /* add new line and clear formatting */
-	drm_printf(p, "==== %s \"%s\" log end   ====\n", prefix, log->name);
+	drm_printf(p, "==== %s \"%.*s\" log end   ====\n", prefix, (int)ARRAY_SIZE(log->name),
+		   log->name);
 }
 
 static void


