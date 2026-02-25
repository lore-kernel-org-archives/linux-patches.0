Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D123A30F951;
	Wed, 25 Feb 2026 06:57:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772002672; cv=none; b=RKQwB4vCJZNgFHA8BG+RGLF7K5TKQBGZGIaj+2lJhVOcuXcrJ+53WFpQczH6KZIxqkLCYlagJOR71KDONL2UzMrhnzMi/f2OXetGCWr3GPO3+39Fy4atl5PCOHWpMm+m1X8P0kc7r+N1oWbQY0FhNDR7Wjw7PJ08pACEMMZziZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772002672; c=relaxed/simple;
	bh=3S7vE2DMKD4iLEniuV42Bgyn2FcyGwRpWSRYW4brrGM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MMEMNKGDSjfibPlBpDqxmrqKIJhpOU5G3nndIbVfpPcDLrrNlAuiv+6eEQIp1AMjqq1Ap9FwwXPrG/CV0vTJvYUIREhh5NeIJnONq2drzEMh26LRnM35ScXCjVH6iFltrJl3K4zn6wGR69GZJm098XTZk2KgrYvaZXVrpicbdlQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QRoW8XGd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QRoW8XGd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8554C116D0;
	Wed, 25 Feb 2026 06:57:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772002672;
	bh=3S7vE2DMKD4iLEniuV42Bgyn2FcyGwRpWSRYW4brrGM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QRoW8XGdyXvGoyu9SZXrz6kas3tfBnH9ahcgPMAuETLR8kndKCvUBZkzirP094xMt
	 z5I2eAlN4Hi2F6jTQSXgQl1sUZ+4bCTQ30gmdrNvrPSdDcCKWs+B5mK6hBNw83PXwT
	 MkInvarSS10Oaeby0mBzZeIRBP5poPs3oSe4KoYY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Alper Ak <alperyasinak1@gmail.com>,
	Thadeu Lima de Souza Cascardo <cascardo@igalia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 456/641] char: misc: Use IS_ERR() for filp_open() return value
Date: Tue, 24 Feb 2026 17:23:02 -0800
Message-ID: <20260225012359.565038853@linuxfoundation.org>
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

From: Alper Ak <alperyasinak1@gmail.com>

[ Upstream commit e849ada70c6b1ee22e9f4f5c0e38231dcee53f04 ]

filp_open() never returns NULL, it returns either a valid pointer or an
error pointer. Using IS_ERR_OR_NULL() is unnecessary. Additionally, if
filp were NULL, PTR_ERR(NULL) would return 0, leading to a misleading
error message.

Fixes: 74d8361be344 ("char: misc: add test cases")
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Closes: https://lore.kernel.org/r/202506132058.thWZHlrb-lkp@intel.com/
Signed-off-by: Alper Ak <alperyasinak1@gmail.com>
Acked-by: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
Link: https://patch.msgid.link/20251226230248.113073-1-alperyasinak1@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/misc_minor_kunit.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/char/misc_minor_kunit.c b/drivers/char/misc_minor_kunit.c
index 6fc8b05169c57..e930c78e1ef97 100644
--- a/drivers/char/misc_minor_kunit.c
+++ b/drivers/char/misc_minor_kunit.c
@@ -166,7 +166,7 @@ static void __init miscdev_test_can_open(struct kunit *test, struct miscdevice *
 		KUNIT_FAIL(test, "failed to create node\n");
 
 	filp = filp_open(devname, O_RDONLY, 0);
-	if (IS_ERR_OR_NULL(filp))
+	if (IS_ERR(filp))
 		KUNIT_FAIL(test, "failed to open misc device: %ld\n", PTR_ERR(filp));
 	else
 		fput(filp);
-- 
2.51.0



