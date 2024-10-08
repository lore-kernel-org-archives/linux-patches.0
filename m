Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBBE51DDC35;
	Tue,  8 Oct 2024 13:01:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728392481; cv=none; b=OfnGOkoSrbPcs/aSwnhisYHuFU3MX+5owKxBWxmeSTH7j0QmJluc34GeMaBs24tt1wzTeShbkP97W4lcthR3PmM0pdOxX1PDtas/XitCOkjQYZeLlHaaqKh6rknrEhnSmDu0P3cQcme9wSDkBFGfUNti1d5lDywUcjgZzz+ExT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728392481; c=relaxed/simple;
	bh=cfkT/kRYYCjTbkjlVZIJudfeILrwye0BwzmxLeH7R4Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UYJsHrbyB5rc8gdvDZSdKLgakQeVW+2xdGOk9oTfnCzw8tK0q83yMREEOq7BdbS6DpvFe95kpDLBPURzBb3vSuX6Np5f+3PCnpC/692AcH8wplGNJVnRl5fOkKmABJnldd1jZLnBhpG2rcWNeaXgHUHoFAAYTOCNYovD5z8icM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XrdeGkIa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XrdeGkIa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48720C4CEC7;
	Tue,  8 Oct 2024 13:01:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728392480;
	bh=cfkT/kRYYCjTbkjlVZIJudfeILrwye0BwzmxLeH7R4Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XrdeGkIaP1nO3HjMKgei7v8nlVwlO68aJjRsAUvsDlaponMeUAmBHKV/HGeczGslK
	 JfKjqtwqJxt1dZRJpVzswZg/pV9oFCcZhNL7V+zo7M4T5OMg8gagbW3V2J35qX1kn6
	 b44VdDSl8/vgHgbV66xKePOzgm79D+K9VWEY3qUc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Jan Kara <jack@suse.cz>,
	Zhang Yi <yi.zhang@huawei.com>,
	stable@kernel.org,
	Theodore Tso <tytso@mit.edu>
Subject: [PATCH 6.11 410/558] jbd2: correctly compare tids with tid_geq function in jbd2_fc_begin_commit
Date: Tue,  8 Oct 2024 14:07:20 +0200
Message-ID: <20241008115718.409091788@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
@@ -710,7 +710,7 @@ int jbd2_fc_begin_commit(journal_t *jour
 		return -EINVAL;
 
 	write_lock(&journal->j_state_lock);
-	if (tid <= journal->j_commit_sequence) {
+	if (tid_geq(journal->j_commit_sequence, tid)) {
 		write_unlock(&journal->j_state_lock);
 		return -EALREADY;
 	}


