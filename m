Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A27133AD9A;
	Tue,  6 Jan 2026 17:36:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767720986; cv=none; b=G8AXXtIQa1b7mLnvQkqjLMyqPOUCjHTzZ9dERuZV3vyVEJk6KCWfVKEkiqyh2sZnXZxZvKG/L2KDCenvzAhHxOcY8XH+5tI7OeEHfFwTZSImJJiQyW2TwjGoYT6mE/LSNfAaUFLihbrEvh7Ci/YCUu28wfhJjXGKNj0PUw7XMyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767720986; c=relaxed/simple;
	bh=4xktEm4ONUeihvykd16sSFIlVI/mOLBuA8wnwoCsL10=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oKpfmrO//jm8oh1btlOtryGpYuNDhYKjhAp5ohxQlDQsLQGY3FZRdJ+0i6dBTDVcuA8gI0zoDuULeI5wS1Xf2QIDF80tTDhkcao3hb2FDOwjiSMomA2oVCc4IMly3vFqPOc9j31oFuWNxOXDXjf0H5d252Mn/mTdKWcTtfIVv/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=afS1VXi2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="afS1VXi2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BA2DC116C6;
	Tue,  6 Jan 2026 17:36:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767720985;
	bh=4xktEm4ONUeihvykd16sSFIlVI/mOLBuA8wnwoCsL10=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=afS1VXi2ntzrHi1iBAnFSlphoYbRQM8fE2h7QdW98pe3CBpDOYgoGxvuBNQnBie6F
	 4jV5ClSkTEfD7Ru4nAvr5/d0GXU7ZaGMB8zQifETt5oQ2MhvkGCn8PEnEjf9jHleNG
	 pEA0S2iNZAPjTx7mqx7oa1AUsPskv87BWsYtArH4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.12 402/567] media: cec: Fix debugfs leak on bus_register() failure
Date: Tue,  6 Jan 2026 18:03:04 +0100
Message-ID: <20260106170506.213530542@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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
@@ -420,6 +420,7 @@ static int __init cec_devnode_init(void)
 
 	ret = bus_register(&cec_bus_type);
 	if (ret < 0) {
+		debugfs_remove_recursive(top_cec_dir);
 		unregister_chrdev_region(cec_dev_t, CEC_NUM_DEVICES);
 		pr_warn("cec: bus_register failed\n");
 		return -EIO;


