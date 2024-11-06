Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B84E51F4725;
	Wed,  6 Nov 2024 12:52:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730897574; cv=none; b=fxfgW0GTnKCPA7KyUIMZl7cDICd2+3LTyC4BoPKqZFukHOJwNxf503lrw7pCaRxIjAyqwJuRMcGjy9mHL2azr3YnZ2vV0qR9hOAgKK1jgA8HX98jlhSeTHrtNqcacnDKctJ/r2NC3id7U0FTLX44I/xU/qHNlT+tq4Hw7Zn8h8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730897574; c=relaxed/simple;
	bh=9iNYxRXqoocMOqlW5Ftyg1ur55lMKDZ4JCn1Dkx05xI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cllxH7/tF/4LzvVazdXxMmmRzZ+MpeUohuQQW+32mWzefR94TZnAa9FuCxIIltBVcMdI3CdMrOmB+B57RFNc2PZmDw/kiWfq56WShK5XphaAFtjFNkWTrUlj3Ktom7ta47F1qaFiUdyHgY42c2wH0rbh8jUqfb06xroG3otX2ww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nwA809f7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nwA809f7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36057C4CECD;
	Wed,  6 Nov 2024 12:52:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730897574;
	bh=9iNYxRXqoocMOqlW5Ftyg1ur55lMKDZ4JCn1Dkx05xI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nwA809f7stPfZsUIiwSzcST0AqmmXpnezdmAeZDTQyyL7f97aJNHgVHJOP4NrM4dS
	 ZUyRTVrepfkz4ghVCNS3TY2FLZ1oOWlZrhyLGWf2eax1jPw4KMBNn1ui9VyJXmFKhp
	 v8nsoNIKK0AwExjIQ8G19A3x4SLZ9VErR1+JNUCQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Matti Vaittinen <mazziesaccount@gmail.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.6 099/151] iio: gts-helper: Fix memory leaks in iio_gts_build_avail_scale_table()
Date: Wed,  6 Nov 2024 13:04:47 +0100
Message-ID: <20241106120311.598152912@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120308.841299741@linuxfoundation.org>
References: <20241106120308.841299741@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/iio/industrialio-gts-helper.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/iio/industrialio-gts-helper.c b/drivers/iio/industrialio-gts-helper.c
index 59d7615c0f56..7326c7949244 100644
--- a/drivers/iio/industrialio-gts-helper.c
+++ b/drivers/iio/industrialio-gts-helper.c
@@ -307,6 +307,8 @@ static int iio_gts_build_avail_scale_table(struct iio_gts *gts)
 	if (ret)
 		goto err_free_out;
 
+	for (i = 0; i < gts->num_itime; i++)
+		kfree(per_time_gains[i]);
 	kfree(per_time_gains);
 	gts->per_time_avail_scale_tables = per_time_scales;
 
-- 
2.47.0



