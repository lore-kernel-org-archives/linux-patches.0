Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3596E335566;
	Thu, 28 May 2026 20:05:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779998722; cv=none; b=CwaF5BmMKnMTd9mGZl6FbcpNm8uyW+hS0qd5vAgADa+ezV+C3i6hi5d9gfOWGi4tO60Eu2VgjL2Fh940x/zoG0Y674WLON1oEilYnH0zj4Cw205qFoWAf6ztyPFN1mkIvxmTwoIr+gpqAYcYtxTkq6mgoV6fgiuHUigHEEGYZT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779998722; c=relaxed/simple;
	bh=RRRbNCBh17WPvN14ij2XFU7+rMIeJ+nW96KOMvwpc7s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a5Wxhlie+EcdHco5xeDEtxu2NhXSauYxaGd+3uhv9RLDafNzYfVrALsB/9Kdkvm7SgGwaAZzQjOuomMg8jxGgRJcweYgwRVjPWfdPSt4Rcue+xg+ccf5VwDJx5uKaQKIFAyZTx03QnZB/6be9beipaBXt8ww2W/9RCkqadyG3ys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1WBelwCf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1WBelwCf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 965B61F000E9;
	Thu, 28 May 2026 20:05:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779998721;
	bh=jdP5jvuq/+C2M9q+zDt199tY6zLY0uu+7mGo4ZVczwE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1WBelwCfuAHsSVRoVd/SsmHsREUUABPRpubl2FrlETpS5KBAIhwWc60u0bPYRnkcr
	 lQUpwIFig0YHFaxKMGX1AlzHwsNhAylfe+XKANYzdC7IlST+9+sku/X4Y8RUfpSQfL
	 3tdnuaobDN3+7gH/IY5SlqGdHg6kmD4cu/JlRCYg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pankaj Raghav <p.raghav@samsung.com>,
	Jeff Layton <jlayton@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cmaiolino@redhat.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 238/461] fs: fix forced iversion increment on lazytime timestamp updates
Date: Thu, 28 May 2026 21:46:07 +0200
Message-ID: <20260528194654.033648121@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pankaj Raghav <p.raghav@samsung.com>

[ Upstream commit 834e98acb748025c04fed3cac9c8954454f4b520 ]

When updating timestamps with lazytime enabled, if only I_DIRTY_TIME is
set (pure lazytime update), inode_maybe_inc_iversion() should not be
forced to increment i_version. The force parameter should only be true
when actual data or metadata changes require an iversion bump.

The current code uses "!!dirty" which evaluates to true whenever dirty
has any bits set, including the I_DIRTY_TIME bit alone. This forces an
iversion increment on every lazytime timestamp update, which then sets
I_DIRTY_SYNC, triggering expensive log flushes on subsequent fdatasync
calls. Andres reported this issue when he noticed a perf regression[1].

Fix this by using "dirty != I_DIRTY_TIME" as the force parameter. This
passes false for pure lazytime updates (allowing the I_VERSION_QUERIED
optimization to work), while still forcing the increment when dirty
contains other flags indicating real changes that require iversion
updates.

[1] https://lore.kernel.org/linux-xfs/7ys6erh3nnyeerv2nybyfvp7dmaknuxrlxv74wx56ocdothkc6@ekfiadtkfn2r/

Fixes: 85c871a02b03 ("fs: add support for non-blocking timestamp updates")
Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
Link: https://patch.msgid.link/20260511111918.1793689-1-p.raghav@samsung.com
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/inode.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/inode.c b/fs/inode.c
index cc12b68e021b2..e10439d8d7d98 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -2130,7 +2130,13 @@ static int inode_update_cmtime(struct inode *inode, unsigned int flags)
 			    inode_iversion_need_inc(inode))
 				return -EAGAIN;
 		} else {
-			if (inode_maybe_inc_iversion(inode, !!dirty))
+			/*
+			 * Don't force iversion increment for pure lazytime
+			 * updates (I_DIRTY_TIME only), let I_VERSION_QUERIED
+			 * dictate whether the increment is needed.
+			 */
+			if (inode_maybe_inc_iversion(inode,
+						     dirty != I_DIRTY_TIME))
 				dirty |= I_DIRTY_SYNC;
 		}
 	}
-- 
2.53.0



