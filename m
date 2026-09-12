Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD7901EB5FD;
	Sat, 12 Sep 2026 07:23:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789197789; cv=none; b=NjWENNQ+CU63xyRoWDcqTF1xmFUl0d2eU92iIlR4dEqU1BBQPRa/+Q44vPznF+N9T1RG45os8fGAxGWhXXmgo5o2KVsvcCNwn/funSFG+5YhO3pzI4r+E6/4HIi7OQDVOyxU3oeHZNYTvrYMD4p4LCKIXaN+09iR1QaMpZebJrk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789197789; c=relaxed/simple;
	bh=2BcwmJrW+DUVdTvmgHZCsMXTC0/copNwgY3OW+2OKS0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E8ZALedrfzb8gz58/Li7dBGoYllBZzpU8SUVU11YuTrQ6YL3q+IqyYc/sdM12L7MIl5u0BAVaJT+zeoZPo6oLT3PJwe+kMuBnklnigd241sZQRfnSRL5EyuVQeMWD48av/dUAAeZT1KF/fx8JZToKn2oj6NRMadNGeACZBzQnqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wvBzugoX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wvBzugoX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64B691F000FF;
	Sat, 12 Sep 2026 07:23:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789197788;
	bh=xivZ1i16mxA0nzXVPYAKR4nUJEfM+RIAU7aajBHiWTI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wvBzugoXHeZQPPX1DUtUkgE0iysdTR6txBCFQjjCXEaL4KGahMh/81Mfyh6gzeq4H
	 WHjrdvCfdVTBqrtfzkuonhvVZ5mzqdOmM1EqYVMEa0FLRDSkBetxOWTsgJ9e9/qZ8v
	 3C7jt+MCMZrnl/YtHZZee+LLf0c6RPyG7V42rgkw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuho Choi <dbgh9129@gmail.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0247/1815] clocksource: Unregister subsystem on device registration failure
Date: Sat, 12 Sep 2026 08:33:17 +0200
Message-ID: <20260912065654.785114425@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index e48c4d379a7ce..5a786b3c778ce 100644
--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -1566,8 +1566,12 @@ static int __init init_clocksource_sysfs(void)
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



