Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CF072EF9C1;
	Thu,  3 Jul 2025 14:50:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751554256; cv=none; b=C8sWA05zlnn57QyxiU7o3o6DL7HbLxYBxGKrc0SXZzxSsAy7RJKoc6TyeN9BsSvDv1OXCxhUXWmdne/J9bN6qQUEiwa1YQdNqK5lYBEYlAfXYXeyc0qcIytWQJfQVzsTBvi7C7UanAYs80ODYoO3HubiSEhzIM+mOovZbGu/w20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751554256; c=relaxed/simple;
	bh=eJvx+2EFDiXD3JkpaV9HTI2u6cM2pTudbqiIcaZhUU8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JRyVbyIf2UyKV0TcLAH/4mHS7NMK3H4gFsmYMYOFwxD7aPWeeyWCQm1J5u8NcYlcFAM1SXUhDIBJrKB3px5NYnW8tt+09U7PzNxWyT+teMFxzz2nCiWkcXNeeSCyQ6lNLFmC9c6wHarOANboY2j+xcWEJrPA7RVD5sfFEgs7uWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eKD1C+dz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eKD1C+dz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1E54C4CEE3;
	Thu,  3 Jul 2025 14:50:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751554256;
	bh=eJvx+2EFDiXD3JkpaV9HTI2u6cM2pTudbqiIcaZhUU8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eKD1C+dzU+UNbnDcxAm0R2GLWYA/05LdaQ1mRKPWFFXUaubzYcgwpkRzrrHeXnJpd
	 Vsc3Tw+9s02p3RqZRuSQofegg/8ttG/tqFqbk9hRD2FjrILP4h6Xq6zpDZjvD2NYbl
	 YvzkUa/UuIOcLLupxeZTyT7P2yN+eXwuVLRGJusE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Zeitlhofer <thomas.zeitlhofer+lkml@ze-it.at>,
	Ping Cheng <ping.cheng@wacom.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 090/218] HID: wacom: fix crash in wacom_aes_battery_handler()
Date: Thu,  3 Jul 2025 16:40:38 +0200
Message-ID: <20250703143959.541483988@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143955.956569535@linuxfoundation.org>
References: <20250703143955.956569535@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Thomas Zeitlhofer <thomas.zeitlhofer+lkml@ze-it.at>

[ Upstream commit f3054152c12e2eed1e72704aff47b0ea58229584 ]

Commit fd2a9b29dc9c ("HID: wacom: Remove AES power_supply after extended
inactivity") introduced wacom_aes_battery_handler() which is scheduled
as a delayed work (aes_battery_work).

In wacom_remove(), aes_battery_work is not canceled. Consequently, if
the device is removed while aes_battery_work is still pending, then hard
crashes or "Oops: general protection fault..." are experienced when
wacom_aes_battery_handler() is finally called. E.g., this happens with
built-in USB devices after resume from hibernate when aes_battery_work
was still pending at the time of hibernation.

So, take care to cancel aes_battery_work in wacom_remove().

Fixes: fd2a9b29dc9c ("HID: wacom: Remove AES power_supply after extended inactivity")
Signed-off-by: Thomas Zeitlhofer <thomas.zeitlhofer+lkml@ze-it.at>
Acked-by: Ping Cheng <ping.cheng@wacom.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/wacom_sys.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/hid/wacom_sys.c b/drivers/hid/wacom_sys.c
index 34428349fa311..64afaa243942c 100644
--- a/drivers/hid/wacom_sys.c
+++ b/drivers/hid/wacom_sys.c
@@ -2874,6 +2874,7 @@ static void wacom_remove(struct hid_device *hdev)
 	hid_hw_stop(hdev);
 
 	cancel_delayed_work_sync(&wacom->init_work);
+	cancel_delayed_work_sync(&wacom->aes_battery_work);
 	cancel_work_sync(&wacom->wireless_work);
 	cancel_work_sync(&wacom->battery_work);
 	cancel_work_sync(&wacom->remote_work);
-- 
2.39.5



