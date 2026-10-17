Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 693103B4404;
	Sat, 17 Oct 2026 17:19:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792257549; cv=none; b=LbX0RaiY/MsG2o0AQqu4WjbOphBf/WlzP+dVq8ctA9WuP4K7fyY7S4virpTWN4Z7lUzuNblzJoorG8PYejq1sehMCtea9kxfThN+UxbzYUHgMTzlgaG0izHJHT6GlRX3t80KZH2tOestrqfO3CIwA1nbPNH+lc/20HvoyrAJtuE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792257549; c=relaxed/simple;
	bh=pWZTTtZr9YcJdj6RII55Dw3tGD7xTn8rTCaUargQTDY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RyUv31Jy2nbS1zf2JWSas1sV6SAYadrpDUERide3yjbJQkY1YYkmiuOz+62SGqOt6XABYdHEXH57Cab3N72VDEaBlDI/4xWCKyC9tL+QyXUVboAwq14cHl1oRB9B7F3ia6oVyQOxbULfX2FGQRhKaPMdWK4RKXRw81j2uyaWT/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wKutGgtU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wKutGgtU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC6D61F000C4;
	Sat, 17 Oct 2026 17:19:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792257547;
	bh=JDU6RKZhPozXJO00PpBffc7SFJSCcm3qbjGnBS4LqFk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wKutGgtU50sB41SS5LDDdhm6fpyaWxcHEyD3Mxo0QSD7If6udFTPWRM/fEcWPCC9t
	 dMPi5GODXqMH1GTgBz13/YXytDw8JH5ld97YDSZpchm9wCsbEYiZZ0XV8hkb3vNpWP
	 lOePKGO1dOBjbmZ2O+mY8v5YxV3lKIGwCIJvr2VA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li RongQing <lirongqing@baidu.com>,
	lihuisong@huawei.com,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Artem Dinaburg <artem@trailofbits.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0594/1674] ACPI: processor_idle: Mark LPI enter functions as __cpuidle
Date: Sat, 17 Oct 2026 17:47:46 +0200
Message-ID: <20261017160446.327901767@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li RongQing <lirongqing@baidu.com>

[ Upstream commit 956ca5d72c76504824c8eb601879da9476973e15 ]

When function tracing or Kprobes is enabled, entering an ACPI Low
Power Idle (LPI) state triggers the following RCU splat:

  RCU not on for: acpi_idle_lpi_enter+0x4/0xd8
  WARNING: CPU: 8 PID: 0 at include/linux/trace_recursion.h:162 function_trace_call+0x1e8/0x228

The acpi_idle_lpi_enter() function is invoked within the cpuidle
path after RCU has already been disabled for the current local CPU.
Consequently, ftrace's function_trace_call() expects RCU to be
actively watching before recording trace data, emitting a warning
if it is not.

Fix this by annotating acpi_idle_lpi_enter(), the generic __weak
stub, and the RISC-V implementation of acpi_processor_ffh_lpi_enter()
with __cpuidle. This moves these functions into the '.cpuidle.text'
section, implicitly disabling ftrace instrumentation (notrace) along
this sensitive path and preventing trace-induced RCU warnings during
idle entry.

Fixes: a36a7fecfe60 ("ACPI / processor_idle: Add support for Low Power Idle(LPI) states")
Signed-off-by: Li RongQing <lirongqing@baidu.com>
Acked-by: lihuisong@huawei.com
Link: https://patch.msgid.link/20260616072617.2272-1-lirongqing@baidu.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Assisted-by: LLM
[ Backport to 6.6.y: Omit the RISC-V hunk because this target has no
  RISC-V ACPI LPI implementation. ]
Signed-off-by: Artem Dinaburg <artem@trailofbits.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/processor_idle.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/acpi/processor_idle.c b/drivers/acpi/processor_idle.c
index d755c266e3586..5db34356328c7 100644
--- a/drivers/acpi/processor_idle.c
+++ b/drivers/acpi/processor_idle.c
@@ -1175,7 +1175,7 @@ static int acpi_processor_get_lpi_info(struct acpi_processor *pr)
 	return 0;
 }
 
-int __weak acpi_processor_ffh_lpi_enter(struct acpi_lpi_state *lpi)
+int __weak __cpuidle acpi_processor_ffh_lpi_enter(struct acpi_lpi_state *lpi)
 {
 	return -ENODEV;
 }
@@ -1188,7 +1188,7 @@ int __weak acpi_processor_ffh_lpi_enter(struct acpi_lpi_state *lpi)
  *
  * Return: 0 for success or negative value for error
  */
-static int acpi_idle_lpi_enter(struct cpuidle_device *dev,
+static int __cpuidle acpi_idle_lpi_enter(struct cpuidle_device *dev,
 			       struct cpuidle_driver *drv, int index)
 {
 	struct acpi_processor *pr;
-- 
2.53.0



