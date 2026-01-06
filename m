Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C346436B048;
	Tue,  6 Jan 2026 17:55:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767722127; cv=none; b=fOi6AWOlowwGQsYNxXmivvtkEuYDw83XKDA4+PoyxAhihyI1qhR7oxcep2/YyMxBy/chJ23hgcXaq19RFQFTPmhnGioF1pjctCrb6GgCgEgnLtZznEhAvGbIqNJki8q+jEBum6FwoS4FcFwVIexSuXf5wpx1n+iDBtnjrQYqWuA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767722127; c=relaxed/simple;
	bh=mjrGx7X4QmDw7aqd7Wzwe1iX83o5emwcb6iIZFmJ30c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TgxFkO+vCstewj/yenK0WypUGobg+VnkLySds0Hb/sUA3OO7oFS37Wop3Es4OWhbeEnhS3lQKs3EIbHB7ClaHBvjzF8UsHehdWps8laLNqaXPSF3aLiKoALnOa3QM3D5pc7lKKYh2mWujXuzgu0Yl70ZCNQNG8NLOOc3uMyRjkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vy5wgcEm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vy5wgcEm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CED3FC16AAE;
	Tue,  6 Jan 2026 17:55:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767722127;
	bh=mjrGx7X4QmDw7aqd7Wzwe1iX83o5emwcb6iIZFmJ30c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Vy5wgcEm3MveDbgCweEjgvuMiYyZcN6J6QpZihP2fSanJuPPUNpgUUxD04EW5dNzv
	 ufQ2yNyk+O454k5XMR8Ylu64GCdZXrwgjiqQhNBK85foNckWXWe/rNTkaxPNtVg5Vg
	 GwWpoKxKI+JBKHbJrhJ/pD6uW7jprIzEi14CKV1A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.18 174/312] media: cec: Fix debugfs leak on bus_register() failure
Date: Tue,  6 Jan 2026 18:04:08 +0100
Message-ID: <20260106170554.129973581@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170547.832845344@linuxfoundation.org>
References: <20260106170547.832845344@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haotian Zhang <vulab@iscas.ac.cn>

commit c43bcd2b2aa3c2ca9d2433c3990ecbc2c47d10eb upstream.

In cec_devnode_init(), the debugfs directory created with
debugfs_create_dir() is not removed if bus_register() fails.
This leaves a stale "cec" entry in debugfs and prevents
proper module reloading.

Fix this by removing the debugfs directory in the error path.

Fixes: a56960e8b406 ("[media] cec: add HDMI CEC framework (core)")
Cc: stable@vger.kernel.org
Signed-off-by: Haotian Zhang <vulab@iscas.ac.cn>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/cec/core/cec-core.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/media/cec/core/cec-core.c
+++ b/drivers/media/cec/core/cec-core.c
@@ -421,6 +421,7 @@ static int __init cec_devnode_init(void)
 
 	ret = bus_register(&cec_bus_type);
 	if (ret < 0) {
+		debugfs_remove_recursive(top_cec_dir);
 		unregister_chrdev_region(cec_dev_t, CEC_NUM_DEVICES);
 		pr_warn("cec: bus_register failed\n");
 		return -EIO;


