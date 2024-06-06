Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A066F19AD5A;
	Thu,  6 Jun 2024 14:21:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683689; cv=none; b=ltLoWfSfAnhnhswN0Hxs3G672fUG+fZCXWlhICvkn5LiddXekqCw7OXLzWp8o+X8/g0fmk2tyTUH7Q3c1zglcs8sg+hT90g13vhGNHlJeyasbphHXBXTNL6io3GcPdSJ9jjmXDjq6EJZWocAt1EuSxsiWh7/xTuKLS6/pxPeAc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683689; c=relaxed/simple;
	bh=LTqq4XoBe/pcE1thiSUvpTYwhaR7BNJ4aF6ap//dVCY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CA6gCHOGj0/eqwI9gedXWkjk6L5tg/lFDKxEWQ141Bjhcy79wTZOxWuRZDRQ4yRX69uopw7dnnWpdS3ZBeXe+eIUEZWRRvHZOivan5spZOlt1CX6fkB+zQPiGJWMn4BriWqZqJZIc44QXLe1ueQMyCMqinIm+HM5PD08JEaGZRA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PHYAAjqF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PHYAAjqF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C045C2BD10;
	Thu,  6 Jun 2024 14:21:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683689;
	bh=LTqq4XoBe/pcE1thiSUvpTYwhaR7BNJ4aF6ap//dVCY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PHYAAjqFSCRy6aWlPddGaLf8Yo6DNKxAQEjZU7N25LOQ8Yei/q92FuXpbv9SQzcyM
	 FKlf95Hd4PwKqn4jWRoGKNtPaseOmBqWIRqARy+vraVTCLkqbwtVzx68W2xc54/08H
	 nE14dfLSaTgs5Q4UEEpdZwyCpZAV1Lycz0R2KpB4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Pearson <mpearson-lenovo@squebb.ca>,
	Hans de Goede <hdegoede@redhat.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 598/744] platform/x86: thinkpad_acpi: Take hotkey_mutex during hotkey_exit()
Date: Thu,  6 Jun 2024 16:04:30 +0200
Message-ID: <20240606131751.645499917@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit e397c564298c2e91aea3887990da8e8eddb65277 ]

hotkey_exit() already takes the mutex around the hotkey_poll_stop_sync()
call, but not around the other calls.

commit 38831eaf7d4c ("platform/x86: thinkpad_acpi: use lockdep
annotations") has added lockdep_assert_held() checks to various hotkey
functions.

These lockdep_assert_held() checks fail causing WARN() backtraces in
dmesg due to missing locking in hotkey_exit(), fix this.

Fixes: 38831eaf7d4c ("platform/x86: thinkpad_acpi: use lockdep annotations")
Tested-by: Mark Pearson <mpearson-lenovo@squebb.ca>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Reviewed-by: Mark Pearson <mpearson-lenovo@squebb.ca>
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Link: https://lore.kernel.org/r/20240424122834.19801-2-hdegoede@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/thinkpad_acpi.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/platform/x86/thinkpad_acpi.c b/drivers/platform/x86/thinkpad_acpi.c
index 89c37a83d7fcd..5b1f08eabd923 100644
--- a/drivers/platform/x86/thinkpad_acpi.c
+++ b/drivers/platform/x86/thinkpad_acpi.c
@@ -3042,10 +3042,9 @@ static void tpacpi_send_radiosw_update(void)
 
 static void hotkey_exit(void)
 {
-#ifdef CONFIG_THINKPAD_ACPI_HOTKEY_POLL
 	mutex_lock(&hotkey_mutex);
+#ifdef CONFIG_THINKPAD_ACPI_HOTKEY_POLL
 	hotkey_poll_stop_sync();
-	mutex_unlock(&hotkey_mutex);
 #endif
 	dbg_printk(TPACPI_DBG_EXIT | TPACPI_DBG_HKEY,
 		   "restoring original HKEY status and mask\n");
@@ -3055,6 +3054,8 @@ static void hotkey_exit(void)
 	      hotkey_mask_set(hotkey_orig_mask)) |
 	     hotkey_status_set(false)) != 0)
 		pr_err("failed to restore hot key mask to BIOS defaults\n");
+
+	mutex_unlock(&hotkey_mutex);
 }
 
 static void __init hotkey_unmap(const unsigned int scancode)
-- 
2.43.0



