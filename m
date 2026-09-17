Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 127CB58FD29;
	Thu, 17 Sep 2026 15:27:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789658854; cv=none; b=YvN427apcOeRkw/OQQ4+Jz7nzy60TcXJmpOn2o1W0L0NNNCd12Eqil77q+xG2S7Lqzg/s3HEPhhzUeY6V6bzG9qiHp+LJ3QFBs8ayBUeJvf6IgQqKrF0e8S8FQF4vPp1Asg+Pb6h76g9H17den7VosySxgOfrg28F5ZDKPI9RTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789658854; c=relaxed/simple;
	bh=DyBKoeOEiUKyXrP/SYOesH5iR4voz7ELKPWh9yrlNps=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kno63f3m9h01YNHhlhteBOJXct+Tf8yeSMp+6FLoI6sXc4t5BiHob1roMGNtwLO0g9Cw8FVs4lfZ6woxs0GlAazwq/QeBBII6pdNEIE3o+tjDylh5p85l6+9NO2lha2WmwO8bmhh+7G4sW4tmj/nKj1S9fsIdn16jg0p8DK7bfw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A8+BkAUH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A8+BkAUH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A3441F0089A;
	Thu, 17 Sep 2026 15:27:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789658835;
	bh=lMXB/Im/wdsoVO9r/0kMfQL2dEgSmW9viM9Oj981ID8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A8+BkAUH+oHCPf6U0V1JnGW3tBAvwqCuAfZoHs1bdNALOjSn/QgyjPH7sgiM6oBXX
	 RiZPLQps8en96VsmY8i2XV1Bhj3Rcdp/EEi6n8XWX+h1QauXn8xfe0tuwoOno6py6x
	 SyG3w7dl4oah64fTVzfvr7CgvsF+qA4oB1wVS2z8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baolin Liu <liubaolin@kylinos.cn>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 038/733] ntfs: propagate reparse index insertion failure
Date: Thu, 17 Sep 2026 16:05:46 +0100
Message-ID: <20260917151351.696162946@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Baolin Liu <liubaolin@kylinos.cn>

[ Upstream commit 9692b1b4fc00cf89628bc43f71729ab21f14f8d3 ]

update_reparse_data() ignores the return value of
set_reparse_index(). When index insertion fails, the code removes
the just-written reparse data as cleanup but still returns 0, so
symlink(2) (and WSL special file creation) reports success while
no reparse data exists on disk. When there was no previous reparse
data (oldsize == 0), the failure was likewise silently ignored.

Propagate the error to the caller.

Fixes: fc053f05ca28 ("ntfs: add reparse and ea operations")
Signed-off-by: Baolin Liu <liubaolin@kylinos.cn>
Reviewed-by: Hyunchul Lee <hyc.lee@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs/reparse.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/ntfs/reparse.c b/fs/ntfs/reparse.c
index f2377e3a56ca9..f8b88a110cb67 100644
--- a/fs/ntfs/reparse.c
+++ b/fs/ntfs/reparse.c
@@ -620,8 +620,9 @@ static int update_reparse_data(struct ntfs_inode *ni, struct ntfs_index_context
 		goto put_rp_inode;
 	}
 
-	if (set_reparse_index(ni, xr, ((const struct reparse_point *)value)->reparse_tag) &&
-	    oldsize > 0) {
+	err = set_reparse_index(ni, xr,
+				((const struct reparse_point *)value)->reparse_tag);
+	if (err && oldsize > 0) {
 		/*
 		 * If cannot index, try to remove the reparse
 		 * data and log the error. There will be an
-- 
2.53.0



