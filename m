Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03DEC3451C1;
	Sat, 12 Sep 2026 14:21:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789222872; cv=none; b=jv9U7Q/21h/084dInH7jmpVwEQ2iF4XcGgrI0AGM4ZBwL9LxouVei/huCC+oOSGNe/YbBxomm/14mqohWMzHlYat8IhRZrs1e+yHU96NEs3/khuy3ExHc3RX3qasnuRRbe/BK/sUoJNJ86r3X7jNpd4PdZQ1bqBgikZDifkxQO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789222872; c=relaxed/simple;
	bh=f5elkpDXjzBk+2DIAVdxOekWahtAjOolrMHhNwcVI9U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mB5HbOhtYTMBAW0V9WZt1S/c0pdg/1L7veoCaiRl8G62hewblNMsJGWgtfzY5ZH4fP9tmDX42x3pk0Ub4jePXy5j6StHilzF+WzP/jKfXCWqpzse8jWNGbD2uLLyOVS3y6V7hxGStSw8zAaFXS34r1fz5SBIGOW8JVhz7WSJ6fY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0fjsnLJn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0fjsnLJn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA1DC1F0089A;
	Sat, 12 Sep 2026 14:21:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789222870;
	bh=2ArQIq6xXOTgsEOyxUJw9nr8os2AD0W0PdlB9mljeDU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0fjsnLJntbVmWUJnm22m28B3yuaq++FKLXaups4WGlGekjsbjuIEbepWtGDbD6ToY
	 ohRqy8GD0hz5vl/pbq15ParbA9r05CajbG7eFceTjBDwuHEiJmNnAcVdIL0obgZvs0
	 sBTRT/9O5ww4ddiej1XXv/gMpt+Vj+Wz+nAiWkCk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuho Choi <dbgh9129@gmail.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0672/1424] clocksource: Unregister subsystem on device registration failure
Date: Sat, 12 Sep 2026 08:51:44 +0200
Message-ID: <20260912065622.345776019@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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
index 353829883e66d..7006f2d8eefe5 100644
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



