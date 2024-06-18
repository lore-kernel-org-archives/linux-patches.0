Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F41641BF38;
	Tue, 18 Jun 2024 13:00:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715636; cv=none; b=rJ/lvr0VlrzlTeEi5o3vVoSKd2W/ZXupwgKPSCFD3MU1JaQv1Hs4VIH8C4A43c7CIB3yh7w5qgu7k1TmB4GtZeiIeE83KQC8LBiMNs9ufdeD1dvLTkO6sAokWzjJTsbjxmuaCkGSGHngCVFRe8z80HvR7z3Hm2QF0UXQ+qa4yD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715636; c=relaxed/simple;
	bh=PRyeniklE+WoArplro8nlaCjQMoV4p5eodQu9q5A4Q8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a7qrxpqEG8p+jIjp2rTOBgfnqObezE7ZSsNsVnrmMC/meNmstWG8bAOWu/WjmQjENZAZWPchhplIHFQjtgcTabbpNyCELSqHmKtyX9baIEhCvACS7Ucs/4Zyc63fr4Rl5IyLTTRHWAfNBfnZ9Jkwc1QsCLSzo/xq5Q32SxQDF08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dcxtBhoe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dcxtBhoe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36AD1C32786;
	Tue, 18 Jun 2024 13:00:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715635;
	bh=PRyeniklE+WoArplro8nlaCjQMoV4p5eodQu9q5A4Q8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dcxtBhoe6scI/nKbC7Kxi3HGETCwYhqQhjDY0PFFalyQlpfFHe0FpFRQLdo/2glNy
	 r83bY+sYkzxyhjl/TupK01KRcUiLGXAUrCjxwvv7/CpCe5tFkSrUOr2gUNd/jtJyws
	 n02KR0NtX6c2dTFzAZtlP2LpsGxNKh1YhcnV5aVE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Amir Goldstein <amir73il@gmail.com>,
	Gabriel Krisman Bertazi <krisman@collabora.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 374/770] fanotify: Allow file handle encoding for unhashed events
Date: Tue, 18 Jun 2024 14:33:47 +0200
Message-ID: <20240618123421.705827441@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240618123407.280171066@linuxfoundation.org>
References: <20240618123407.280171066@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gabriel Krisman Bertazi <krisman@collabora.com>

[ Upstream commit 74fe4734897a2da2ae2a665a5e622cd490d36eaf ]

Allow passing a NULL hash to fanotify_encode_fh and avoid calculating
the hash if not needed.

Link: https://lore.kernel.org/r/20211025192746.66445-15-krisman@collabora.com
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Gabriel Krisman Bertazi <krisman@collabora.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/notify/fanotify/fanotify.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/notify/fanotify/fanotify.c b/fs/notify/fanotify/fanotify.c
index 397ee623ff1e8..ec84fee7ad01c 100644
--- a/fs/notify/fanotify/fanotify.c
+++ b/fs/notify/fanotify/fanotify.c
@@ -403,8 +403,12 @@ static int fanotify_encode_fh(struct fanotify_fh *fh, struct inode *inode,
 	fh->type = type;
 	fh->len = fh_len;
 
-	/* Mix fh into event merge key */
-	*hash ^= fanotify_hash_fh(fh);
+	/*
+	 * Mix fh into event merge key.  Hash might be NULL in case of
+	 * unhashed FID events (i.e. FAN_FS_ERROR).
+	 */
+	if (hash)
+		*hash ^= fanotify_hash_fh(fh);
 
 	return FANOTIFY_FH_HDR_LEN + fh_len;
 
-- 
2.43.0



