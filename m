Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C747E1DB148;
	Thu, 17 Apr 2025 18:09:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744913349; cv=none; b=Kx143o1EbVSfR+/EFl1cEGAIL8hR3XeyeTEniQzLaJPb00zJwqNiyPRIe1kFEDzUCLFTVkwkA4LMz+ClPy5aWyiGoG7JCTmaTAQiywZGit+ksZFTPD5oYckrANzZvgKcQH5OF8plojVe4L/h74CsP/FqT8aO6Q8G9NBntkQn9iw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744913349; c=relaxed/simple;
	bh=Kik8hiakI/2HYGFhWp1zlXYzcM77f23vXofToSxLOcE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BHO2b9MqMlkmQC/UABtqXIB8+yZyF/oEjxQbsVEixNZIO7LcosTjzNdw1q95yfEYZ9DQ0DTTgFRxKI8CM5YlTk01vzBSz7M+zAsSzTSgCXjXQ8E488c+HaEATAKASeUUNjCV+2ZAZnwEeGt3jXkxG9Ksjt5wjkByayKH1WfixQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cwO5ka5p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cwO5ka5p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2F9BC4CEE4;
	Thu, 17 Apr 2025 18:09:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744913349;
	bh=Kik8hiakI/2HYGFhWp1zlXYzcM77f23vXofToSxLOcE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cwO5ka5pkelHyGK+sWoU0OFx8dDfnOkG0NGGX3OfMN+cmAmAUR0rHkfpzn7UJB/Ee
	 m6ti5OEfQFUQ5hXitFrNdeb1Mh9/vKDCaiDmOT78EpJVE8eqlzaPAOJ0co0jtCpnCp
	 Z1ZLZHKWkw3IM++zPez7qxgphj5svpTK6IAhVG2I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Carlos Maiolino <cmaiolino@redhat.com>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH 6.14 310/449] udf: Fix inode_getblk() return value
Date: Thu, 17 Apr 2025 19:49:58 +0200
Message-ID: <20250417175130.590067325@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175117.964400335@linuxfoundation.org>
References: <20250417175117.964400335@linuxfoundation.org>
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

From: Jan Kara <jack@suse.cz>

commit 6afdc60ec30b0a9390d11b7cebed79c857ce82aa upstream.

Smatch noticed that inode_getblk() can return 1 on successful mapping of
a block instead of expected 0 after commit b405c1e58b73 ("udf: refactor
udf_next_aext() to handle error"). This could confuse some of the
callers and lead to strange failures (although the one reported by
Smatch in udf_mkdir() is impossible to trigger in practice). Fix the
return value of inode_getblk().

Link: https://lore.kernel.org/all/cb514af7-bbe0-435b-934f-dd1d7a16d2cd@stanley.mountain
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Fixes: b405c1e58b73 ("udf: refactor udf_next_aext() to handle error")
CC: stable@vger.kernel.org
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/udf/inode.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/udf/inode.c
+++ b/fs/udf/inode.c
@@ -810,6 +810,7 @@ static int inode_getblk(struct inode *in
 		}
 		map->oflags = UDF_BLK_MAPPED;
 		map->pblk = udf_get_lb_pblock(inode->i_sb, &eloc, offset);
+		ret = 0;
 		goto out_free;
 	}
 


