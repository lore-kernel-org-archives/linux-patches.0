Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0AFB42CB1D;
	Thu, 16 Jul 2026 14:24:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211886; cv=none; b=lpbROLEi+yt9xD/caN4LG9aUh5ZNonv0OfAneENYb66r1Ky1fGbR1N1t0EcaajsNtJqCZvynwKiTipGQtA2A81CXyEk+xV2azdhtGhhWpn6EOB26qKQsbMTQHxRvHzcnw0Ojf3r0masthmd1lcCGU/iDiXxBYA9LM//hQcoKkV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211886; c=relaxed/simple;
	bh=+J8su4jnRYqb3ASOv59GmficKAz8K1APO9sdEcCGv5g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b+iJSI+orji2W4Zg5Xio99Ic9Q97JofigIQ1ql6uEWOrsJEcnG9oQkMA/hJbag4P/Y7EVsULP04QQbrD/gsQjEFdt+NV44V6G7A+8xt+3VFUqKG28TB8/ggQk2L8L7ZIeEIWO3oFqx53s8X7WwJS6rRe6xK+dhr7zM+w5d4mX+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qSlUu5aF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qSlUu5aF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 894E01F00ADE;
	Thu, 16 Jul 2026 14:24:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211882;
	bh=npP6PREmRY7eHY8tD5yGWzkRvRIfpZS0NMgZfCoUNS4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qSlUu5aF5SsPfuuCL8hYIdBM4/bZhrgpvqMdiNp0qoa4aFInytyAghLbCm+1DarL/
	 G27b6NF9vouQ8B69L5nwhJkpCdbe7xacaXrzb+VV/4qvy5hR79bRN5SXsNQu0W+onp
	 PyGDywAIa4QSQjU+WQ6JpaXHRpLWOPo3prrvvgrs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Martyn Welch <martyn@welchs.me.uk>,
	Hao-Qun Huang <alvinhuang0603@gmail.com>
Subject: [PATCH 6.12 116/349] staging: vme_user: fix location monitor leak in fake bridge
Date: Thu, 16 Jul 2026 15:30:50 +0200
Message-ID: <20260716133035.954782112@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133033.287196923@linuxfoundation.org>
References: <20260716133033.287196923@linuxfoundation.org>
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

From: Hao-Qun Huang <alvinhuang0603@gmail.com>

commit e8422d89e8af41d87f0e9db564be8e2634f4c602 upstream.

fake_init() allocates a location monitor resource and links it into
fake_bridge->lm_resources. The init error path frees this list, but
fake_exit() only frees the slave and master resource lists. Loading
and unloading the module therefore triggers a kmemleak warning:

  unreferenced object 0xffff8b8b82aebe40 (size 64):
    comm "init", pid 1, jiffies 4294894572
    backtrace (crc c1e013ef):
      kmemleak_alloc+0x4e/0x90
      __kmalloc_cache_noprof+0x338/0x430
      0xffffffffc0602246
      do_one_initcall+0x4f/0x320
      do_init_module+0x68/0x270
      load_module+0x2a3b/0x2d90

Free the lm_resources list in fake_exit() as well, before fake_bridge
is freed.

Fixes: 658bcdae9c67 ("vme: Adding Fake VME driver")
Cc: stable <stable@kernel.org>
Cc: Martyn Welch <martyn@welchs.me.uk>
Assisted-by: Claude:claude-fable-5
Signed-off-by: Hao-Qun Huang <alvinhuang0603@gmail.com>
Link: https://patch.msgid.link/20260704065817.403111-1-alvinhuang0603@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/vme_user/vme_fake.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/staging/vme_user/vme_fake.c
+++ b/drivers/staging/vme_user/vme_fake.c
@@ -1239,6 +1239,7 @@ static void __exit fake_exit(void)
 {
 	struct list_head *pos = NULL;
 	struct list_head *tmplist;
+	struct vme_lm_resource *lm;
 	struct vme_master_resource *master_image;
 	struct vme_slave_resource *slave_image;
 	int i;
@@ -1269,6 +1270,13 @@ static void __exit fake_exit(void)
 
 	fake_crcsr_exit(fake_bridge);
 	/* resources are stored in link list */
+	list_for_each_safe(pos, tmplist, &fake_bridge->lm_resources) {
+		lm = list_entry(pos, struct vme_lm_resource, list);
+		list_del(pos);
+		kfree(lm);
+	}
+
+	/* resources are stored in link list */
 	list_for_each_safe(pos, tmplist, &fake_bridge->slave_resources) {
 		slave_image = list_entry(pos, struct vme_slave_resource, list);
 		list_del(pos);


