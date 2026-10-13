Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C27A4EC675;
	Tue, 13 Oct 2026 12:31:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894693; cv=none; b=P1+YUrtzPEOPDEC6NklXyRNYrnkp7rUuI1lW48lPp9Elmet+WoNeW3Pkp5zetNavC+JGueeqNSifnxQWmtFo/d8M+IVSQrAksyl7ukiAkMmXyW33/io1BYfapfDU3s5Goja90M3O3Tg3kISQzD4sNaxNqVblmrXAyt8EZh3VkOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894693; c=relaxed/simple;
	bh=qVlRZ3LVs6x2IXGZevZq8P7m14ZvVzAcxunPchKefBU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uJuou7WlfjpxKHppyYMNBDC959ZKlZzFs8NfRy676pLJ1tbK8aF1J1dD0wJvEEylzevYl+gqfCFGfux/c1ajPURX5BXFLZri0Udioh9A7AjBLCKYA8Oq3UpK2oJrTGrLBO6EDTj+9b2SRsdjUQGyxjI4ZUOA903I8MgXuetkFes=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A2+RRLeO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A2+RRLeO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 921B21F000FF;
	Tue, 13 Oct 2026 12:31:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791894692;
	bh=5e3UPDcW6o3Pp8WpvRKF+3pMaLRPOFEa/3Gk65MRSKs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A2+RRLeOBH1Y7ajeBdvli7Wcm50bLDwMefTh5lfx/CcCNebVs57KgAliDa6UpSjhH
	 1mRD4ixo3gJW6tX1Pi+d1XEbqQekJiXR0vEBeRtUTN0BYP6VQDDVh86FXhFAoGFDVt
	 GRaPF7rjQKaR+/FhnZ2ft1R7HQW24aQVaf//HkGk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiri Kosina <jkosina@suse.com>,
	Benjamin Tissoires <bentiss@kernel.org>
Subject: [PATCH 6.12 024/497] HID: bpf: cast size to ssize_t when checking hid_bpf_hw_request
Date: Tue, 13 Oct 2026 13:33:11 +0200
Message-ID: <20261013112908.458355670@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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

commit 3afefbfe55c2a8a0c4bdf6f4cc1f773da120027c upstream.

As reported by Sashiko:
If a transport driver encounters a hardware error and returns a negative
error code such as -EPIPE, ret is implicitly promoted to size_t when
compared against size. This causes the negative error code to evaluate
as a large positive number, making the (ret > size) condition true.

This silently converts the hardware error into a success return value
and copies the unmodified buffer back, which could leave BPF programs
operating on uninitialized or stale data.

Fix this by casting size into ssize_t to return the actual negative
error code.

Link: https://lore.kernel.org/all/20260904130354.A79471F00A3D@smtp.kernel.org/
Fixes: 2b658c1c442e ("HID: bpf: prevent buffer overflow in hid_hw_request")
Cc: stable@vger.kernel.org
Acked-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Benjamin Tissoires <bentiss@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/bpf/hid_bpf_dispatch.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/hid/bpf/hid_bpf_dispatch.c
+++ b/drivers/hid/bpf/hid_bpf_dispatch.c
@@ -459,7 +459,7 @@ hid_bpf_hw_request(struct hid_bpf_ctx *c
 					      (u64)(long)ctx,
 					      true); /* prevent infinite recursions */
 
-	if (ret > size)
+	if (ret > (ssize_t)size)
 		ret = size;
 	if (ret > 0)
 		memcpy(buf, dma_data, ret);


