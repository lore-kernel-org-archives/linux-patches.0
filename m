Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 666054266B2;
	Tue, 21 Jul 2026 21:12:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784668368; cv=none; b=cQ0r53OCNYyGkP0cnD2yUFo+u/r/o1mvmJPvKVmTpRWo9qBDVuRLmZFelCokH7kza4nGcoPXcGHE2maAA8TcnNxfAMb78soQFfGjBY5v+B4JrgX3DdXYqHJ3zcb2p7IbsskP81KFQsGTY/DFUlUwT3OlyXzldXNjYc+jeu1Lo00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784668368; c=relaxed/simple;
	bh=pICdW4y3/4YWsDVGrCp77X2RFsToCpAYLvOFwvxsZVs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nBq24sDA8z9eSCc7fhCtqzfbeQfh0DSa9AzVrHCoGUojZln1oiKL19wkvw5eAdrqcq97a/0b3CvfftUDW2HnUxJOnA0hzYje3esjTr7UW2iuIVc4z8DL7m9hMK4AXzdtznXE07NZnAcp9BopQylyeBNPjhOghjP3oYZDb9SduFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kB5j50fM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kB5j50fM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC0491F000E9;
	Tue, 21 Jul 2026 21:12:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784668367;
	bh=J4cvEfQjBOEOC8i+nkZW8/m0NMA04OQLNhyMJkxwzdw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kB5j50fMI6x4ArAIWG20fcxVReCLHWj56mXEJ6deRvUYNyd7IaeHcCmkhd3pnnuAY
	 ku61cPxpZeRW9T9Vwxk1m4VexrTvRsEqCQmPjRZJO1KS7RaiOD1ieJAjdMrnI222bJ
	 X7RM2zm2iQrCYRDY3ETuZoKdoeCNQ7Guu8rtsPdI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Martyn Welch <martyn@welchs.me.uk>,
	Hao-Qun Huang <alvinhuang0603@gmail.com>
Subject: [PATCH 6.1 0105/1067] staging: vme_user: fix location monitor leak in fake bridge
Date: Tue, 21 Jul 2026 17:11:46 +0200
Message-ID: <20260721152426.938370319@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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
@@ -1253,6 +1253,7 @@ static void __exit fake_exit(void)
 {
 	struct list_head *pos = NULL;
 	struct list_head *tmplist;
+	struct vme_lm_resource *lm;
 	struct vme_master_resource *master_image;
 	struct vme_slave_resource *slave_image;
 	int i;
@@ -1283,6 +1284,13 @@ static void __exit fake_exit(void)
 
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


