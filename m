Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6614742CAF1;
	Tue, 21 Jul 2026 19:59:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784663993; cv=none; b=rwUeNiCkW7aZlb8psuK0WHIKwi9pXiHS2E5sFP9LPdYXuOYqQ01yBuJPKv5rDYPG23vGDjJrRmtK4p354gonOMN2ozsGE+DXic3Hj6clyACi8wqAtie7mSxHxxhoJCq8oavH853KwjKDyNW9H0Jp7kC0RodwRDkaCxkyMp+rOVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784663993; c=relaxed/simple;
	bh=VMFFAgz2ZIMsSQcsG/mX5tbpnY7SLW/UH6hJWvKVOsQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Iocv2MB/opvClthu/D9ZlxE+j0t43jF5hxYEHXrlaZNapgrhvmf1c08fZb1TvR3bLq/6dRwIULiuyYzLobbUesHj9m0k6oIYrEvj81icfWAzteeCk8Wo260TQy3vNFtdTf3YFkWWg2ahiV+D5z9CMXXUz+8Kw3E/k1rL/1h9PjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b4ZRE7qJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b4ZRE7qJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC28F1F000E9;
	Tue, 21 Jul 2026 19:59:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784663991;
	bh=CdsDR4GvoXPyNQHrYw2DciMV4pjNi3me8B1gskEACOM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b4ZRE7qJKU+j3fhmoYAp+td58PnQCYBOrIOa3adB5d1+OksjqRjJTcOgBY06qS6BY
	 C7y4U0MR0p7TuUVVUPx68MTWD8vm3UB+KOtc3fp0H2rsoY+yv6JNzT7sk7Fr9QfzT9
	 ECkVkWtuzEguVkJ1capwNca+VaQb3XBKvgEmCzjo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jhonraushan <raushan.jhon@gmail.com>,
	Karol Wachowski <karol.wachowski@linux.intel.com>
Subject: [PATCH 6.12 1015/1276] accel/ivpu: Reject firmware log with size smaller than header
Date: Tue, 21 Jul 2026 17:24:18 +0200
Message-ID: <20260721152508.716615080@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

From: Jhonraushan <raushan.jhon@gmail.com>

commit ddb44baed257560f192b145ed36cf8c0a412de47 upstream.

fw_log_from_bo() validates the tracing buffer header_size and that the
log fits within the BO, but never checks that log->size is at least
log->header_size. fw_log_print_buffer() then computes:

  u32 data_size = log->size - log->header_size;

which underflows to a near-U32_MAX value when firmware reports a log whose
size is smaller than its header. That huge data_size defeats the
log_start/log_end bounds clamps added by commit dd1311bcf0e6 ("accel/ivpu:
Add bounds checks for firmware log indices"), so fw_log_print_lines() reads
far past the small real data region of the BO. A size of 0 also makes
fw_log_from_bo() advance the offset by 0, causing the callers to loop
forever on the same header.

Reject logs whose size is smaller than the header (which also rejects
size == 0).

Fixes: d4e4257afa6e ("accel/ivpu: Add firmware tracing support")
Cc: stable@vger.kernel.org
Signed-off-by: Jhonraushan <raushan.jhon@gmail.com>
Reviewed-by: Karol Wachowski <karol.wachowski@linux.intel.com>
Signed-off-by: Karol Wachowski <karol.wachowski@linux.intel.com>
Link: https://patch.msgid.link/20260715074206.867712-1-raushan.jhon@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/accel/ivpu/ivpu_fw_log.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/accel/ivpu/ivpu_fw_log.c
+++ b/drivers/accel/ivpu/ivpu_fw_log.c
@@ -43,6 +43,10 @@ static int fw_log_from_bo(struct ivpu_de
 		ivpu_dbg(vdev, FW_BOOT, "Invalid header size 0x%x\n", log->header_size);
 		return -EINVAL;
 	}
+	if (log->size < log->header_size) {
+		ivpu_dbg(vdev, FW_BOOT, "Invalid log size 0x%x\n", log->size);
+		return -EINVAL;
+	}
 	if ((char *)log + log->size > (char *)ivpu_bo_vaddr(bo) + ivpu_bo_size(bo)) {
 		ivpu_dbg(vdev, FW_BOOT, "Invalid log size 0x%x\n", log->size);
 		return -EINVAL;


