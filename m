Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABC2C13C90B;
	Tue, 25 Jun 2024 10:02:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719309765; cv=none; b=LGy4ncahB7aVnLthtPZ2t0WB1RnMxywY29pPiceJrKd5IEONWzjQCWpk43Ekw4kdpb7xYOMi054UYxtJ18fGtRbmqqMYk2X4WUKpd9627/+QHII/4VExHkg4yziFSSgudOMdYzlGLKGKBQ2E6VFyto5hXPVNZoTe3LPs2h00OV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719309765; c=relaxed/simple;
	bh=KMRfRbT+AYzmvuidJ/C5JvCnxNYDpZZ3UYE65772PQ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NS2HZzGbhHP/e7RJmFLOcuy0cFhqFi+oejzlps6IflF0xH5hJ3REYjbroEQHBDBvLkyqZBwyc9CMCnSbFxHdD6R6O/FbvdE2Quu03hOqsdofKMS4xQac2OPaYJePyihjMvKF1FTkf2po6qM5R1GFWLBw5v9SU5B6LCh9dT+t8Yo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=afWL8WHB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="afWL8WHB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31A76C32781;
	Tue, 25 Jun 2024 10:02:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719309765;
	bh=KMRfRbT+AYzmvuidJ/C5JvCnxNYDpZZ3UYE65772PQ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=afWL8WHBU1SORhU27VOOhEDVK8XRuHwpssdnKJoKE6vwxsKQIjIXcvviDjil7iQKr
	 Ql++S+8Xctr8EAu9J3kDZ/V+I7cdH4wRt0ohuX7MVOQ3NsxIvoP/RSNp/6ZM7gLkxe
	 why1QwyowVU3nKHcPamaFcWMy1aeOe1RTHTMo+Ts=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masahiro Yamada <masahiroy@kernel.org>,
	Nicolas Schier <nicolas@fjasle.eu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 126/131] Revert "kheaders: substituting --sort in archive creation"
Date: Tue, 25 Jun 2024 11:34:41 +0200
Message-ID: <20240625085530.724599128@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085525.931079317@linuxfoundation.org>
References: <20240625085525.931079317@linuxfoundation.org>
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
index 473036b43c832..99422673a782b 100755
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



