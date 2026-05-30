Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02A6C2628D;
	Sat, 30 May 2026 17:54:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780163696; cv=none; b=GtVXvWh8KaDdSCjJuikDnH4Dr4A5mns87Ne/xe5LmyTIteeEmXiDSbBKbtOaIgyuQarf7ACkSUnKD1PlZfQlq/cglW8Uv29xG07tPytErsif5NNMapdPnxb5v2VPjOZXv94Ood9BTS3Pl7iDtoH+KyxTt+ZIwBBKWlSjIKH41Sk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780163696; c=relaxed/simple;
	bh=9yCsUUcCBbx3uGDTs6g8bHdPlZCcjCCnit4p9n3r8Is=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZGaO46RzywDMJIucmN0nyFLVuC3huFfGfVVJj3gHurh1Y5/9SJGkuGtBwVLG9ioDMPpOTnH3B/4NzFM4KdOgXsavjvw/4PbQei29UCzh8TKRz/blS2oS1bppJRMME//nI30Cn7oROTk6mec1RYYmk99qG+XbH1KbhoqIp3XEoFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mAONZHaZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mAONZHaZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45FAD1F00893;
	Sat, 30 May 2026 17:54:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780163694;
	bh=rp4dHnvpRGNLBvOF0PT3qLdOa5AvMfUNMaf1RLLQbt0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mAONZHaZl48xQfxwRaGYVY92rMcrQ/i3eTmHCWqDp9uUndW9f2xCjSyqxFK4c7OFc
	 j4JD6IdGSeDinpQsImeTWcOi4F/z7JDci5FwL981LVzXHsE8iX3DaxQD6m+hQimuF+
	 7FzrVBkWJEhUwHONkWh/hUpsF8YkR22UgqrjkYJU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junrui Luo <moonafterrain@outlook.com>,
	Yu Kuai <yukuai@fnnas.com>
Subject: [PATCH 5.15 335/776] md/raid10: fix divide-by-zero in setup_geo() with zero far_copies
Date: Sat, 30 May 2026 18:00:49 +0200
Message-ID: <20260530160249.229871916@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

From: Junrui Luo <moonafterrain@outlook.com>

commit 9aa6d860b0930e2f72795665c42c44252a558a0c upstream.

setup_geo() extracts near_copies (nc) and far_copies (fc) from the
user-provided layout parameter without checking for zero. When fc=0
with the "improved" far set layout selected, 'geo->far_set_size =
disks / fc' triggers a divide-by-zero.

Validate nc and fc immediately after extraction, returning -1 if
either is zero.

Fixes: 475901aff158 ("MD RAID10: Improve redundancy for 'far' and 'offset' algorithms (part 1)")
Cc: stable@vger.kernel.org
Signed-off-by: Junrui Luo <moonafterrain@outlook.com>
Link: https://lore.kernel.org/linux-raid/SYBPR01MB7881A5E2556806CC1D318582AF232@SYBPR01MB7881.ausprd01.prod.outlook.com
Signed-off-by: Yu Kuai <yukuai@fnnas.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/raid10.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -4004,6 +4004,8 @@ static int setup_geo(struct geom *geo, s
 	nc = layout & 255;
 	fc = (layout >> 8) & 255;
 	fo = layout & (1<<16);
+	if (!nc || !fc)
+		return -1;
 	geo->raid_disks = disks;
 	geo->near_copies = nc;
 	geo->far_copies = fc;


