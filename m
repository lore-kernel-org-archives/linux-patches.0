Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69C8214E2F4;
	Tue,  9 Jul 2024 11:23:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720524196; cv=none; b=DT4PaA5cE6fedztKzEga6LrBcAWewy98X0TXYK3fY+IILiXm5ngEi3pMxhhZIobPKJG+XSruyQlfqOblZ1Qg4YUdwwnqcihh1fTdCsyM78IvfvX4jFrQTX4d41SD7AlHjn6u4daYV+7C81OIokF5qJ5imgpU5BKMsl1FaXsxeJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720524196; c=relaxed/simple;
	bh=4cciCGoRCw4XkUwugSU6yZYbrTvCCj3SKupLjKDEKZE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lxfd/OBiHzM7eVFdf0yz5azum92yzhAaoCZ6/LX8TOlVhIMngz3VPdgFtoGK2kD4EcupPc91zEiZWKKbcNLgM+R2R2MYsU3HmTQkM17BVKZdkg8f4erGNA6H4laFUFBqZjLGoefBelfOPjnLWuvYztjyDWZL/fIOuIpWC8My7cw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V0jtxjHw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V0jtxjHw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1147C3277B;
	Tue,  9 Jul 2024 11:23:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720524196;
	bh=4cciCGoRCw4XkUwugSU6yZYbrTvCCj3SKupLjKDEKZE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V0jtxjHw57wwhgW0ZqIY57MoA1CBnS5rIhb4lLu91Afn6ijblYLvkin1d9rJTJf0A
	 yd1q0iJhz2ogE/LVvY9rZG7fARhYalPp9YBNk7WKSawXbZr1d8FnfpAAXqeJCW5Kt/
	 8BzbutlVRyfkD2dozLjNtwJdv4lowpXbo5xUagpY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Marshall <hubcap@omnibond.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 061/197] orangefs: fix out-of-bounds fsid access
Date: Tue,  9 Jul 2024 13:08:35 +0200
Message-ID: <20240709110711.323916687@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110708.903245467@linuxfoundation.org>
References: <20240709110708.903245467@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mike Marshall <hubcap@omnibond.com>

[ Upstream commit 53e4efa470d5fc6a96662d2d3322cfc925818517 ]

Arnd Bergmann sent a patch to fsdevel, he says:

"orangefs_statfs() copies two consecutive fields of the superblock into
the statfs structure, which triggers a warning from the string fortification
helpers"

Jan Kara suggested an alternate way to do the patch to make it more readable.

I ran both ideas through xfstests and both seem fine. This patch
is based on Jan Kara's suggestion.

Signed-off-by: Mike Marshall <hubcap@omnibond.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/orangefs/super.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/orangefs/super.c b/fs/orangefs/super.c
index 34849b4a3243c..907765673765c 100644
--- a/fs/orangefs/super.c
+++ b/fs/orangefs/super.c
@@ -201,7 +201,8 @@ static int orangefs_statfs(struct dentry *dentry, struct kstatfs *buf)
 		     (long)new_op->downcall.resp.statfs.files_avail);
 
 	buf->f_type = sb->s_magic;
-	memcpy(&buf->f_fsid, &ORANGEFS_SB(sb)->fs_id, sizeof(buf->f_fsid));
+	buf->f_fsid.val[0] = ORANGEFS_SB(sb)->fs_id;
+	buf->f_fsid.val[1] = ORANGEFS_SB(sb)->id;
 	buf->f_bsize = new_op->downcall.resp.statfs.block_size;
 	buf->f_namelen = ORANGEFS_NAME_MAX;
 
-- 
2.43.0



