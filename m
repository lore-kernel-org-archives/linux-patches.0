Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EB443F44E4;
	Mon, 17 Aug 2026 13:45:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786974306; cv=none; b=oiPx+KRV6uYjjfrOVVk7F3i5dUYIn2T+RV3uWpU6HM7EXzIrJVGLhf0ui14be+sd+9sLfIXXdxWdzFcceSCLd+i0jc8FPIRLA2cabNVnOeoaKLzKS9+4whNEUY9Iv6a9vC63aT+yrf3/EnbTQJ2P/TLX/OHFxA1zerB7p3tt0k8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786974306; c=relaxed/simple;
	bh=G4C9/GVv5ClTILqTu570c5uerarNuD8/1xVwO4UpqHc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UCP+mtcURXHPjiJK5ufMexIOufTtOZs40YzId4JN1PkdjQ4PT5hrgmEGjD+AQ/93h57mz9WJSQTM4x7IntkW/gMrO5NjdQKWaS9iYW4gVQoSja5XaOPFZxF0EDrcTZl0qjuwJNEt41er+tfeLh/vk5GWdYxUr0UiPWWHjrMwmDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Rj8+mKPR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Rj8+mKPR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27EA31F000E9;
	Mon, 17 Aug 2026 13:44:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786974300;
	bh=OGMgNInUQKUEpwneF8ZctBhmxd1jDck/VBTMLOebZ3U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Rj8+mKPR5UQZOAQczSfd4qR/Jn1xFdi5mVtFEfEjNrFJSEPwgcyxcf+hIjT26U3gT
	 eKb6GvXgak5fPXRBpou3+h2xJTldm7SwCJbZLqYLSMe6f5nF8ZgGQ0GywpEnOznbdN
	 NSdojaqMME9NDigSaWuA0Bzz9+vawKLjYLI5kbK0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Willem de Bruijn <willemb@google.com>,
	Qihang Tang <q.h.hack.winter@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.1 157/271] net: remove CAP_SYS_RAWIO zero-padding in dev_validate_header
Date: Mon, 17 Aug 2026 15:31:22 +0200
Message-ID: <20260817132543.365893794@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.752504388@linuxfoundation.org>
References: <20260817132536.752504388@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qihang Tang <q.h.hack.winter@gmail.com>

commit 3b9a324e646d3657a8d9806dfbfe4f3e4066e882 upstream.

dev_validate_header() reads dev->hard_header_len directly when
zero-padding short link layer headers for CAP_SYS_RAWIO holders:

    if (capable(CAP_SYS_RAWIO)) {
        memset(ll_header + len, 0, dev->hard_header_len - len);
        return true;
    }

Packet send paths call dev_validate_header() on skbs whose headroom was
allocated from an earlier hard_header_len read. If the device is
reconfigured so that dev->hard_header_len increases before validation,
the memset writes past the reserved buffer, an out-of-bounds write.

This out-of-bounds write is masked in some SOCK_RAW paths today because
the same concurrent increase can first make skb_push() exceed the
reserved headroom and trigger skb_under_panic(). Remove the zero-padding
branch before making those hard_header_len reads consistent, so the
snapshot fixes do not turn a loud panic into a silent overwrite.

This path is only reached for variable length L2 protocols, where
len < hard_header_len but len >= min_header_len. No remaining in-tree
variable length L2 protocol implements header_ops->validate, and the
CAP_SYS_RAWIO bypass that zero-pads and accepts short headers has no
real value beyond allowing testing of intentionally malformed input.

Drop the CAP_SYS_RAWIO branch. The remaining reads of
dev->hard_header_len in dev_validate_header() are comparisons only and
have no memory safety impact.

Suggested-by: Willem de Bruijn <willemb@google.com>
Fixes: 2793a23aacbd ("net: validate variable length ll headers")
Cc: stable@vger.kernel.org
Signed-off-by: Qihang Tang <q.h.hack.winter@gmail.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Link: https://patch.msgid.link/20260805125729.19220-2-q.h.hack.winter@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/netdevice.h |    5 -----
 1 file changed, 5 deletions(-)

--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -3509,11 +3509,6 @@ static inline bool dev_validate_header(c
 	if (len < dev->min_header_len)
 		return false;
 
-	if (capable(CAP_SYS_RAWIO)) {
-		memset(ll_header + len, 0, dev->hard_header_len - len);
-		return true;
-	}
-
 	if (dev->header_ops && dev->header_ops->validate)
 		return dev->header_ops->validate(ll_header, len);
 


