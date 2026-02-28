Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9AC9359A90
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:14:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302452; cv=none; b=Gt0odiHeJX4iDwVN6lE8qVKNUyUbWCMYTmx9JKIjRHCtZQ0oCr3w+A1LOQfAkqoD5y2xaxdkBaP+MetmBlWfCW+w6OtfRkzlul4YQ5wyO0TkJApzkTQB7FvPjAB9kSIfSP4xis8MzUeQSarLOJnGgCifApSR7xA2Uv8NCX7KJ58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302452; c=relaxed/simple;
	bh=AJGnjivqcq6Q8bcwCFRdMie3j1ywce37sfDMqI7UJvM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r1+YDD48aBDlfRbQk08ckgePvQfBEnLGOojv0pDhO/aJvdp4ki/GnqoZnGYSXstPp0QenJbIVnMn6QjF15Xx89OAYTC7Rn7GiVXTx7KplsWfZhetPsBeWPf5cS3vSIIVGcudJUbe7MzjsPYr6uoGDIrLv8AxjohKscdkSCRdM/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MlNRhMYF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MlNRhMYF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30BCEC116D0;
	Sat, 28 Feb 2026 18:14:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302452;
	bh=AJGnjivqcq6Q8bcwCFRdMie3j1ywce37sfDMqI7UJvM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MlNRhMYF/a/oGWZLxdiaANtnWGkfESaSwBK0N8Y06OdbAYxsZBjOGqDMKMSafdFRX
	 J17CBZBg3TCOm74L6o1EjjbFLq8pk4y4UgVpaPd1zP4nU9TJL3yLkvDk8YUveOk7tB
	 pV/m8pOhyL6RnnRt9+fSrGjhziB97CR9xfexcdhB5gquUpk+pBdTXYbLHQRD3ucDyN
	 T3vwSAlywktGu30VVgue+t9Uek75VJZ9vFG3pzXWKDLn+0i5OguKRpys8pjGvDg+QK
	 bZVQf9G/lWRE/ZXhZL6vGcFfsAciwXqscPR9x+tBjDj+300FCI2KE20ezWOysXCTlI
	 DlDkdWSWr2F3Q==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Haotian Zhang <vulab@iscas.ac.cn>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 193/232] mfd: arizona: Fix regulator resource leak on wm5102_clear_write_sequencer() failure
Date: Sat, 28 Feb 2026 13:10:46 -0500
Message-ID: <20260228181127.1592657-193-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181127.1592657-1-sashal@kernel.org>
References: <20260228181127.1592657-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Haotian Zhang <vulab@iscas.ac.cn>

[ Upstream commit 4feb753ba6e5e5bbaba868b841a2db41c21e56fa ]

The wm5102_clear_write_sequencer() helper may return an error
and just return, bypassing the cleanup sequence and causing
regulators to remain enabled, leading to a resource leak.

Change the direct return to jump to the err_reset label to
properly free the resources.

Fixes: 1c1c6bba57f5 ("mfd: wm5102: Ensure we always boot the device fully")
Signed-off-by: Haotian Zhang <vulab@iscas.ac.cn>
Reviewed-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://patch.msgid.link/20251214145804.2037-1-vulab@iscas.ac.cn
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/arizona-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/arizona-core.c b/drivers/mfd/arizona-core.c
index b1c53e0407710..9ac671ec26684 100644
--- a/drivers/mfd/arizona-core.c
+++ b/drivers/mfd/arizona-core.c
@@ -1106,7 +1106,7 @@ int arizona_dev_init(struct arizona *arizona)
 		} else if (val & 0x01) {
 			ret = wm5102_clear_write_sequencer(arizona);
 			if (ret)
-				return ret;
+				goto err_reset;
 		}
 		break;
 	default:
-- 
2.51.0

