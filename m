Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0D8B3FE67B;
	Tue, 21 Jul 2026 17:36:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655415; cv=none; b=ot3BVdGalroNzU8ejoSph2MHbr1jsTeenN1B9OsbSPYeiyEzBr3sn2jIpGTHB2lUU7t+9CRhTj5kbKQbfuSDAEL/6F03sKA9gMIcjPiYeq5zpLJBMovFKRzMGmXnxFxphhXQp5E7Mfm1QyobwbnImjzB50vvx+QT6/JKQhzkWVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655415; c=relaxed/simple;
	bh=CA4b+dYhqoGHcQTUQdJc5nP0JcTAoFmgxqvlrZGLTXo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IGTNspelE+fqTayNFG5VMYW2i642IQNspIpZZ2aXRPFlm+ihf4oWdZrbPewHyuGMHSohcUnsNYtf2w/HjfM+Urn/x68MGLuWj1xwMwHN47cXn3JvSqS/ZVeNSGRzlSecnGO56B1EAcEp2oWrkHY9xkRQVp1ejWPQqQYs1DIJ9bc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=taM1eGT/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="taM1eGT/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 237B51F000E9;
	Tue, 21 Jul 2026 17:36:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655414;
	bh=2+BepILDE9wRQVXbLWfQrAyD7UY0O7EJWBghzEY2vuc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=taM1eGT/MBFF3h7ZqnfZfz1eP7uNeLTI0pHACaETjMMgCxAVWy5QefCwTy2Lhp8uG
	 0s9fj3KD2gGPMHqDSlqzIRDx7P1XurblfLKnyFVVIXl58a8CE5cIMQ7T9rHTTNGuVC
	 +MTEKusCxdQZqU3oQqGgCYOeiJxDjlZoqtc6nKvM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 2073/2077] exfat: fix implicit declaration of brelse()
Date: Tue, 21 Jul 2026 17:29:06 +0200
Message-ID: <20260721152641.598316552@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit f0d1b2e1e02c11e29c953f22a485449e3da2a575 ]

exfat_cluster_walk() calls brelse(bh) without including the header that
declares the function, causing the following build error:

    fs/exfat/exfat_fs.h:542:9: error: implicit declaration of function ‘brelse’ [-Werror=implicit-function-declaration]

Fix this by adding the missing buffer_head.h in exfat_fs.h.

Acked-by: Christoph Hellwig <hch@lst.de>
Acked-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Stable-dep-of: 044472d5ee7d ("iomap: consolidate bio submission")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/exfat/exfat_fs.h |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/exfat/exfat_fs.h
+++ b/fs/exfat/exfat_fs.h
@@ -12,6 +12,7 @@
 #include <linux/blkdev.h>
 #include <linux/backing-dev.h>
 #include <uapi/linux/exfat.h>
+#include <linux/buffer_head.h>
 
 #define EXFAT_ROOT_INO		1
 


