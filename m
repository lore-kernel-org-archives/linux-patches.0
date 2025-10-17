Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 507413277A9;
	Fri, 17 Oct 2025 15:39:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715591; cv=none; b=kszdD2qzP9AWPqPaopCDeMM6z3NJBB/qTSZsyQWjzbvF805N/S7xcXIWzdGzJmEYayoH3FGMOPfiD0k4ze+fsjh9lvSJyaXmuH8R1C2lMYIdnfjehAl8jHVTFkTa/btQvQMiinPSDcReSSegQ1McmELiaWeQnQwZcDFqusy+nMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715591; c=relaxed/simple;
	bh=WttkTSmx6mpQQG21urS5YNukrnKUgEEQ5wyTduzazKQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZAPjDfkPYELr5fHdGA9AIgqAuHkZ5T0fQ/WvkXMD1c4iIzU4UXiGMsj8Nx0ZPi2mGNgsJzFRfJnnwROUElJt7C737NR0UEuxIQHJ+ZqnxxAc4NY5ICRTP5vxlZ5x2JH9zwiTGCxjBqvrFvFjlCeGXlg4taxjDIwhfucZ2iNWu5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BeF6k1sv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BeF6k1sv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C852BC4CEE7;
	Fri, 17 Oct 2025 15:39:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760715591;
	bh=WttkTSmx6mpQQG21urS5YNukrnKUgEEQ5wyTduzazKQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BeF6k1svjWI/1s0P62VvJ1PXMyOltiyczA9p9BlbCTwjiGfn7QHoAdmoVEskyXp8u
	 fwnFUjMZkXPd+Bcg6Jvpnt6U/5rMUMWBV4CaWRDrZdASPwrtMKoswlE0iBF2dn2UAC
	 0XQakyi/SHUFwjLsB57IT5PKex36PWENnn91hL5Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Markus Elfring <Markus.Elfring@web.de>,
	Yang Erkun <yangerkun@huawei.com>,
	Ming Lei <ming.lei@redhat.com>,
	Yu Kuai <yukuai1@huaweicloud.com>,
	Li Chen <chenl311@chinatelecom.cn>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.17 236/371] loop: fix backing file reference leak on validation error
Date: Fri, 17 Oct 2025 16:53:31 +0200
Message-ID: <20251017145210.620461106@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li Chen <me@linux.beauty>

commit 98b7bf54338b797e3a11e8178ce0e806060d8fa3 upstream.

loop_change_fd() and loop_configure() call loop_check_backing_file()
to validate the new backing file. If validation fails, the reference
acquired by fget() was not dropped, leaking a file reference.

Fix this by calling fput(file) before returning the error.

Cc: stable@vger.kernel.org
Cc: Markus Elfring <Markus.Elfring@web.de>
CC: Yang Erkun <yangerkun@huawei.com>
Cc: Ming Lei <ming.lei@redhat.com>
Cc: Yu Kuai <yukuai1@huaweicloud.com>
Fixes: f5c84eff634b ("loop: Add sanity check for read/write_iter")
Signed-off-by: Li Chen <chenl311@chinatelecom.cn>
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Reviewed-by: Yang Erkun <yangerkun@huawei.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/block/loop.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -551,8 +551,10 @@ static int loop_change_fd(struct loop_de
 		return -EBADF;
 
 	error = loop_check_backing_file(file);
-	if (error)
+	if (error) {
+		fput(file);
 		return error;
+	}
 
 	/* suppress uevents while reconfiguring the device */
 	dev_set_uevent_suppress(disk_to_dev(lo->lo_disk), 1);
@@ -993,8 +995,10 @@ static int loop_configure(struct loop_de
 		return -EBADF;
 
 	error = loop_check_backing_file(file);
-	if (error)
+	if (error) {
+		fput(file);
 		return error;
+	}
 
 	is_loop = is_loop_device(file);
 


