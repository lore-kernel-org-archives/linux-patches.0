Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 921641A682B;
	Tue, 16 Jun 2026 15:27:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781623630; cv=none; b=M9Nd0wGCkSbds69eu9C/qL6rACShh4Sm3mdxKgk1dYGHzwDQtQeeJrZcUP3pqacc6RySwddPOc4qilcyasendGqho1GcfM75OWjUEdlWFXrmTUZX+xlbHlH3xbX5ENUtkywUFfBXDDft+4D6SO0kzPFB49alvidM9gE2dvMbiZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781623630; c=relaxed/simple;
	bh=iAvno3QvKiFhxvZeGa1zFeD9w9T2G/zLSJbkpb7QvO0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mJGmutZxgHSdHrQZv8LnXpA5OICcx+U7hnHbvEIlOlc8TfNbLSKyf36xmVtGg8Gj/Cvgbq66UCx39nn5/BhExjKMTY/m9AiCrpLXBXIV5MTvU519BacI+Q1/H2sfEk+HeF1/c6beyCDfwzhxhTcqx78scHcGlSmatUva5q8DXSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oq97h7DH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oq97h7DH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 660EB1F000E9;
	Tue, 16 Jun 2026 15:27:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781623629;
	bh=8YMGb7Mbmo6vTaGX0/GM7b8k1ngEIaISIV+tv3t5Lwo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oq97h7DHnWHD+ZaZzts6c8omZte9G2HVOi+BAs47SlszgAhrYan19eFeqD2Rjb8Vn
	 kKUYFIfnhzT++gfRJaw/achSeeUext1ty0nErepq8dNYg2RoHRq7YIFKLCh2Byf+C5
	 s1BynaxqwPHbTmgbl9rnn3a6ht0zdRrMvmiXY0XA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrzej Kacprowski <andrzej.kacprowski@linux.intel.com>,
	Karol Wachowski <karol.wachowski@linux.intel.com>
Subject: [PATCH 7.0 178/378] accel/ivpu: Add bounds checks for firmware log indices
Date: Tue, 16 Jun 2026 20:26:49 +0530
Message-ID: <20260616145119.752063585@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145109.744539446@linuxfoundation.org>
References: <20260616145109.744539446@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrzej Kacprowski <andrzej.kacprowski@linux.intel.com>

commit dd1311bcf0e62f0c515115f46a3813370f4a4bb1 upstream.

Add validation that read and write indices in the firmware log buffer
are within valid bounds (< data_size) before using them. If
out-of-bounds indices are encountered (from firmware), clamp them to
safe values instead of proceeding with invalid offsets.

This prevents potential out-of-bounds buffer access when firmware
supplies invalid log indices.

Fixes: 1fc1251149a7 ("accel/ivpu: Refactor functions in ivpu_fw_log.c")
Cc: stable@vger.kernel.org # v6.18+
Signed-off-by: Andrzej Kacprowski <andrzej.kacprowski@linux.intel.com>
Reviewed-by: Karol Wachowski <karol.wachowski@linux.intel.com>
Signed-off-by: Karol Wachowski <karol.wachowski@linux.intel.com>
Link: https://patch.msgid.link/20260529115842.135378-1-andrzej.kacprowski@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/accel/ivpu/ivpu_fw_log.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/accel/ivpu/ivpu_fw_log.c
+++ b/drivers/accel/ivpu/ivpu_fw_log.c
@@ -98,6 +98,11 @@ static void fw_log_print_buffer(struct v
 	u32 log_start = only_new_msgs ? READ_ONCE(log->read_index) : 0;
 	u32 log_end = READ_ONCE(log->write_index);
 
+	if (log_start >= data_size)
+		log_start = 0;
+	if (log_end > data_size)
+		log_end = data_size;
+
 	if (log->wrap_count == log->read_wrap_count) {
 		if (log_end <= log_start) {
 			drm_printf(p, "==== %s \"%s\" log empty ====\n", prefix, log->name);


