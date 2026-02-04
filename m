Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89C2941B36C;
	Wed,  4 Feb 2026 15:09:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770217789; cv=none; b=H/04kTZSsOxBacwPVkuPTFHaJ7faFuJuI78JeTWZlmQRNJmdbenA3XPtKAgFKW8TWfs9UE28T8LeW+Ld4ygE4Phj8cSSZiy5+RivfsBWo5R1GHi4krNbHK9zjMbK9nOo3SbdZ7Xy4df7m7S3KJC+xIBX0clJJzYf+NJ0tcgeor8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770217789; c=relaxed/simple;
	bh=RtF8vSQR9qJo6QZmYWHj4buzWJ7E4axj3b7p+bdJVog=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bqkJIzKHkot4Nc1Vg4YtBuRz/tEQCMI4rNu+tvTmL2Uvb8KKD/PY3yFPeV4eaYt1KzFCtuQaXPvzQSFo4qPTrUr9l/QSvxYGrOan6Q+3eYklbR3Lx1b18TzAc50wTBJO6OOB1tjncYxw7/kHGctUjYgG6CqzUGJYx73t+c6BeKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BBc9o8h+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BBc9o8h+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E47ADC4CEF7;
	Wed,  4 Feb 2026 15:09:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770217789;
	bh=RtF8vSQR9qJo6QZmYWHj4buzWJ7E4axj3b7p+bdJVog=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BBc9o8h+RTSFjXUrR6pZPcvcFakYS39wziF33BLzDtuHe4+TkCRZssYkKLVd1lz39
	 JJYqiFbevmwOPA+TWOGPhL9yqDzBC7klPdjSErgfwXmegZvnkZ0Bl8eIIelHPgJIOp
	 ZXiqH5DqEimagMsbeIKy5VdkOrY+jTp0F9B3mptU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>,
	Krzysztof Kozlowski <krzk@kernel.org>
Subject: [PATCH 6.1 118/280] w1: fix redundant counter decrement in w1_attach_slave_device()
Date: Wed,  4 Feb 2026 15:38:12 +0100
Message-ID: <20260204143913.885551322@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143909.614719725@linuxfoundation.org>
References: <20260204143909.614719725@linuxfoundation.org>
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
@@ -767,8 +767,6 @@ int w1_attach_slave_device(struct w1_mas
 	if (err < 0) {
 		dev_err(&dev->dev, "%s: Attaching %s failed.\n", __func__,
 			 sl->name);
-		dev->slave_count--;
-		w1_family_put(sl->family);
 		atomic_dec(&sl->master->refcnt);
 		kfree(sl);
 		return err;


