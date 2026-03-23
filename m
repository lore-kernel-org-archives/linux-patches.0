Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A145C33CE9A;
	Mon, 23 Mar 2026 14:44:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774277068; cv=none; b=s3jM0zmPzYH98REx+2hp5pQxc+6dDnp6KgG3ScyrP+3koZTkvr28Gx0rszdvMudZnff3R/q904FUnTrYBhXPuuR4AlOp15td4UmP7nsWS9U3IZ/9WvCIGmatGG+MN3ql6Ojvj7moWCaNXeFuntAcUVx2h7R041OmTD4+XZe4ADE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774277068; c=relaxed/simple;
	bh=KOWjegGwcsgPa3U8MDbF5s4W8Qr1XTHwj3PqBbLU5Ak=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NTPr04XJv0Su9TbTUP3PPz5DOLVLyulxtiMxPsNpsqYxXcX/sxnIl9zQIR/v5d4kmLf36Ceiy+rhR2vAkv82OSlKnlmVl0LpW27pnAkPg26uCBbixbbSE1q0i01NHLOE+WtUyUfehu8srnXiDb66CWLIkW1Qc5ojLqISRjLvr8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r+er2zAr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r+er2zAr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37918C4CEF7;
	Mon, 23 Mar 2026 14:44:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774277068;
	bh=KOWjegGwcsgPa3U8MDbF5s4W8Qr1XTHwj3PqBbLU5Ak=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r+er2zArZwdfxtD4SCdMfGMMtJhwZeCduB3NQ5UVFMORIKkwgs8FPHhbcSulJZEOY
	 JEf6Pth+2u4/1g7aUuqbWlDpC1ScVsZYgjgGBCTEcHcHzoFDv49gKfjNBNzhgI2rhH
	 aAU31IKLiFrh27JbdVBMYnPe7xEkSEWRxodnLF9o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiri Kosina <jkosina@suse.com>,
	Benjamin Tissoires <bentiss@kernel.org>
Subject: [PATCH 6.12 309/460] HID: bpf: prevent buffer overflow in hid_hw_request
Date: Mon, 23 Mar 2026 14:45:05 +0100
Message-ID: <20260323134534.089979321@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Tissoires <bentiss@kernel.org>

commit 2b658c1c442ec1cd9eec5ead98d68662c40fe645 upstream.

right now the returned value is considered to be always valid. However,
when playing with HID-BPF, the return value can be arbitrary big,
because it's the return value of dispatch_hid_bpf_raw_requests(), which
calls the struct_ops and we have no guarantees that the value makes
sense.

Fixes: 8bd0488b5ea5 ("HID: bpf: add HID-BPF hooks for hid_hw_raw_requests")
Cc: stable@vger.kernel.org
Acked-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Benjamin Tissoires <bentiss@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/bpf/hid_bpf_dispatch.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/hid/bpf/hid_bpf_dispatch.c
+++ b/drivers/hid/bpf/hid_bpf_dispatch.c
@@ -450,6 +450,8 @@ hid_bpf_hw_request(struct hid_bpf_ctx *c
 					      (u64)(long)ctx,
 					      true); /* prevent infinite recursions */
 
+	if (ret > size)
+		ret = size;
 	if (ret > 0)
 		memcpy(buf, dma_data, ret);
 


