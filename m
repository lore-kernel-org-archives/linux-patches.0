Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E6D81E25F8;
	Wed,  6 Nov 2024 12:43:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896992; cv=none; b=DcejtDwEnJVC+IQqmk6TvrmncpO29EyeP9WpFDTN3On2RuwBGDhgG95+mTSgTQOqTuK953lvFXkWOVwxehO+Q3ipo4FwDBEnZGMJhVr+thU/ZJ7X/JCH5+D/QAtRfcS7Q3/JJ47kG5Nv0jRlCyaXDch5PCjWdnExayqZ1Ef1K7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896992; c=relaxed/simple;
	bh=j2D+M/6FPdfJ8p1t9pbPJ9bmiF5lnKWS9d632ymab6w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=T/Hs/159bMBkLfaIBw5JIcfxsdssJqMRS7TLjsPCnDsSwTgZxwLsAab5XFqOCEJPz/MevqIfnkcVX9ciioNI+uY5oQObvm0L3xm5t8aXyWTVvX8dtr+DoRu/QTeIfjrqNMob7x3phUxF/8vvKntbWVr6AG2ccYIDN0/t8fvOeR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1752h3vN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1752h3vN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6760EC4CECD;
	Wed,  6 Nov 2024 12:43:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730896992;
	bh=j2D+M/6FPdfJ8p1t9pbPJ9bmiF5lnKWS9d632ymab6w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1752h3vNDfQ2fetLN5MrD02oBGJN7RPPwRAYLz/ppbp37wKQIIJrZcF1DXQUD9LJw
	 aIO3zHvN9FrfBA4OXIDgUywA9LugLglWKW7bSzujhxEi8we++eoeRUD9h3fsBrJcNG
	 75GpX3n75bVY8Wu+/ZYjgoisybaJgOsMJXxQwNWE=
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
Subject: [PATCH 6.1 003/126] selftests/mm: fix incorrect buffer->mirror size in hmm2 double_map test
Date: Wed,  6 Nov 2024 13:03:24 +0100
Message-ID: <20241106120306.141292208@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120306.038154857@linuxfoundation.org>
References: <20241106120306.038154857@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 4adaad1b822f0..95af1a73f505f 100644
--- a/tools/testing/selftests/vm/hmm-tests.c
+++ b/tools/testing/selftests/vm/hmm-tests.c
@@ -1652,7 +1652,7 @@ TEST_F(hmm2, double_map)
 
 	buffer->fd = -1;
 	buffer->size = size;
-	buffer->mirror = malloc(npages);
+	buffer->mirror = malloc(size);
 	ASSERT_NE(buffer->mirror, NULL);
 
 	/* Reserve a range of addresses. */
-- 
2.43.0



