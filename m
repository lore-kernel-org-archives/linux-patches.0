Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1322F168C4;
	Mon, 27 May 2024 19:26:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716838009; cv=none; b=nNLdCFEWVsEtEYAyBHbXPIQ6Q5aRXXlCnlYHUHLB+pFV2OrvTIc2h/TQmygzgpfZVOLeb7Auv+RE8vXC3xYUmmk1MOmBjVu9PTsYxiDYEgqXZhPAdzAmMWwPOno89whhsBi9cp1i1GBm88qcX+VGHIO0/cpbCU7pku80SG2mkBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716838009; c=relaxed/simple;
	bh=ErnoN3GR8yThyHoi1ibTWGOnVhiaPUMF94jreWrLp/s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UQrQJh4i2oa+iCGyK1ZOQT47JssttIMZXjAYmIAdwleH9zaH1fWDdil7LbHndbUVd2e5oOcPUJ+yIIGCp2LmyLhZnv/NFKNBzfflKfue5QLHgxGQ6AGIaBjnxG6S122uCYsN/RwtWt/r3d92VNWm8OgwskBPI6obPDU9Drz+lQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Lga1apy1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Lga1apy1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AF10C2BBFC;
	Mon, 27 May 2024 19:26:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716838008;
	bh=ErnoN3GR8yThyHoi1ibTWGOnVhiaPUMF94jreWrLp/s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Lga1apy1GoefSSEeI4MhRAmAgp6Kxvqc23DSe/I86vA/iaFQmQrD9Zazx4B3Cpfgj
	 v4v06cTURK2RsnZ7tZgv13+O0U5ITjmjIZFfUfuuhbhmGaHe/X+UGYh6ajmIMGHb6E
	 85uX27Z1cxmNIHAJ6pWKO2FmALtZ3cshQd30UN6I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 232/493] gfs2: Remove ill-placed consistency check
Date: Mon, 27 May 2024 20:53:54 +0200
Message-ID: <20240527185637.895231501@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andreas Gruenbacher <agruenba@redhat.com>

[ Upstream commit 59f60005797b4018d7b46620037e0c53d690795e ]

This consistency check was originally added by commit 9287c6452d2b1
("gfs2: Fix occasional glock use-after-free").  It is ill-placed in
gfs2_glock_free() because if it holds there, it must equally hold in
__gfs2_glock_put() already.  Either way, the check doesn't seem
necessary anymore.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Stable-dep-of: d98779e68772 ("gfs2: Fix potential glock use-after-free on unmount")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/gfs2/glock.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index 385561cd4f4c7..5d5b3235d4e59 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -170,7 +170,6 @@ void gfs2_glock_free(struct gfs2_glock *gl)
 {
 	struct gfs2_sbd *sdp = gl->gl_name.ln_sbd;
 
-	gfs2_glock_assert_withdraw(gl, atomic_read(&gl->gl_revokes) == 0);
 	rhashtable_remove_fast(&gl_hash_table, &gl->gl_node, ht_parms);
 	smp_mb();
 	wake_up_glock(gl);
-- 
2.43.0



