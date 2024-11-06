Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96C541FC7F4;
	Wed,  6 Nov 2024 12:39:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896745; cv=none; b=hY6GT3t3ZfhM9Wzd1sFrA7gosLsFq5t/o1nRpb9RFBI7bd1aqYUJ8Tca0ZlM7CrjnF+U2iSG6yQpYPCAbgUyDasiJvSscYpL6U3ClEJmyuTbeLdbsLe64azUE291FfOEDDQ3ijiREfJ6Ke6SthMHjsyvk8SID+DaU/6ebHM0020=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896745; c=relaxed/simple;
	bh=EeEgVEjiD6zErx1YOiRPF5zqRq8zLyviw/RUevcQ60w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZHGoS9Uu4GVSlX1M1qFLiT4SoDuweeC3pBfzbzE3vV8jV7sSerrOfhAG+VJujepVPU00A41ckQERfndqh3/InquZi2ZJxWHyGv+voV/eS9FYyLhrmnQryUhdzc8H0Xt/risYAyMjz+dCsxysfvNlbUC+vtpQ9wppgBGBiZnbLnU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y5/rnZZ8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y5/rnZZ8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A49A0C4CECD;
	Wed,  6 Nov 2024 12:39:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730896745;
	bh=EeEgVEjiD6zErx1YOiRPF5zqRq8zLyviw/RUevcQ60w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y5/rnZZ81BuvGVUWNudaEGigDTqoaf+cmThcRG8V+9PpELEC2Kh7UHL2iKkzaewOX
	 UxXda/Kprl71iJ54zAAkiTgifmG9YWBohKfavxDKpKhZaPyFYp964CgCs+T3Map89z
	 xvcXJoOxZu0q3QOZThwQDilDNU+yRk81ZLqa142U=
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
Subject: [PATCH 5.10 057/110] selftests/mm: fix incorrect buffer->mirror size in hmm2 double_map test
Date: Wed,  6 Nov 2024 13:04:23 +0100
Message-ID: <20241106120304.774982038@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120303.135636370@linuxfoundation.org>
References: <20241106120303.135636370@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 426dccc08f906..738c34eb50afc 100644
--- a/tools/testing/selftests/vm/hmm-tests.c
+++ b/tools/testing/selftests/vm/hmm-tests.c
@@ -1474,7 +1474,7 @@ TEST_F(hmm2, double_map)
 
 	buffer->fd = -1;
 	buffer->size = size;
-	buffer->mirror = malloc(npages);
+	buffer->mirror = malloc(size);
 	ASSERT_NE(buffer->mirror, NULL);
 
 	/* Reserve a range of addresses. */
-- 
2.43.0



