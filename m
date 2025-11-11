Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEDE72DEA9D;
	Tue, 11 Nov 2025 01:24:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824264; cv=none; b=b7AfMfhjvQT7FmoOCBbO9ISSQCpGHpIXkAnsXHFjWW/pUTvfdBAXHm4jVLXnKe2NVlHnh8YBldgXPRx3E2074Xs3/4W9bR0z6VvtfRsW00e5YBxAlcIs+fvyBdPKsgSLJbpNIAp6NCfiuMOzVvxRllTXDjGsIMbXvHoX/aKhDnA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824264; c=relaxed/simple;
	bh=iWdm0e9PMbesC4CbJfD8esl7JmZxkZwnSTiweqJwHQc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mzRhJ4vY86GlbfFkt+9Gy+kkZGJQL3YhhjRrMxRDLV476bevpM3nc1F2TL6RxN4CwP3G/WxqVsx9Sl0vpQlwnfpY6GqX8N+Jprh8rzw+11eFF4A+Tu3TYw9j/duiKefTjcMxxAjhhbuawZ9kQBCAkaTbF9Dyz66Oez8RvCi7Aoc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QqHiMDZa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QqHiMDZa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B3B5C116B1;
	Tue, 11 Nov 2025 01:24:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824263;
	bh=iWdm0e9PMbesC4CbJfD8esl7JmZxkZwnSTiweqJwHQc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QqHiMDZaKrd1EYkW5gc7WD1dNSG3JxvcvQrqlrCCRFlJDfpfFJ7REfBPm+cCbFh2t
	 KbnWknPiyhq3joAQhIuUtEhYW+IWlbUg+u7ty73Q50+D8fBndLAnaBbQ/9dR22E+Ya
	 zIASbAcVjU1vAFUogfh2hkZeuxzfr1Ihgckh1w8M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xion Wang <xion.wang@mediatek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 473/849] char: Use list_del_init() in misc_deregister() to reinitialize list pointer
Date: Tue, 11 Nov 2025 09:40:43 +0900
Message-ID: <20251111004547.883688690@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xion Wang <xion.wang@mediatek.com>

[ Upstream commit e28022873c0d051e980c4145f1965cab5504b498 ]

Currently, misc_deregister() uses list_del() to remove the device
from the list. After list_del(), the list pointers are set to
LIST_POISON1 and LIST_POISON2, which may help catch use-after-free bugs,
but does not reset the list head.
If misc_deregister() is called more than once on the same device,
list_empty() will not return true, and list_del() may be called again,
leading to undefined behavior.

Replace list_del() with list_del_init() to reinitialize the list head
after deletion. This makes the code more robust against double
deregistration and allows safe usage of list_empty() on the miscdevice
after deregistration.

[ Note, this seems to keep broken out-of-tree drivers from doing foolish
  things.  While this does not matter for any in-kernel drivers,
  external drivers could use a bit of help to show them they shouldn't
  be doing stuff like re-registering misc devices - gregkh ]

Signed-off-by: Xion Wang <xion.wang@mediatek.com>
Link: https://lore.kernel.org/r/20250904063714.28925-2-xion.wang@mediatek.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/misc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/char/misc.c b/drivers/char/misc.c
index 4c276b8066ff8..ea5b4975347a0 100644
--- a/drivers/char/misc.c
+++ b/drivers/char/misc.c
@@ -281,7 +281,7 @@ void misc_deregister(struct miscdevice *misc)
 		return;
 
 	mutex_lock(&misc_mtx);
-	list_del(&misc->list);
+	list_del_init(&misc->list);
 	device_destroy(&misc_class, MKDEV(MISC_MAJOR, misc->minor));
 	misc_minor_free(misc->minor);
 	if (misc->minor > MISC_DYNAMIC_MINOR)
-- 
2.51.0



