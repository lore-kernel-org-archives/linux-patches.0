Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7548778C9C;
	Sat, 12 Sep 2026 19:26:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789241206; cv=none; b=kle5F+1hDwVeXWVpncReioIeRlVsgbgHlKDDm8TLVeBOmJpjLg0DCq3KU/AnfqC1Gx6PnGds4kbnZTfGZWgCXsqcodhKrtXFqRl/MxX3+smtP2nAEmAfuhXXu/Ugz8YH+weJpcszYqRvAZ4QzQ4rTJ9X0e0SJ9lFnx+lWSFDycc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789241206; c=relaxed/simple;
	bh=elw0lAlA+lIAq/RRfd2Wgb0wiZt4TMp/72u4D1PsjuU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IuPqSC2eNViCyhPmL5tjZfj8nLbaUyw3tsyW395ghdedb5n58bYA+TXqu9hseKETVzSdv69HS6Cjt4swbFvj7b4LsONXHUkEjIDWqA/Qwl85Xb5cAvM8hAo/WZdh9O/JopCFKM+i3rIDttgVWNWtlk+GZwlLl0KU3532Zw+hcfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b2VqMr0i; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b2VqMr0i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BFC51F000FF;
	Sat, 12 Sep 2026 19:26:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789241205;
	bh=gVrMaau+lBSqF+49+/n37T0gjZF2V5nngNDq5IFJkW8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b2VqMr0iN/Ov1bImdv/I/UDuyO9WOpYvdwxJYeBqUaOYfrD38jivteNu5LpiE4cmE
	 WbY9tw4nRSj+0FqkVBmonuvXVjbJWLAI4GhaVXjyoTxEgKs5neNqpg2I8IUOMvHUjr
	 GWjAwT8ITY8d6X7iKV0H8etu4vzWZ6Fhj0D/prKY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 5.10 087/798] Bluetooth: hci_intel: fix usage_count leak when autosuspend_delay is negative
Date: Sat, 12 Sep 2026 08:55:15 +0200
Message-ID: <20260912065518.952617715@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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


