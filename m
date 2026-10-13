Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A6DA4F7975;
	Tue, 13 Oct 2026 12:32:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894761; cv=none; b=bdAYvu3Ai6MpkknnE6iaFxIYn7IMO4g8zVloeMn90bfd1Cu5fWSyodqURsWtlXR9zOL/Cuwe05RtcQRNXmxgodgojyUMnzjlPvXmjXwS+zfqmvlNqOUu815r4WkLcAJEqEKHg9eQYTgMNbEUsUFVEIUDU0LWNpa0G5ffzeMtUmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894761; c=relaxed/simple;
	bh=ohH/Pla+5I98bke04syqWmXnE5ogttdEJLBJFAkdE7U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pC8c1ehb5S9lTdaz20l1TeYeUH2ng3pqG2KIT70BXYEVhiYwhSWpdq2loky7A4NjIXPD3joc13/lYNjpcWl+x5J4EBq03ZlpECGtzGuOtB4qaGVcmNkqwQ002g7YiruuRLjjbECvc7IusYdFYtvxrz7bRSFk30bLCtZfJ09EVUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wW0TSRb1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wW0TSRb1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 724691F000FF;
	Tue, 13 Oct 2026 12:32:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791894760;
	bh=qlhjzsjMp329mq64fqZaAnRg4qF7lpxJXQ6MdylKBM4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wW0TSRb1QGs6VlonIlbAh8GQhnPyzMHw/Anzt1ZGH5araXuB1C1ynrnwOHq0QVz9m
	 Qo07dR+0hDfSrF702noHfgxxCra/bj883fDJE8Z8Gqv39P45YDV39YDOSKr4ia2eco
	 oiqPxmYSiViqIVF0kLn6vQ00WWP29BBmODWOQ2hk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 048/497] mtd: core: call _get_device() with the master MTD
Date: Tue, 13 Oct 2026 13:33:35 +0200
Message-ID: <20261013112909.027863691@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit 12b31d1acd20b3185bb5f0748db0cf6874c8e9d1 ]

__get_mtd_device() calls the master's _get_device() callback with mtd,
which may be a partition. __put_mtd_device() passes the master.

This breaks gluebi partitions because gluebi_get_device() uses
container_of() and therefore requires the master MTD. Pass the master
to _get_device(), matching _put_device().

Fixes: 46b5889cc2c5 ("mtd: implement proper partition handling")
Assisted-by: Codex:gpt-5.6-sol
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/mtdcore.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mtd/mtdcore.c b/drivers/mtd/mtdcore.c
index 0c8e8eb5f0f3d..12d31ed27b4ec 100644
--- a/drivers/mtd/mtdcore.c
+++ b/drivers/mtd/mtdcore.c
@@ -1259,7 +1259,7 @@ int __get_mtd_device(struct mtd_info *mtd)
 	int err;
 
 	if (master->_get_device) {
-		err = master->_get_device(mtd);
+		err = master->_get_device(master);
 		if (err)
 			return err;
 	}
-- 
2.53.0



