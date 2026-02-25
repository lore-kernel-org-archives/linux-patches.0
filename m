Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57C111FE45D;
	Wed, 25 Feb 2026 01:46:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983990; cv=none; b=mzG1cK2S3pEVimNjzHtPUc1/RrzwKcl9fq6iPVbd6eJN1NELLzP5Ggn0tx1CMEY4SJ7Wc57CbXjvOJ7AA7MMmtiLxthi1OiPkZEsJapWEbcH1eim9LV4RwLnnTjDYNJl7//gDktXafEOkDLS5Hab1f5alUFKKNGp2+WF+JDGxi8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983990; c=relaxed/simple;
	bh=xwS1vQc0it7QfN3AIulb/IDCUU1EARj/ZKh81/SCjZY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KXkedUOX3Z/6zhcjsGXap7THhiDZ60AlsyPlXyZmZQ8lNJYARGnjf7sbZWmzvK/SbcWHHAsTkwBv5Cs7CYoTLcOkCUvaR+AJRVzEGIKuVPSNru2325DER+6V7Ahd71F+zuKYnrg/3knYB8sIEq8umDY27sDaaFhh+5o8NX44N7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uSoHafx+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uSoHafx+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 194C9C116D0;
	Wed, 25 Feb 2026 01:46:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983990;
	bh=xwS1vQc0it7QfN3AIulb/IDCUU1EARj/ZKh81/SCjZY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uSoHafx+713fhcKs8vkvDO9B0EOCRYjQd4M1GcT6DOShslXigSb3q7ZmRCf3qZoi/
	 3gbvsl22AT3viD/PM3BXaZcW1RzRWveT9WgEYrTmdTYovv+AOtRLj7WCVsYHfuupGl
	 GLPFo+wR0TznWSepnxxHijNYxo88278CEzEYJAVE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 245/641] dm: fix unlocked test for dm_suspended_md
Date: Tue, 24 Feb 2026 17:19:31 -0800
Message-ID: <20260225012354.799722611@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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

From: Mikulas Patocka <mpatocka@redhat.com>

[ Upstream commit 24c405fdbe215c45e57bba672cc42859038491ee ]

The function dm_blk_report_zones tests if the device is suspended with
the "dm_suspended_md" call. However, this function is called without
holding any locks, so the device may be suspended just after it.

Move the call to dm_suspended_md after dm_get_live_table, so that the
device can't be suspended after the suspended state was tested.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Fixes: 37f53a2c60d0 ("dm: fix dm_blk_report_zones")
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-zone.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/md/dm-zone.c b/drivers/md/dm-zone.c
index 78e17dd4d01b8..ba39c8313f32b 100644
--- a/drivers/md/dm-zone.c
+++ b/drivers/md/dm-zone.c
@@ -66,11 +66,13 @@ int dm_blk_report_zones(struct gendisk *disk, sector_t sector,
 		 * Zone revalidation during __bind() is in progress, but this
 		 * call is from a different process
 		 */
-		if (dm_suspended_md(md))
-			return -EAGAIN;
-
 		map = dm_get_live_table(md, &srcu_idx);
 		put_table = true;
+
+		if (dm_suspended_md(md)) {
+			ret = -EAGAIN;
+			goto do_put_table;
+		}
 	} else {
 		/* Zone revalidation during __bind() */
 		map = zone_revalidate_map;
@@ -80,6 +82,7 @@ int dm_blk_report_zones(struct gendisk *disk, sector_t sector,
 		ret = dm_blk_do_report_zones(md, map, sector, nr_zones, cb,
 					     data);
 
+do_put_table:
 	if (put_table)
 		dm_put_live_table(md, srcu_idx);
 
-- 
2.51.0



