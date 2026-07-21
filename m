Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC0993BA232;
	Tue, 21 Jul 2026 21:06:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784667979; cv=none; b=ANCzIqVGZpH6Y0el5mxKOchWGpTqDFx6P3gcX8+P5fmo3QCJQd4D976XurgpiMAgXjQqRJGPLKWPm0qoTlgXteenCCWhkR2oC/19TCAYeN80nlVX8AxZR1fV8bWda7yvbZdzPRLFaO8ITD6piZL02oCa7QV89FfDYAeccZCFyKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784667979; c=relaxed/simple;
	bh=RtyKHk3RGzZHR+ypWiCynt1Fiuzkt0eWPpnue0up4gU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EDQkU88+MXbgqItDJio8FXtAB9WjSfmWXtyF4uT9ycnDx+6DuKgueG016+hXOVGxsqEhLq1Cc/QwrzB3pHWOue1PgdZC9T7LjzuDM/QqvBSFjJaf3qfCamrqK6xLRy4A4jtsexkjfC2DFYvdY8gxM22obAMLBVD6IJhtVbrp0wY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J6AYBzs7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J6AYBzs7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CD741F000E9;
	Tue, 21 Jul 2026 21:06:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784667977;
	bh=fKoc8j9MA+jTq+SzBpHfBmN0AT2BX6+gawQqnM+hEjs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J6AYBzs7Z/rfUlC2PWy794ceOBU1fcQZZRjlXEoJCdui2ISwk51SMhHdTAuk1cR4J
	 iZjERYDpzewn7K5t6g7n53uIIl637jzUHg/3/86rfFKG2XFD8+DhRyC1Tu3gvdcvTp
	 u4+u1Ea/eXeWjJoSvZrKRbacsL1qqOWDgSCg4+HM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Biju Das <biju.das.jz@bp.renesas.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Danilo Krummrich <dakr@kernel.org>
Subject: [PATCH 6.6 1265/1266] driver core: Fix missing jiffies conversion in deferred_probe_extend_timeout()
Date: Tue, 21 Jul 2026 17:28:22 +0200
Message-ID: <20260721152510.133405720@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

From: Danilo Krummrich <dakr@kernel.org>

commit f9e6da99fe49277979798a1c3b9790ae10aaa18a upstream.

mod_delayed_work() takes jiffies, not seconds. Thus, restore the dropped
conversion.

While at it, fix incorrect indentation.

Fixes: 1137838865bf ("driver core: Use mod_delayed_work to prevent lost deferred probe work")
Tested-by: Biju Das <biju.das.jz@bp.renesas.com>
Tested-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Link: https://patch.msgid.link/20260525012340.3860581-1-dakr@kernel.org
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/base/dd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -327,7 +327,7 @@ void deferred_probe_extend_timeout(void)
 	 * start a new one.
 	 */
 	if (mod_delayed_work(system_wq, &deferred_probe_timeout_work,
-						 driver_deferred_probe_timeout))
+			     secs_to_jiffies(driver_deferred_probe_timeout)))
 		pr_debug("Extended deferred probe timeout by %d secs\n",
 					driver_deferred_probe_timeout);
 }


