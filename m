Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFB3F3A6F00;
	Sat, 17 Oct 2026 18:09:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792260593; cv=none; b=pUZCQeB0SFnTKgcP1IDkhcprx4x9P/CNzmpdq0babSJUAmSXZr+vnQhcOtKVv0/DIl1WeoWcZSpz0nnRQTYHJVgXNbum2c/lSvaoa+uvU6wpLB5nwuwJ5kYvPq6mvS1Ey5BVSbNstql/rnSNb/enyhK9l1D25bLd29X3To/Z+NM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792260593; c=relaxed/simple;
	bh=JhNE25fgrirs3SrWMssk+kARihp1xl3Hje8SNTyGdcg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H0ZrqT02vFS5hBZelAhieCWGX/pPhdsCoyPvA6ukyhd+hndi32o4E/hhlSTmi3AIIF8Ch+XBH147tpBjsT9bCcHKWvtaxHdDsc5xz8iPxZC0Qv27uCpP183TRTsaFrMJMQbv1yHBncbizTNJneQCqgxh6F2EeCUfs+PaEqc5Srs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=awcU/lWs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="awcU/lWs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 227901F000C4;
	Sat, 17 Oct 2026 18:09:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792260592;
	bh=IeArbMCUVYh1iGjkoz3rvUvh/nNQShYQbLxOgPr2Yvc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=awcU/lWs2NE+OHPiDI8z57auoy59My3r/KF8XchbMWCzZybyDzym66hnu+xnH+fEi
	 1oYP37PzpKQBIme3TGoF/gT3KQTFa3mnGq2+YKfP9B1LZnyFkwqANHqM+F9mL8M+tL
	 4qzyb6C3vgLt5F1UzS00LPO72UvWFbv5I28vAjds=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Dawid Osuchowski <dawid.osuchowski@linux.intel.com>,
	Karol Wachowski <karol.wachowski@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1597/1674] accel/ivpu: Limit firmware log name prints to field size
Date: Sat, 17 Oct 2026 18:04:29 +0200
Message-ID: <20261017160512.078319909@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dawid Osuchowski <dawid.osuchowski@linux.intel.com>

[ Upstream commit 95bf070f3225dc7175725438c916ad321d42fe45 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/accel/ivpu/ivpu_fw_log.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/accel/ivpu/ivpu_fw_log.c b/drivers/accel/ivpu/ivpu_fw_log.c
index ccad9aa99e5d6..1894ecb0237ca 100644
--- a/drivers/accel/ivpu/ivpu_fw_log.c
+++ b/drivers/accel/ivpu/ivpu_fw_log.c
@@ -56,9 +56,10 @@ static int fw_log_ptr(struct ivpu_device *vdev, struct ivpu_bo *bo, u32 *offset,
 	*offset += log->size;
 
 	ivpu_dbg(vdev, FW_BOOT,
-		 "FW log name \"%s\", write offset 0x%x size 0x%x, wrap count %d, hdr version %d size %d format %d, alignment %d",
-		 log->name, log->write_index, log->size, log->wrap_count, log->header_version,
-		 log->header_size, log->format, log->alignment);
+		 "FW log name \"%.*s\", write offset 0x%x size 0x%x, wrap count %d, hdr version %d size %d format %d, alignment %d",
+		 (int)ARRAY_SIZE(log->name), log->name, log->write_index, log->size,
+		 log->wrap_count, log->header_version, log->header_size, log->format,
+		 log->alignment);
 
 	return 0;
 }
@@ -104,11 +105,13 @@ static void fw_log_print_buffer(struct ivpu_device *vdev, struct vpu_tracing_buf
 
 	if (!(log->write_index || log->wrap_count) ||
 	    (log->write_index == log->read_index && only_new_msgs)) {
-		drm_printf(p, "==== %s \"%s\" log empty ====\n", prefix, log->name);
+		drm_printf(p, "==== %s \"%.*s\" log empty ====\n", prefix,
+			   (int)ARRAY_SIZE(log->name), log->name);
 		return;
 	}
 
-	drm_printf(p, "==== %s \"%s\" log start ====\n", prefix, log->name);
+	drm_printf(p, "==== %s \"%.*s\" log start ====\n", prefix, (int)ARRAY_SIZE(log->name),
+		   log->name);
 	if (log->write_index > log->read_index) {
 		buffer_print(log_buffer + log_start, log_end - log_start, p);
 	} else {
@@ -116,7 +119,8 @@ static void fw_log_print_buffer(struct ivpu_device *vdev, struct vpu_tracing_buf
 		buffer_print(log_buffer, log_end, p);
 	}
 	drm_printf(p, "\x1b[0m");
-	drm_printf(p, "==== %s \"%s\" log end   ====\n", prefix, log->name);
+	drm_printf(p, "==== %s \"%.*s\" log end   ====\n", prefix, (int)ARRAY_SIZE(log->name),
+		   log->name);
 }
 
 void ivpu_fw_log_print(struct ivpu_device *vdev, bool only_new_msgs, struct drm_printer *p)
-- 
2.53.0



