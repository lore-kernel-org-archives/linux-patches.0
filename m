Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA3F7221F17;
	Wed,  4 Feb 2026 14:47:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770216478; cv=none; b=seTKIeduWgRv7dd3pVbWHXVD02oKrrGgVtt45YnH7uM2LhkYBiF/8UlCVCOxWF1U53DMswyBVjrSDmZF2gHcFjH96wdKwZbF7F7x4wbgNQ/rLjt8bxIvjiduhfXvz4g6khI4Jm55knOF6FJ8CKxqyJfV02i0dlXTQzSzg9Hsh2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770216478; c=relaxed/simple;
	bh=6bHzCVPyxZ6cFFhTrDkLbJAmNHiM14SO6aWfCGwT/1M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HtGuUZMXid8hzHfKHkbUbt4+MoSXstNf5O4TlakJx1paQTrfOLDZ2ZPSRConYU/T9U+p/n+wMWbxMCWd2eJtwKCGFdScYvU3oAOC3sBjWre4TbT2ZXcXxxuhu+35Fd3Z2UtBHuawq8KgQO6aCr8BC8stv3QjYbAs9bEcG2wAlKg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PvZhaFBf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PvZhaFBf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D022C4CEF7;
	Wed,  4 Feb 2026 14:47:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770216477;
	bh=6bHzCVPyxZ6cFFhTrDkLbJAmNHiM14SO6aWfCGwT/1M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PvZhaFBfe14yVJwtJz3Dg5NYApvl6mZlMsJT1c8O0zZ3oLq0Pt8kMlTH+O/n+FGSE
	 8dOIlu7fHxiuh+EsSIV35oArIKme9zBwAG6eElnwod5tFLz15Hs0vxxwvGHhnfTIG3
	 2oYK6v9K+k8yzeM71ZZb9iazEfXMdfGNCXbV/IE4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>,
	Krzysztof Kozlowski <krzk@kernel.org>
Subject: [PATCH 5.10 066/161] w1: fix redundant counter decrement in w1_attach_slave_device()
Date: Wed,  4 Feb 2026 15:38:49 +0100
Message-ID: <20260204143854.131484291@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143851.755002596@linuxfoundation.org>
References: <20260204143851.755002596@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -765,8 +765,6 @@ int w1_attach_slave_device(struct w1_mas
 	if (err < 0) {
 		dev_err(&dev->dev, "%s: Attaching %s failed.\n", __func__,
 			 sl->name);
-		dev->slave_count--;
-		w1_family_put(sl->family);
 		atomic_dec(&sl->master->refcnt);
 		kfree(sl);
 		return err;


