Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B95F81E572B;
	Mon, 21 Oct 2024 10:34:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729506878; cv=none; b=PlZsflXk7HtKs8FQDBNPkEv27SDQVKPlqhtFl0jgi46e+eXIcfjBk0BbQLHTrVaaI2kvvv7DzArrr55Lxa3FW1u2ypnmTIjLqPh1GDE+28DfeSD7vY9Pbone4SSGQfBIxPMue1DkyuesxBHdi7ofc1FFgrUYEA1vU48wn6LmstM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729506878; c=relaxed/simple;
	bh=rQYhdvkwhxxuTT5kRb9U/WoCWYP/FU6FDvvxDYuVFVU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Hcm+HhpxnKylx6GOMZb5VZEofa53knfzcAyPNEp15U2LexkESXMni+Caxw6+Lr66Fw0fPnEFgP3q7PY6Z5JG1zMFvoeINUw9E0NirIx7rDvLrbezb+j9tzExgfEf01S1+OZ+tTyjiWIeu7vsUN0iGrL31H5yG7G+x7r+7SECh8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JL7Fq2dK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JL7Fq2dK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A5F7C4CEC3;
	Mon, 21 Oct 2024 10:34:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729506878;
	bh=rQYhdvkwhxxuTT5kRb9U/WoCWYP/FU6FDvvxDYuVFVU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JL7Fq2dKlRADDuENswlsLDe+vT37n9UfTdAugjO2ZfLgkdtO9vM/G+LjhbI3VODF9
	 Sdjtj+9l3A4NfMgfzIIxx65sGtf/VYw2yw0V4NHhvngYClepBq5By6fJ63Sh4deeE0
	 sj5ENEPYyrBUARpK3rvHcQhMM/0SR7/p1kUqMHLQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Horman <horms@kernel.org>,
	=?UTF-8?q?Jens=20Emil=20Schulz=20=C3=98stergaard?= <jensemil.schulzostergaard@microchip.com>,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 016/124] net: microchip: vcap api: Fix memory leaks in vcap_api_encode_rule_test()
Date: Mon, 21 Oct 2024 12:23:40 +0200
Message-ID: <20241021102257.351838155@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102256.706334758@linuxfoundation.org>
References: <20241021102256.706334758@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jinjie Ruan <ruanjinjie@huawei.com>

commit 217a3d98d1e9891a8b1438a27dfbc64ddf01f691 upstream.

