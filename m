Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F2C38F74
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:03:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4006C433C7;
	Sun, 16 Jul 2023 20:03:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689537821;
	bh=XdmBM+HcrORK2datcEIfJ15niSu1b/KXMSjP8u+P144=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pXFwl/8wpCZIKFc4JqTpSxALNCT64HNZk6Uu1UdCpeVyAH9BFGuRI44moGWwe+GGN
	 RIRJPKUA5qFpRSlQk5101WRlfwdIeaVmg67Na6vUDGq08aerbChlPCg5FOjgeIK8BM
	 DlNgfrfsvGV6ttDSqAfNzt1bx5ApE2DcyVTK6GLk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Javier Martinez Canillas <javierm@redhat.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 232/800] Input: tests - fix use-after-free and refcount underflow in input_test_exit()
Date: Sun, 16 Jul 2023 21:41:25 +0200
Message-ID: <20230716194954.477945642@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit fd75f3694b1dd5070408ea4a58ca7f8e0a3fcbcd ]

With CONFIG_DEBUG_SLAB=y:

        # Subtest: input_core
        1..3
    input: Test input device as /devices/virtual/input/input1
    8<--- cut here ---
    Unable to handle kernel paging request at virtual address 6b6b6dd7 when read
    ...
     __lock_acquire from lock_acquire+0x26c/0x300
     lock_acquire from _raw_spin_lock_irqsave+0x50/0x64
     _raw_spin_lock_irqsave from devres_remove+0x20/0x7c
     devres_remove from devres_destroy+0x8/0x24
     devres_destroy from input_free_device+0x2c/0x60
     input_free_device from kunit_try_run_case+0x70/0x94 [kunit]

Without CONFIG_DEBUG_SLAB=y:

	KTAP version 1
	# Subtest: input_core
	1..3
    input: Test input device as /devices/virtual/input/input1
    ------------[ cut here ]------------
    WARNING: CPU: 0 PID: 694 at lib/refcount.c:28 refcount_warn_saturate+0x54/0x100
    refcount_t: underflow; use-after-free.
    ...
    Call Trace: [<0037cad4>] dump_stack+0xc/0x10
     [<00377614>] __warn+0x7e/0xb4
     [<0037768c>] warn_slowpath_fmt+0x42/0x62
     [<001eee1c>] refcount_warn_saturate+0x54/0x100
     [<000b1d34>] kfree_const+0x0/0x20
     [<0036290a>] __kobject_del+0x0/0x6e
     [<001eee1c>] refcount_warn_saturate+0x54/0x100
     [<00362a1a>] kobject_put+0xa2/0xb6
     [<11965770>] kunit_generic_run_threadfn_adapter+0x0/0x1c [kunit]

As per the comments for input_allocate_device() and
input_register_device(), input_free_device() must be called only to free
devices that have not been registered.  input_unregister_device()
already calls input_put_device(), thus leading to a use-after-free.

Moreover, the kunit_suite.exit() method is called after every test case,
even on failures.  As the test itself already does cleanups in its
failure paths, this may lead to a second use-after-free.

Fix the first issue by dropping the call to input_allocate_device() from
input_test_exit().
Fix the second issue by making the cleanup code conditional on a
successful test.

Fixes: fdefcbdd6f361841 ("Input: Add KUnit tests for some of the input core helper functions")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Javier Martinez Canillas <javierm@redhat.com>
Link: https://lore.kernel.org/r/957b3b309a44d39fb6e38b2a526b250f69ea3d2c.1683022164.git.geert+renesas@glider.be
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/tests/input_test.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/input/tests/input_test.c b/drivers/input/tests/input_test.c
index e5a6c1ad2167c..8b8ac3412a70d 100644
--- a/drivers/input/tests/input_test.c
+++ b/drivers/input/tests/input_test.c
@@ -43,8 +43,8 @@ static void input_test_exit(struct kunit *test)
 {
 	struct input_dev *input_dev = test->priv;
 
-	input_unregister_device(input_dev);
-	input_free_device(input_dev);
+	if (input_dev)
+		input_unregister_device(input_dev);
 }
 
 static void input_test_poll(struct input_dev *input) { }
-- 
2.39.2



