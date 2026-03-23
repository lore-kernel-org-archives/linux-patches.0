Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B23753B19B3;
	Mon, 23 Mar 2026 14:02:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774274555; cv=none; b=fyrFBCUGdobfdV3e3K1xWZxrvfAhM1PqG35e4FiGinDNAMLGYI3KiMnG8mjKZ3nIcE19FtTHAeolNgL7OGqEeyVENY6hVyXT9sQdMEOInIlh2exKV5Soj5sTZiXnJRfOgi2wV/cDucZ6HhlmsPKhC78j/AUEFuxVRFflg839Y7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774274555; c=relaxed/simple;
	bh=pbNxgRNr0ZXrjpEN9kWfU7/bxkaroi7z7LvOL752Qnw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lD3fbKF90OVWQ5t3xwK40e2w4+WsIdQuQzq9EeIz6LT5IIYD8NR7NNq5GHbmGrHnet76xfc+HvcsAPr1tMfHzg5s8AbcAx6zs9Naxh35OQkK7HZMNyBDyCrMpPzc7cF9TOJYxarF0zcpod8VbgR44T8rZafi54EmmeKjnAyHrHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J6xBNQ2D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J6xBNQ2D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0062FC4CEF7;
	Mon, 23 Mar 2026 14:02:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774274555;
	bh=pbNxgRNr0ZXrjpEN9kWfU7/bxkaroi7z7LvOL752Qnw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J6xBNQ2DvdbDXAN6QPUQfXXvKY8qeVnOO3VH4AgSHmdBwcMu05yTLcLmJOz0RV2Qw
	 A3Nau4iTgtIPZhiwqwRZTd5s+jegQiuoQ71v6T7ey7LfTZxC1/PINrDaZDbqtYdHwB
	 DqVSOZXiQ8Q7PfMx4mYj2vZ6bA8CyHMYfFgR4K9g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiri Kosina <jkosina@suse.com>,
	Benjamin Tissoires <bentiss@kernel.org>
Subject: [PATCH 6.18 005/212] HID: bpf: prevent buffer overflow in hid_hw_request
Date: Mon, 23 Mar 2026 14:43:46 +0100
Message-ID: <20260323134503.940085960@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134503.770111826@linuxfoundation.org>
References: <20260323134503.770111826@linuxfoundation.org>
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
@@ -447,6 +447,8 @@ hid_bpf_hw_request(struct hid_bpf_ctx *c
 					      (u64)(long)ctx,
 					      true); /* prevent infinite recursions */
 
+	if (ret > size)
+		ret = size;
 	if (ret > 0)
 		memcpy(buf, dma_data, ret);
 


