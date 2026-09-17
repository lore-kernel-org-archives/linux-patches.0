Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51E7549D590;
	Thu, 17 Sep 2026 17:41:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789666869; cv=none; b=fnRtPxknHaDXbPGHaW9Y/1kLI31QuHwdwYJOfAlECTDa7ejhsTYLYSGykuh6ZG4Z8YZmBzYOO4TDV/EeQ9OQEGj66jg8AzlydCdaJRLgz8m5y+E2WixKvAsydmb/UgLIhAU7WFky0QTQ7uf9zgZqz7t+5EfHPu9w65n41y+TCD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789666869; c=relaxed/simple;
	bh=AkImZwsN5+hJxsMWSNyCYxtPb3Jo2R1AYXCyl38dlTk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=boPfn3ROKTinS3SmO+inbpJ38S0lbPhe8v/GLSRJiru1YX6AkZGPerHyXLe7iyVOD6o7nOmPv3l5Z/LQ3SfU+7gyKkas/QeZ3OlHqa2ipSCmeGV0Vq0cEGFsY/DfH/oQ+AzAotsqRPhw2ag3/7R7vgZwLiRT8fJEVpdQXFgKOBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vZuBmfJ6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vZuBmfJ6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A495C1F000FF;
	Thu, 17 Sep 2026 17:41:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789666867;
	bh=nsQ10FrZr6gMJme/BYrZccdlJfDd2f+JvWXAEjddgjs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vZuBmfJ6KrpJlon4RzgAkhAhVxt00nI89SvNJa2NyKYYCNtM81D6QgRdSXmVq/eH7
	 2ij/XZ7UZnBeA5976us9fQ87r4qujIfo7syN2tlkyNp2SlGVXuiQAuHtClMOr4hRj0
	 2EnLhvAuSzOlK3/aZSvHTWCvCf+yM5fkmcy6YYFA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.18 1103/1250] xfs: fix unit conversions in per_binval computation
Date: Thu, 17 Sep 2026 16:14:58 +0100
Message-ID: <20260917151622.077118561@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Darrick J. Wong <djwong@kernel.org>

commit 05cff7c2b79f76c7cfe90613a60e16aaaa051ef7 upstream.

LOLLM noticed that we're doing the unit conversion in the per_binval
computation backwards -- xfs_buf_inval_log_space's second parameter is
supposed to be in bytes, but max_binval is in units of fsblocks.  Hence
the conversion should be FSB -> B, not the other way around.

Cc: stable@vger.kernel.org # v6.18
Fixes: b2311ec6778fcd ("xfs: compute per-AG extent reap limits dynamically")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/reap.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/scrub/reap.c b/fs/xfs/scrub/reap.c
index fcd14c1703ea..496c6eab555e 100644
--- a/fs/xfs/scrub/reap.c
+++ b/fs/xfs/scrub/reap.c
@@ -601,7 +601,7 @@ xreap_configure_agextent_limits(
 
 	/* Maximum overhead of invalidating one buffer. */
 	const unsigned int	per_binval =
-		xfs_buf_inval_log_space(1, XFS_B_TO_FSBT(mp, max_binval));
+		xfs_buf_inval_log_space(1, XFS_FSB_TO_B(mp, max_binval));
 
 	/*
 	 * For each transaction in a reap chain, we can delete some number of
@@ -680,7 +680,7 @@ xreap_configure_agcow_limits(
 
 	/* Overhead of invalidating one buffer */
 	const unsigned int	per_binval =
-		xfs_buf_inval_log_space(1, XFS_B_TO_FSBT(mp, max_binval));
+		xfs_buf_inval_log_space(1, XFS_FSB_TO_B(mp, max_binval));
 
 	/*
 	 * For each transaction in a reap chain, we can delete some number of
-- 
2.55.0



