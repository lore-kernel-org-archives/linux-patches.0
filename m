Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9CA62F9D85;
	Thu, 28 May 2026 20:46:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780001182; cv=none; b=YZSUeo6w3Bb++jEKaQaHevn/XE+JmQ6EZOrcJCoYF2R17JWnOGoeOxhhToxtQpAqQ7+qsHTg+rfOxLhdA3hvSC1qY0joqK6KhnvN/jfPceEOtBo7QebbEaUavozZUH5CCB6dq26Sid8GvVv1Y91pLc6nnS15f5AQLyOJdcJ54mI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780001182; c=relaxed/simple;
	bh=+zm/DLF3A+mIlXtl2HGtFXy6chGs+RyYL+PrTMfL8C8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cswi4OFua34wbrjPMdhZwCTMABrBdnDtlcvrFrovFk75ivtufnIRBLA6yOFbgMJ3e0xdhadS22BFDM8QOKAmPHGFokBSKgWcG60wd35hyMIAouCdPVdnaX9XjDh+bpWX0OheD84PXfMr4enBXc67tRdLjYehSx1IKVCZfWw2c5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vu3aAXXr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vu3aAXXr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1498B1F000E9;
	Thu, 28 May 2026 20:46:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780001181;
	bh=BRHujQYcA99aMrQzyi1Ry9S7VevY6DUNQZdKqvzxh2I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Vu3aAXXrKIlT6rVx1woDFrslbfSjFtGvkX8V0YrcWcXxdaD7vLJqV79d7Lo1MHHvH
	 8PSZGEBFG7qQMxlGGJhemMfHjNF59N2jTjdhmLJRScv+rD5Wk6OIbcgXn5mFI7hswh
	 LlDjVwFHjk4Fpyq7wZ1Z3lq8D0HQRqm0FmizNGVo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jann Horn <jannh@google.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.6 037/186] Bluetooth: bnep: Fix UAF read of dev->name
Date: Thu, 28 May 2026 21:48:37 +0200
Message-ID: <20260528194929.965991478@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194928.941004471@linuxfoundation.org>
References: <20260528194928.941004471@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jann Horn <jannh@google.com>

commit 59e932ded949fa6f0340bf7c6d7818f962fa4fd2 upstream.

bnep_add_connection() needs to keep holding the bnep_session_sem while
reading dev->name (just like bnep_get_connlist() does); otherwise the
bnep_session() thread can concurrently free the net_device, which can for
example be triggered by a concurrent bnep_del_connection().

(This UAF is fairly uninteresting from a security perspective;
calling bnep_add_connection() requires passing a capable(CAP_NET_ADMIN)
check. It also requires completely tearing down a netdev during a fairly
tight race window.)

Cc: stable@vger.kernel.org
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Jann Horn <jannh@google.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/bnep/core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/bluetooth/bnep/core.c
+++ b/net/bluetooth/bnep/core.c
@@ -638,8 +638,8 @@ int bnep_add_connection(struct bnep_conn
 		goto failed;
 	}
 
-	up_write(&bnep_session_sem);
 	strcpy(req->device, dev->name);
+	up_write(&bnep_session_sem);
 	return 0;
 
 failed:


