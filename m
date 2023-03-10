Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D42598481
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 14:06:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 504A8C433D2;
	Fri, 10 Mar 2023 14:06:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678457163;
	bh=rAVK09GvI0sZ+tjgMiU6r2EeyV9OP5l4Xml8V9iKA3E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pdMy7saLy5c3uVz8gFzaUdrfuROxkaV9U+FPy6Uugk38zVj7pFwWZ12s7RZk0IYg7
	 3xtY9U+FxxTXMd7bqGLD4ReNckCRBDAq94skN2AP1n5Qsz11tO51rtf6L4uBc5h+vB
	 RWi25EYzG29PTRzjZwedVrmdnPIpmPfTNWuL5d84=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhihao Cheng <chengzhihao1@huawei.com>,
	Richard Weinberger <richard@nod.at>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 042/200] ubi: ubi_wl_put_peb: Fix infinite loop when wear-leveling work failed
Date: Fri, 10 Mar 2023 14:37:29 +0100
Message-Id: <20230310133718.371554047@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133717.050159289@linuxfoundation.org>
References: <20230310133717.050159289@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Zhihao Cheng <chengzhihao1@huawei.com>

[ Upstream commit 4d57a7333e26040f2b583983e1970d9d460e56b0 ]

Following process will trigger an infinite loop in ubi_wl_put_peb():

	ubifs_bgt		ubi_bgt
ubifs_leb_unmap
  ubi_leb_unmap
    ubi_eba_unmap_leb
      ubi_wl_put_peb	wear_leveling_worker
                          e1 = rb_entry(rb_first(&ubi->used)
			  e2 = get_peb_for_wl(ubi)
			  ubi_io_read_vid_hdr  // return err (flash fault)
			  out_error:
			    ubi->move_from = ubi->move_to = NULL
			    wl_entry_destroy(ubi, e1)
			      ubi->lookuptbl[e->pnum] = NULL
      retry:
        e = ubi->lookuptbl[pnum];	// return NULL
	if (e == ubi->move_from) {	// NULL == NULL gets true
	  goto retry;			// infinite loop !!!

$ top
  PID USER      PR  NI    VIRT    RES    SHR S  %CPU %MEM     COMMAND
  7676 root     20   0       0      0      0 R 100.0  0.0  ubifs_bgt0_0

Fix it by:
 1) Letting ubi_wl_put_peb() returns directly if wearl leveling entry has
    been removed from 'ubi->lookuptbl'.
 2) Using 'ubi->wl_lock' protecting wl entry deletion to preventing an
    use-after-free problem for wl entry in ubi_wl_put_peb().

Fetch a reproducer in [Link].

Fixes: 43f9b25a9cdd7b1 ("UBI: bugfix: protect from volume removal")
Fixes: ee59ba8b064f692 ("UBI: Fix stale pointers in ubi->lookuptbl")
Link: https://bugzilla.kernel.org/show_bug.cgi?id=216111
Signed-off-by: Zhihao Cheng <chengzhihao1@huawei.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/ubi/wl.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/mtd/ubi/wl.c b/drivers/mtd/ubi/wl.c
index f45df3b773739..9e14319225c97 100644
--- a/drivers/mtd/ubi/wl.c
+++ b/drivers/mtd/ubi/wl.c
@@ -976,11 +976,11 @@ static int wear_leveling_worker(struct ubi_device *ubi, struct ubi_work *wrk,
 	spin_lock(&ubi->wl_lock);
 	ubi->move_from = ubi->move_to = NULL;
 	ubi->move_to_put = ubi->wl_scheduled = 0;
+	wl_entry_destroy(ubi, e1);
+	wl_entry_destroy(ubi, e2);
 	spin_unlock(&ubi->wl_lock);
 
 	ubi_free_vid_buf(vidb);
-	wl_entry_destroy(ubi, e1);
-	wl_entry_destroy(ubi, e2);
 
 out_ro:
 	ubi_ro_mode(ubi);
@@ -1260,6 +1260,18 @@ int ubi_wl_put_peb(struct ubi_device *ubi, int vol_id, int lnum,
 retry:
 	spin_lock(&ubi->wl_lock);
 	e = ubi->lookuptbl[pnum];
+	if (!e) {
+		/*
+		 * This wl entry has been removed for some errors by other
+		 * process (eg. wear leveling worker), corresponding process
+		 * (except __erase_worker, which cannot concurrent with
+		 * ubi_wl_put_peb) will set ubi ro_mode at the same time,
+		 * just ignore this wl entry.
+		 */
+		spin_unlock(&ubi->wl_lock);
+		up_read(&ubi->fm_protect);
+		return 0;
+	}
 	if (e == ubi->move_from) {
 		/*
 		 * User is putting the physical eraseblock which was selected to
-- 
2.39.2



