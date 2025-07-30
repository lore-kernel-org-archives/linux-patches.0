Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A381B635;
	Wed, 30 Jul 2025 09:50:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753869012; cv=none; b=JuSeSoQr8u/jahtMp9lEAki/snz9runzBbfIbnUElPdDy1MhM876HK+wEiJvg3aKRpKJmDH7iRfzBzuqjEzihw5yJ5FM58ZWgenyNcDqFiMdv2ejV1Hx5T4Po/UZQphXdY97T7eGZPIxBOryoqVNAY1zKQ+aRe9u9GxRYVrHm2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753869012; c=relaxed/simple;
	bh=DYnIQLKW85njS5b3uo6KorL8dy/Rh6hx7UW0jVC2cLg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u2Lnq4wr8YWsKO6/l4gQtRtiv4omMNifmfsVMcA87zgVKrIWIZvwuB1B/u3I3fB1vUJqBX7446cxtGkaZX2Y2YMPRdNNnAlfoSDuisoitUoePuJMWmVsPUtxe6PPoHq5gcRuA9K4dkmrjaVqix9rsckR7lnoz0HBiaExsJ1+V5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dfQYU/rL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dfQYU/rL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD750C4CEF6;
	Wed, 30 Jul 2025 09:50:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753869012;
	bh=DYnIQLKW85njS5b3uo6KorL8dy/Rh6hx7UW0jVC2cLg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dfQYU/rL/BVlJIfKb6Q9E7XLuUtqAZD2AwROjOhy0wG2vUGDxqFZisDHvqGNZkx8W
	 jeRVkOEbEUZwlbhw7IIxmbv62aBuFXucMG56phNygwSTldxVI18IFJ5g+m7izTj6Jd
	 +i+V5SmJGZoK15ORe/W8UcbcfTBtNvXrCNOEXffA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yasumasa Suenaga <yasuenag@gmail.com>,
	Naman Jain <namjain@linux.microsoft.com>,
	Wei Liu <wei.liu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 16/92] tools/hv: fcopy: Fix incorrect file path conversion
Date: Wed, 30 Jul 2025 11:35:24 +0200
Message-ID: <20250730093231.246296591@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250730093230.629234025@linuxfoundation.org>
References: <20250730093230.629234025@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index 7d9bcb066d3fb..92e8307b2a467 100644
--- a/tools/hv/hv_fcopy_uio_daemon.c
+++ b/tools/hv/hv_fcopy_uio_daemon.c
@@ -118,8 +118,11 @@ static int hv_fcopy_create_file(char *file_name, char *path_name, __u32 flags)
 
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
@@ -326,7 +329,7 @@ static void wcstoutf8(char *dest, const __u16 *src, size_t dest_size)
 {
 	size_t len = 0;
 
-	while (len < dest_size) {
+	while (len < dest_size && *src) {
 		if (src[len] < 0x80)
 			dest[len++] = (char)(*src++);
 		else
@@ -338,27 +341,15 @@ static void wcstoutf8(char *dest, const __u16 *src, size_t dest_size)
 
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



