Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 142591649B3;
	Mon, 29 Jan 2024 17:14:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548440; cv=none; b=l7OXLErQvRjj/iHXKZ69eJu7Zr62bvHNi8Qd5a0oEoe2WsOqrCmVB3sCuTzfIcvDTaqUmmmW1Ty/hbDx2lC9N4vlrPfIJZ1p8kOymntIzwEx5wtlzJgL0IaGcfMv4SQKXFYDmb2AdtGUnpfNQkIt1BuW8sHSTAA+PgTr8p3dhpI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548440; c=relaxed/simple;
	bh=uwdmQyn0LzrzE+i/QiFoas7FOnXQzk8MaZqYJA+RsQo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h0K2NyrHEBy8CblajYAIqO5sCq/xEZ6gwRrd51XZV1JEFlLFoEGOlpju2AfN9S/UVo4Oxxna5Npfz0p+y4YHQmTZHm4fuZBhgeWVUU0+IvxLOnRB1nZzgXL+RQM0kGCw6fkBdQQ+g7nEeeJW/OP9Q91RLw7H4f72pnXK1YjbINs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uO6ozwb7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uO6ozwb7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD7E8C43399;
	Mon, 29 Jan 2024 17:13:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548439;
	bh=uwdmQyn0LzrzE+i/QiFoas7FOnXQzk8MaZqYJA+RsQo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uO6ozwb7uof4yRxfwzG557Jry+m+/alti4+pe3oqSwEacs5gcOOH04jAp9cnaNoCm
	 XSxDUHWVCVYNRYjrhmscWySMbuS675uYWI/25zfGp68V1OdVqn6mlzn2MuUoLNaJGc
	 gc5eP06G6bJkkorKpcEQXv00PhiH+z/fdpI7hVKQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 6.6 045/331] mtd: maps: vmu-flash: Fix the (mtd core) switch to ref counters
Date: Mon, 29 Jan 2024 09:01:49 -0800
Message-ID: <20240129170016.255189593@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170014.969142961@linuxfoundation.org>
References: <20240129170014.969142961@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miquel Raynal <miquel.raynal@bootlin.com>

commit a7d84a2e7663bbe12394cc771107e04668ea313a upstream.

While switching to ref counters for track mtd devices use, the vmu-flash
driver was forgotten. The reason for reading the ref counter seems
debatable, but let's just fix the build for now.

Fixes: 19bfa9ebebb5 ("mtd: use refcount to prevent corruption")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202312022315.79twVRZw-lkp@intel.com/
Cc: stable@vger.kernel.org
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20231205075936.13831-1-miquel.raynal@bootlin.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/maps/vmu-flash.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mtd/maps/vmu-flash.c b/drivers/mtd/maps/vmu-flash.c
index a7ec947a3ebb..53019d313db7 100644
--- a/drivers/mtd/maps/vmu-flash.c
+++ b/drivers/mtd/maps/vmu-flash.c
@@ -719,7 +719,7 @@ static int vmu_can_unload(struct maple_device *mdev)
 	card = maple_get_drvdata(mdev);
 	for (x = 0; x < card->partitions; x++) {
 		mtd = &((card->mtd)[x]);
-		if (mtd->usecount > 0)
+		if (kref_read(&mtd->refcnt))
 			return 0;
 	}
 	return 1;
-- 
2.43.0



