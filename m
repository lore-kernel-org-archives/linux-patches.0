Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4C753AF66D;
	Sat, 17 Oct 2026 16:47:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792255672; cv=none; b=bUi94V//49RSTHNyGVf/J+b6yiM6nkuIyPAMUSILEnAYhfVgRCHPYBuXgXy0UBEPjGCh4pI2+2VVW2HHibsnH242QcL489045cgT/0YW3R412X4ZCAwQzDI3RU9R0qIkuALuodE2FZzrM+uiDmpQz6KocfWo4HTdw1yHAyKR0I0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792255672; c=relaxed/simple;
	bh=WlKXm3ci9NhRf68kj+vW4Z1kOeKNJe9+UOqF9yVPnJU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G0dvK3kak7DfRT4a7cyOaQr536ZjqrTHi0ZZDvdJBE+Zi1oilmIk+VSzi6SRyOUWUJiUFa7TUdtZpvB2A+RqeRP2HtcHsSuH5QeO2QU05zKkk2TiqMexEPG1O3ZCD7z7ik7+VXtiAmkGk8Xo6cftI5RiGkqaN/cNbXNX1S4lXAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PtAN5ofV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PtAN5ofV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CEF81F000C4;
	Sat, 17 Oct 2026 16:47:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792255671;
	bh=lMfQ2EiIV1tflNQ1tuCLj4/m/F/ZWmTVFNM9lcNNBhI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PtAN5ofVc1vzG2Y+WURBjALS1q9al3DIPhBAaHyiFJdwXF4lPq2+fU2H1ndTdAI+h
	 IC7jvIKh3BWGvClaerK73Ay3dMs8SH/lIGw0qGVB4IjlZpX8XUBfeX+sEvxkAooQPZ
	 DESH6FOAwhtLZFrR3EyiLES4OIrLoP24xlVmWZZs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shibo Zhu <3499129952@qq.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 854/869] PM: sleep: Unblock runtime PM when device prepare fails
Date: Sat, 17 Oct 2026 18:01:35 +0200
Message-ID: <20261017160058.757222591@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

From: Shibo Zhu <3499129952@qq.com>

[ Upstream commit cb258d651d747a7f7063d40f145418bee562ceaf ]

device_prepare() blocks runtime PM for a device with runtime PM disabled
before invoking its system-sleep ->prepare() callback. For a device that
has never enabled runtime PM, this changes dev->power.last_status from
RPM_INVALID to RPM_BLOCKED.

If the callback returns an error, dpm_prepare() does not move the device
to dpm_prepared_list. Consequently, the recovery path through
dpm_complete() never calls device_complete() for the failing device.

The error path drops the runtime PM usage reference, but does not clear
RPM_BLOCKED. A later legitimate pm_runtime_enable() then reports:

  Attempt to enable runtime PM when it is blocked

before clearing the stale state.

Call pm_runtime_unblock() on the prepare error path before dropping the
runtime PM reference, matching the cleanup performed by device_complete().

The issue was reproduced with a platform test device whose ->prepare()
callback returns -EIO while runtime PM has never been enabled. Before
the fix, last_status remained RPM_BLOCKED after the failed suspend and
the first pm_runtime_enable() produced the warning above. With the fix,
last_status is restored to RPM_INVALID and the warning is absent.

Fixes: 3e5eee147b7b ("PM: Block enabling of runtime PM during system suspend")
Cc: All applicable <stable@vger.kernel.org>
Signed-off-by: Shibo Zhu <3499129952@qq.com>
Link: https://patch.msgid.link/tencent_C5AC0A02FC01F700E764F8C2E3ECE4F41009@qq.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/power/main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/base/power/main.c b/drivers/base/power/main.c
index fab8df1e29e62..ab240ccf7fd41 100644
--- a/drivers/base/power/main.c
+++ b/drivers/base/power/main.c
@@ -1888,6 +1888,7 @@ static int device_prepare(struct device *dev, pm_message_t state)
 
 	if (ret < 0) {
 		suspend_report_result(dev, callback, ret);
+		pm_runtime_unblock(dev);
 		pm_runtime_put(dev);
 		return ret;
 	}
-- 
2.53.0



