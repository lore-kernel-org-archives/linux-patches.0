Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11F6236124;
	Wed, 30 Jul 2025 09:42:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753868540; cv=none; b=kRRevyXi1L+hk+tUMZ6n3PyMlEEVXG+bGOW3h7gO198pXA1jj7lEbJ4IjFx0T+30pX9sy+iwH7n6IDk103MjQBQw2/d1h8oF+p2TMKYWjD/eu0TUz1P52kTpnvZMAlcnNjilUing0mXSlTdf9kOFCGjHzIWLGtXMOk2XuKfbKjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753868540; c=relaxed/simple;
	bh=Q44wi1mZROHcD/syr7LNwYnRQWzeskBnWshEzgoBOEQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LYRgElgqDwhK4JMIWKuJcU2qOtLUtxWRVZbnfxZA2Q01Ci/RjeCv0ZPx7gAMTB57WwSndqWHPdfNQj6UoU9bpOEaSAmgHOaU/Vh6dabEZYAZ1TZWkaaOfuxrsvvRhXxabDpHbWbC0z3FaXybfu4x6Sj/D6e/KaDBx+XIMu+BaIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tyz0ATFr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tyz0ATFr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F013C4CEE7;
	Wed, 30 Jul 2025 09:42:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753868539;
	bh=Q44wi1mZROHcD/syr7LNwYnRQWzeskBnWshEzgoBOEQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tyz0ATFrLBfN1N+QPQjlNHRxUETL9vxjONQcfq+da6mLapnd4BbVP3oWnEZ8Z9+pI
	 VnZ58tzDdREBoo9ju7UgYDljZdhqigzN0dFj3HiVmwkxImO7lOPpagTqpvCqpg22d7
	 bmngcR3s7DPOIr12/mouK5VUdbqYmxNMXPR8majQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yasumasa Suenaga <yasuenag@gmail.com>,
	Naman Jain <namjain@linux.microsoft.com>,
	Wei Liu <wei.liu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 014/117] tools/hv: fcopy: Fix incorrect file path conversion
Date: Wed, 30 Jul 2025 11:34:43 +0200
Message-ID: <20250730093234.139536727@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250730093233.592541778@linuxfoundation.org>
References: <20250730093233.592541778@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yasumasa Suenaga <yasuenag@gmail.com>

[ Upstream commit 0d86a8d65c1e69610bfe1a7a774f71ff111ed8c1 ]

The hv_fcopy_uio_daemon fails to correctly handle file copy requests
from Windows hosts (e.g. via Copy-VMFile) due to wchar_t size
differences between Windows and Linux. On Linux, wchar_t is 32 bit,
whereas Windows uses 16 bit wide characters.

Fix this by ensuring that file transfers from host to Linux guest
succeed with correctly decoded file names and paths.

- Treats file name and path as __u16 arrays, not wchar_t*.
- Allocates fixed-size buffers (W_MAX_PATH) for converted strings
  instead of using malloc.
- Adds a check for target path length to prevent snprintf() buffer
  overflow.

Fixes: 82b0945ce2c2 ("tools: hv: Add new fcopy application based on uio driver")
Signed-off-by: Yasumasa Suenaga <yasuenag@gmail.com>
Reviewed-by: Naman Jain <namjain@linux.microsoft.com>
Link: https://lore.kernel.org/r/20250628022217.1514-2-yasuenag@gmail.com
Signed-off-by: Wei Liu <wei.liu@kernel.org>
Message-ID: <20250628022217.1514-2-yasuenag@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/hv/hv_fcopy_uio_daemon.c | 37 +++++++++++++---------------------
 1 file changed, 14 insertions(+), 23 deletions(-)

diff --git a/tools/hv/hv_fcopy_uio_daemon.c b/tools/hv/hv_fcopy_uio_daemon.c
index 12743d7f164f0..9caa24caa0801 100644
--- a/tools/hv/hv_fcopy_uio_daemon.c
+++ b/tools/hv/hv_fcopy_uio_daemon.c
@@ -62,8 +62,11 @@ static int hv_fcopy_create_file(char *file_name, char *path_name, __u32 flags)
 
 	filesize = 0;
 	p = path_name;
-	snprintf(target_fname, sizeof(target_fname), "%s/%s",
-		 path_name, file_name);
+	if (snprintf(target_fname, sizeof(target_fname), "%s/%s",
+		     path_name, file_name) >= sizeof(target_fname)) {
+		syslog(LOG_ERR, "target file name is too long: %s/%s", path_name, file_name);
+		goto done;
+	}
 
 	/*
 	 * Check to see if the path is already in place; if not,
@@ -270,7 +273,7 @@ static void wcstoutf8(char *dest, const __u16 *src, size_t dest_size)
 {
 	size_t len = 0;
 
-	while (len < dest_size) {
+	while (len < dest_size && *src) {
 		if (src[len] < 0x80)
 			dest[len++] = (char)(*src++);
 		else
@@ -282,27 +285,15 @@ static void wcstoutf8(char *dest, const __u16 *src, size_t dest_size)
 
 static int hv_fcopy_start(struct hv_start_fcopy *smsg_in)
 {
-	setlocale(LC_ALL, "en_US.utf8");
-	size_t file_size, path_size;
-	char *file_name, *path_name;
-	char *in_file_name = (char *)smsg_in->file_name;
-	char *in_path_name = (char *)smsg_in->path_name;
-
-	file_size = wcstombs(NULL, (const wchar_t *restrict)in_file_name, 0) + 1;
-	path_size = wcstombs(NULL, (const wchar_t *restrict)in_path_name, 0) + 1;
-
-	file_name = (char *)malloc(file_size * sizeof(char));
-	path_name = (char *)malloc(path_size * sizeof(char));
-
-	if (!file_name || !path_name) {
-		free(file_name);
-		free(path_name);
-		syslog(LOG_ERR, "Can't allocate memory for file name and/or path name");
-		return HV_E_FAIL;
-	}
+	/*
+	 * file_name and path_name should have same length with appropriate
+	 * member of hv_start_fcopy.
+	 */
+	char file_name[W_MAX_PATH], path_name[W_MAX_PATH];
 
-	wcstoutf8(file_name, (__u16 *)in_file_name, file_size);
-	wcstoutf8(path_name, (__u16 *)in_path_name, path_size);
+	setlocale(LC_ALL, "en_US.utf8");
+	wcstoutf8(file_name, smsg_in->file_name, W_MAX_PATH - 1);
+	wcstoutf8(path_name, smsg_in->path_name, W_MAX_PATH - 1);
 
 	return hv_fcopy_create_file(file_name, path_name, smsg_in->copy_flags);
 }
-- 
2.39.5



