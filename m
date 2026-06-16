Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3675446AF1D;
	Tue, 16 Jun 2026 16:25:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781627139; cv=none; b=At7ypPNCouRKPMN1qD/FVtyeA5KrkTNYF7G90y4hLjAKmEQKJ3mTewqemzN0FrF5sDBvX64/Nnf6zXloWgNWyigv2e/sEOeQ7oRwJAJZtZC5lMyPyXgU3D6G7fPQ9xBqErgbvGn5WvINDmfrPn6Nl3zy0FZbqozXIQZyvMG5wVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781627139; c=relaxed/simple;
	bh=m1tVhkoeSINQVe97koRWqn1ML+/3WXPT2I9fPpu4oUI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OB9QaDNm1P+bvBPiZJeMY0xkRlkoTUTLGela2lMeFUb0PzF1Q9evcKb6sd8cML9l3J6b1Q2MK5MOIjPxx19XfKT6yYI2RF09nM2/Nm2OwHWMCQYf+6Jk0glyzvS0jKDEhleWp3qVwBL2edAI0Wziz+jb/u6AisTXWyVrLbCd9ig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JQ3cDF7M; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JQ3cDF7M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D5451F000E9;
	Tue, 16 Jun 2026 16:25:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781627137;
	bh=bNu9vumZaViLEyH49u/xbqD9Y+rHjVbw2Mx8ulM/zE8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JQ3cDF7MCk99kn73hdKJrQCWo4DerIbZyS/lMuzBvLVC9t30eKutB59kLQI2yT1TX
	 IFU+PJaY0xYlNXL3K3abbEQ3VrEbDC/2HyuBGfoA0uBIIUc3oNaXLSWKrrwNLvK8m5
	 jOwQgVewCqbI1MEHAp07gOmmNn7Q75azJQSJ4WsU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrzej Kacprowski <andrzej.kacprowski@linux.intel.com>,
	Karol Wachowski <karol.wachowski@linux.intel.com>
Subject: [PATCH 6.12 125/261] accel/ivpu: Add bounds checks for firmware log indices
Date: Tue, 16 Jun 2026 20:29:23 +0530
Message-ID: <20260616145050.872498239@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145044.869532709@linuxfoundation.org>
References: <20260616145044.869532709@linuxfoundation.org>
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
 drivers/accel/ivpu/ivpu_fw_log.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/accel/ivpu/ivpu_fw_log.c b/drivers/accel/ivpu/ivpu_fw_log.c
index 337c906b0210..275baf844b56 100644
--- a/drivers/accel/ivpu/ivpu_fw_log.c
+++ b/drivers/accel/ivpu/ivpu_fw_log.c
@@ -98,6 +98,11 @@ static void fw_log_print_buffer(struct vpu_tracing_buffer_header *log, const cha
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
-- 
2.54.0



