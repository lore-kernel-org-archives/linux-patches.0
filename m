Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2D6B1C93A0;
	Tue, 27 Aug 2024 15:24:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724772247; cv=none; b=VViNlXfW4iIubx5U3PBwknf//G/+//p3N/MdkYbbCI9WAxtvibuSVv603pRd6fGkSHbrTFQTldHMvn1r421dLa2SgI5YHiXixYhUoOOy8nNaHTDTTLF5hphHh+UMKUJAJaI0X8fXP5Fn40KQ7IoCvM1xoTbFQAZYFhNjTFmtGzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724772247; c=relaxed/simple;
	bh=b9ahZOiMGqBEmrPW3xH+gNx6zPHU/4XI7NgWBBGmOY0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=awaOGuP69EY/gE24XQYKdD4DTAUFHDSaIL2lHbFpHKaVvoVSsv2gcBqJYSZPq04VKN9F9bgmMgud2L9we9QBqpNhVmAcTIsQ05R2wo/vIXQ0rsZbcZIUbFP2ZOEGis4z362NyTYn4PUnvaYg1nO01+th0MLSiPNrqCGIo78z0sc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SXGNIGie; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SXGNIGie"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30490C61071;
	Tue, 27 Aug 2024 15:24:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724772247;
	bh=b9ahZOiMGqBEmrPW3xH+gNx6zPHU/4XI7NgWBBGmOY0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SXGNIGieYfPt191X4V+oU/G/U82iohoCRJvt9okcJoF12KU88y5NB/ZFQdXV3qYwl
	 FxvLXZeMwyfKda8+EDkdzK5C2wIK6BGgfvvcO/gA0NrgelmJluGkieziivGJlUBor1
	 tKpdImoE533I21PUqbh0MP9w6ej7OBKRGwbjkmzU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 157/321] gfs2: Refcounting fix in gfs2_thaw_super
Date: Tue, 27 Aug 2024 16:37:45 +0200
Message-ID: <20240827143844.208417746@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143838.192435816@linuxfoundation.org>
References: <20240827143838.192435816@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andreas Gruenbacher <agruenba@redhat.com>

[ Upstream commit 4e58543e7da4859c4ba61d15493e3522b6ad71fd ]

It turns out that the .freeze_super and .thaw_super operations require
the filesystem to manage the superblock refcount itself.  We are using
the freeze_super() and thaw_super() helpers to mostly take care of that
for us, but this means that the superblock may no longer be around by
when thaw_super() returns, and gfs2_thaw_super() will then access freed
memory.  Take an extra superblock reference in gfs2_thaw_super() to fix
that.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/gfs2/super.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/gfs2/super.c b/fs/gfs2/super.c
index f9b47df485d17..aff8cdc61eff7 100644
--- a/fs/gfs2/super.c
+++ b/fs/gfs2/super.c
@@ -814,6 +814,7 @@ static int gfs2_thaw_super(struct super_block *sb)
 	if (!test_bit(SDF_FREEZE_INITIATOR, &sdp->sd_flags))
 		goto out;
 
+	atomic_inc(&sb->s_active);
 	gfs2_freeze_unlock(&sdp->sd_freeze_gh);
 
 	error = gfs2_do_thaw(sdp);
@@ -824,6 +825,7 @@ static int gfs2_thaw_super(struct super_block *sb)
 	}
 out:
 	mutex_unlock(&sdp->sd_freeze_mutex);
+	deactivate_super(sb);
 	return error;
 }
 
-- 
2.43.0



