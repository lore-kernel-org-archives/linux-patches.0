Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08BC626461F;
	Wed, 28 Jan 2026 15:44:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769615050; cv=none; b=qJ0CgVBOyugPQ2hETY16a5brcqEQOSK24+DXePVjLRwUdHNlta6lL0NmAtK5gJR9yX1TfcvB7ndsOPwZkHFNOpmLg9IahIDGd/HOHlWWhjIGwK8lCuw5HICHm3xWqsOfeh345IFeLEy64kspeEJSjBv+DyHFe2tf8AsEGanVuro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769615050; c=relaxed/simple;
	bh=lYyWy04hy5bBfRrngIPq3QZMPuLIA2lQLdVeOja5KTg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uDmtfiLLNDj/NhWKp16ozKdLVochCLAXJ0A/odDbmZrtR1il3bikBWgffm+b96xxRRFErAgrExuumJkN4CRsmPFxXz8YPcpT7lclNvm03raeEGTOIYYM1brBkD2DUHwXHRU9gX4jYACccu79Ggfsp+bezP5JJiyZaU8/d/ePGzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zE8E7yVe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zE8E7yVe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85608C4CEF1;
	Wed, 28 Jan 2026 15:44:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769615049;
	bh=lYyWy04hy5bBfRrngIPq3QZMPuLIA2lQLdVeOja5KTg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zE8E7yVenzRo0nggJAB6lXbzsBf9v0wsp4F1lLaf9WeDyT5wGNoTxCZF7NAdRh1N+
	 3j0mYyN1/Zg+8bYc8R190U8R6+4VHp44pmdL9Rkvp/G2DE6yzuSh9zGHJuTIGBA8Wa
	 0yxkzSPH8gWGrGiJVO/ml5hySlUOj4RHxr/cS5W4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>,
	Krzysztof Kozlowski <krzk@kernel.org>
Subject: [PATCH 6.12 046/169] w1: fix redundant counter decrement in w1_attach_slave_device()
Date: Wed, 28 Jan 2026 16:22:09 +0100
Message-ID: <20260128145335.675811658@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145334.006287341@linuxfoundation.org>
References: <20260128145334.006287341@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


