Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22B8B33263B;
	Thu, 20 Aug 2026 15:03:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787238227; cv=none; b=mMFFe8GpNqfBO5Mu/arRnt2zo+tQovd6rMSg+Xs9KlZTfsWTvtB5ySXRvtEJTxbHXqWcwDJ/23BNXo9I9stFPimSmDAsQMaiCvtABoE7kfsL4GiUIqIO0wxiZvlvmGzf0UAwj7C+A9qhIEk28C2eOqXWteHggxwr6Fh+qOmiRqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787238227; c=relaxed/simple;
	bh=rr+O9zVXcU1rZIiJqstq+LhHcA6rPWW/wbQmmeEZoVg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fAryntAT+d1saBTRyO6qVKrOabfdxaztnEQgljmho60P1TdNAX8ugfPSXdH05MtDX7FbiFlmTl2gj5/6kaaO0DG3kfY5GV7fnWUdXi41jWBPi5Vzy0aDLndCLKdeVMduhZvN2ErNJilVYDN291wn0AfZ1cqYckNSnV1CiL1TgVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=haHnputh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="haHnputh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DB5E1F000E9;
	Thu, 20 Aug 2026 15:03:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787238226;
	bh=JSqV41xXj8gis7PB6NcuEsc9XFe0DeBIIyVM/aRgyoE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=haHnputhYy+Vx/D90uBnk7f/vL4roXD9H/8zsYMYhsYI5P4LCNWLlnKBDB0mAW9/l
	 QtCvOYo1J7GLqJvUBdFnTotkA+tmFuBgtrXWcfhrKnh+GkuxLpjuwDcxa+SjTamXT0
	 drPjtZqeKNnKwszR7ssCvVVMJ9Mp/rDmN5V0SME8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Raphael Zimmer <raphael.zimmer@tu-ilmenau.de>,
	Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 7.1 075/228] libceph: Avoid using invalid osd indices from primary_temp
Date: Thu, 20 Aug 2026 16:53:37 +0200
Message-ID: <20260820145246.751919623@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145244.450574346@linuxfoundation.org>
References: <20260820145244.450574346@linuxfoundation.org>
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
@@ -2809,9 +2809,10 @@ static void get_temp_osds(struct ceph_os
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
 


