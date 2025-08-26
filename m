Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D854B352FE1;
	Tue, 26 Aug 2025 14:33:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756218837; cv=none; b=iszN181Nt0IzTFlX+Vo3k8C4kASDJyQvvBkeRRzveq6Bg2RJ9JAxRMZwvSRzO1G5lynD5GKiBtwON454L/RQ3rgcZZfF+4CORLNTiOgc3dXQkd87pwR+nWHG7g5IsSk9GvXD87QZGvnZ86m+trsMM4Ani10lH64WAUAeN8EkWKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756218837; c=relaxed/simple;
	bh=084hwqLi6x54iYQ/kkXnQXgk5Uv6p8qE0WsReKjEF4Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oGL0MERtOgi/oTPyurJmrOcVC+VjLlhiJjE8ZPihvbCjSzg7PfscLSqCCwJBi2H1N5xxspVb3HV4Rz2tvAMBitAaWlXDY0NaXdCOBL9iN0gRPKdePiI0qUqBEfOxfZBXg4IDqgIiUSr8p43Av9LSkEApEB0jR3YOIgNgWDxaeKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ust7wk24; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ust7wk24"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BE4BC4CEF1;
	Tue, 26 Aug 2025 14:33:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756218837;
	bh=084hwqLi6x54iYQ/kkXnQXgk5Uv6p8qE0WsReKjEF4Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ust7wk24OQadTNRJuSVtWjIAL0SUmCN5s3OpAteVDR55egGjodWcbEBsmCB0toNTL
	 KoqC2/fZMIQ7i4s2QDndd318bt8r0MWQQBimycFSZQjgB76SLzU1OxJZNf4tAbDaxZ
	 n2gbyZfzudWYstfi/jPXtX+vmZcuPOE4eDYEVRX8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Mike Marshall <hubcap@omnibond.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 121/403] fs/orangefs: Allow 2 more characters in do_c_string()
Date: Tue, 26 Aug 2025 13:07:27 +0200
Message-ID: <20250826110910.078906957@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110905.607690791@linuxfoundation.org>
References: <20250826110905.607690791@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index fa41db088488..b57140ebfad0 100644
--- a/fs/orangefs/orangefs-debugfs.c
+++ b/fs/orangefs/orangefs-debugfs.c
@@ -728,8 +728,8 @@ static void do_k_string(void *k_mask, int index)
 
 	if (*mask & s_kmod_keyword_mask_map[index].mask_val) {
 		if ((strlen(kernel_debug_string) +
-		     strlen(s_kmod_keyword_mask_map[index].keyword))
-			< ORANGEFS_MAX_DEBUG_STRING_LEN - 1) {
+		     strlen(s_kmod_keyword_mask_map[index].keyword) + 1)
+			< ORANGEFS_MAX_DEBUG_STRING_LEN) {
 				strcat(kernel_debug_string,
 				       s_kmod_keyword_mask_map[index].keyword);
 				strcat(kernel_debug_string, ",");
@@ -756,7 +756,7 @@ static void do_c_string(void *c_mask, int index)
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



