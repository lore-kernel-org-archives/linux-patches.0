Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55C9F3612F6;
	Sat, 12 Sep 2026 07:49:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789199344; cv=none; b=BXrfC8NMMNmgM8k4GlTh1OLHkvDDchYvdbX4Bfj47roU2Mg1nqwX1EbfIJeTuFsoWpcJsdjxzDcK/Uuz6vfLSb/kPQHNfRcqluyVMbd9oW0VUfubuFGco1u9Vh3+QubXMnxpBnIqZR8xl6n/0aeylgEnByWj0IISF9AoFGMug8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789199344; c=relaxed/simple;
	bh=5nEnXnYuhghZ7nFYcRI17nK2KcDFJR/ixr+6vGAL86Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=So+qj0sljDf5+aIPwRHXudZ8etrlnk0zgynLNL8v3yRVgnTxShnTKYICNELrVkpnp1dcLWWvkZ1lHK8wnz2oGvrsIwOs3bgwG3LLui+qGLOaS7Z2ddn5n3MegTJF3U5raFUIXvj2uhNEF2wwxEHh+bYj+RzvV8jTh40+gNQBTsI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K8M42xwC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K8M42xwC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0B2D1F000FF;
	Sat, 12 Sep 2026 07:49:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789199342;
	bh=QzRytk+0Tmn/YKaSpeVJaXN/QHEoZOJW4Dv3iE2UQco=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K8M42xwCmfqxFVf1KVUZZyc7VrkOpmym7Y80Lte30C6fJg3bmNaHtvA6QLMQLIj7/
	 niKcSk3+kOz8Kh/DbeGJQwVE+aG7v0uQsyh8eri+/wd5/AJgycPIUhWj8svVyvETpx
	 j5aKnmarP+a5r+SwU9Hxox3HxiEF/ReMEl9gPmnE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"=?UTF-8?q?Ricardo=20B . =20Marli=C3=A8re?=" <rbm@suse.com>,
	Ihor Solodrai <ihor.solodrai@linux.dev>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0565/1815] selftests/bpf: Fix lsm_bdev dev_t encoding mismatch
Date: Sat, 12 Sep 2026 08:38:35 +0200
Message-ID: <20260912065702.146838003@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
User-Agent: quilt/0.69
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ricardo B. Marlière <rbm@suse.com>

[ Upstream commit 71cf3f3275e5f4d7f31bd540608c80535343b427 ]

progs/lsm_bdev.c keys its verity_devices hashmap with the raw kernel dev_t
read straight off bdev->bd_dev, i.e. MKDEV(major, minor) = (major << 20) |
minor. prog_tests/lsm_bdev.c instead builds its lookup key with dev_key =
(__u32)st.st_rdev from stat(2), but the stat(2) syscall fills st_rdev via
the kernel's new_encode_dev(), a different bit layout: (minor & 0xff) |
(major << 8) | ((minor & ~0xff) << 12).

For any device with a non-trivial major these two values differ, so the
lookup can never find what the BPF program stored, and test_lsm_bdev()
always fails with:

  test_lsm_bdev:FAIL:map lookup unexpected error: -2 (errno 2)

Reconstruct the raw kernel dev_t from the decoded major/minor instead of
casting st_rdev directly, restoring the layout the BPF program actually
reads.

Fixes: 96f4c251a087 ("selftests/bpf: add block device management selftests")
Signed-off-by: Ricardo B. Marlière <rbm@suse.com>
Acked-by: Ihor Solodrai <ihor.solodrai@linux.dev>
Link: https://lore.kernel.org/bpf/20260720-selftests-bpf_fixes-v2-2-b450eda93dfe@suse.com
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/prog_tests/lsm_bdev.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/lsm_bdev.c b/tools/testing/selftests/bpf/prog_tests/lsm_bdev.c
index a970798e11735..28bc4b117f415 100644
--- a/tools/testing/selftests/bpf/prog_tests/lsm_bdev.c
+++ b/tools/testing/selftests/bpf/prog_tests/lsm_bdev.c
@@ -17,6 +17,7 @@
 #include <stdlib.h>
 #include <string.h>
 #include <sys/stat.h>
+#include <sys/sysmacros.h>
 #include <sys/types.h>
 #include <unistd.h>
 #include "lsm_bdev.skel.h"
@@ -172,7 +173,7 @@ void test_lsm_bdev(void)
 	if (!ASSERT_OK(stat(DM_DEV_PATH, &st), "stat dm dev"))
 		goto remove_dm;
 
-	dev_key = (__u32)st.st_rdev;
+	dev_key = (major(st.st_rdev) << 20) | minor(st.st_rdev);
 
 	/* Look up the device in the BPF map and verify. */
 	err = bpf_map__lookup_elem(skel->maps.verity_devices,
-- 
2.53.0



