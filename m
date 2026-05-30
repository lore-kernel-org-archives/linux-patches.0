Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0164E32B11D;
	Sat, 30 May 2026 17:05:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780160743; cv=none; b=QGasfVfb7GHcdzBPQsCu6GnVMD3F990YxNEMumFpyDpmdq4ywXWHUDGrzFgP0gMTK7M1LMxAWEvyRIze78rAD6JAzpk4J0Cv+7Utb6fUFcQRHMsx+bnZ2rqnHzPUrvXaY4CiPTi3OZXP19Cm56msfv1ouHNygvlriYUXPFU4VUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780160743; c=relaxed/simple;
	bh=A84ljExZlVmXzGZs3sUhNGF6k0WQmnq8NdBmQG8SO1s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SWnB06IqtL8mLUL+vuv0XXgPY3rz4JsYOHhNQ9XGufoJPePSZWpKEZnYoSFORz/cWBDwyZj+WnU77RXHIMskp1W7ArPWXjkN827yZKlcrMFmWqLHPc/S3CQm+okI+zxY5x19+jZSC1Vr1nK04QSp7uzc11Ar/jj+ASSlSl3cqpI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d3sqyCar; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d3sqyCar"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 464011F00893;
	Sat, 30 May 2026 17:05:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780160742;
	bh=CWDOmsTioXO/4I/e8Oi20BOwTcAYS2xWrU5kxesMn3k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d3sqyCarOgNcQ8j6C+JIes33yKXcwOgEOglJfOTzAChSYIZDf4q0NZDQpa66rsjek
	 4xAQWo80nQJQ+Ggfib40AlRUBvM6m7cgMUY6QJEdqYPkd+Azv7+YXIfME6vtCpwknJ
	 0qdsEYQuJhRGiQW16lSUPBKKz0NggoxGB3Yunj44=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Siwei Zhang <oss@fourdim.xyz>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.1 422/969] Bluetooth: L2CAP: Fix null-ptr-deref in l2cap_sock_get_sndtimeo_cb()
Date: Sat, 30 May 2026 17:59:06 +0200
Message-ID: <20260530160311.918730727@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

From: Siwei Zhang <oss@fourdim.xyz>

commit 78a88d43dab8d23aeef934ed8ce34d40e6b3d613 upstream.

Add the same NULL guard already present in
l2cap_sock_resume_cb() and l2cap_sock_ready_cb().

Fixes: 8d836d71e222 ("Bluetooth: Access sk_sndtimeo indirectly in l2cap_core.c")
Cc: stable@kernel.org
Signed-off-by: Siwei Zhang <oss@fourdim.xyz>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/l2cap_sock.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/bluetooth/l2cap_sock.c
+++ b/net/bluetooth/l2cap_sock.c
@@ -1767,6 +1767,9 @@ static long l2cap_sock_get_sndtimeo_cb(s
 {
 	struct sock *sk = chan->data;
 
+	if (!sk)
+		return 0;
+
 	return sk->sk_sndtimeo;
 }
 


