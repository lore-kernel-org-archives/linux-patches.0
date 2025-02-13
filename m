Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6A07153598;
	Thu, 13 Feb 2025 14:54:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739458458; cv=none; b=IE9QRbKKWdaSnodfNjs1cpShl1Cao2sZQg1pJ+FsWa8WCMCRb0jilALIrFB1Nf9PH75Kng/HbHRF4lntwe+VCmLOcc5ZyfeOB2nlZBUfu2ilwrZbEpOk9YOyyFd3YeO3QElPQ6B9aS0XZd8fYwQfGX8mwgqn3ab2Frsq/6fqhhM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739458458; c=relaxed/simple;
	bh=pHRwzJrTh9nlBXYlDUmsJMEfMdlYLXkv/5q7DyWfR1g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lb03EiK6pSU+NnVgt+UMyS3SZCDUtaXOl5hP0v0/IxjK81bCJqTpZ6eo3ZkWgkhQ7GS2BwIWbM88rR+3+raqxGstcFu7YcInjkA8XclEozAgbqSS2Oi0O0xTO+HcFFdfW10xMN3M416NIRMv94onUbxZQ8ZElG08LmQ5L5J+tVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kTumWvuS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kTumWvuS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 392A4C4CEE5;
	Thu, 13 Feb 2025 14:54:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739458457;
	bh=pHRwzJrTh9nlBXYlDUmsJMEfMdlYLXkv/5q7DyWfR1g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kTumWvuSYa+dDGdcLXRfeY1v+vFjECS8FWhCgpwgfvXqzue8myDynjS+KOByJuPq6
	 538irr3q7BLLgDceZtTyuhqceslXVKOkmn+An4dt/H1ZHC96rKjlYuxn0CW9kiGRAd
	 1YND89a4uUpWscpxre7xe7BARZQfPlh5Qy/o7LB4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ivan Stepchenko <sid@itb.spb.ru>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 6.12 373/422] mtd: onenand: Fix uninitialized retlen in do_otp_read()
Date: Thu, 13 Feb 2025 15:28:42 +0100
Message-ID: <20250213142450.942233262@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142436.408121546@linuxfoundation.org>
References: <20250213142436.408121546@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Ivan Stepchenko <sid@itb.spb.ru>

commit 70a71f8151b9879b0950668ce3ad76263261fee0 upstream.

The function do_otp_read() does not set the output parameter *retlen,
which is expected to contain the number of bytes actually read.
As a result, in onenand_otp_walk(), the tmp_retlen variable remains
uninitialized after calling do_otp_walk() and used to change
the values of the buf, len and retlen variables.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 49dc08eeda70 ("[MTD] [OneNAND] fix numerous races")
Cc: stable@vger.kernel.org
Signed-off-by: Ivan Stepchenko <sid@itb.spb.ru>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/nand/onenand/onenand_base.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/mtd/nand/onenand/onenand_base.c
+++ b/drivers/mtd/nand/onenand/onenand_base.c
@@ -2923,6 +2923,7 @@ static int do_otp_read(struct mtd_info *
 	ret = ONENAND_IS_4KB_PAGE(this) ?
 		onenand_mlc_read_ops_nolock(mtd, from, &ops) :
 		onenand_read_ops_nolock(mtd, from, &ops);
+	*retlen = ops.retlen;
 
 	/* Exit OTP access mode */
 	this->command(mtd, ONENAND_CMD_RESET, 0, 0);


