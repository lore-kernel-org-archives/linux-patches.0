Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9895A375ACB;
	Wed, 20 May 2026 16:52:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295969; cv=none; b=DxcvP5tQl3IJRQMhWL5Om97qZZi6S2TgXeMSzifflQgqbHQNWCRZWy4o7c/WjMdqM6N0cjn7hHo/Y0InemiIWznhqbCBF9lRUonz4moCqsThmNuCAvynCGtJqRxxTSJjGSAqi9POUp4w+QZH7V7Gv4aAj5ln8tMB/2Hk1ikaX4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295969; c=relaxed/simple;
	bh=OxMaLyYF9XlM0xbgJl3CPGMvTWd84Fz09a0bTbc+RJE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FG956FVMTmRHKtZBeyqKDiKqXsGgMBkdHhMQ4ZV1dhzBfec8lLGjODxOjTW5gin8OoH4iRFhDgOj9j978zfpPMks8axQC8LCWBjyhgMe0pkQ3bY9u/jPEKiP8PMj+2WWjN2TcBu7XabUItd2hVnseOFMoBwt9zfRhEyO/KCw4UU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1Ej35Iua; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1Ej35Iua"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3E831F00893;
	Wed, 20 May 2026 16:52:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295968;
	bh=B4WTfLDTBEA9MPDiMFG/ololhJymYIkxM6ro5UbMFv8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1Ej35IuavPra00iKMHZG2SORh7mfSgPkvQK6gyqjVsuuLn7c7jrU/cGHV5MYCsBdD
	 xo+53GpBH4/DfepStzVYeq4RZ1bUoyn8rNbaYayrIMKNQ53CtMrl5GHxETp8UC8SES
	 s/mGRtMx0VMqlzwEReQVgqHcMWK8XEGQoYpVO+KE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ye Bin <yebin10@huawei.com>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0604/1146] ext4: fix miss unlock sb->s_umount in extents_kunit_init()
Date: Wed, 20 May 2026 18:14:14 +0200
Message-ID: <20260520162201.848335554@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ye Bin <yebin10@huawei.com>

[ Upstream commit 5941a072d48841255005e3a5b5a620692d81d1a7 ]

There's warning as follows when do ext4 kunit test:
WARNING: kunit_try_catch/15923 still has locks held!
7.0.0-rc3-next-20260309-00028-g73f965a1bbb1-dirty #281 Tainted: G            E    N
1 lock held by kunit_try_catch/15923:
 #0: ffff888139f860e0 (&type->s_umount_key#70/1){+.+.}-{4:4}, at: alloc_super.constprop.0+0x172/0xa90
Call Trace:
 <TASK>
 dump_stack_lvl+0x180/0x1b0
 debug_check_no_locks_held+0xc8/0xd0
 do_exit+0x1502/0x2b20
 kthread+0x3a9/0x540
 ret_from_fork+0xa76/0xdf0
 ret_from_fork_asm+0x1a/0x30

As sget() will return 'sb' which holds 's->s_umount' lock. However,
"extents-test" miss unlock this lock.
So unlock 's->s_umount' in the end of extents_kunit_init().

Fixes: cb1e0c1d1fad ("ext4: kunit tests for extent splitting and conversion")
Signed-off-by: Ye Bin <yebin10@huawei.com>
Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Reviewed-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Link: https://patch.msgid.link/20260330133035.287842-2-yebin@huaweicloud.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/extents-test.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/ext4/extents-test.c b/fs/ext4/extents-test.c
index 5496b2c8e2cd3..82c59291e0458 100644
--- a/fs/ext4/extents-test.c
+++ b/fs/ext4/extents-test.c
@@ -309,6 +309,8 @@ static int extents_kunit_init(struct kunit *test)
 	kunit_activate_static_stub(test, ext4_ext_zeroout, ext4_ext_zeroout_stub);
 	kunit_activate_static_stub(test, ext4_issue_zeroout,
 				   ext4_issue_zeroout_stub);
+	up_write(&sb->s_umount);
+
 	return 0;
 }
 
-- 
2.53.0



