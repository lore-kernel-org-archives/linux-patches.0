Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0AED246770;
	Tue, 13 Oct 2026 12:30:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894622; cv=none; b=EAV10WFjvCduxpiyDv9jXBLPdLut7lZnIZ0rg1HVgpZVDMZTbWaDRA6Lv7qYnQ1p3vT4KSD/mRJyDAPjdYw/zjqk83vq18vgt8pHflw42xauYWgnfnEhe8DRMZ9SJOVyEkHhGyVJDLUJBASZRz/9bcxMMEUtkAMOnpR2teCWtdI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894622; c=relaxed/simple;
	bh=+58K0PHeKOyPm71bsd2IPW5PHkWi13asqxvuN0QUJPE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DF6Q+qdrKCBDUBn2EEHAiBtPUL8TjPempIrIsGW6xd7mKhJL5pdVIwnM8BPqT/jJMBUuoX94+aAWS8xK4DmfFU8obY9i8paBwcBUn4C7xCEXg8w/YEOj7D1A/R9dyNKpyPofP8ULZwsalj0NrroJ16nQAWMe2BX4FnLqpJxIG/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Viw1JrOA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Viw1JrOA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B13F91F000FF;
	Tue, 13 Oct 2026 12:30:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791894621;
	bh=utkdLyhpdDc5dUOEreLWUdG0/9ydJRMU9YwfFUru/bg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Viw1JrOA7HHnkaWpucokFevRFSId/uQGdc5YKGnv4cYpD/HJkg5OowW7f6EM/ohPp
	 /Qu3ZWp77R8ljz3am/B3sM7TFlSB2Yre6pPesheXCdvp8MILPHW4xromUw7k0hEZBH
	 DWHyPzo3XJ/pTLqKL0gDg+CI+GqiUbmiRQtp+Pho=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 620/621] ACPI: scan: Do not mark button ACPI devices as wakeup-capable
Date: Tue, 13 Oct 2026 13:40:15 +0200
Message-ID: <20261013112935.510917093@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

[ Upstream commit 91ba8de81bcb8cea922ee9427e54798a16dfd724 ]

It is generally questionable to mark struct acpi_device "devices" as
wakeup-capable because they represent firmware entities that by
themselves have no wakeup capabilities.

It was done for struct acpi_device "devices" corresponding to buttons
because the ACPI button driver was binding to them directly, but now
that corresponding platform devices are created for the buttons and
they are marked as wakeup-capable by the ACPI button driver, there is
no reason to continue doing it.

Update acpi_wakeup_gpe_init() accordingly.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Link: https://patch.msgid.link/2891119.BEx9A2HvPv@rafael.j.wysocki
Stable-dep-of: 57c31e6d620f ("ACPI: scan: Use acpi_setup_gpe_for_wake() for buttons")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/scan.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
index 32fa1c1ded601..31cd177bd9672 100644
--- a/drivers/acpi/scan.c
+++ b/drivers/acpi/scan.c
@@ -1029,7 +1029,6 @@ static bool acpi_wakeup_gpe_init(struct acpi_device *device)
 		    wakeup->sleep_state == ACPI_STATE_S5)
 			wakeup->sleep_state = ACPI_STATE_S4;
 		acpi_mark_gpe_for_wake(wakeup->gpe_device, wakeup->gpe_number);
-		device_set_wakeup_capable(&device->dev, true);
 		return true;
 	}
 
-- 
2.53.0



