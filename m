Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99E2815099D;
	Tue, 15 Oct 2024 11:34:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728992084; cv=none; b=Er68YePFjqCqN8PlEWjt760fbtVDoplpR9QDFBRYtci0FxDO3EveSopmgt9Ze7CNeIM6xXYnCEyF+h64IQb7nUv0PuMZmHwH87v/Umuxe7FkH6+9M6Bd243gH4tFYS89wjT3LwFn0/Jk7s0HwxwvdaefO7oVKGpoPBQHjoU6gnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728992084; c=relaxed/simple;
	bh=QxNtkB/OwYoTG8xBBws8nGw49rDgY1voKJE8euoRVCY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ProdamNCPWuJzu5EDyMIe2F4pzpAN9K1yFU3MKi+x/hGu76nS3NQ1UHbyB3ix2tDGCQJt2aXoITNsErLSP/p1/9rMz5lpgPr8U11hCsGYPjQCH92X5zRwnW+UMOj3ErSJCpvAbe/iSwGhBbszcJqxnWVfGuBoKRSgSwHyxEIEsI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ChvdDE5z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ChvdDE5z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7B3BC4CED2;
	Tue, 15 Oct 2024 11:34:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728992084;
	bh=QxNtkB/OwYoTG8xBBws8nGw49rDgY1voKJE8euoRVCY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ChvdDE5zw7cn7hbesBwfkwJjRTeftgGsCMp26foWAdXfeRilbZl4BDYXEEtTrlBdm
	 04MQuQQDWQQWoLGgtuWNOKdfJ1aXCf/zNTCyioitjfPiZo7ijrQiVbsVal0Ub/RDj8
	 xf9xpTgqq33ki2HIkAudw8FGz1uL9qp51YeuJ4Sc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Jan Kara <jack@suse.cz>,
	Zhang Yi <yi.zhang@huawei.com>,
	stable@kernel.org,
	Theodore Tso <tytso@mit.edu>
Subject: [PATCH 5.15 006/691] jbd2: correctly compare tids with tid_geq function in jbd2_fc_begin_commit
Date: Tue, 15 Oct 2024 13:19:14 +0200
Message-ID: <20241015112440.580778620@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kemeng Shi <shikemeng@huaweicloud.com>

commit f0e3c14802515f60a47e6ef347ea59c2733402aa upstream.

Use tid_geq to compare tids to work over sequence number wraps.

Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Zhang Yi <yi.zhang@huawei.com>
Cc: stable@kernel.org
Link: https://patch.msgid.link/20240801013815.2393869-2-shikemeng@huaweicloud.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/jbd2/journal.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -740,7 +740,7 @@ int jbd2_fc_begin_commit(journal_t *jour
 		return -EINVAL;
 
 	write_lock(&journal->j_state_lock);
-	if (tid <= journal->j_commit_sequence) {
+	if (tid_geq(journal->j_commit_sequence, tid)) {
 		write_unlock(&journal->j_state_lock);
 		return -EALREADY;
 	}


