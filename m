Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056498;
	b=QjsFLRK/yR+h7gpb5zamD6Nk7r5GonOgoiPzO1ypTBijrmxxfkpSeWHwYjgViBKfDd2B
	 5fwhp4jD7gnjucmNAIO9iyXFF4hO6KXqFPeeqbzHNhrMuXqRAKCOi6be8hPnOAurT9cvy
	 tgnjOtjd4JT86JLtBT3QRFDk6TC8SyE1m9gCO+ucMXZiRCSkLejqXHhGfvjLjaBnKXvxp
	 f8Jh15jyVXzfJ8rasRB1Pwevb4IDjX5O3PrrR5K0i+Q+IGnwsODraTrQBu1YnMYYHKvmg
	 jiOR19tWQ8oSI/6m5B6d2jS6352Rmd/K97Z8fnFdG31fimCsCnNaY20632kAvccLvlA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056498;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NAjTisuwySTOeXhhZ9mEgVdlslU7wVT12UAjD5xB2ug=;
	b=TyW0Ol7QwdAvx/sInS/SIL6m6IVHND2qlhLT/wYdY9BQUK1i/bi2StigC7VovqG4xT1d
	 PWwbz00nd2LbSEAhSf6SO8NlIDFz+LUw+yRto0KfUfr0TPKyygMfvB+kT5xLxDonrnBX+
	 EDcGiFI8IH1lJ/sB+JIRtnRcFapFHhC940NKZU711/H8MSCXhGzCL2EJ36c8FHoUtL+I7
	 IDGtpqmQSRBjMLE/kHHNqqlCjsRE3s2zFK2HX526SSO09hGywOtCfnRn4VgNr9a4nDBnD
	 xooisNWczapShCIosLelMAcFSznzXtaoH39n47MYNiaotzlu5DMi+HnSUYy39verMlw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DnEt636d;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB43260A2601;
	Thu, 19 Nov 2026 02:48:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DnEt636d
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 407271F000C6;
	Thu, 19 Nov 2026 02:48:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056498;
	bh=NAjTisuwySTOeXhhZ9mEgVdlslU7wVT12UAjD5xB2ug=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DnEt636dQ1njtFGzEWqaPjJ3ERKHk+zs1ZCcpVD9gqCuxsQHaGUWXjSweksC48R3O
	 Nzv0iBbcpY4uf2Am2NHTfcpa345gsarHP/E0AoKO33mcmnCSdg27qPKBm9l4D8UMbV
	 6n2mI3ptMPID2VPIqzadevRnAzzynxhK9Qn1y8As=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fabrice Derepas <fabrice.derepas@canonical.com>,
	Mimi Zohar <zohar@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 2010/2214] ima: reject a kexec buffer whose declared size exceeds the buffer
Date: Wed, 18 Nov 2026 16:01:26 +0100
Message-ID: <20261118150131.152745583@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 31a8388e3dfae..3d2e6810c10df 100644
--- a/security/integrity/ima/ima_template.c
+++ b/security/integrity/ima/ima_template.c
@@ -445,6 +445,11 @@ int ima_restore_measurement_list(loff_t size, void *buf)
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



