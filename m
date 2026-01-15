Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A84233D2FE6;
	Thu, 15 Jan 2026 17:55:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499709; cv=none; b=BaroNF0j9W6OFyWP5u9V/njlyUBy6i8V1XSu3Uiqwy1C/+AA7fFpkRls9TqR8/ZHO1oIceKFbXgW4JWKs0grfUJm70rtQpdSrGhXuQrID8fR9WRdZJih1NZA7HplQJV76VNOEa/RYo9s1avMg823UU4+vuDgpIcaap0Bokzy/dM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499709; c=relaxed/simple;
	bh=xB06htfO3t48LXMupJtuk3SRnNx6xW/o0waUuFiNMj0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GLUTuTHoLSmHWmPSclHvArCLR44QNmrkNe+xDLQQfQdJFKZgOLta3oxcj3MLZGjjH0j5T5ILYg1Zpjmp2K3M87TbQVMTYxD/1vOQ1zmX8HIzgjjDChgYuitJrrriTTtfHhXzGICkm6HWPrppqn6Hi20BFmyCFyd/jWimWFo1RN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iHQK1fCo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iHQK1fCo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 361BDC116D0;
	Thu, 15 Jan 2026 17:55:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768499709;
	bh=xB06htfO3t48LXMupJtuk3SRnNx6xW/o0waUuFiNMj0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iHQK1fCoqn5fLrI7dgT0oGcZs3tExk+oO7eikOARFqyREPR/IDcKKqbn6/UFMD2my
	 2yIppfmkra/qytxabDy9ZFuInss83IPhqRYMd0CAfBVsYYCH+3ZdHHTY4f7A8jcViY
	 XYLh9QPzcvIk5N27m0Tm7VSzUU9WTpd7jK+yaQfM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 5.10 322/451] media: cec: Fix debugfs leak on bus_register() failure
Date: Thu, 15 Jan 2026 17:48:43 +0100
Message-ID: <20260115164242.548419887@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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
@@ -433,6 +433,7 @@ static int __init cec_devnode_init(void)
 
 	ret = bus_register(&cec_bus_type);
 	if (ret < 0) {
+		debugfs_remove_recursive(top_cec_dir);
 		unregister_chrdev_region(cec_dev_t, CEC_NUM_DEVICES);
 		pr_warn("cec: bus_register failed\n");
 		return -EIO;


