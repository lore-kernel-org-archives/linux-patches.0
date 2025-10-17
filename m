Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 580C81D5CE0;
	Fri, 17 Oct 2025 15:20:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760714444; cv=none; b=XCbWv9mSTGf3/oGMSko+mHnK5l+F8QF2knd2cCSRyEAFgLGg1TTG8wq1atrPpVcyGdhq5sLwu6onR4R7MTMGKjdwGwaByKO2Y4fKkFPeFz+p1yxBNYgx8katRCfVt31JCCRqGb6v2/2F0sDLZP+3qKxmUl6CkakNO0JSe2ielqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760714444; c=relaxed/simple;
	bh=VJBHMiXlBaLTuCNDqJWMXG55sXIucT25bpf4D8VjP/0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FQ/d600ejmsn7fD4IVDjUflyzpIWuddnHKMHIpC7obMu+8r46iKa7fq5Dr0aoJKVWI393p72y0uoYXKvGtnP4lKmFQdXmuV8jMYHxFxdOi0kZHYzQymRI9qmYjCXcKEEUQos2XJlJB5BT/n2vg7D602xJBO8962PydP6dUSXkWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W/T8xDFO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W/T8xDFO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB028C4CEE7;
	Fri, 17 Oct 2025 15:20:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760714444;
	bh=VJBHMiXlBaLTuCNDqJWMXG55sXIucT25bpf4D8VjP/0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W/T8xDFOo4nStfFTMRy5GEpSQ5Qwe6fAsikRS9Mc2LnDozwv2Ck3JGnQq9DoIYXqi
	 2yhJC3yevCoyjkrnPNlc/GgO+wv/H2nyRg8Cfif/DS+LqjgO2nc4posKGRYFfOIj76
	 lgfhulF8UbK45qbajipLf/IR3+mTom6GfXoHigvE=
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
Subject: [PATCH 6.12 148/277] loop: fix backing file reference leak on validation error
Date: Fri, 17 Oct 2025 16:52:35 +0200
Message-ID: <20251017145152.528627400@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145147.138822285@linuxfoundation.org>
References: <20251017145147.138822285@linuxfoundation.org>
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
@@ -536,8 +536,10 @@ static int loop_change_fd(struct loop_de
 		return -EBADF;
 
 	error = loop_check_backing_file(file);
-	if (error)
+	if (error) {
+		fput(file);
 		return error;
+	}
 
 	/* suppress uevents while reconfiguring the device */
 	dev_set_uevent_suppress(disk_to_dev(lo->lo_disk), 1);
@@ -973,8 +975,10 @@ static int loop_configure(struct loop_de
 		return -EBADF;
 
 	error = loop_check_backing_file(file);
-	if (error)
+	if (error) {
+		fput(file);
 		return error;
+	}
 
 	is_loop = is_loop_device(file);
 


