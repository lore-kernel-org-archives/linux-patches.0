Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79D1E3009E2;
	Thu, 16 Jul 2026 14:05:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210727; cv=none; b=kmQvlXoACjd+ruv4xbPMewaitIm6muq1/wwpMtdXFNXT5dcRkxizQdNx7056+hhtNA0s0IwS3jgbA54Jj4tYoKmT+9mIB1TZyzVT5CnJJaHcGnL5R1NZmca1+8Ojj4My+peAFti8XOki99CmDkLWi1KI0qmt2PpH2R0B8r1Rv/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210727; c=relaxed/simple;
	bh=RFInnW84Y2Lxui4nGGop4jBfvIlwYPeMhAXnADarYOA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CI2wTN+GZBRtspnWj8DH/OoT15PP2dQA12eYwaE+L1kDOrK7sRNkqSrau2oao2zqdW60X5Znwrs1bbC+lrjkbWGyJJM5DQPB/WpX3vO42L7V+QtaUuYajdx4yi21JGKPAN520Kr/7EdaytPs6tlJO0ai9sPSjXjbQ2+1miR17x0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Npbm9hwj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Npbm9hwj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE9E71F000E9;
	Thu, 16 Jul 2026 14:05:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210726;
	bh=22WGn7jk/VqJMSpv13JF+OoeLLWJ4pyW5MMiREu9MTg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Npbm9hwjMPyxCkXwFiFKsHDiSIj95ZoxzxC3lDpZTxKgank57Zvy29nE0ZUUYZbU5
	 pfltNrVMCaqgKXYSSrdwL9wKO1by9vz/1RUl+FCWCGoDDPyzvoWQ8ZKPFSYnKQPfn5
	 u/NRzi4+puFS3JtUAeKkmm0wJ5UTjVsuF8MoJJtw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Martyn Welch <martyn@welchs.me.uk>,
	Hao-Qun Huang <alvinhuang0603@gmail.com>
Subject: [PATCH 6.18 157/480] staging: vme_user: fix location monitor leak in fake bridge
Date: Thu, 16 Jul 2026 15:28:24 +0200
Message-ID: <20260716133048.104409674@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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


