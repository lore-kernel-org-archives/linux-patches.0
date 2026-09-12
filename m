Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D4E632FA30;
	Sat, 12 Sep 2026 16:07:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789229249; cv=none; b=qS/DgNUmAF1QRqYTi3yn0RPrTXQd+b6KSeLnCfhY6OVzm/f6JDJywiNjPckWZGTUrMlPWkWz2lb5zFgGrYQ8FyM3W35Ef4gOMBKPBZ3FS6KmVd1M4fyL6CjnyKaFdnr3V34pfw1+U13XboEEnkDHb3ZHy1qJBPe3VgNKze6d9zg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789229249; c=relaxed/simple;
	bh=m8xZ1F+WOncrxebvcYeeBV30oNGf8aGWk9luuU6+tNc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ocdTAcY4TjxxPhC9xHQATeOEiB2MygylRIo755jFxjfvIwE1gWFTuyCTn/KKmsludNxEgrEomhg5cHLIJjRuPt49Pnx+1RR7CJAlvLMjgH8vbF6ti0Z6m4mjXHVesoVjbR2uyzzB1M4TYsmDvvhS5gLrI5ulX3N60z0TXLxTYfI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xa6l9C8Q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xa6l9C8Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E86A21F000FF;
	Sat, 12 Sep 2026 16:07:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789229245;
	bh=2k9xyXsL51oEmMN9/tpgppFwoFxnmfCvJqwJBM2KpcU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Xa6l9C8QCE730Ge46YxtvvYvqVCA18rYuFQejdWP1aZRXywLQEY7JIhN1T4bNM5Nz
	 8I3hRf/q5ws0JP3L6jIjM4PwHla4sJs6h6B9cF4RicpPeaE/1wBe9etDlx2EDgW6Os
	 EfYD8e6O9RlNs9OqHO9PQkXuiUPfdaVYmADT/I3s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuho Choi <dbgh9129@gmail.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0549/1191] clocksource: Unregister subsystem on device registration failure
Date: Sat, 12 Sep 2026 08:54:37 +0200
Message-ID: <20260912065600.574485940@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index e89fd0bbc3b35..847df85e5ecda 100644
--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -1471,8 +1471,12 @@ static int __init init_clocksource_sysfs(void)
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



