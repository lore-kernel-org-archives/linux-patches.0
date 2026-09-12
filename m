Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D0F341837E;
	Sat, 12 Sep 2026 08:42:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789202526; cv=none; b=nO/x2Cdoc/KNSBogpu/0reW+LLROig3LLWVH9jiYs+liN4s4QAIiSjP0PjNyeJt/z5HSG9DZGS13UUDNdZwdWWP0dcHnjXPt60Ysyekk41De5j9sN2aRMWUs2LjGe8Jd1nwGbbSK2gE+U/Z1o8qv1MiiArUxYBWqZ9BPtU+ompc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789202526; c=relaxed/simple;
	bh=1oRurAG/p19WMxxwncyjvBCjmrgSnYE76z74N9PbUAg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W5DP13ETAflexHVF8FA2rQfK7Z+fQ92oIjFmErj1xIT00xMYryYbQhbyYf91uQAkB28RgISs/f5WssNZEK7NuSKPIvBEXxFh35RcOS5tOM/hiaalDtCnYFUBEhcv4vRIUIfQLEJe+eD/MFJDBnDafag/0KmMLws0NVzZkoMlItk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TmhubQyu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TmhubQyu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 265351F000FF;
	Sat, 12 Sep 2026 08:42:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789202525;
	bh=JBZ/pB8QsSO4bQnG4lNDagUmI54/Xt+8DmqbsKen3uk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TmhubQyuRNUxu/jNZtRtHPOc0EA3Fq34T3mxZ6YUgNXiS9eQUrHrywa39HkzrAB8z
	 vYEk/MHqWrGFu2ZjXP2YbpY3jyuCAhU0o7AALrlLNCYKMt6Uz7d31sF/4QspUNUqWI
	 BEvh2buIrNMrq8He7Q7Xd620Z+QKv0qac+TJmzX8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Yang Xiuwei <yangxiuwei@kylinos.cn>,
	John Garry <john.g.garry@oracle.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1220/1815] scsi: sd: Fix error handling in sd_probe() after large pool creation failure
Date: Sat, 12 Sep 2026 08:49:30 +0200
Message-ID: <20260912065717.647568736@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yang Xiuwei <yangxiuwei@kylinos.cn>

[ Upstream commit e3cc6ea1a745e7f5d326f919a428b244fa119d8f ]

After device_add(&sdkp->disk_dev) succeeds, sd_large_pool_create()
failure must unregister disk_dev and let scsi_disk_release() free
sdkp. Going through out_free_index kfree()s an already registered device
and leaks the sysfs entry.

Fixes: 7179e626b76e ("scsi: sd: Enable sector size > PAGE_SIZE in SCSI sd driver")
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Yang Xiuwei <yangxiuwei@kylinos.cn>
Reviewed-by: John Garry <john.g.garry@oracle.com>
Link: https://patch.msgid.link/20260707030333.22245-2-yangxiuwei@kylinos.cn
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/sd.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 599e75f333343..d18693d390b2f 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -4089,7 +4089,9 @@ static int sd_probe(struct scsi_device *sdp)
 	if (sdp->sector_size > PAGE_SIZE) {
 		if (sd_large_pool_create()) {
 			error = -ENOMEM;
-			goto out_free_index;
+			device_unregister(&sdkp->disk_dev);
+			put_disk(gd);
+			goto out;
 		}
 	}
 
-- 
2.53.0



