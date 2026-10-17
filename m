Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E5883A8753;
	Sat, 17 Oct 2026 18:06:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792260376; cv=none; b=rrlqVMfc6L6Bn9nUOgdPC+XlLeGYhzQiON/nC+ogV4ssVP9XTz8z7BtLOrcQrgir95tbiTEp44yA1WH7FOIgT5lDX/PG/VBUBU1kx3G9K0arj8XiyGM8blZWeyosy9vSFwaPBSpxRnKyDQ0xP9+cgvDAFEji+jIxCWTe77bCXg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792260376; c=relaxed/simple;
	bh=dtqWbgXBOVliNOA5JYv3DcpDHqUoRwhw69/egqUeVpA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lhm32zlJS2eivlXFEMs/K+eLndjcD9xND75VPAziqOS8r3mNEI12kp/OpUUamUcIqrQ4CNj1IPCSGEgClpVMpLdi597eKFXdctPHIdxH3jHVfIawokiW4MXwhTBl4nn9iLusrdHf44eYsNQ2XIf+6/LXkZftBFWXzCNiNiASteA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aCPOcy+9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aCPOcy+9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 588A61F000C4;
	Sat, 17 Oct 2026 18:06:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792260375;
	bh=fcVPscN0En5RAWDvnrBkMjd9cpPwAe4V44yy3yJ25RU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aCPOcy+9O1dVaCcDEjysevxbYyLHbazlH0L+qqPgiACJP2FDrQCcwEDqohXF9GBqv
	 +naTFxUyLccpNX5mNopcjc8NFjtVrYNsKBfjcTJyHrV/7q5cyr1CY2eDCcSudYWqaa
	 QoWMxPgClVV16GEsxJVxbS14aPjZZn9Q4xMlpY/w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+e1c69cadec0f1a078e3d@syzkaller.appspotmail.com,
	Daniel Yang <danielyangkang@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1524/1674] exfat: resolve memory leak from exfat_create_upcase_table()
Date: Sat, 17 Oct 2026 18:03:16 +0200
Message-ID: <20261017160510.238274833@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Yang <danielyangkang@gmail.com>

[ Upstream commit c290fe508eee36df1640c3cb35dc8f89e073c8a8 ]

If exfat_load_upcase_table reaches end and returns -EINVAL,
allocated memory doesn't get freed and while
exfat_load_default_upcase_table allocates more memory, leading to a
memory leak.

Here's link to syzkaller crash report illustrating this issue:
https://syzkaller.appspot.com/text?tag=CrashReport&x=1406c201980000

Reported-by: syzbot+e1c69cadec0f1a078e3d@syzkaller.appspotmail.com
Fixes: a13d1a4de3b0 ("exfat: move freeing sbi, upcase table and dropping nls into rcu-delayed helper")
Cc: stable@vger.kernel.org
Signed-off-by: Daniel Yang <danielyangkang@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Stable-dep-of: 20dd3185d138 ("exfat: fix handling of damaged volume in exfat_create_upcase_table()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/exfat/nls.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/exfat/nls.c b/fs/exfat/nls.c
index 0e05c6b5a2864..e027b34356969 100644
--- a/fs/exfat/nls.c
+++ b/fs/exfat/nls.c
@@ -785,8 +785,11 @@ int exfat_create_upcase_table(struct super_block *sb)
 				le32_to_cpu(ep->dentry.upcase.checksum));
 
 			brelse(bh);
-			if (ret && ret != -EIO)
+			if (ret && ret != -EIO) {
+				/* free memory from exfat_load_upcase_table call */
+				exfat_free_upcase_table(sbi);
 				goto load_default;
+			}
 
 			/* load successfully */
 			return ret;
-- 
2.53.0



