Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD1EC38944D;
	Wed, 30 Sep 2026 17:04:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790787855; cv=none; b=Isflnq2i0i04yk6ls5Vnmg3AkF9B5Lk7pKpZa0Bk8Db73LmwKDYZqRYNUCG4D5GjNgJ5SPS5l17qOyMaAab8aT0Qff9CxPDHlrrhyltwJDhcFWPpVUSvAG1WdKgcSXKVuOLiIFZdUBvvx6kDHlV1ZygiU8vrC5rRiyh+oBF3CFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790787855; c=relaxed/simple;
	bh=lNhKLbpRhvoVJCfkMe6T8OA1ZMpvXz4UEXZmyvxuEsc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ERz9KFLREfdS6HABscxOvedAQ0AEZVnQFbFq9MmLgfTW7C3z4DspQBCHTvzHh4W02/IP/TYZdlXZMb1sI+uD6tO2hHaznuldpUphxkgqLyv0rvfe5+I+Zq/d+cCKgxJb9ps0WkOn7gWzmOS0c9EehlHnq7mQjfie5Ld3mvBs8dM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eNzF+ro4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eNzF+ro4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 419D21F000FF;
	Wed, 30 Sep 2026 17:04:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790787853;
	bh=Ys85ge+TJXRH+RtC1eYHDTQ+pXI/BZpC9Q9dXyzAhDM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eNzF+ro4OzQQ9SnLPj5E4TWWVCF8E8ZBTSfbwiAxVazjuln9GRON2rxJENCwJNgEa
	 GEzeVw+ZYHrbwkQ+Et5i8nI8XTZtUKObKRZeuJUqsuVofXruEKf0L8X1lRctdB+QYD
	 EuR8AxN3Yc7Od1Nh6yOKoP0+fxbAGvonH8lxBn/0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vineeth Vijayan <vneethv@linux.ibm.com>,
	Peter Oberparleiter <oberpar@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>
Subject: [PATCH 7.2 376/457] s390/cio: Fix NULL pointer dereference in ccw_device_get_util_str()
Date: Wed, 30 Sep 2026 17:28:01 +0200
Message-ID: <20260930152354.119495939@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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

From: Vineeth Vijayan <vneethv@linux.ibm.com>

commit 5b76268dac968612f7283d59b539036de955b7d9 upstream.

The channel path registry entry associated with a CHPID may be removed
while the subchannel's PMCW still references that CHPID. In this case,
chpid_to_chp() can return NULL, leading to a NULL pointer dereference.

Add the missing NULL check before dereferencing the returned pointer.

Fixes: 199652309a4d ("s390/cio: add helper to query utility strings per given ccw device")
Cc: stable@vger.kernel.org
Signed-off-by: Vineeth Vijayan <vneethv@linux.ibm.com>
Reviewed-by: Peter Oberparleiter <oberpar@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/s390/cio/device_ops.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/s390/cio/device_ops.c
+++ b/drivers/s390/cio/device_ops.c
@@ -517,6 +517,8 @@ u8 *ccw_device_get_util_str(struct ccw_d
 	chp_id_init(&chpid);
 	chpid.id = sch->schib.pmcw.chpid[chp_idx];
 	chp = chpid_to_chp(chpid);
+	if (!chp)
+		return NULL;
 
 	util_str = kmalloc(sizeof(chp->desc_fmt3.util_str), GFP_KERNEL);
 	if (!util_str)


