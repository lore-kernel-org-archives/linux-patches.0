Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020864;
	b=BtCFvZByNQK7Hil0JkgVFB6ldE2PiwLpahDMQ0paHVolVZy0XCckX6/uUfk+k97n9Z3f
	 tFhimjKt8qlgNghPT94Ewz2Q47+c9HawUkDN9YRBKTa/QUEKcFV8eDFgf8Z3pS+u7YQID
	 EV9NdivYQltEnrISbe64UkrcDwNNMAbH8KiVumBro85Por1kkLxHdlJC92IyfS/q9WVPT
	 vWwZhC2Plt9WqY2ngz6XU5l/s0DTW3ffv9alW72UFSQPY6kbCCK0XktcJD5iVimlpJ1oK
	 nDCSOLnGTgJdz8cGKHH3W909DnjEo+ZrgxBIS7FpcRjZ4CO5rlR2sjjMBT7GzNPH3vw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020864;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ewaINX4zR1WKCvLQ/C/Dds6RKRSeqod977ECR1j47l4=;
	b=f/1m1QznJaRi1hwfFCxLROhFNeJh2TgSngl3lS0xA8v40tQ7D4agHTAg2gFuuYxcpgk6
	 UgwTssKk7aPvzk5izXZE0bu2ff5VieEUD64M7AEn+khBpNhl574zufV7Fik1ISGpCUGrI
	 +lwZf4Qb/k3+3UeWezhRd7mpPm05t4nR79lu5zxvaxj8OlD8GdZJ6DoIjHF1FZuaLTS8v
	 NbACtkpatch3022cbGchDUpQNGF/QOkfyZ+BmTV5s8hd2CVgONXtdHb/Bbu1GXmanfh5C
	 nY6ULC9NcMzUe7Bh5OVg8HPU5eo2RpY1chOfaWGkWyOv75TOdR6kbbK+ksOcnrb2kMg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FfETFH1E;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFBE3606A320;
	Wed, 18 Nov 2026 16:54:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FfETFH1E
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1A891F000C4;
	Wed, 18 Nov 2026 16:54:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020864;
	bh=ewaINX4zR1WKCvLQ/C/Dds6RKRSeqod977ECR1j47l4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FfETFH1EkKoQzYgNtg6Sz/LOTrOvQmTFXfbLIdf55DMQ3JDCdOMEUnJtgbChBPZqE
	 TQi+1STeobqZe7Shk+fw3QNqod438PyQXn5MtRL33L0xGfmb3BrfqKclIHnVR7n+Q5
	 HuzSEO/PZeKndzfL+dGd+o+MFIJiP5k5qaJZgybQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fabrice Derepas <fabrice.derepas@canonical.com>,
	Mimi Zohar <zohar@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2051/2651] ima: reject a kexec buffer whose declared size exceeds the buffer
Date: Wed, 18 Nov 2026 15:54:51 +0100
Message-ID: <20261118150359.912361121@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fabrice Derepas <fabrice.derepas@canonical.com>

[ Upstream commit ceb24c7052cc4649e3b52a51a7cca7dfe4896cec ]

ima_restore_measurement_list() parses the measurement list persisted across
kexec.  It computes the parse end directly from the blob:

	bufendp = buf + khdr->buffer_size;

khdr->buffer_size is a u64 read straight from the persisted buffer.  The
only length checks in the function are size >= sizeof(*khdr), version == 1
and count -- none relates buffer_size to size, the actual buffer size the
caller (ima_load_kexec_buffer()) obtained from the ima-kexec-buffer region.
ima_parse_buf() bounds every field read to bufendp, so a blob whose
internal buffer_size exceeds the real size makes the parse loop read past
the end of the buffer (CWE-125).

The buffer's memory range is validated against addressable RAM by
commit cbf9c4b9617b ("of: check previous kernel's ima-kexec-buffer
against memory bounds") and commit c5489d04337b ("x86/kexec: add a
sanity check on previous kernel's ima kexec buffer"), but the blob's
own declared size is never clamped to it.  Reject a buffer_size larger
than size before the loop.

This is on the boot-time kexec-restore path (__init) and the buffer comes
from the previous kernel, so triggering it requires control of the
persisted buffer; it is an out-of-bounds read only.

Fixes: 94c3aac567a9 ("ima: on soft reboot, restore the measurement list")
Assisted-by: copilot-cli:claude-opus-4-6 frama-c
Signed-off-by: Fabrice Derepas <fabrice.derepas@canonical.com>
Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/integrity/ima/ima_template.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/security/integrity/ima/ima_template.c b/security/integrity/ima/ima_template.c
index 7034573fb41e9..2467caefbd70c 100644
--- a/security/integrity/ima/ima_template.c
+++ b/security/integrity/ima/ima_template.c
@@ -450,6 +450,11 @@ int ima_restore_measurement_list(loff_t size, void *buf)
 		return -EINVAL;
 	}
 
+	if (khdr->buffer_size > size) {
+		pr_err("attempting to restore a corrupted measurement list");
+		return -EINVAL;
+	}
+
 	bitmap_zero(hdr_mask, HDR__LAST);
 	bitmap_set(hdr_mask, HDR_PCR, 1);
 	bitmap_set(hdr_mask, HDR_DIGEST, 1);
-- 
2.53.0



