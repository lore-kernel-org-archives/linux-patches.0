Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065391;
	b=NFU4oxgpJmTr31ePbc5QJ5fsTRc+6N6tX2lQ5RMX54m6HrPGYRxgI27fn7UNWYOYv3xp
	 exWdfgvWM2PUCjkfzJ82YCjoGPytlou5XLN6IP6fk8OlcWSNyKixv+BLwyqxWIxWsQtur
	 6Wlx0mGXYNxi2oJ/Ps9Stpl2MOa76YB+d+j3zGcobACu4CKkDTmWXcc/qgKNhlw+h4wTB
	 B74th89iAXxehilvXJHTpIe9bRHui5SB6vDLmsSVqU6VM62V2fzAMo9j194Tm97JcR8h+
	 JA4Qr90Rgn56BUPM0VZQ4O5AyfCaxe9SgO7qDlBNPikzcGGBgcvm6g1CT0POIrgv/bg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065391;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=THKrBCNgHgeex1bxDIjmFLFy85oN6R1u3saDbhz9WT8=;
	b=rWwoFaCozpCKYS/j9R3ErsPN0YFcJCKqi7aWhdNa/L9hdsE6M5XKsBCRpvsPMBwDV+hx
	 c73GmoEuOIGlNM6Dky/aUF3j9rTQ7idENV68Nvez+BVc8ce0xauJHOIk6SI6gkOtjxebr
	 9AxmoPmKPMA/XzBcIHev3l8DVyAX1+quhYTN9QLEi6JeWCxYmnJtlTeaxIm+v1PhScOxu
	 EfTXTRgt97b4JEHYe18uhBzGPFEa8fFQQiE+XSRal53Y0zs5vYL2m9x663cC3g1UiXn69
	 x+wwvFrlyzTPe2t5NuXxUQ5v/Lj/mT8EsPvtngZGtsVbsCexvLVFSTpKpI2ysKfrZ+w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gu0IeBpb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79AE6606A32C;
	Sat,  7 Nov 2026 15:29:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gu0IeBpb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C76A1F0089F;
	Sat,  7 Nov 2026 15:29:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065391;
	bh=THKrBCNgHgeex1bxDIjmFLFy85oN6R1u3saDbhz9WT8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gu0IeBpb5IJU8qn5feUOrE8ygANuA9m+c5siTzML5RM82iescX4fxM5HIQNa4ytKc
	 aZeniXwd9LiFYSk9hKNEUMBIRcFgTCs5JUjb8bBWQbF1xbTeBX5f6Vu5t+6sB2Kehp
	 cC+yewS59pjVMjdmBvxoBikDlMAVwGFWHTux4vuo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Max Kellermann <max.kellermann@ionos.com>,
	Xiubo Li <xiubo.li@clyso.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1114/1257] ceph: avoid pending truncate during nonblocking cap acquire
Date: Sat,  7 Nov 2026 08:56:50 -0500
Message-ID: <20261107135010.015013302@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Max Kellermann <max.kellermann@ionos.com>

[ Upstream commit 979b7ed4457a04c5a41c36f86052ecc6b76c67d9 ]

Readahead acquires caps while the folios are locked.  This can
deadlock when processing a pending truncate; truncate_pagecache() can
then attempt to a folio that is already locked.

Return -EAGAIN instead when `NON_BLOCKING` is set, causing the
readahead to be abandoned.

Cc: stable@vger.kernel.org
Fixes: 49870056005c ("ceph: convert ceph_readpages to ceph_readahead")
Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
Reviewed-by: Xiubo Li <xiubo.li@clyso.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ceph/caps.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index bcb04c6cb92cb..86e195c5fd325 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -2889,6 +2889,10 @@ static int try_get_cap_refs(struct inode *inode, int need, int want,
 	}
 
 	/* finish pending truncate */
+	if (ci->i_truncate_pending && (flags & NON_BLOCKING)) {
+		ret = -EAGAIN;
+		goto out_unlock;
+	}
 	while (ci->i_truncate_pending) {
 		spin_unlock(&ci->i_ceph_lock);
 		if (snap_rwsem_locked) {
-- 
2.53.0



