Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE095224234;
	Tue,  8 Apr 2025 11:28:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744111708; cv=none; b=mmBrc4VNZLbnm7jfpYVjgDD9Joz5zPcfpZBNMGG7i9CLF+x8JDlhAl5X7/9wKdEEH0Ua1UlGXHXbPSPtWQcMWLFNgJhRPIoWZpWSEO0lDjxfEf8PDL8wpiAFPVAcxxxO1/A/80wQ2lZIh8POPLC/OHtHgnYIUWnBeqwA27CngUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744111708; c=relaxed/simple;
	bh=8tnKVohkxmh3GUriLwZqUTjPpVLK/9SH5to918iVVQc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UK+98BI76cGUHaGvNvkHp6TEyvrSdM4sSQCYANg/Uam2blU6yh3dMUkiWaXkCWZ5sfpZrsDaG8LlT6ZUvFuxw0kaE7Dxdf3IGJp9IKfN+OS1sJf/Ufvcp931onH6lYLRg2eZWkOh+IdEJbHlZPuKT+4/SQnlszp/s1B6nAB+fJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OUfSjd98; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OUfSjd98"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EEFEC4CEE5;
	Tue,  8 Apr 2025 11:28:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744111708;
	bh=8tnKVohkxmh3GUriLwZqUTjPpVLK/9SH5to918iVVQc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OUfSjd984oQ77VZ+u04Q8brnhz3FqiddsllXR4mAzwKtA72JPF9q1oqbnR9nmPeXM
	 CUq5yhswWwUz+WKYWDEGBTjKNkUSi3sNVIuO01C8gR2+ycZ3ZEMuNkASTB7ckNQkZ9
	 rZhJX2SL8Lp2Yc8pGgsrpi2meECuuLN2eE2TWbZI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephen Brennan <stephen.s.brennan@oracle.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 530/731] perf dso: fix dso__is_kallsyms() check
Date: Tue,  8 Apr 2025 12:47:07 +0200
Message-ID: <20250408104926.602706735@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stephen Brennan <stephen.s.brennan@oracle.com>

[ Upstream commit ebf0b332732dcc64239119e554faa946562b0b93 ]

Kernel modules for which we cannot find a file on-disk will have a
dso->long_name that looks like "[module_name]". Prior to the commit
listed in the fixes, the dso->kernel field would be zero (for user
space), so dso__is_kallsyms() would return false. After the commit,
kernel module DSOs are correctly labeled, but the result is that
dso__is_kallsyms() erroneously returns true for those modules without a
filesystem path.

Later, build_id_cache__add() consults this value of is_kallsyms, and
when true, it copies /proc/kallsyms into the cache. Users with many
kernel modules without a filesystem path (e.g. ksplice or possibly
kernel live patch modules) have reported excessive disk space usage in
the build ID cache directory due to this behavior.

To reproduce the issue, it's enough to build a trivial out-of-tree hello
world kernel module, load it using insmod, and then use:

   perf record -ag -- sleep 1

In the build ID directory, there will be a directory for your module
name containing a kallsyms file.

Fix this up by changing dso__is_kallsyms() to consult the
dso_binary_type enumeration, which is also symmetric to the above checks
for dso__is_vmlinux() and dso__is_kcore(). With this change, kallsyms is
not cached in the build-id cache for out-of-tree modules.

Fixes: 02213cec64bbe ("perf maps: Mark module DSOs with kernel type")
Signed-off-by: Stephen Brennan <stephen.s.brennan@oracle.com>
Link: https://lore.kernel.org/r/20250318230012.2038790-1-stephen.s.brennan@oracle.com
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/dso.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/dso.h b/tools/perf/util/dso.h
index bb8e8f444054d..c0472a41147c3 100644
--- a/tools/perf/util/dso.h
+++ b/tools/perf/util/dso.h
@@ -808,7 +808,9 @@ static inline bool dso__is_kcore(const struct dso *dso)
 
 static inline bool dso__is_kallsyms(const struct dso *dso)
 {
-	return RC_CHK_ACCESS(dso)->kernel && RC_CHK_ACCESS(dso)->long_name[0] != '/';
+	enum dso_binary_type bt = dso__binary_type(dso);
+
+	return bt == DSO_BINARY_TYPE__KALLSYMS || bt == DSO_BINARY_TYPE__GUEST_KALLSYMS;
 }
 
 bool dso__is_object_file(const struct dso *dso);
-- 
2.39.5



