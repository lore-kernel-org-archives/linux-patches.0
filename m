Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7795137750;
	Sat, 30 May 2026 18:49:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780166969; cv=none; b=t5/VI9m5vrW35zY9f4OH6gy4yGf6whS/lmrgCHo5XMJMnb5RW+MQ/YZBI/P8Q5EavLTBzujMx4TgA46+4Jsjg6OBQAVSBm64c83CFCQrMm1MgaLdcaxigTQCOQSvfZbuuNb2jvV8q7wOWUSKZKUTO2IJmfhxCX0xcfbS38ZMzRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780166969; c=relaxed/simple;
	bh=G12JbuQ4RRd97tfq+lBB9YsooZ8xT4YeHJYV5ejZIOc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bSu/U9Adz7CyWcmkONEHjEd+Ug2I7XE522xkz8+h3XxmHCdezPrCv7+zIi9rdYV7W+kLHQ0b207YB8ZPSD8HPac+ovkXH7Ux82o6BSDvSiUsBkoJh/0UfkIGNxvIjemJRl3gL5qlDEi2bJ+thPuTjc4bmxVZ+QOabYVThT0SrPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Fi77qMMG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Fi77qMMG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26AA01F00893;
	Sat, 30 May 2026 18:49:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780166968;
	bh=ZKVEQs4YA14azoK6+A5+SvK0cVuoNaad+MlJ649jGr4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Fi77qMMGJKaOVvzl+y5ffx4aI2rhZPYtFWkaZK/PTqty/BNQN1w07BLh6uKLhDY4w
	 s1Zm6/42V9JqgId9UOPdi1B4pt7j4VuAM1WZSTNaRItuqUW1KKvbr9QfAQ9vT+QTvr
	 MQDRJFS6cvlLL9QH5h75X1Q2Nfjs6c9A7Lvy4Yio=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ben Hutchings <benh@debian.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 525/589] Revert "s390/cio: Fix device lifecycle handling in css_alloc_subchannel()"
Date: Sat, 30 May 2026 18:06:46 +0200
Message-ID: <20260530160238.478975896@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Hutchings <benh@debian.org>

This reverts commit 2b2ad7ad4a28ffdb9f94e6d979b88a5b12b71681, which
was commit f65c75b0b9b5a390bc3beadcde0a6fbc3ad118f7 upstream.  The
order of initialisation and error paths in this function are
substantially different in 5.10 and this backport did not take that
into account.

Signed-off-by: Ben Hutchings <benh@debian.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/cio/css.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/s390/cio/css.c b/drivers/s390/cio/css.c
index e5e20ea850aad..cf2c3c4c590f9 100644
--- a/drivers/s390/cio/css.c
+++ b/drivers/s390/cio/css.c
@@ -241,7 +241,7 @@ struct subchannel *css_alloc_subchannel(struct subchannel_id schid,
 	return sch;
 
 err:
-	put_device(&sch->dev);
+	kfree(sch);
 	return ERR_PTR(ret);
 }
 
-- 
2.53.0



