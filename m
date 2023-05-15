Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B298EDF40
	for <patches@lists.linux.dev>; Mon, 15 May 2023 16:38:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A1F7C433D2;
	Mon, 15 May 2023 16:38:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684168725;
	bh=rPrFVykLGyIwbOrWdYyCSdfqLKOOGMD8pVRAUnqFu4U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GH/SPl/KJ+bafSay7IwAKu0VuRWBMbKqG101olMGhlQY+N7pVZEJNf6cHJpECSWLM
	 vA9CHTLGfjNfNbKr9CyIPaaG1ned+fwPI7lnZ4HL75WvFNtam+ZcwLdgJQbkSqjQsF
	 QbWN1oIFgtYVUXEyakc3tfSwiuwq1j0iwpfVXyoc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wang YanQing <udknight@gmail.com>,
	Zhihao Cheng <chengzhihao1@huawei.com>,
	Richard Weinberger <richard@nod.at>
Subject: [PATCH 4.19 021/191] ubi: Fix return value overwrite issue in try_write_vid_and_data()
Date: Mon, 15 May 2023 18:24:18 +0200
Message-Id: <20230515161707.964132361@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161707.203549282@linuxfoundation.org>
References: <20230515161707.203549282@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Wang YanQing <udknight@gmail.com>

commit 31a149d5c13c4cbcf97de3435817263a2d8c9d6e upstream.

The commit 2d78aee426d8 ("UBI: simplify LEB write and atomic LEB change code")
adds helper function, try_write_vid_and_data(), to simplify the code, but this
helper function has bug, it will return 0 (success) when ubi_io_write_vid_hdr()
or the ubi_io_write_data() return error number (-EIO, etc), because the return
value of ubi_wl_put_peb() will overwrite the original return value.

This issue will cause unexpected data loss issue, because the caller of this
function and UBIFS willn't know the data is lost.

Fixes: 2d78aee426d8 ("UBI: simplify LEB write and atomic LEB change code")
Cc: stable@vger.kernel.org
Signed-off-by: Wang YanQing <udknight@gmail.com>
Reviewed-by: Zhihao Cheng <chengzhihao1@huawei.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/ubi/eba.c |   19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

--- a/drivers/mtd/ubi/eba.c
+++ b/drivers/mtd/ubi/eba.c
@@ -960,7 +960,7 @@ static int try_write_vid_and_data(struct
 				  int offset, int len)
 {
 	struct ubi_device *ubi = vol->ubi;
-	int pnum, opnum, err, vol_id = vol->vol_id;
+	int pnum, opnum, err, err2, vol_id = vol->vol_id;
 
 	pnum = ubi_wl_get_peb(ubi);
 	if (pnum < 0) {
@@ -995,10 +995,19 @@ static int try_write_vid_and_data(struct
 out_put:
 	up_read(&ubi->fm_eba_sem);
 
-	if (err && pnum >= 0)
-		err = ubi_wl_put_peb(ubi, vol_id, lnum, pnum, 1);
-	else if (!err && opnum >= 0)
-		err = ubi_wl_put_peb(ubi, vol_id, lnum, opnum, 0);
+	if (err && pnum >= 0) {
+		err2 = ubi_wl_put_peb(ubi, vol_id, lnum, pnum, 1);
+		if (err2) {
+			ubi_warn(ubi, "failed to return physical eraseblock %d, error %d",
+				 pnum, err2);
+		}
+	} else if (!err && opnum >= 0) {
+		err2 = ubi_wl_put_peb(ubi, vol_id, lnum, opnum, 0);
+		if (err2) {
+			ubi_warn(ubi, "failed to return physical eraseblock %d, error %d",
+				 opnum, err2);
+		}
+	}
 
 	return err;
 }


