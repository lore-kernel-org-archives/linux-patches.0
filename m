Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5157413F432;
	Wed,  3 Jul 2024 11:17:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720005446; cv=none; b=sSvl35no39CedKMr8Z1hxFIGknpUyBdK/YT4lBkgipzokRyN2LOGUs5cplPTPNAzE0ewh13u+KFPNH+sRTvonBAErHDtSUl3hbKJmy2hFx38DhGGfRffp3LIo3xaOMVpochm2o2cq3lclPEjGN3Axndpu7aGAW9N0K1lip4HIAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720005446; c=relaxed/simple;
	bh=5VP7xz/yNeBw2roqY97oap5h8BtDVnCtJsvRcUfih/M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L9KSj61JKNtyeKpShnVJHgYSP/Krik4fgAEJgMiiD307QFyLbsbG8wNComfuu/GFtKvaWhpxti2H+EH+8iBkcCcO1eOCt+PhJya6ErFwe1B/OYPht4FDkGGJz4PsbsRDaPQ5K5ZDKkeN9tDC8bTvl2txcwx5iklvSTT0YQbQyq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AuBouhL+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AuBouhL+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCC3AC2BD10;
	Wed,  3 Jul 2024 11:17:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720005446;
	bh=5VP7xz/yNeBw2roqY97oap5h8BtDVnCtJsvRcUfih/M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AuBouhL+csOFRJPgVFkdlBKrUwrH44VjnS7Q4hPDWsurRIVFG+7UBIaXUQJk37UIu
	 mX3LEwG4VULT3p/jLxXsCX72Xs3ecf9oZ64a//OYyM4HUcQbbWDzxT4kNJQY22zF6C
	 gJPLsNX3SBXtAryjWfF/VPDcdAlql/PdoM1L8rz8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 5.15 076/356] mei: me: release irq in mei_me_pci_resume error path
Date: Wed,  3 Jul 2024 12:36:52 +0200
Message-ID: <20240703102915.978957471@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102913.093882413@linuxfoundation.org>
References: <20240703102913.093882413@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


