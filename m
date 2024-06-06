Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04CD21A3BD9;
	Thu,  6 Jun 2024 14:14:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683246; cv=none; b=NATdrGDoWaOct+Tj36X04uWlgJzQQbuvl0vgy6rNCn/+PmSc7y8sXhWf6iXbTKbBZu0El9KENfj27pYl13X+rnahjqze8BUtO4xBI0KQ8iUt28pu219e8iJb77vDHhnZ3Zd4sR392wrnjhikMBqipemk7DO2R3oiyyF3HvVDcLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683246; c=relaxed/simple;
	bh=TUiggbPdYlcfAaeVhzWiSydGBAbjuxady4+OhaZX5kM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lJhDxsWaFVELe8A3TZZPeu41vDyADfYjP7cFdw+Ca6yq4iE/BAIOJpfPWAHMqdcAw5TLFRXAIixM1f/RvS6XFKC0ka4LojBZvsSv+eJirb9ben0jIYDaVHYvIn7a9JWH6ftLtmuyPz/qlnHvhJTrDvNq3cwY5tIHm67s+n2wtgo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xw5/zVGM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xw5/zVGM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA93DC2BD10;
	Thu,  6 Jun 2024 14:14:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683245;
	bh=TUiggbPdYlcfAaeVhzWiSydGBAbjuxady4+OhaZX5kM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xw5/zVGMWrKQvaSF4R0UwsXf4LBGxeJqvbVICOPbo8baf1DSQ/NH50/N0Mb6mY+Hn
	 /ZZ9c8fMtlozCT3oiGFNFkqFfACcKLoBznnvf2x/tYhA3CtkePP7T8azm92FlUrYEy
	 VCM0IpejgvsrYsYSP/G0BAU48keiKDUSslpu32kU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 190/744] gfs2: Remove ill-placed consistency check
Date: Thu,  6 Jun 2024 15:57:42 +0200
Message-ID: <20240606131738.530301232@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 207b7c23bc0f3..a2a1935e2eede 100644
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



