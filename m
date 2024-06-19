Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9868D1474C8;
	Wed, 19 Jun 2024 13:15:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718802904; cv=none; b=NEAOH7Ot9Gml4Anuavf5kiMxu7pBA19MEkgP5DIVyUsm4qg4PX9I4zv2PNmKLRj7kLw1Ikx7YP0xJCdZvX4K87swIJmysDKlbEYdjuVW6Nj22QNlE4pmYuGowVzBjUG9RMEorC6hDapc9/4gOxScrwRKn1LCMvCib/GxOFKcNVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718802904; c=relaxed/simple;
	bh=0jIb3T4Zv86pUGiBuiQdZ06ZjgvmQIwi25G8htLsyYk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IevV6fiaZMUZanqahccMQWLRzMZGAO8hJgi6arHU/n9ZxeQn27NTQyKP5uDEN30+dahGKtAQTcDcY7P/RnSZGhoJQ/aehU4EMuteqwwi2l0GLgCK0m0GbLdt9ixbQrjL8gHHuhsHTUHq/yzY0FmWgMgVu5pd3rZMVEgq3uVUdLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DiKli2f7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DiKli2f7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19C07C2BBFC;
	Wed, 19 Jun 2024 13:15:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718802904;
	bh=0jIb3T4Zv86pUGiBuiQdZ06ZjgvmQIwi25G8htLsyYk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DiKli2f7W2d4HNIpf0FuhuZIrLO01BLprRXVxOuEHaPt6yFh6/dtCKzqMTqEQCxC9
	 5h52jBkIXrf0DfCjLxP8pfTXIrpyD7R05RpX4+ZL711VJOg/MkfO78P5CMv2w9dlr3
	 nF3DkzHuxEieJA6hXPA39PIt0O7dGRUxgQJy460U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 6.9 087/281] mei: me: release irq in mei_me_pci_resume error path
Date: Wed, 19 Jun 2024 14:54:06 +0200
Message-ID: <20240619125613.197774041@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125609.836313103@linuxfoundation.org>
References: <20240619125609.836313103@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tomas Winkler <tomas.winkler@intel.com>

commit 283cb234ef95d94c61f59e1cd070cd9499b51292 upstream.

The mei_me_pci_resume doesn't release irq on the error path,
in case mei_start() fails.

Cc: <stable@kernel.org>
Fixes: 33ec08263147 ("mei: revamp mei reset state machine")
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Link: https://lore.kernel.org/r/20240604090728.1027307-1-tomas.winkler@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/mei/pci-me.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/misc/mei/pci-me.c
+++ b/drivers/misc/mei/pci-me.c
@@ -385,8 +385,10 @@ static int mei_me_pci_resume(struct devi
 	}
 
 	err = mei_restart(dev);
-	if (err)
+	if (err) {
+		free_irq(pdev->irq, dev);
 		return err;
+	}
 
 	/* Start timer if stopped in suspend */
 	schedule_delayed_work(&dev->timer_work, HZ);


