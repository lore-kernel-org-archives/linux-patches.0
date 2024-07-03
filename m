Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF20713B280;
	Wed,  3 Jul 2024 11:27:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720006022; cv=none; b=YeRYAx70G7qWoQVkgjxkv3ve2p8pANMqDh70YWZUQ3f/Pme95wi/b/F8ejA93QgUuTZk0QEBwAvj3cQ506IPX8AFAq6AqSX321pZx2uO2eNKepJRK6Ejn1gl8NwUJCiro2pOScAPX7HGqTV2cT9SDxCS53fD3qbIXmITZmusISE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720006022; c=relaxed/simple;
	bh=mx+M/kBojnvjrnv/YHzWPKH5cbGl6hKSbYxqG41VEHc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pQFbEmyZsfcMGXAdpNEbQw8W8q2fn8PyRNHFZ1yBUW2yh4jA7KvDcAH7PfI1LKl+r6DaIJ9aNBb67bDQOCgGB7yHZf7dMzku5GlwKGbUkYvC5u3/5VGVsGObi1hpKKI2OIstgas6ViiZ7mm2NkpMBKU6agIaNCVm7aOpFlX2Oc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vr99wkUo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vr99wkUo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73D42C2BD10;
	Wed,  3 Jul 2024 11:27:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720006021;
	bh=mx+M/kBojnvjrnv/YHzWPKH5cbGl6hKSbYxqG41VEHc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Vr99wkUoN9krE2tIfeBGxoaZGS0NdzxoSa0UhrR8vy1kDqqe/8tmaKtJM1Fom85zm
	 /taWTDjzu9KsXONJTmnVsvKg/U+BLuNFyVTU7lzs+pze6qLPIgpr+KMb7mqs+sxieM
	 5Ye3WWjUfwND7Y2JDw30/hM7BdXqFvZ5UIzsBvW4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masahiro Yamada <masahiroy@kernel.org>,
	Nicolas Schier <nicolas@fjasle.eu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 247/356] Revert "kheaders: substituting --sort in archive creation"
Date: Wed,  3 Jul 2024 12:39:43 +0200
Message-ID: <20240703102922.460597152@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102913.093882413@linuxfoundation.org>
References: <20240703102913.093882413@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Masahiro Yamada <masahiroy@kernel.org>

[ Upstream commit 49c386ebbb43394ff4773ce24f726f6afc4c30c8 ]

This reverts commit 700dea5a0bea9f64eba89fae7cb2540326fdfdc1.

The reason for that commit was --sort=ORDER introduced in
tar 1.28 (2014). More than 3 years have passed since then.

Requiring GNU tar 1.28 should be fine now because we require
GCC 5.1 (2015).

Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Reviewed-by: Nicolas Schier <nicolas@fjasle.eu>
Stable-dep-of: 3bd27a847a3a ("kheaders: explicitly define file modes for archived headers")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/gen_kheaders.sh | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/kernel/gen_kheaders.sh b/kernel/gen_kheaders.sh
index 1966a749e0d96..5ab483a3ee5a5 100755
--- a/kernel/gen_kheaders.sh
+++ b/kernel/gen_kheaders.sh
@@ -81,12 +81,9 @@ find $cpio_dir -type f -print0 |
 	xargs -0 -P8 -n1 perl -pi -e 'BEGIN {undef $/;}; s/\/\*((?!SPDX).)*?\*\///smg;'
 
 # Create archive and try to normalize metadata for reproducibility.
-# For compatibility with older versions of tar, files are fed to tar
-# pre-sorted, as --sort=name might not be available.
-find $cpio_dir -printf "./%P\n" | LC_ALL=C sort | \
-    tar "${KBUILD_BUILD_TIMESTAMP:+--mtime=$KBUILD_BUILD_TIMESTAMP}" \
-    --owner=0 --group=0 --numeric-owner --no-recursion \
-    -I $XZ -cf $tarfile -C $cpio_dir/ -T - > /dev/null
+tar "${KBUILD_BUILD_TIMESTAMP:+--mtime=$KBUILD_BUILD_TIMESTAMP}" \
+    --owner=0 --group=0 --sort=name --numeric-owner \
+    -I $XZ -cf $tarfile -C $cpio_dir/ . > /dev/null
 
 echo $headers_md5 > kernel/kheaders.md5
 echo "$this_file_md5" >> kernel/kheaders.md5
-- 
2.43.0



