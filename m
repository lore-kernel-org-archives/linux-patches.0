Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3107733F59A;
	Sat, 12 Sep 2026 12:09:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789214980; cv=none; b=WycpCUiaIdCxXfxmtusirUp7bO+V7DfMxCifQT4A6OBWs/pNN0sL4yY6sVCw5nDvVv/ymoqtjW78vMLWQxBFJP9JtQ1XNv69e9Ej1EPze4T4TxHY4DX2iSb892IuIg4OI7J2s83OxvNfUAV1DQv6OxScn+2TZmuvEJCAe3SCH5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789214980; c=relaxed/simple;
	bh=XnFYBVbBGT7Al+EHk5gyYPkiAnycny9im2N6mRb0NLI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sx8c5MrqDH6rc7Qopz2sq3M9oOAwkBr0UZPX1/LjqGPIVo5F6x65JRviNmuE9TN4YPuJV5q85PE+kaURzD5M+tdBhAL2+2x4TWV3JBdpzx9btS1enD/xtN8a1hI8nvLEayarDJdw6WhU2pIoh1AdTLlq2+PcCwZ0rY2K18qQcc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B6LcNrbq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B6LcNrbq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D91D1F000FF;
	Sat, 12 Sep 2026 12:09:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789214977;
	bh=USUlxBMBvxo8apHQ3TzU8gwTTlj5U5ZCC0UdJh0EwLg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=B6LcNrbqqCTw07td2ZtwhGq/179aOxrtS/uUND0aqqUyPTdc7VBUMVkF5VrYOfabc
	 3CpIaki1KtPCCDuSRSTgdejZ4zT9AyxL6Gys5tJA3mmWcbf3DGx8TiOlmwE90BZxlT
	 LH1iD3rnI6DUvkScHcxrqVRJEwbOqLsxBpDBJG1w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuho Choi <dbgh9129@gmail.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0438/1376] clocksource: Unregister subsystem on device registration failure
Date: Sat, 12 Sep 2026 08:47:44 +0200
Message-ID: <20260912065617.295656568@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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
index df386912f9613..e69c349a2fef9 100644
--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -1510,8 +1510,12 @@ static int __init init_clocksource_sysfs(void)
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



