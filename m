Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 149473FE375;
	Sat, 12 Sep 2026 09:50:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789206609; cv=none; b=NhpLTIrfUP9T5YHgo9cUus24bqSRiwR85K2UXkG1Ut3haU6ywvmssHRXG+3/kfQArYsdSJbJZVwdOVJ58sQH2py5yLEw/YpaVnEVz9hrQ3Ct7PDTb3IMfshRB+G9yqqzvTkPgT1CqiphbWy4JIOkjSz9pLb3x23vsCx456mHa14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789206609; c=relaxed/simple;
	bh=WFgK7RrSZuY0kCRRkJSY6RTxKwI42igfFWYOb64wLZo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cs1jrSEXMu41dvuCycSmTcHztisM+IlC4vcyTBNTbpwzv6AczJozwaqLslhN9pSR4EEzIXgxTvmaTziOtcR1cvu6kif3sxG/uODQMHJ/t3SrvEH+m4bEK7CmGl3r7gyC9a4Ls2Ws1m7Xrk/FmgW5qD6NTR4cRFou2IeR9enccmI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=riRQHO8y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="riRQHO8y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8938A1F000FF;
	Sat, 12 Sep 2026 09:50:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789206607;
	bh=0nKTW3Rd5tJ3xdHAUwRnwiFPWj8D1zix+ZSYfSg7c/g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=riRQHO8ydSb6uqOUTF71Ww+BWVsXeZFke+Ir93vJ/e8oEnlZzS+9IacZSxF4s54Qb
	 T7EgW06/iTp7MAzF3spCltGtLczojsxF5ZkLMW33iIglRHCVUQR3Rp+BsjoRq9ryHv
	 wiqBgBb3xrdXBY86/AwYxgb1WNfCJqWw5XGfa/fM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuho Choi <dbgh9129@gmail.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0243/1518] clocksource: Unregister subsystem on device registration failure
Date: Sat, 12 Sep 2026 08:40:12 +0200
Message-ID: <20260912065628.977945488@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

From: Yuho Choi <dbgh9129@gmail.com>

[ Upstream commit 3dee6537e728bd8137fda6eaf859f26e685943f7 ]

init_clocksource_sysfs() registers the clocksource subsystem before
registering the clocksource device. If device_register() fails, the
function returns the error while leaving the subsystem registered.

Unregister the clocksource subsystem on that failure path so the
successful subsystem registration is unwound before returning.

Fixes: d369a5d8fc70 ("clocksource: convert sysdev_class to a regular subsystem")
Signed-off-by: Yuho Choi <dbgh9129@gmail.com>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Link: https://patch.msgid.link/20260702215733.84588-1-dbgh9129@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/time/clocksource.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
index df71949616584..c2ce6cea24107 100644
--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -1482,8 +1482,12 @@ static int __init init_clocksource_sysfs(void)
 {
 	int error = subsys_system_register(&clocksource_subsys, NULL);
 
-	if (!error)
-		error = device_register(&device_clocksource);
+	if (error)
+		return error;
+
+	error = device_register(&device_clocksource);
+	if (error)
+		bus_unregister(&clocksource_subsys);
 
 	return error;
 }
-- 
2.53.0



