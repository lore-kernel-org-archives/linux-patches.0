Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09B7F1D0DDC;
	Wed,  2 Oct 2024 14:01:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727877701; cv=none; b=qg+JHaYduBnSunRR+nZ21NKAjAYpOVnyv7lhojfOGFBhmh1GUAXvP8oha/R8Bsj2lWPrOKH081vYnqpKSxc94eU5LDLelB96JAb9ZAErci8wtZOxXzmAXtA3+VLDq6W3OPkB3vtMDqTYe++8ZtWXWujBzFvtQX71o5exxyCXQ5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727877701; c=relaxed/simple;
	bh=zdUA2EF/IRN5YYbmw/CWK8AMjM/lRLtC+7PCztvctw4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kBtTKVX7Rg7UytkloypW11smDibAZpb4QSh6wIYwyhLczxevVAchLO0Bm3pmoZhtBALrt+oOIHWiJrjoEh1cESrLvwfnjNLbOTbnhW+v+YqbXZoYsOWpDkGVRQAuhc1W3nSuWIPTB9TsS5W/Goq9TkIyBzKXGqaoziSZRkuyd7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LhRqtDB3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LhRqtDB3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84965C4CEC5;
	Wed,  2 Oct 2024 14:01:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727877700;
	bh=zdUA2EF/IRN5YYbmw/CWK8AMjM/lRLtC+7PCztvctw4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LhRqtDB3n+w+saJYrIvLrCn6Mb71cXi+h+p9bPFHazR6/OaEQcu6CvpHQrzTJcVtX
	 LPiMjJRgx0B0fRZmXSQnLmcUvtd90gdcqFqOPN2OXsliBiCxp9QZOzSozb1LyreVWb
	 FYjEULtRljMZNFtBHBh2YJ4iNCE2OLP038NBH+No=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 163/634] fbdev: hpfb: Fix an error handling path in hpfb_dio_probe()
Date: Wed,  2 Oct 2024 14:54:23 +0200
Message-ID: <20241002125817.545374262@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit aa578e897520f32ae12bec487f2474357d01ca9c ]

If an error occurs after request_mem_region(), a corresponding
release_mem_region() should be called, as already done in the remove
function.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/hpfb.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/video/fbdev/hpfb.c b/drivers/video/fbdev/hpfb.c
index 66fac8e5393e0..a1144b1509826 100644
--- a/drivers/video/fbdev/hpfb.c
+++ b/drivers/video/fbdev/hpfb.c
@@ -345,6 +345,7 @@ static int hpfb_dio_probe(struct dio_dev *d, const struct dio_device_id *ent)
 	if (hpfb_init_one(paddr, vaddr)) {
 		if (d->scode >= DIOII_SCBASE)
 			iounmap((void *)vaddr);
+		release_mem_region(d->resource.start, resource_size(&d->resource));
 		return -ENOMEM;
 	}
 	return 0;
-- 
2.43.0



