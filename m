Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5245F3C1D43;
	Sat, 12 Sep 2026 07:13:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789197234; cv=none; b=blU8PGL34I5/ax4vS8j5wihuOCBxO8MRCyHhbb7Z6o/Z5tS1Fy8f9gt2yrajH1FYLMXM6Wy2x2kvY75HLZgIHVNNPmhwwsOGMjwTuIf0dlA2iA51yNc4fnkevFPqi/o7lRzvZ+lvZZGIcaZTUbCVIbuWxrHcYVULEGgz91w9AP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789197234; c=relaxed/simple;
	bh=As2W4EWfoFP8fOwqSslc+TuQiv6K7luELSaRbH/tFQs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eTpX3m0Ev2mp4waHeEZq0X6cg1zzl66V7ntPFL2DyX8PdDdk5EtGk6Zc6i7lvorja+pGuZhtbSJtH2bjOVOUYyptg9rA4ISKk7qMDDnZZ+TkNAmmbe72iFHTqOPuBDMZp1YJ6aPzsVmICZEInWJwsGoVByP38aDXW0c4RSpBpco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P1KnPc8r; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P1KnPc8r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 958921F000FF;
	Sat, 12 Sep 2026 07:13:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789197233;
	bh=RvLkFWZoYgO7jbV5wCAbNNpUrkspfmYjSFH7VElcc2I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P1KnPc8rXHnohsSmulghg0epY111ghNwV8xEadtbXJFgF/g0+YASNDFMhN1FKpit8
	 pMLwaQSTAQv2/KhNuqIuOVlcUTrSCuqYbDug1BeNnRJvmawnh3Ul9PKX1OhC56kE/m
	 l32Xp4e3HUh3Dm1bqFA3nWhAZXWAGySqATzV7WaE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Jun <lijun01@kylinos.cn>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0093/1815] firmware: imx: sm-misc: Add NULL check for kmalloc in syslog_show
Date: Sat, 12 Sep 2026 08:30:43 +0200
Message-ID: <20260912065651.191389450@linuxfoundation.org>
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

From: Li Jun <lijun01@kylinos.cn>

[ Upstream commit 4cf26bc2e7e099c86127d63ed7272753da45737e ]

Add a proper NULL check for the kmalloc() return value in syslog_show().
If memory allocation fails, syslog would be NULL and passing it to
misc_syslog() could lead to a NULL pointer dereference.

Fixes: 80a4062e8821 ("firmware: imx: sm-misc: Dump syslog info")
Signed-off-by: Li Jun <lijun01@kylinos.cn>
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/imx/sm-misc.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/firmware/imx/sm-misc.c b/drivers/firmware/imx/sm-misc.c
index ac9af824c2d40..fb8d7bdb5b084 100644
--- a/drivers/firmware/imx/sm-misc.c
+++ b/drivers/firmware/imx/sm-misc.c
@@ -79,6 +79,9 @@ static int syslog_show(struct seq_file *file, void *priv)
 	u16 size = SZ_4K / 4;
 	int ret;
 
+	if (!syslog)
+		return -ENOMEM;
+
 	if (!ph)
 		return -ENODEV;
 
-- 
2.53.0



