Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F2DE146016;
	Wed, 19 Jun 2024 13:29:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718803746; cv=none; b=pGZDXNi7WTzbGt6Ua2KntQhadN1v+L0kBCQk4iLEf7RbSj1R7WTjou5ugpJJuNofxcuMXYEP8Lx6wooQUCpC5pfkNd633xerDV9KMY1XuSj3VquAtuujEMhOV3+WXTOq0VkGA0wGgKMVaedDceNVC38Eyff6aSYF5hgDMhpCIlM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718803746; c=relaxed/simple;
	bh=ljK6dJOrkk7hurIe7ZAMR6KoBqKPvV6IA6X8nttyMC0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HHE3hKzhiHHGLuHcdVn4ZsUsLCIKke7r5kC4hL4ENrucEgILwmXDcFDYBMsq/93TBHFJRBmkODEZgun80OUaLqX9f/+IzoC+kpSYiVQ9x8DEx/dO4gUHxxlzUo8fqg9YjE5mgodKCKuwI+pBjjC58RlUSec1ljpYlrwB6ECPTi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mGXxsVDM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mGXxsVDM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52E5DC2BBFC;
	Wed, 19 Jun 2024 13:29:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718803745;
	bh=ljK6dJOrkk7hurIe7ZAMR6KoBqKPvV6IA6X8nttyMC0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mGXxsVDMDezRP1MZIQdH8JQrQCHvWaXWyRU65cifaYeyfEwGBDCEancz+ysnm4uCT
	 RTyAPDRJc7cXHcV3LNet+TNLSIxr2sZfJjDu0EEfOR6SWnfEA8O+hRYSTwm/Ogl1XC
	 SMHCUsMpGNTD/yMnh9sOMEKX0mJU4dSA73LpryXk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 6.1 089/217] mei: me: release irq in mei_me_pci_resume error path
Date: Wed, 19 Jun 2024 14:55:32 +0200
Message-ID: <20240619125600.124021009@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125556.491243678@linuxfoundation.org>
References: <20240619125556.491243678@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -394,8 +394,10 @@ static int mei_me_pci_resume(struct devi
 	}
 
 	err = mei_restart(dev);
-	if (err)
+	if (err) {
+		free_irq(pdev->irq, dev);
 		return err;
+	}
 
 	/* Start timer if stopped in suspend */
 	schedule_delayed_work(&dev->timer_work, HZ);


