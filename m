Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E11651885A5;
	Wed, 28 Jan 2026 15:34:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769614468; cv=none; b=rNovRVCq/K7+CJDuXyYojzNfMSdFLC95hd+GrkxefRnMniIwYcFs+3cnlURcn91IAIY7bekAZxBOLDE2r6rnsV91xkEbqwla4o5B6Nq/dy9lpbkKej2ZOv23+U0+kpNidRUtzt5fO4IB5W+7QTq8l2mGI1hFEGMBBlX4qeYNFlY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769614468; c=relaxed/simple;
	bh=Lqpt9qH7Y/i9gKNKn9OjCd1v610iIhBLw68Doir5DEk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IQQluq6d3f1ATh+CtjXjQzpo3hLH580j/pB9g+860NEuPBaDYFXGMwqwW0cgjf6oGcemNyUILxSclP6Vm3B0MaAYbmfqhbk0nGlIEOjkdP9lupj0nK4d0vYPkzeaGimXCiu0DCmhNsrT0FjPeWVWuv87+QhnjmitsbrJk66a0+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uLFaNMc1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uLFaNMc1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C2E6C4CEF1;
	Wed, 28 Jan 2026 15:34:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769614467;
	bh=Lqpt9qH7Y/i9gKNKn9OjCd1v610iIhBLw68Doir5DEk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uLFaNMc1OjbRJn0SJHO2kjDtxIrOJiPD+s1WkdUd21o/dPtVjhHLAzWJGNlY6POJq
	 TXSl6QWMxcHpmfASi1MNrTw4OsjQvDsKSVLUn4Hb0sovQqaTILWBISD5wLSwcgEUlX
	 AbSi60FDXcGc0n1AGcwjwqUIgd2k/lCHKoUe/d9I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>,
	Krzysztof Kozlowski <krzk@kernel.org>
Subject: [PATCH 6.6 138/254] w1: fix redundant counter decrement in w1_attach_slave_device()
Date: Wed, 28 Jan 2026 16:21:54 +0100
Message-ID: <20260128145349.783682033@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.698118637@linuxfoundation.org>
References: <20260128145344.698118637@linuxfoundation.org>
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

From: Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>

commit cc8f92e41eb76f450f05234fef2054afc3633100 upstream.

In w1_attach_slave_device(), if __w1_attach_slave_device() fails,
put_device() -> w1_slave_release() is called to do the cleanup job.
In w1_slave_release(), sl->family->refcnt and sl->master->slave_count
have already been decremented. There is no need to decrement twice
in w1_attach_slave_device().

Fixes: 2c927c0c73fd ("w1: Fix slave count on 1-Wire bus (resend)")
Cc: stable@vger.kernel.org
Signed-off-by: Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>
Link: https://patch.msgid.link/20251218111414.564403-1-lihaoxiang@isrc.iscas.ac.cn
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/w1/w1.c |    2 --
 1 file changed, 2 deletions(-)

--- a/drivers/w1/w1.c
+++ b/drivers/w1/w1.c
@@ -758,8 +758,6 @@ int w1_attach_slave_device(struct w1_mas
 	if (err < 0) {
 		dev_err(&dev->dev, "%s: Attaching %s failed.\n", __func__,
 			 sl->name);
-		dev->slave_count--;
-		w1_family_put(sl->family);
 		atomic_dec(&sl->master->refcnt);
 		kfree(sl);
 		return err;


