Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4600822D78C;
	Tue, 20 May 2025 13:54:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747749257; cv=none; b=aGVdDx3D0cVRdgzlg0LGkPOpaNd4a3j8229StzpQbivrXBJBLoywpGZEJJXc8a2Fjh0T2d8mpoNQ2kZmEBPfhe9kD7bVyzohcQb86+ddar4IQCpbkaBbHqi9H7a/M+yG/DrdgRwDoZJCc6cGyEwc33mtgnkHswPf3HuBWdz1yRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747749257; c=relaxed/simple;
	bh=ZtmbbANvrtgmnMURulRnXfv8oYoZVDJM/oIKMOlZMxk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CS8a9XT/UCVlKQeNqT/Oyds5knx/7XEwTPIBQbdNYZLpjnu+dde2fvMnkFN0u4MB8C4VzpnbzrHRAlJZfDdnI9GmbzlL0TYPlpFnAZ4fMzia6ZbhrYsmhOtxUKp43RzP9GVkBF5m2iMClctw7ar6n7DqLn8E3kdDPV5IOGCUJlo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r1Hnu4+B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r1Hnu4+B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C145EC4CEE9;
	Tue, 20 May 2025 13:54:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747749257;
	bh=ZtmbbANvrtgmnMURulRnXfv8oYoZVDJM/oIKMOlZMxk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r1Hnu4+BUoc34Rv88k6mpouB3BwRdkZkQg27izuVhdK9eWtbvaV8+Xo3j76KjDPEZ
	 XUdL8qKmt/zH5NAFiSnOY/V9cY2GPyLrjQT/w5PMFMgk8AB9QLzQLmPX1EUTZOVvPc
	 m3QM4te28WaXe3Qk8SXcR2iQA9jffpWgtgRkWDLI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"stable@vger.kernel.org, Fengnan Chang" <changfengnan@bytedance.com>,
	Fengnan Chang <changfengnan@bytedance.com>
Subject: [PATCH 5.15 46/59] block: fix direct io NOWAIT flag not work
Date: Tue, 20 May 2025 15:50:37 +0200
Message-ID: <20250520125755.671687774@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125753.836407405@linuxfoundation.org>
References: <20250520125753.836407405@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fengnan Chang <changfengnan@bytedance.com>

commit 8b44b4d81598 ("block: don't allow multiple bios for IOCB_NOWAIT
issue") backport a upstream fix, but miss commit b77c88c2100c ("block:
pass a block_device and opf to bio_alloc_kiocb"), and introduce this bug.
commit b77c88c2100c ("block: pass a block_device and opf to
bio_alloc_kiocb") have other depend patch, so just fix it.

Fixes: 8b44b4d81598 ("block: don't allow multiple bios for IOCB_NOWAIT issue")
Signed-off-by: Fengnan Chang <changfengnan@bytedance.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/fops.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/block/fops.c
+++ b/block/fops.c
@@ -259,7 +259,6 @@ static ssize_t __blkdev_direct_IO(struct
 				blk_finish_plug(&plug);
 				return -EAGAIN;
 			}
-			bio->bi_opf |= REQ_NOWAIT;
 		}
 
 		if (is_read) {
@@ -270,6 +269,10 @@ static ssize_t __blkdev_direct_IO(struct
 			bio->bi_opf = dio_bio_write_op(iocb);
 			task_io_account_write(bio->bi_iter.bi_size);
 		}
+
+		if (iocb->ki_flags & IOCB_NOWAIT)
+			bio->bi_opf |= REQ_NOWAIT;
+
 		dio->size += bio->bi_iter.bi_size;
 		pos += bio->bi_iter.bi_size;
 


