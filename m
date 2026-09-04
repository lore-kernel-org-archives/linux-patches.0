Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FBE641D624;
	Fri,  4 Sep 2026 06:14:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788502495; cv=none; b=bT5gqlVlbgIEJyWF6a8638xHsQ8yes/OKp8rDgFXgQKdwIBN3D5FjqRC1IxCznpO5a7xiRMy/8PT2mKW0S9ohQv1tjnAdcmsjqh4A+1N3FHP5p6nQCqOCkInZZAkljNUpMYFvZUWApdk6EebnCyotT27YNxh8W6ttfgCh/97/gQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788502495; c=relaxed/simple;
	bh=MaTjjREhhi+Mg4VYOhrABHVZiSCqN1kEw6gpbvqqGzk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FSuIvoaRy2fywa2BmQNtfwUCH3SzkebHQaYq4ZQwyI7gpMGzwXkgHt6CIfQbF7xpfTFXqg0dhx4AkLe/Bt9Y2B0gSFcxp5wuz56+VJ8+rcbWdTatYQjsvGwYwNGveUysSBEm3uLTwqQq+jHkOMbdYIq2ne/R/yUW6be4knun8Hk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LDjNumzY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LDjNumzY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 788B91F00A3D;
	Fri,  4 Sep 2026 06:14:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788502494;
	bh=OAbBrv9KfH24em1cUmMGKiP/dDH+3aihfPc+1mow7ok=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LDjNumzYiY+h8t3kXHjV3d4TOsFnej9HJihwQFhZJW6hwssRyt4j4YqiqBkwQv7X1
	 blz8zujU6cd/ra+ZmGTBvIfiWcRNgL7iqqzGCghb05mBVupe+ovCqXhZuw9fDVUjVG
	 NzneWxnKjUlv1PBlNMwgSpZXMbXocXRwAuTjeie8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.12 184/403] Bluetooth: hci_intel: fix usage_count leak when autosuspend_delay is negative
Date: Fri,  4 Sep 2026 06:59:47 +0200
Message-ID: <20260904045739.040915242@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045734.806166532@linuxfoundation.org>
References: <20260904045734.806166532@linuxfoundation.org>
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

From: Guangshuo Li <lgs201920130244@gmail.com>

commit c7e9a8cb6918656884a0757c92465075c7555ffa upstream.

intel_set_power() calls pm_runtime_use_autosuspend() when powering on
the device, but the power-off path does not call the matching
pm_runtime_dont_use_autosuspend() before disabling runtime PM.

If the autosuspend delay is set to a negative value while autosuspend
is enabled, the runtime PM core increments usage_count to prevent
runtime suspend. Without calling pm_runtime_dont_use_autosuspend()
during teardown, this reference is not dropped and usage_count remains
unbalanced.

Add the missing pm_runtime_dont_use_autosuspend() call before disabling
runtime PM.

This issue was found by manual code inspection.

Fixes: 74cdad37cd24 ("Bluetooth: hci_intel: Add runtime PM support")
Cc: stable@vger.kernel.org
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/bluetooth/hci_intel.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/bluetooth/hci_intel.c
+++ b/drivers/bluetooth/hci_intel.c
@@ -348,6 +348,7 @@ static int intel_set_power(struct hci_ua
 			devm_free_irq(&idev->pdev->dev, idev->irq, idev);
 			device_wakeup_disable(&idev->pdev->dev);
 
+			pm_runtime_dont_use_autosuspend(&idev->pdev->dev);
 			pm_runtime_disable(&idev->pdev->dev);
 		}
 	}


