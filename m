Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF4EA24DCF6;
	Mon, 13 Apr 2026 16:17:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776097036; cv=none; b=hgSj26V7d439DzDTT9uUcPQrtPzdeju3ExS4JF7MhqyRUr4tUbwm2jc6vzukaE/+JK9XTuAUPGSB5hOFqTMIeu4zrvw+Pkdx2BNyQIZEOBsegsNezy3UrjXz0oBXbObXmAIHBT3hDB2iMMJ1M8AB6jeAji7cqgm3u+rCttyWRiA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776097036; c=relaxed/simple;
	bh=lqRETBBzAgPR729EtYd0LDUwD6iSWfpfv2AzgWi0tJ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ic7+u6aKht1YGaewjYSChL3LFMCeHSvKHA3USzMAhqgq5PamhP+DFyQJa1WXSO8J0i+iJMqpF8bJySD1noH4ja025hcMymkGH1dc6z+tpgfzzHT0gH9U+EOb4y7xonQ4Iu1yZQGUcIi2GLOIakCE1yBxY9Iquw8Mri/si7kEt2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=huKV0hv3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="huKV0hv3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53C11C2BCAF;
	Mon, 13 Apr 2026 16:17:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776097036;
	bh=lqRETBBzAgPR729EtYd0LDUwD6iSWfpfv2AzgWi0tJ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=huKV0hv3rxEEe4FH0YL0D6hZo0YrJszVHWgHJszT+KIbI5zlRJNQr+jkckxgcNM5V
	 7aZtcwqZAL0agZwpqALYf4oxs2RkNRKiLme9mbfvOLNi3q4Xhc73ViNlC6CeRTnUzV
	 sXGcQWK8mkjcFC3jOtWglVMF5+RRQrKugyzsXzJo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yasuaki Torimaru <yasuakitorimaru@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Breno Leitao <leitao@debian.org>,
	Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH 6.1 37/55] xfrm: clear trailing padding in build_polexpire()
Date: Mon, 13 Apr 2026 18:01:11 +0200
Message-ID: <20260413155726.221540576@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155724.820472494@linuxfoundation.org>
References: <20260413155724.820472494@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yasuaki Torimaru <yasuakitorimaru@gmail.com>

commit 71a98248c63c535eaa4d4c22f099b68d902006d0 upstream.

build_expire() clears the trailing padding bytes of struct
xfrm_user_expire after setting the hard field via memset_after(),
but the analogous function build_polexpire() does not do this for
struct xfrm_user_polexpire.

The padding bytes after the __u8 hard field are left
uninitialized from the heap allocation, and are then sent to
userspace via netlink multicast to XFRMNLGRP_EXPIRE listeners,
leaking kernel heap memory contents.

Add the missing memset_after() call, matching build_expire().

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Signed-off-by: Yasuaki Torimaru <yasuakitorimaru@gmail.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Reviewed-by: Breno Leitao <leitao@debian.org>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/xfrm/xfrm_user.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -3524,6 +3524,8 @@ static int build_polexpire(struct sk_buf
 		return err;
 	}
 	upe->hard = !!hard;
+	/* clear the padding bytes */
+	memset_after(upe, 0, hard);
 
 	nlmsg_end(skb, nlh);
 	return 0;


