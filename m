Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22D9D197A82;
	Thu,  6 Jun 2024 14:10:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683014; cv=none; b=Hs2uI33Z+L5iMPioCIK8G3PEiJuihcDTcynN1Q0qvUlwVkhFW7N3kz8zooLwIUi2YovoNb0S/cOUDwJ1k04HVyYVH5p8QnF8zA5FAUpEI0aScaAhWTrn3n/PNhWHCn5Bx5HusMdo/hl67MJaEzc8IzwXdfWWYyK0ieYqSmebwEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683014; c=relaxed/simple;
	bh=rCnrJwm2NU7RRuxIcy8FVri/BCQ9GXpw5u3syunNcNo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GySvPHwM2wACtNq4s8PIEUy4tAZJ9VqQMucK4cGuWUhsNlX0f/JOMGNI9NfK0zSvKWYYE4v9Ko/xWu9mbTBN4dQp4CXrmF+CeFqRAKbDz2SJGDFn/TsV/ksZERqkGEp7insN4fqqBLxdeSuK/kIh+gKZlGLkc6CHAR9e4g/+k6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Pld6Nt4R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Pld6Nt4R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00F74C32781;
	Thu,  6 Jun 2024 14:10:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683014;
	bh=rCnrJwm2NU7RRuxIcy8FVri/BCQ9GXpw5u3syunNcNo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Pld6Nt4RnnsL+r49Y+Xd5cmuzCN0zyv8O8Xygg0N04adIO3c7Rv1IBXFAt9JiPc90
	 Cj+bZi5BBLTmt/+VsnMED702CzCOktXhTDY8WdTTKS27dpQj49MdBdrz1VYa9P2sq/
	 JFSZOpgsdeRME0swe7fyqPMJNu1za1L6H//ErUZU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Pearson <mpearson-lenovo@squebb.ca>,
	Hans de Goede <hdegoede@redhat.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 188/374] platform/x86: thinkpad_acpi: Take hotkey_mutex during hotkey_exit()
Date: Thu,  6 Jun 2024 16:02:47 +0200
Message-ID: <20240606131658.167778950@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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
index 82429e59999da..87a4a381bd988 100644
--- a/drivers/platform/x86/thinkpad_acpi.c
+++ b/drivers/platform/x86/thinkpad_acpi.c
@@ -3044,10 +3044,9 @@ static void tpacpi_send_radiosw_update(void)
 
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
@@ -3057,6 +3056,8 @@ static void hotkey_exit(void)
 	      hotkey_mask_set(hotkey_orig_mask)) |
 	     hotkey_status_set(false)) != 0)
 		pr_err("failed to restore hot key mask to BIOS defaults\n");
+
+	mutex_unlock(&hotkey_mutex);
 }
 
 static void __init hotkey_unmap(const unsigned int scancode)
-- 
2.43.0



