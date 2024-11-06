Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AAFC646;
	Wed,  6 Nov 2024 13:18:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730899129; cv=none; b=Fuy816Xd4Rpt/6d4OTYdmTyuBQ0+GgqWY0hQqK0Uy5KfcyyI1G0wv+vqFpseCZUoTUmoKUmNGcaXUZIPcVpMUJr/8/wBFIXCC1sKXfiL/X9GyogK3rhXQFbHgqVMg8RkNYf7066gC1vXTOfRWNgCTNxumgQDyLTFHdR0+PDHYw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730899129; c=relaxed/simple;
	bh=hKCuvq3OmT2hRGIWI5ZUpEnl0G3g5uQsCSlnZBZJZos=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UQcWxHtBnscNlvG2KFSPgMcRVaGbISb2L6q2UV8I61PoE5XdDjcFtzncIzWqgfTDO6qO08bx9rJrvIEZKpPTjbhaNnPGTKM4v7Ofg4fP/cybZyERrQ0HCsCT3LTh0qNtC4m9ItzMK7Il1Mw3rtFaVOvXs5KPASU3mYE7Mhjq/zU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gFauQQk5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gFauQQk5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8BD5C4CECD;
	Wed,  6 Nov 2024 13:18:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730899129;
	bh=hKCuvq3OmT2hRGIWI5ZUpEnl0G3g5uQsCSlnZBZJZos=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gFauQQk52S4E5OXfvc+axCcX3mzAOYwzlnuodkSOVwMeA7WdS/PJ8TViRKMysUh7B
	 xmjcjlziTFK1/1zkpIeDVlJgjhYStV7e0TRwfJgm6IZQtGTucpB53CeRbr3VlkQClk
	 xL/ZD2c/HXgTds+3OV+yQDl1UWpSUbPeArE7bJt4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Donet Tom <donettom@linux.ibm.com>,
	Muhammad Usama Anjum <usama.anjum@collabora.com>,
	=?UTF-8?q?J=C3=A9r=C3=B4me=20Glisse?= <jglisse@redhat.com>,
	Kees Cook <keescook@chromium.org>,
	Mark Brown <broonie@kernel.org>,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Shuah Khan <shuah@kernel.org>,
	Ralph Campbell <rcampbell@nvidia.com>,
	Jason Gunthorpe <jgg@mellanox.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 01/73] selftests/mm: fix incorrect buffer->mirror size in hmm2 double_map test
Date: Wed,  6 Nov 2024 13:05:05 +0100
Message-ID: <20241106120259.999995913@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120259.955073160@linuxfoundation.org>
References: <20241106120259.955073160@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Donet Tom <donettom@linux.ibm.com>

[ Upstream commit 76503e1fa1a53ef041a120825d5ce81c7fe7bdd7 ]

The hmm2 double_map test was failing due to an incorrect buffer->mirror
size.  The buffer->mirror size was 6, while buffer->ptr size was 6 *
PAGE_SIZE.  The test failed because the kernel's copy_to_user function was
attempting to copy a 6 * PAGE_SIZE buffer to buffer->mirror.  Since the
size of buffer->mirror was incorrect, copy_to_user failed.

This patch corrects the buffer->mirror size to 6 * PAGE_SIZE.

Test Result without this patch
==============================
 #  RUN           hmm2.hmm2_device_private.double_map ...
 # hmm-tests.c:1680:double_map:Expected ret (-14) == 0 (0)
 # double_map: Test terminated by assertion
 #          FAIL  hmm2.hmm2_device_private.double_map
 not ok 53 hmm2.hmm2_device_private.double_map

Test Result with this patch
===========================
 #  RUN           hmm2.hmm2_device_private.double_map ...
 #            OK  hmm2.hmm2_device_private.double_map
 ok 53 hmm2.hmm2_device_private.double_map

Link: https://lkml.kernel.org/r/20240927050752.51066-1-donettom@linux.ibm.com
Fixes: fee9f6d1b8df ("mm/hmm/test: add selftests for HMM")
Signed-off-by: Donet Tom <donettom@linux.ibm.com>
Reviewed-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Jérôme Glisse <jglisse@redhat.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: Przemek Kitszel <przemyslaw.kitszel@intel.com>
Cc: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Cc: Jason Gunthorpe <jgg@mellanox.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/vm/hmm-tests.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/vm/hmm-tests.c b/tools/testing/selftests/vm/hmm-tests.c
index 203323967b507..a8f69d991243d 100644
--- a/tools/testing/selftests/vm/hmm-tests.c
+++ b/tools/testing/selftests/vm/hmm-tests.c
@@ -1482,7 +1482,7 @@ TEST_F(hmm2, double_map)
 
 	buffer->fd = -1;
 	buffer->size = size;
-	buffer->mirror = malloc(npages);
+	buffer->mirror = malloc(size);
 	ASSERT_NE(buffer->mirror, NULL);
 
 	/* Reserve a range of addresses. */
-- 
2.43.0



