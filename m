Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89FE33B2FDC;
	Wed, 30 Sep 2026 17:33:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790789589; cv=none; b=WleBoZNbAvtHFgopVwIfiRYA8c+3wGpBXItd0DH4pp4gEVAU73McPLXIfLq7hVYHaq1dGb7q2zb7BjI1+ZU+kg8QwKC2LLmVVWsuIaU79n41ozAawaRErjmLdanI9pt9s6S5Loj2WdMOg928gy7begZwykWIqkBAUipJKWu0sw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790789589; c=relaxed/simple;
	bh=UEMsO4QO8DuBdr9oQiAvRKpAyzf4bzyBN8olyoVGYQs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FCeUZ7DtGBw6sHBxUONtigwE4UZxpyBxI8IXLpM5si1cGlTmodu6JcrPv0vfbqSczD0mAL/UX5hFgi6GoqKcRhd3egWs+GdsYt9ZU0gJyS+QxMn6ls6bg4/SShuFO3tcbmctG3vLandkCp3aRRQbuHoPI7mPQKZDPRI12fdQTN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hmOJOc3O; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hmOJOc3O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEFAA1F000FF;
	Wed, 30 Sep 2026 17:33:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790789587;
	bh=Jo09KlRL/qU27aC3Eybqf2+T7dcqxwnHSY07jRgRMQE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hmOJOc3OuMiBS+2+ydZeZZ84eluP3vHv7HrlU6V2Apz4OoB3vCyHyQy4MsaVh5Jne
	 XX07YkC/d3EZu5DFuiU5PmdVlrsfGFUuUzJAePwwnIWBF6fFwS/7l9rg5YdOoIfA9B
	 R2DBIxV34EkdXqGPPLfZ0f1G/qDzTpph1esyTVxU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vineeth Vijayan <vneethv@linux.ibm.com>,
	Peter Oberparleiter <oberpar@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>
Subject: [PATCH 6.12 529/877] s390/cio: Fix NULL pointer dereference in ccw_device_get_util_str()
Date: Wed, 30 Sep 2026 17:24:00 +0200
Message-ID: <20260930152426.061237188@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


