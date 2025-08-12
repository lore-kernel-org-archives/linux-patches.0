Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E5CC3D994;
	Tue, 12 Aug 2025 19:20:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755026429; cv=none; b=RiV2+EVWD8fM1Rq1DyLbUWX+rLecVZVVCpnyQe6Qe7qHAP1jervsbsbL53fhwh/AeGk2bbSWZf/7VQv5F7OqJ0usHxeVxsmv8mplDmDLlh4qT8L1naKQ/BtNv0Mo7q+Rwa6f7QXuARo0qns4Xoa49Zuwfsid1SWYAHYjUxbk7lI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755026429; c=relaxed/simple;
	bh=UoHeN+Gy6LC2omSYge0Mq4KV+/u4d/onl+G/8TtRioA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rUkcMgQPls/PxyAa4jptrAwqPEv+dbg4T/QqdR4XzbwaDBwdRJ3c6hOEbdDXrOaMFSvvkO2/EZ75g++EQvRY4mNQhnJhI5SFd4RMCxNspk6Sm3LOeqAv3R8hN5RwRTRCNxnMcqGr7YkDjB4r4U1WCf0XyahU1jEJ02JJEA04Xu0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VkjIk0UT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VkjIk0UT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69B0AC4CEF0;
	Tue, 12 Aug 2025 19:20:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755026428;
	bh=UoHeN+Gy6LC2omSYge0Mq4KV+/u4d/onl+G/8TtRioA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VkjIk0UTzUbNJ0n4lB4UQz+OXbmS1fF5HkltjdZbkxrATPJvgRfJPCmNFF1fKVjQS
	 Sx7fnnMD9B3trgukhW7CERACeEDQprDsZLLh8mHxG9VGIRmtngutFUHDhPBeY0JKPg
	 va3TpIpNZ2Hw9idfkdJi7cyoGU9kCCzhk8mELN/g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Mike Marshall <hubcap@omnibond.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 301/480] fs/orangefs: Allow 2 more characters in do_c_string()
Date: Tue, 12 Aug 2025 19:48:29 +0200
Message-ID: <20250812174409.845371341@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
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

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit 2138e89cb066b40386b1d9ddd61253347d356474 ]

The do_k_string() and do_c_string() functions do essentially the same
thing which is they add a string and a comma onto the end of an existing
string.  At the end, the caller will overwrite the last comma with a
newline.  Later, in orangefs_kernel_debug_init(), we add a newline to
the string.

The change to do_k_string() is just cosmetic.  I moved the "- 1" to
the other side of the comparison and made it "+ 1".  This has no
effect on runtime, I just wanted the functions to match each other
and the rest of the file.

However in do_c_string(), I removed the "- 2" which allows us to print
two extra characters.  I noticed this issue while reviewing the code
and I doubt affects anything in real life.  My guess is that this was
double counting the comma and the newline.  The "+ 1" accounts for
the newline, and the caller will delete the final comma which ensures
there is enough space for the newline.

Removing the "- 2" lets us print 2 more characters, but mainly it makes
the code more consistent and understandable for reviewers.

Fixes: 44f4641073f1 ("orangefs: clean up debugfs globals")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Mike Marshall <hubcap@omnibond.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/orangefs/orangefs-debugfs.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/orangefs/orangefs-debugfs.c b/fs/orangefs/orangefs-debugfs.c
index f7095c91660c..e8e3badbc2ec 100644
--- a/fs/orangefs/orangefs-debugfs.c
+++ b/fs/orangefs/orangefs-debugfs.c
@@ -769,8 +769,8 @@ static void do_k_string(void *k_mask, int index)
 
 	if (*mask & s_kmod_keyword_mask_map[index].mask_val) {
 		if ((strlen(kernel_debug_string) +
-		     strlen(s_kmod_keyword_mask_map[index].keyword))
-			< ORANGEFS_MAX_DEBUG_STRING_LEN - 1) {
+		     strlen(s_kmod_keyword_mask_map[index].keyword) + 1)
+			< ORANGEFS_MAX_DEBUG_STRING_LEN) {
 				strcat(kernel_debug_string,
 				       s_kmod_keyword_mask_map[index].keyword);
 				strcat(kernel_debug_string, ",");
@@ -797,7 +797,7 @@ static void do_c_string(void *c_mask, int index)
 	    (mask->mask2 & cdm_array[index].mask2)) {
 		if ((strlen(client_debug_string) +
 		     strlen(cdm_array[index].keyword) + 1)
-			< ORANGEFS_MAX_DEBUG_STRING_LEN - 2) {
+			< ORANGEFS_MAX_DEBUG_STRING_LEN) {
 				strcat(client_debug_string,
 				       cdm_array[index].keyword);
 				strcat(client_debug_string, ",");
-- 
2.39.5



