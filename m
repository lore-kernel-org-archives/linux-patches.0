Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C65E314F9C8;
	Tue, 20 Feb 2024 21:08:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708463302; cv=none; b=ahlB0F6Xcw2DYadyW4ADpdVd6DK87L78Ot3YyDHEEH9kk9Drf3rIbUnkqYSuEx30F3GhqJM4bXNUl1T4GR/goURCQ06dFIIixCgS5qmsjv9BLTDzwaXTX91zXyVvb9cOWgvvKzr09lpzUwlqjbCBEDTr1BSEfaWHOaaQBszHArA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708463302; c=relaxed/simple;
	bh=g/wQgi6P5TF8Wd199+qgnYXaW4w13hfdYDWgvYkhdE4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vj8XzjY3oRjQJlm5+9HkZ6+NHfZxbf8AXiOqksX12sBi4ORAvHwV2s/aOIu5nSwkSu6ZeS4FKUcBAac9X70RFyt9Rz+KnGYQanrh4xj8vNV1Trg8qri2gz4dIjAyLAbYCau6A2/tHQv8peCtOm6Yf5G3R65iQY5F/SaoKQCnMRY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J7XaiaW6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J7XaiaW6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D143C433F1;
	Tue, 20 Feb 2024 21:08:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708463302;
	bh=g/wQgi6P5TF8Wd199+qgnYXaW4w13hfdYDWgvYkhdE4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J7XaiaW6g/SYuXGuPgLt5/0NzB2embgXsxCkD+GD5527Mi/PUO17iZH4V4FI9XvI1
	 84yt7damyZKeI4bDArEPuAVMuWcQq87nmfQFrNvtU9yEh6hVWj3QbiWnR+WzhKHx+o
	 Xdb4YGQSG1SqL7RSmqtWxxjFkSdjoK9rtyi3K1V4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryan Roberts <ryan.roberts@arm.com>,
	Pedro Demarchi Gomes <pedrodemargomes@gmail.com>,
	Shuah Khan <shuah@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 170/197] selftests/mm: ksm_tests should only MADV_HUGEPAGE valid memory
Date: Tue, 20 Feb 2024 21:52:09 +0100
Message-ID: <20240220204846.157133473@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220204841.073267068@linuxfoundation.org>
References: <20240220204841.073267068@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ryan Roberts <ryan.roberts@arm.com>

[ Upstream commit d021b442cf312664811783e92b3d5e4548e92a53 ]

ksm_tests was previously mmapping a region of memory, aligning the
returned pointer to a PMD boundary, then setting MADV_HUGEPAGE, but was
setting it past the end of the mmapped area due to not taking the pointer
alignment into consideration.  Fix this behaviour.

Up until commit efa7df3e3bb5 ("mm: align larger anonymous mappings on THP
boundaries"), this buggy behavior was (usually) masked because the
alignment difference was always less than PMD-size.  But since the
mentioned commit, `ksm_tests -H -s 100` started failing.

Link: https://lkml.kernel.org/r/20240122120554.3108022-1-ryan.roberts@arm.com
Fixes: 325254899684 ("selftests: vm: add KSM huge pages merging time test")
Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
Cc: Pedro Demarchi Gomes <pedrodemargomes@gmail.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/vm/ksm_tests.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/vm/ksm_tests.c b/tools/testing/selftests/vm/ksm_tests.c
index 0d85be2350fa..a81165930785 100644
--- a/tools/testing/selftests/vm/ksm_tests.c
+++ b/tools/testing/selftests/vm/ksm_tests.c
@@ -470,7 +470,7 @@ static int ksm_merge_hugepages_time(int mapping, int prot, int timeout, size_t m
 	if (map_ptr_orig == MAP_FAILED)
 		err(2, "initial mmap");
 
-	if (madvise(map_ptr, len + HPAGE_SIZE, MADV_HUGEPAGE))
+	if (madvise(map_ptr, len, MADV_HUGEPAGE))
 		err(2, "MADV_HUGEPAGE");
 
 	pagemap_fd = open("/proc/self/pagemap", O_RDONLY);
-- 
2.43.0



