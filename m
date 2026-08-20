Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ADE442AF95;
	Thu, 20 Aug 2026 16:40:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787244027; cv=none; b=jeZVmiOtKjl6hVqev5E8uCPB00LxvbLvEXGT5viNianBZhzU4rNv/slLeCAzVeSkTJmLRNMS1MRVv/0yVkLnPFPVdP1QEwuTshRd1QLdc/gudKKzRVwhK7JoEOk8VEW/TjtlTcBA9gd2tV8F5Nzk/PSvFSKA/rQz2AZNqFvmp8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787244027; c=relaxed/simple;
	bh=pHOcKcDf8FvPjTjZdx1P3PBwPaTNacn55R3RZXdL+5o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ByZY2g7aI3DjeSzB3vvZM4vm5J4GWlJWsTy+8YNkHGrIjitKX9uAUp7K5xlQpWb57EU6374dqIOKYG8NVcrJOmI1mCl60eC7RvpEqmd1w098OKmeOZzM7+KOV3SFtRN1Psxv8ZeB1UjeJFBUSsNZvHBTFdmo38jsFqrcA/PdFIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uy7wmkoQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uy7wmkoQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95FCC1F00A3D;
	Thu, 20 Aug 2026 16:40:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787244026;
	bh=IRu0/Y//yZ07Ke34VxNczVUeep2/8E+44PUWp03Jj+w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uy7wmkoQQF3MGo7e6eY0LbyWIvBrY5WlhAXC8xPogqJ70Qb+tvJDwyo8hl0HmwPwZ
	 cUn6bRoU0lwxwK392PCsNWZQHsI/99kf/PGvWsD15wbmLQ6aQ9kzCQyBqfU82HpbCR
	 pCrr3wGPBZR1rgiSrhvI8kdAMWmKRNAKL0FcZUAM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Raphael Zimmer <raphael.zimmer@tu-ilmenau.de>,
	Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 5.10 027/235] libceph: Avoid using invalid osd indices from primary_temp
Date: Thu, 20 Aug 2026 16:54:23 +0200
Message-ID: <20260820145217.259820536@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145216.426568665@linuxfoundation.org>
References: <20260820145216.426568665@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Raphael Zimmer <raphael.zimmer@tu-ilmenau.de>

commit 3660b98d1204b419f6a77e9a295f148dcf38d042 upstream.

A corrupted osdmap received from a Ceph monitor or OSD may contain osd
indices in its pg_temp, primary_temp, pg_upmap, and pg_upmap_items parts
that don't exist, i.e., that are greater than max_osd or smaller than
CEPH_HOMELESS_OSD (-1). These indices are used to create the up and
acting set in ceph_pg_to_up_acting_osds(), called from calc_target().
While most of these osd indices are checked, the one from primary_temp
is not. Subsequently, this may lead to calc_target() returning this
(potentially invalid) index as target osd for a (linger) request.
Because the osd_state, osd_weight, and osd_addr arrays only contain
max_osd entries (with indices 0 to max_osd -1), this leads to
out-of-bounds accesses when trying to read values from these arrays.

This patch fixes the issue by adding a check to get_temp_osds(), so that
only valid osd indices from primary_temp are used, and it falls back to
using the primary from pg_temp or the up set if it is invalid.

[ idryomov: changelog ]

Cc: stable@vger.kernel.org
Fixes: 5e8d4d36bf23 ("libceph: add support for primary_temp mappings")
Signed-off-by: Raphael Zimmer <raphael.zimmer@tu-ilmenau.de>
Reviewed-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ceph/osdmap.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/net/ceph/osdmap.c
+++ b/net/ceph/osdmap.c
@@ -2772,9 +2772,10 @@ static void get_temp_osds(struct ceph_os
 		}
 	}
 
-	/* primary_temp? */
+	/* primary_temp? (shouldn't ever be a nonexistent or down OSD) */
 	pg = lookup_pg_mapping(&osdmap->primary_temp, pgid);
-	if (pg)
+	if (pg && !WARN_ON_ONCE(ceph_osd_is_down(osdmap,
+						 pg->primary_temp.osd)))
 		temp->primary = pg->primary_temp.osd;
 }
 


