Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1209A272E53;
	Thu, 20 Aug 2026 16:29:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787243393; cv=none; b=qUQb43rtolQdAGzO05o4BpVpsLnwGLULSMXevOsLqj4joJEezASSW+/DNOBICpXKmLUouT0qsgzuqBnr66cwsrwHWV1TINFM7El9sE8pNhKzrSuSo7GpsgaeRIRE60ub2YPD/WYP7Y2y4UET8ZEAYuq44P1qbuBbdGJrEtu0UGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787243393; c=relaxed/simple;
	bh=OHliEtq5Qf+xE7gKI9YBw8m7z7oHrnlJiZf9FGEBz5U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XV/+dItSvH6U2NDSTNDQkdJtZNX/gTc/1mTHlpGoYapRyHDCIEQ8SPWlrI/l4WonR2coc5Xdxm2hizCalpduhHH8RXkj2u1YHMVQSMGn6QRIUPy+1Bz5P0J9nsTiQRmbQh9rqZPBhzLAD6dj5HqZjkFLITi8IgIKb53qRqINiyw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0maUsX0r; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0maUsX0r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B3591F000E9;
	Thu, 20 Aug 2026 16:29:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787243392;
	bh=abXlpOUXPNkFHK9w2xMTb60XJphZdO7Kkp+58iI/rKI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0maUsX0rK4XibnSIPP6pq3PRk17qAR6KHI45Xo8jroD4sipQYeYNsyyRoUIl6vo65
	 7+gFrr+klyWweWNcMR4eEZ/p+Y8ornNRbC1OOkfWJKrlo4VF5BTGj6Hrv7Ic68Pj8C
	 NpDKWYNwg3itx8nXtAddW+TEkTuHLByRBZ3CW9ew=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Raphael Zimmer <raphael.zimmer@tu-ilmenau.de>,
	Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 5.15 030/272] libceph: Avoid using invalid osd indices from primary_temp
Date: Thu, 20 Aug 2026 16:53:34 +0200
Message-ID: <20260820145232.135746030@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145231.229664293@linuxfoundation.org>
References: <20260820145231.229664293@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2791,9 +2791,10 @@ static void get_temp_osds(struct ceph_os
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
 


