Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4E661F9F6E;
	Tue,  3 Dec 2024 15:31:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733239911; cv=none; b=aj7Swk/d2xELRq99FmJYlf8RCMsD1Hma21H2rpG1uqikltG4Agr60AALbLXTTVGLxZ5yxsIfdxv7ftoAVigbHVvtw/7cwGa2l0MEGzGYSf+TzNtsOHtMYcEf9Iz9Fx4MWNefsOYAi2IxGujd+WsgJwvju1iyxftOEgHaWZkxDeQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733239911; c=relaxed/simple;
	bh=qi9wRBWfSIoaUuYGrndsOzmjMnItCFcv9yCjFxd4Jy0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JPOGmCLACY+oPVB7kLNCOndMy5azsZgwAyCpwHgU7QYFN64oDPJEXwzELP3u1bJ6mZ69Jkqub4j5O2xG0qyjarEnYM9sv9PaDjyx+UNdU06jZMmj5jTX1J2Iq/UitFygrJsFObHrakq9mp6F9LshxHDb4qu2j2OF5a16V+Suonk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dxtnatMU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dxtnatMU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E34CAC4CED6;
	Tue,  3 Dec 2024 15:31:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733239911;
	bh=qi9wRBWfSIoaUuYGrndsOzmjMnItCFcv9yCjFxd4Jy0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dxtnatMUq5OpK0HHMkPqxK8PPX6Jff0qEQk47b3giYyIBChjSFMFosi0GXp2Ypijn
	 LuTcoYnSH/2ZhmVhwBxqLi6b41G2i3l2URTCKb0dgo+0sOQZn6YK+suR9oq/Z2CUz5
	 CiqlkcogZ9yFtiAvOcLMrWo0Q4yCzfbH/pDkER2Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhihao Cheng <chengzhihao1@huawei.com>,
	Richard Weinberger <richard@nod.at>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 775/817] ubifs: Correct the total block count by deducting journal reservation
Date: Tue,  3 Dec 2024 15:45:47 +0100
Message-ID: <20241203144026.264134580@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

From: Zhihao Cheng <chengzhihao1@huawei.com>

[ Upstream commit 84a2bee9c49769310efa19601157ef50a1df1267 ]

Since commit e874dcde1cbf ("ubifs: Reserve one leb for each journal
head while doing budget"), available space is calulated by deducting
reservation for all journal heads. However, the total block count (
which is only used by statfs) is not updated yet, which will cause
the wrong displaying for used space(total - available).
Fix it by deducting reservation for all journal heads from total
block count.

Fixes: e874dcde1cbf ("ubifs: Reserve one leb for each journal head while doing budget")
Signed-off-by: Zhihao Cheng <chengzhihao1@huawei.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ubifs/super.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/ubifs/super.c b/fs/ubifs/super.c
index 291583005dd12..245a10cc1eeb4 100644
--- a/fs/ubifs/super.c
+++ b/fs/ubifs/super.c
@@ -773,10 +773,10 @@ static void init_constants_master(struct ubifs_info *c)
 	 * necessary to report something for the 'statfs()' call.
 	 *
 	 * Subtract the LEB reserved for GC, the LEB which is reserved for
-	 * deletions, minimum LEBs for the index, and assume only one journal
-	 * head is available.
+	 * deletions, minimum LEBs for the index, the LEBs which are reserved
+	 * for each journal head.
 	 */
-	tmp64 = c->main_lebs - 1 - 1 - MIN_INDEX_LEBS - c->jhead_cnt + 1;
+	tmp64 = c->main_lebs - 1 - 1 - MIN_INDEX_LEBS - c->jhead_cnt;
 	tmp64 *= (long long)c->leb_size - c->leb_overhead;
 	tmp64 = ubifs_reported_space(c, tmp64);
 	c->block_cnt = tmp64 >> UBIFS_BLOCK_SHIFT;
-- 
2.43.0



