Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27889146582;
	Tue, 18 Jun 2024 13:02:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715755; cv=none; b=E0BdIyafaFA4fVAtsnQZEER8drx4urDI1q2fInAYpEZmLJMTqXAfi0mCFG2XkPMmExsnsJ66y1G3YsNpiK/1q17t/KwHAxLZuCw15/d6rkEbm7cWK0wwvvxlZWbpAnL0inPU4+YqXrEzkV43BdkIUsgGs2BH7JKU8PMIC1xIJYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715755; c=relaxed/simple;
	bh=0vVOTuuTGBVCXmJNMra161rulU4CpTTlfhfCl4VNwj4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d0Triilk+/crR2lJI3CHM1Fj8rmBOrQV+KbgMaP/ho+XAEBVcWJhzjHjdbO6LEHMfffXpD2QxvRFzSFm2K4fYpOIqSmZAMLRAeO9nkzaqNjsMckPDMoSOH6w4K9kQEdHJA6ct0VfEK4sMkYCIiMy1L9m2Gs50sgrjcWENwCHS7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NOYJymTW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NOYJymTW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72588C3277B;
	Tue, 18 Jun 2024 13:02:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715755;
	bh=0vVOTuuTGBVCXmJNMra161rulU4CpTTlfhfCl4VNwj4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NOYJymTWnRikXZ44JDS4wovDvYnf+UGSmZuot8mYp5CVT/j1G0J/i4jCTBntDb+fV
	 UkIkFp/jwRn8PZsSU8fuIp/tcv1/qHw9b6PBtKntkzXtD0GqrROkG21Qg6jwRrqopH
	 w5TxL0WborciedqogR/YLDQSimO8jyY0Kf/gA1sM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amir Goldstein <amir73il@gmail.com>,
	Jan Kara <jack@suse.cz>,
	Gabriel Krisman Bertazi <krisman@collabora.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 384/770] fanotify: WARN_ON against too large file handles
Date: Tue, 18 Jun 2024 14:33:57 +0200
Message-ID: <20240618123422.098468094@linuxfoundation.org>
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

[ Upstream commit 572c28f27a269f88e2d8d7b6b1507f114d637337 ]

struct fanotify_error_event, at least, is preallocated and isn't able to
to handle arbitrarily large file handles.  Future-proof the code by
complaining loudly if a handle larger than MAX_HANDLE_SZ is ever found.

Link: https://lore.kernel.org/r/20211025192746.66445-26-krisman@collabora.com
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Gabriel Krisman Bertazi <krisman@collabora.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/notify/fanotify/fanotify.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/fs/notify/fanotify/fanotify.c b/fs/notify/fanotify/fanotify.c
index cedcb15468043..45df610debbe4 100644
--- a/fs/notify/fanotify/fanotify.c
+++ b/fs/notify/fanotify/fanotify.c
@@ -360,13 +360,23 @@ static u32 fanotify_group_event_mask(struct fsnotify_group *group,
 static int fanotify_encode_fh_len(struct inode *inode)
 {
 	int dwords = 0;
+	int fh_len;
 
 	if (!inode)
 		return 0;
 
 	exportfs_encode_inode_fh(inode, NULL, &dwords, NULL);
+	fh_len = dwords << 2;
 
-	return dwords << 2;
+	/*
+	 * struct fanotify_error_event might be preallocated and is
+	 * limited to MAX_HANDLE_SZ.  This should never happen, but
+	 * safeguard by forcing an invalid file handle.
+	 */
+	if (WARN_ON_ONCE(fh_len > MAX_HANDLE_SZ))
+		return 0;
+
+	return fh_len;
 }
 
 /*
-- 
2.43.0