Commit a3c1e45156ad ("net: microchip: vcap: Fix use-after-free error in
kunit test") fixed the use-after-free error, but introduced below
memory leaks by removing necessary vcap_free_rule(), add it to fix it.

	unreferenced object 0xffffff80ca58b700 (size 192):
	  comm "kunit_try_catch", pid 1215, jiffies 4294898264
	  hex dump (first 32 bytes):
	    00 12 7a 00 05 00 00 00 0a 00 00 00 64 00 00 00  ..z.........d...
	    00 00 00 00 00 00 00 00 00 04 0b cc 80 ff ff ff  ................
	  backtrace (crc 9c09c3fe):
	    [<0000000052a0be73>] kmemleak_alloc+0x34/0x40
	    [<0000000043605459>] __kmalloc_cache_noprof+0x26c/0x2f4
	    [<0000000040a01b8d>] vcap_alloc_rule+0x3cc/0x9c4
	    [<000000003fe86110>] vcap_api_encode_rule_test+0x1ac/0x16b0
	    [<00000000b3595fc4>] kunit_try_run_case+0x13c/0x3ac
	    [<0000000010f5d2bf>] kunit_generic_run_threadfn_adapter+0x80/0xec
	    [<00000000c5d82c9a>] kthread+0x2e8/0x374
	    [<00000000f4287308>] ret_from_fork+0x10/0x20
	unreferenced object 0xffffff80cc0b0400 (size 64):
	  comm "kunit_try_catch", pid 1215, jiffies 4294898265
	  hex dump (first 32 bytes):
	    80 04 0b cc 80 ff ff ff 18 b7 58 ca 80 ff ff ff  ..........X.....
	    39 00 00 00 02 00 00 00 06 05 04 03 02 01 ff ff  9...............
	  backtrace (crc daf014e9):
	    [<0000000052a0be73>] kmemleak_alloc+0x34/0x40
	    [<0000000043605459>] __kmalloc_cache_noprof+0x26c/0x2f4
	    [<000000000ff63fd4>] vcap_rule_add_key+0x2cc/0x528
	    [<00000000dfdb1e81>] vcap_api_encode_rule_test+0x224/0x16b0
	    [<00000000b3595fc4>] kunit_try_run_case+0x13c/0x3ac
	    [<0000000010f5d2bf>] kunit_generic_run_threadfn_adapter+0x80/0xec
	    [<00000000c5d82c9a>] kthread+0x2e8/0x374
	    [<00000000f4287308>] ret_from_fork+0x10/0x20
	unreferenced object 0xffffff80cc0b0700 (size 64):
	  comm "kunit_try_catch", pid 1215, jiffies 4294898265
	  hex dump (first 32 bytes):
	    80 07 0b cc 80 ff ff ff 28 b7 58 ca 80 ff ff ff  ........(.X.....
	    3c 00 00 00 00 00 00 00 01 2f 03 b3 ec ff ff ff  <......../......
	  backtrace (crc 8d877792):
	    [<0000000052a0be73>] kmemleak_alloc+0x34/0x40
	    [<0000000043605459>] __kmalloc_cache_noprof+0x26c/0x2f4
	    [<000000006eadfab7>] vcap_rule_add_action+0x2d0/0x52c
	    [<00000000323475d1>] vcap_api_encode_rule_test+0x4d4/0x16b0
	    [<00000000b3595fc4>] kunit_try_run_case+0x13c/0x3ac
	    [<0000000010f5d2bf>] kunit_generic_run_threadfn_adapter+0x80/0xec
	    [<00000000c5d82c9a>] kthread+0x2e8/0x374
	    [<00000000f4287308>] ret_from_fork+0x10/0x20
	unreferenced object 0xffffff80cc0b0900 (size 64):
	  comm "kunit_try_catch", pid 1215, jiffies 4294898266
	  hex dump (first 32 bytes):
	    80 09 0b cc 80 ff ff ff 80 06 0b cc 80 ff ff ff  ................
	    7d 00 00 00 01 00 00 00 00 00 00 00 ff 00 00 00  }...............
	  backtrace (crc 34181e56):
	    [<0000000052a0be73>] kmemleak_alloc+0x34/0x40
	    [<0000000043605459>] __kmalloc_cache_noprof+0x26c/0x2f4
	    [<000000000ff63fd4>] vcap_rule_add_key+0x2cc/0x528
	    [<00000000991e3564>] vcap_val_rule+0xcf0/0x13e8
	    [<00000000fc9868e5>] vcap_api_encode_rule_test+0x678/0x16b0
	    [<00000000b3595fc4>] kunit_try_run_case+0x13c/0x3ac
	    [<0000000010f5d2bf>] kunit_generic_run_threadfn_adapter+0x80/0xec
	    [<00000000c5d82c9a>] kthread+0x2e8/0x374
	    [<00000000f4287308>] ret_from_fork+0x10/0x20
	unreferenced object 0xffffff80cc0b0980 (size 64):
	  comm "kunit_try_catch", pid 1215, jiffies 4294898266
	  hex dump (first 32 bytes):
	    18 b7 58 ca 80 ff ff ff 00 09 0b cc 80 ff ff ff  ..X.............
	    67 00 00 00 00 00 00 00 01 01 74 88 c0 ff ff ff  g.........t.....
	  backtrace (crc 275fd9be):
	    [<0000000052a0be73>] kmemleak_alloc+0x34/0x40
	    [<0000000043605459>] __kmalloc_cache_noprof+0x26c/0x2f4
	    [<000000000ff63fd4>] vcap_rule_add_key+0x2cc/0x528
	    [<000000001396a1a2>] test_add_def_fields+0xb0/0x100
	    [<000000006e7621f0>] vcap_val_rule+0xa98/0x13e8
	    [<00000000fc9868e5>] vcap_api_encode_rule_test+0x678/0x16b0
	    [<00000000b3595fc4>] kunit_try_run_case+0x13c/0x3ac
	    [<0000000010f5d2bf>] kunit_generic_run_threadfn_adapter+0x80/0xec
	    [<00000000c5d82c9a>] kthread+0x2e8/0x374
	    [<00000000f4287308>] ret_from_fork+0x10/0x20
	......

Cc: stable@vger.kernel.org
Fixes: a3c1e45156ad ("net: microchip: vcap: Fix use-after-free error in kunit test")
Reviewed-by: Simon Horman <horms@kernel.org>
Reviewed-by: Jens Emil Schulz Østergaard <jensemil.schulzostergaard@microchip.com>
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
Link: https://patch.msgid.link/20241014121922.1280583-1-ruanjinjie@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/microchip/vcap/vcap_api_kunit.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/microchip/vcap/vcap_api_kunit.c b/drivers/net/ethernet/microchip/vcap/vcap_api_kunit.c
index f2a5a36fdacd..7251121ab196 100644
--- a/drivers/net/ethernet/microchip/vcap/vcap_api_kunit.c
+++ b/drivers/net/ethernet/microchip/vcap/vcap_api_kunit.c
@@ -1444,6 +1444,8 @@ static void vcap_api_encode_rule_test(struct kunit *test)
 
 	ret = vcap_del_rule(&test_vctrl, &test_netdev, id);
 	KUNIT_EXPECT_EQ(test, 0, ret);
+
+	vcap_free_rule(rule);
 }
 
 static void vcap_api_set_rule_counter_test(struct kunit *test)
-- 
2.47.0



