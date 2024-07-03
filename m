Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EF98172BCF;
	Wed,  3 Jul 2024 10:42:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720003379; cv=none; b=CNDim8E7vKGNBK9WMcbMLusOQZwnQqMBdmIyhM6wmRSg23D2T7RfW2rf8YmsyJeUqgK+nK+qUyFNU7BwKSZzKofBalpFVTGLthR5Fjy6WcoWbP+Y8Fyey9lT4W+lnDZZjBrKXKtxToIOhFAoIGGQ/RxAV4faBaUGpK2d+6HBTmU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720003379; c=relaxed/simple;
	bh=JeyY8yQdsW7+XOA095MVF3j0rrBaO8lPd054cnlg07g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f4tJEmHWwAG992cuhz9fxU3JbGuFFIhOUxVD5WEaRhiv7tLI/6sY1Bv3pp1cvRr4hcnoATqUMT+rwpd9162zkLkMT5Bq/Zlp7FV0RywAb7aYcRQKkQJnl9qNWUoFdu4oAi0NoUdCp7NJi9Eyo5vDwj3CMNdcJQJVctYgQRE+5pI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bs3hDqSl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bs3hDqSl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A041C4AF0E;
	Wed,  3 Jul 2024 10:42:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720003379;
	bh=JeyY8yQdsW7+XOA095MVF3j0rrBaO8lPd054cnlg07g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bs3hDqSlXPh4KIC6aRpumPNW2W1am6a0dPhuPh0aDPw+tFkri0fvv9PH3p6i8FZok
	 IEVEdR9M3imXJRokmRRHZhUsi10fb+UiC4aOIHLCZf59U8sUwZXR+KC5A0pK4edE6U
	 eaS/TwsjQb3lezufscmKGLTKhYP0sebO9i/12gFA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 4.19 030/139] mei: me: release irq in mei_me_pci_resume error path
Date: Wed,  3 Jul 2024 12:38:47 +0200
Message-ID: <20240703102831.579604105@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102830.432293640@linuxfoundation.org>
References: <20240703102830.432293640@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
@@ -388,8 +388,10 @@ static int mei_me_pci_resume(struct devi
 	}
 
 	err = mei_restart(dev);
-	if (err)
+	if (err) {
+		free_irq(pdev->irq, dev);
 		return err;
+	}
 
 	/* Start timer if stopped in suspend */
 	schedule_delayed_work(&dev->timer_work, HZ);


