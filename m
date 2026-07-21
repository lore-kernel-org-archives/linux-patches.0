Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52E1946D090;
	Tue, 21 Jul 2026 17:36:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655389; cv=none; b=KWbf9eGNDfBNtJb6JZ9+APw4yyLHZ7hu2eziSMxi37cFPfv9I0gzeWjC3Nslvlrgad5jtVyKlpI0qgx7lBAFyHB3q/uZOveWonp3bcRXC+CMSUPy/sDrH3F4hTuKvucvLpNg025GajdEDAoIHBMvgS4rWJuPi7Tw6YAVzWSAUig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655389; c=relaxed/simple;
	bh=c5ZbLLaLhcK5avahNHtIdpWaa5ki7zB0T8aw/Onn4Ew=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ydemdlu1aIY1gZPiHjuD7mudVCW5ev8MlL1rhN8a9zFP1GB8/SIaxbmsgyknuVXgoa+fCx5CpRdktVmcDitN9tbfwl1F57VXlm7Pr3wxrstral3nCo61RERiBODrhEkZr4GPq5q9PtbJbHXyKjOwHevwzP3XmTyK6QLjoF2cW7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Cbq/5x7b; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Cbq/5x7b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9EF71F000E9;
	Tue, 21 Jul 2026 17:36:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655388;
	bh=MRBZPvreaOHjw3+xG2cnKT5s7EtzVURxLMQUSNW5yCk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Cbq/5x7bJSEwd6lXVMK/t8fWEzCYUJ/kPx4sI8Ep9DejL2FG1R2w2F1mGuPBuNes/
	 yrch0M7BL2KfPYGxLm5ji6oYirOuP6L2wq68ZjKz8+j98V0BRaI1+7KNB203eDE7jU
	 Sf3xv1wbzWTg8lc1e05XfIk20m4It79gnSgJU2N8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 2064/2077] xfs: add newly added RTGs to the free pool in growfs
Date: Tue, 21 Jul 2026 17:28:57 +0200
Message-ID: <20260721152641.382979331@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit ae3692c7f440c1ff577aae1a51202415ec4a794b ]

When growing a zoned RT section, the newly added RTGs also need to be
tagged as free in the radix tree and add to the nr_free_zones counters.
Call xfs_add_free_zone to do that, otherwise using up the newly added
space will wait for free zones forever.

Fixes: 01b71e64bb87 ("xfs: support growfs on zoned file systems")
Cc: stable@vger.kernel.org # v6.15
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_rtalloc.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -933,6 +933,14 @@ xfs_growfs_rt_zoned(
 	mp->m_features |= XFS_FEAT_REALTIME;
 	xfs_rtrmapbt_compute_maxlevels(mp);
 	xfs_rtrefcountbt_compute_maxlevels(mp);
+
+	/*
+	 * Finally add the newly added zone to the freelist and add the space
+	 * to the available counter.  The order is important here: only add
+	 * the available space after the zones, as available space guarantees
+	 * that zones to back it are available.
+	 */
+	xfs_zone_mark_free(rtg);
 	xfs_zoned_add_available(mp, freed_rtx);
 out_free:
 	kfree(nmp);


