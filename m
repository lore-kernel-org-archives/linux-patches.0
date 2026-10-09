Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A43A01799F;
	Fri,  9 Oct 2026 14:18:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791555520; cv=none; b=n9wnvQUoFefUC5ntDXa9yFBo4GSSfS8jLHfZ86hgSpdN3sGGFsuka5XoonKrO0y18MMyhCpphpYhe9xw/0kgfJ3M+K6BHimhNdjllJMtG6nvf1fDT8Er8/rrO3B9/7Xvw+lSchTCLSKk8950d0B4ziFTxivUF3d0K79MWTnAkzs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791555520; c=relaxed/simple;
	bh=76Mv2Rctknkq2cyAv6zRQxMCCrQOrsvNogkyxN+UDyk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QidBLwtq2WHRVOwo3n9354zM2ZGRnsfAnOjzidmCp7ElU29hQ+7jm0bN0sf/nmddsu4Z+uNVygH6U0NPf8zZ7U473aZwGCzklscLJ0ho08OlfPde5cd3xszYSiYWSPH5sHmsB4w8esPfnfGpIuDus9zwjutcOH6DocoaGU6fJa8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P63BxOOk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P63BxOOk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F37091F00898;
	Fri,  9 Oct 2026 14:18:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791555519;
	bh=plO2jPSFODS/o0JLKKjpvZSXJjY158i7kk/ONgohDoA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P63BxOOk0zxHw8M66hxLitSw9OlXSl8PAIEUGWCevGAj2nrad8ooRjesiB5LpaXUw
	 q+2CN25O9PI1FHOPHjJXFhjuD/2e43QP3U/v8m82OvDZyOHlQT0P91ZtEUnylPgnjG
	 GwlwavfqCZdb2WY5Cfcfjuk9hNq1hOk/SQXJKZYQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiri Kosina <jkosina@suse.com>,
	Benjamin Tissoires <bentiss@kernel.org>
Subject: [PATCH 7.2 022/428] HID: bpf: cast size to ssize_t when checking hid_bpf_hw_request
Date: Fri,  9 Oct 2026 16:05:59 +0200
Message-ID: <20261009140946.548983504@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -453,7 +453,7 @@ hid_bpf_hw_request(struct hid_bpf_ctx *c
 					      (u64)(long)ctx,
 					      true); /* prevent infinite recursions */
 
-	if (ret > size)
+	if (ret > (ssize_t)size)
 		ret = size;
 	if (ret > 0)
 		memcpy(buf, dma_data, ret);


