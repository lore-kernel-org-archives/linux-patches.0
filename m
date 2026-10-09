Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DDD24E0B6E;
	Fri,  9 Oct 2026 14:15:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791555360; cv=none; b=V+p+BujPdsTBWCTdKNrrJSTp9z7xmmBz2wbnmXpeK3SFVNtIcRihdyrCAiE32P0hAJGM1s5K2z4nfnuoIb8a6YKLWy0lcmWIecus2ia+qQpjrlBweW9WC+BrFFdRN1f0tEr5DuSVlA0gWmcFJ9p82wZDo60FOvQVQT/GLPoR8VU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791555360; c=relaxed/simple;
	bh=iYIpk03vPFYqilmQrwHZZDIWmoXBmqO4m5PWRZ6QoKU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=np1VIMscIlh5nM3jDVzNBtEv1I3PSH3RnQYEHvorsXe1rGQiPB+NZd08Ad12xtNxVw2oMMck84CKcPBbUpLxhV/ZCLPTW8b3V4tsrLlbK7VRUHsMQ8ibDr5ddV0AeMF2nZL/Z1YBcWonaw9gf1n25my6sOiKZ+e1d5lugq66aPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j4yjxUD6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j4yjxUD6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B07A01F000FF;
	Fri,  9 Oct 2026 14:15:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791555356;
	bh=QsBft/ZoT+imrYClzs8h/2gXAgCYA/SMVhJuyGQ6oRc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j4yjxUD645WeRGjDlHhSgMVI6eBsoNtwFXA20LIQekVChOLzhIuClAKTPCOhJUVDN
	 m4Xjeiu2w+q3Iisj08gyeR56GyYHJcMFnBMyf0xv7XTmEyiZxEdhEd1rr60PGMPzNc
	 u8IaVXpncxQ/+gaRW+b80XUCI07U/CpqxBU6CHr0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiri Kosina <jkosina@suse.com>,
	Benjamin Tissoires <bentiss@kernel.org>
Subject: [PATCH 6.18 022/403] HID: bpf: cast size to ssize_t when checking hid_bpf_hw_request
Date: Fri,  9 Oct 2026 16:06:23 +0200
Message-ID: <20261009140952.635479963@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -456,7 +456,7 @@ hid_bpf_hw_request(struct hid_bpf_ctx *c
 					      (u64)(long)ctx,
 					      true); /* prevent infinite recursions */
 
-	if (ret > size)
+	if (ret > (ssize_t)size)
 		ret = size;
 	if (ret > 0)
 		memcpy(buf, dma_data, ret);


