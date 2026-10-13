Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A02324FDE6D;
	Tue, 13 Oct 2026 12:11:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791893478; cv=none; b=A122hu2aqpcJOrgFtrQp0uWm6U7VnF5HDWjc5PYHRjwiWBRkgz9FU4nRzCk/P0oY6f0RqjGxkrNWGEi95zD4HNqDh8cogCpux5eHQWI7RCoDm3g62SXa3bYWgc0uFVXXuvOMBaBpnJUkG7Opx92+hOCWz2Id8ZCQGVLfJVElvs8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791893478; c=relaxed/simple;
	bh=hmnAhchcJ6/2cZN/Z4GtLMpKvPyR/BsH1VfOSuWNPPQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A+gPsN9y5sYZ26u2xcJtX/sX58oSJtdJAIK45G4JoyxCXHRY0RP+VFOKmn1usxqHRBbRCU9TSQZ46s6i7COX0Vu45CV9yT32x/6x+VGFwsT5j56Utdu2DLqFvSxrMGzuPjjhHtn8LLBLdeZlB5Unpzs431S8N0LHa5Nm28u31rY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Jm2rGVCL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Jm2rGVCL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 098971F000FF;
	Tue, 13 Oct 2026 12:11:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791893477;
	bh=Hs1k57M27aEyOk1jpNCfOgLK3CXBqzW49TTkiIAcZpI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Jm2rGVCLmq5gSE0XZY8pLK4bNlMc+Kc3aPYAh0qmxIyfTGZzVx6vC/ADkmIK6x9e7
	 da8KuxmjcK+a14JHoNeErNk5JZnmAVzuUwOfOAiNs6pP3KVXs/V8dJVRH0kSq2z7x6
	 Vetab6qkdNG7Qu5hvhHodgSTix/FG5iTcgR9iX3A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 238/621] ACPI: button: Fix ACPI GPE handler leak during removal
Date: Tue, 13 Oct 2026 13:33:53 +0200
Message-ID: <20261013112926.505573843@linuxfoundation.org>
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

[ Upstream commit fe80251152fed5b185f795ef2cd9f7fe9c3162e0 ]

Commit a7e23ec17fee ("ACPI: button: Install notifier for system events
as well") changed the ACPI notify handler type for ACPI buttons to
ACPI_ALL_NOTIFY, but it forgot to update acpi_button_remove() to reflect
that change.  This leads to leaking the notify handler past driver
removal, which may cause a kernel crash to occur if ACPI notify on
the given device is triggered after removing the driver, and causes a
subsequent probe of the given device with the same driver to fail.

Address this by updating the acpi_remove_notify_handler() call in
acpi_button_remove() as appropriate.

Fixes: a7e23ec17fee ("ACPI: button: Install notifier for system events as well")
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reviewed-by: Mario Limonciello (AMD) <superm1@kernel.org>
Cc: 6.15+ <stable@vger.kernel.org> # 6.15+
Link: https://patch.msgid.link/7954431.EvYhyI6sBW@rafael.j.wysocki
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/button.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/acpi/button.c b/drivers/acpi/button.c
index 63beaeb9f7cc7..384caea90ce5f 100644
--- a/drivers/acpi/button.c
+++ b/drivers/acpi/button.c
@@ -683,7 +683,7 @@ static void acpi_button_remove(struct platform_device *pdev)
 						acpi_button_event);
 		break;
 	default:
-		acpi_remove_notify_handler(adev->handle, ACPI_DEVICE_NOTIFY,
+		acpi_remove_notify_handler(adev->handle, ACPI_ALL_NOTIFY,
 					   button->type == ACPI_BUTTON_TYPE_LID ?
 						acpi_lid_notify :
 						acpi_button_notify);
-- 
2.53.0



