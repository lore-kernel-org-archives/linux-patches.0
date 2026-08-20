Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 951C837EFFE;
	Thu, 20 Aug 2026 15:14:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787238848; cv=none; b=usChC/n0JK+QLTa0h1Iar0o9d/3/RCRXhNj15kLEBp5TAMry0EVx7Uh5kyUQ3dIDbV3Yl4pMACnGFdsc+qkvQX7ZChXQvjmPZsscirz2SKXExM1qa1EDyX3AfOhqihqQWfvSgr7lLXOBVeex4/iB765bmJeWEVo7jLg2Q4Y0qpk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787238848; c=relaxed/simple;
	bh=lmeRzpGly/67BP+CmErz9+XUrnc/1yfwfQDX1FIWTmk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RLKkU4eDKBTfdfbWQEisuNnjgD3FZGobcDEwv2v0L0iUUW2MA+aTGdOaKeMa8RGW4LQAv80Gwpcol1vskjd7yWo8/QOc4Ws1RgCHuoWRoSA8H98KEAokg+9o9BNGLT6HVPG7o1x1qevc7pNjhQ18YQU7Zbc5LYSla4kpHL3tLq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yR4PX1fe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yR4PX1fe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F18C31F000E9;
	Thu, 20 Aug 2026 15:14:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787238847;
	bh=ZrGNkott0089FHdfWa3MSpeUu8gnzNf0l0t0052BnJs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yR4PX1febOlUmZEIabRmOF45Re237RrOQjtgvYELXDW6z2o6kTchjGrpqstdeisbl
	 F8Pm3pkkaRONfnVvokbD3q/VA+npeQH1gAj8Bq588yUz71xrZrlfhV/vYhh5xlHITL
	 ZUUYGQMDmqit2XlWXkxI1CJ2pF7aGbk3VgBO9kGM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Raphael Zimmer <raphael.zimmer@tu-ilmenau.de>,
	Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 6.18 062/217] libceph: Avoid using invalid osd indices from primary_temp
Date: Thu, 20 Aug 2026 16:53:50 +0200
Message-ID: <20260820145239.488261943@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145237.531699751@linuxfoundation.org>
References: <20260820145237.531699751@linuxfoundation.org>
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
@@ -2811,9 +2811,10 @@ static void get_temp_osds(struct ceph_os
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
 


