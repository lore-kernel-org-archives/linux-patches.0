Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B99913BC0B;
	Wed,  3 Jul 2024 11:00:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720004450; cv=none; b=u8h4wyXhN76QB6o7xkOea+BtmxY8/ebHlwwk6puShukfwrCYZBE2bfVaWt1HcT+wUmIsTsLYd2rMgOl/DiViJXXdYcH46aeZ7avOMBwZ/qLvlw24w0fJbtDCcwuo3nhUDa2h3vT6kad8H9n/I7aGo2GfOuW382IyBPVhShOc0zM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720004450; c=relaxed/simple;
	bh=AR43VykcEoDxSsJlSAZO48mY140wDLZwSPvb2L5kx0s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W9dVZGcIQnmV+xCmwjzwzQ5VI7sYyJtxYb/3BSScalI1Qupjjp6s6v3X0lO9QTsfs+yB+RediAPYMXKSMgM7oQDR85gyJVvntD+PCcL9ldqN96ILL6Wgq+1EhHaxy9vrtxmiT9ODeJLW73e+JxEB0g1Et+fL6lWb/oFPD52LCsE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bHZZvVcL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bHZZvVcL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45076C2BD10;
	Wed,  3 Jul 2024 11:00:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720004449;
	bh=AR43VykcEoDxSsJlSAZO48mY140wDLZwSPvb2L5kx0s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bHZZvVcLtnoPN5NzQHnC6s3jtO714vGaXp+AGKf5xcRJdD5ztEHshFBoDZsZ3mQRQ
	 ReZpc3hrtWMSUSd80Ig+q0m1MsMt8dJAbEMFyy0N7Lj1x/tAgGUCl0EwY859dow1mx
	 ferBj6aOMjN01qNslsf1m/GxZmTCI+R8j+jbLMLM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 5.10 045/290] mei: me: release irq in mei_me_pci_resume error path
Date: Wed,  3 Jul 2024 12:37:06 +0200
Message-ID: <20240703102905.903348399@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102904.170852981@linuxfoundation.org>
References: <20240703102904.170852981@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -400,8 +400,10 @@ static int mei_me_pci_resume(struct devi
 	}
 
 	err = mei_restart(dev);
-	if (err)
+	if (err) {
+		free_irq(pdev->irq, dev);
 		return err;
+	}
 
 	/* Start timer if stopped in suspend */
 	schedule_delayed_work(&dev->timer_work, HZ);


