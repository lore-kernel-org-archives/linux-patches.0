Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CDB07DA7F;
	Wed,  6 Nov 2024 12:30:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896221; cv=none; b=JDLhXICp8188kXLIjn6RPDeEPPIDmD4KvLR9+RqDPRzpVbvH+6KP8ha5MqhV2lMCIsZIxhiDM1SjKMxhfsQwCVdsYwgvYjvIittxJva8xJccWf9VJpbRIUT1Of1exrohbHMgNo8K9hJGxNXiwDutr/xK/gP0cOR5KfVVAW445jE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896221; c=relaxed/simple;
	bh=GzfIqZT6FxwehxYWE+gVuaHm/aCH504DBqhF2n6yD50=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m9hqz1pVXoZW6bVeY1Z1sVvUcWFiDjaYLR4+ElgqZPXxWTDMjVA7reGoma5w0Hql16Zu3N9ZnmfgvZZ8B8EaTUYDVraZeRwTXAarD7H5HaFYuX4sOBDpb/pQQv2hOI2RK6/O7f6CDqIxYxCP6dnyku7s398M8eIu2md3lfGd2iM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=On6Z1Lt4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="On6Z1Lt4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77471C4CECD;
	Wed,  6 Nov 2024 12:30:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730896220;
	bh=GzfIqZT6FxwehxYWE+gVuaHm/aCH504DBqhF2n6yD50=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=On6Z1Lt4/r4K6VhZFUYW93nvutYaNO/rWBqdQPCUuJVFtFSiYFqqZGhvvEQiMBnDi
	 hpSNeeCGsrrZ5j2IdTScI/5edU/2aR8eBQmFQFvbDtjUKa6/lSpq7l9dZ/4wkqJP6q
	 sXTaL5Zo+OndMmh6jl5NOBJoeGtPGv1r5Fc6Jd8Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Matti Vaittinen <mazziesaccount@gmail.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.11 131/245] iio: gts-helper: Fix memory leaks in iio_gts_build_avail_scale_table()
Date: Wed,  6 Nov 2024 13:03:04 +0100
Message-ID: <20241106120322.448084155@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120319.234238499@linuxfoundation.org>
References: <20241106120319.234238499@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jinjie Ruan <ruanjinjie@huawei.com>

commit 691e79ffc42154a9c91dc3b7e96a307037b4be74 upstream.

modprobe iio-test-gts and rmmod it, then the following memory leak
occurs:

	unreferenced object 0xffffff80c810be00 (size 64):
	  comm "kunit_try_catch", pid 1654, jiffies 4294913981
	  hex dump (first 32 bytes):
	    02 00 00 00 08 00 00 00 20 00 00 00 40 00 00 00  ........ ...@...
	    80 00 00 00 00 02 00 00 00 04 00 00 00 08 00 00  ................
	  backtrace (crc a63d875e):
	    [<0000000028c1b3c2>] kmemleak_alloc+0x34/0x40
	    [<000000001d6ecc87>] __kmalloc_noprof+0x2bc/0x3c0
	    [<00000000393795c1>] devm_iio_init_iio_gts+0x4b4/0x16f4
	    [<0000000071bb4b09>] 0xffffffdf052a62e0
	    [<000000000315bc18>] 0xffffffdf052a6488
	    [<00000000f9dc55b5>] kunit_try_run_case+0x13c/0x3ac
	    [<00000000175a3fd4>] kunit_generic_run_threadfn_adapter+0x80/0xec
	    [<00000000f505065d>] kthread+0x2e8/0x374
	    [<00000000bbfb0e5d>] ret_from_fork+0x10/0x20
	unreferenced object 0xffffff80cbfe9e70 (size 16):
	  comm "kunit_try_catch", pid 1658, jiffies 4294914015
	  hex dump (first 16 bytes):
	    10 00 00 00 40 00 00 00 80 00 00 00 00 00 00 00  ....@...........
	  backtrace (crc 857f0cb4):
	    [<0000000028c1b3c2>] kmemleak_alloc+0x34/0x40
	    [<000000001d6ecc87>] __kmalloc_noprof+0x2bc/0x3c0
	    [<00000000393795c1>] devm_iio_init_iio_gts+0x4b4/0x16f4
	    [<0000000071bb4b09>] 0xffffffdf052a62e0
	    [<000000007d089d45>] 0xffffffdf052a6864
	    [<00000000f9dc55b5>] kunit_try_run_case+0x13c/0x3ac
	    [<00000000175a3fd4>] kunit_generic_run_threadfn_adapter+0x80/0xec
	    [<00000000f505065d>] kthread+0x2e8/0x374
	    [<00000000bbfb0e5d>] ret_from_fork+0x10/0x20
	......

It includes 5*5 times "size 64" memory leaks, which correspond to 5 times
test_init_iio_gain_scale() calls with gts_test_gains size 10 (10*size(int))
and gts_test_itimes size 5. It also includes 5*1 times "size 16"
memory leak, which correspond to one time __test_init_iio_gain_scale()
call with gts_test_gains_gain_low size 3 (3*size(int)) and gts_test_itimes
size 5.

The reason is that the per_time_gains[i] is not freed which is allocated in
the "gts->num_itime" for loop in iio_gts_build_avail_scale_table().

Cc: stable@vger.kernel.org
Fixes: 38416c28e168 ("iio: light: Add gain-time-scale helpers")
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
Reviewed-by: Matti Vaittinen <mazziesaccount@gmail.com>
Link: https://patch.msgid.link/20241011095512.3667549-1-ruanjinjie@huawei.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/industrialio-gts-helper.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/iio/industrialio-gts-helper.c
+++ b/drivers/iio/industrialio-gts-helper.c
@@ -307,6 +307,8 @@ static int iio_gts_build_avail_scale_tab
 	if (ret)
 		goto err_free_out;
 
+	for (i = 0; i < gts->num_itime; i++)
+		kfree(per_time_gains[i]);
 	kfree(per_time_gains);
 	gts->per_time_avail_scale_tables = per_time_scales;
 


