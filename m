Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E85B41428E4;
	Wed,  3 Jul 2024 10:56:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720004200; cv=none; b=sGZiNAHXwiSh9PP86KM/Dyssh6wCWj0y8V/W6/FCmi7XCSxTw9xFO6U8fNhiMRFQ3fdbeWMK8mrX/3QmcSbDFyEyCMRZS+6y6DA4KmM9CTLPBmmgKAzvymMzAISHMItZiB28ZQmfWvzI7i629FaAjnJ58dv4Js0OBemwGKHcWfA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720004200; c=relaxed/simple;
	bh=/7QvhKu2H4VLlAP4bp+85G0/KRi5M2/4tcvBDeBkvKI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W/vFMQ7CzhTQCWgvDk0CUjK1lvl1fnUfQmxVy7zn5yyOsYZZJdKQNTjktqF4q8TNQi5b8eUmt52aN0m6/J+DEA+n/aG8nXzmQ5gmRmIi7KHofAMwC51iHXwBCstY0VCJoCr/vxCz9FbIzv0+b7gNsULPbtB4FJQnb1Dd7jehAUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l0I89fcW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l0I89fcW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D39CC2BD10;
	Wed,  3 Jul 2024 10:56:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720004199;
	bh=/7QvhKu2H4VLlAP4bp+85G0/KRi5M2/4tcvBDeBkvKI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l0I89fcWmImNUk7HYiewuAlGwrIWyZxP6IXIfLDSJqwpZp2Cg6EGN5P83HQjmWSTM
	 NzJSO5GMms1ZbccPbX7AngA+K7LYOqq1ac4hjw1X0RV3Idz+vhk2HXPjRViAlFtDaO
	 TJgQjKgdJpnXpJQRGnQf098/MjfzP8PBlkttYF4w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masahiro Yamada <masahiroy@kernel.org>,
	Nicolas Schier <nicolas@fjasle.eu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 126/189] Revert "kheaders: substituting --sort in archive creation"
Date: Wed,  3 Jul 2024 12:39:47 +0200
Message-ID: <20240703102846.248750886@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102841.492044697@linuxfoundation.org>
References: <20240703102841.492044697@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index c1510f0ab3ea5..d7e827c6cd2d2 100755
--- a/kernel/gen_kheaders.sh
+++ b/kernel/gen_kheaders.sh
@@ -83,12 +83,9 @@ find $cpio_dir -type f -print0 |
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



