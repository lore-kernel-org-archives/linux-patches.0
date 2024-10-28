Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89FCF189BAF;
	Mon, 28 Oct 2024 06:40:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097615; cv=none; b=tDGU55orPVAcznZ02Y90BG2RURV5WnRBrGCjcRptw+3L7pSv+uodK5iZdpLQ57qWjqrg03dV+sRAGIjnO9Kcf4rcNp5qQJqTOFA9AyHXv5HdmeByVD+jcagxSRFSVoW5g+Bu9MkhMPCmsOaPEfcn7y3UJv8BQrvH3/SI9vSeLVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097615; c=relaxed/simple;
	bh=+I++vypiqBy6c2n/BqHGA69yMTbdVWl8c9Kx/FjsoBs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EegEU8nUTjMJ7zzxFscIp+RiBafHwZFbgKHW+Am6WmM7vn16KSxzeq1grRsZdNwwziOivUTuDpkZVdYLqNcRjaIsX53Kxh8C5xCwXeWsuRENirj+dSwz0p/IF8k5lc5V4Ed0W3wFWCif0URnkcGi3IlBjgyC7CNIouwgrzxVIGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1WD6Ukty; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1WD6Ukty"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29704C4CECD;
	Mon, 28 Oct 2024 06:40:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097615;
	bh=+I++vypiqBy6c2n/BqHGA69yMTbdVWl8c9Kx/FjsoBs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1WD6Ukty9Q1baTmZPLpmWT1STy0moTqiCmctVw3otEcl2YZr12To2RAGWJKqIzs5c
	 4Is25qWAdyIrPkYSfwhppD4BKS+OQY5zhwfmIFNI4PHIuPRK7qhDB6Q70Ka+w8czBg
	 Dn4ap22Dkq/DTtFS8R6iCTMzitkrnLBWE9Ekcffs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Su Hui <suhui@nfschina.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 072/208] smb: client: fix possible double free in smb2_set_ea()
Date: Mon, 28 Oct 2024 07:24:12 +0100
Message-ID: <20241028062308.422985499@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062306.649733554@linuxfoundation.org>
References: <20241028062306.649733554@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Su Hui <suhui@nfschina.com>

[ Upstream commit 19ebc1e6cab334a8193398d4152deb76019b5d34 ]

Clang static checker(scan-build) warning：
fs/smb/client/smb2ops.c:1304:2: Attempt to free released memory.
 1304 |         kfree(ea);
      |         ^~~~~~~~~

There is a double free in such case:
'ea is initialized to NULL' -> 'first successful memory allocation for
ea' -> 'something failed, goto sea_exit' -> 'first memory release for ea'
-> 'goto replay_again' -> 'second goto sea_exit before allocate memory
for ea' -> 'second memory release for ea resulted in double free'.

Re-initialie 'ea' to NULL near to the replay_again label, it can fix this
double free problem.

Fixes: 4f1fffa23769 ("cifs: commands that are retried should have replay flag set")
Reviewed-by: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Su Hui <suhui@nfschina.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/smb2ops.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 450e3050324c6..ab6e79be2c15d 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -1122,7 +1122,7 @@ smb2_set_ea(const unsigned int xid, struct cifs_tcon *tcon,
 	struct cifs_fid fid;
 	unsigned int size[1];
 	void *data[1];
-	struct smb2_file_full_ea_info *ea = NULL;
+	struct smb2_file_full_ea_info *ea;
 	struct smb2_query_info_rsp *rsp;
 	int rc, used_len = 0;
 	int retries = 0, cur_sleep = 1;
@@ -1143,6 +1143,7 @@ smb2_set_ea(const unsigned int xid, struct cifs_tcon *tcon,
 	if (!utf16_path)
 		return -ENOMEM;
 
+	ea = NULL;
 	resp_buftype[0] = resp_buftype[1] = resp_buftype[2] = CIFS_NO_BUFFER;
 	vars = kzalloc(sizeof(*vars), GFP_KERNEL);
 	if (!vars) {
-- 
2.43.0



