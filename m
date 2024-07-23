Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50C3015821E;
	Tue, 23 Jul 2024 18:39:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721759958; cv=none; b=SkXZ4/hGnO9sFFyFL/wV0IukJfK8iyMUysNES6vSoY2eRK8eaZ9l37vzauTjxasziewDM71It8FInU8srH09OPkOAiWIM3BD9g931BicmsdZCFFEZ3fo4rUhzdm+ITJ59LUBMfOSz60dK2afm5yjYE364NXA0Tj0N/kDZhkGkbU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721759958; c=relaxed/simple;
	bh=1Q7qtXJcivNIlqW5z10uGWViFqeoZXd8hAlNNiyUnT4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MHBRySzNC5i9Zb63vNZGf00DIB5TiF1EOhHU72B8fAnGHqbdeNS2G9d6gGQtW4xX7jh36WYB9NEJLtjBHhZB42DOcfQhaEOl9gmn71VEejBuh8Wi6mxC0RrxUkXyUgkMe8BSRivJV2hsetvwwFuw/gdlEO0xlUx0MGW35j+z+5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hISyNH2t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hISyNH2t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9F40C4AF09;
	Tue, 23 Jul 2024 18:39:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721759958;
	bh=1Q7qtXJcivNIlqW5z10uGWViFqeoZXd8hAlNNiyUnT4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hISyNH2t7NA/soNarJXane2fhB4Mf8bK0kVcQGG2CfJO1WxO0AxvwlkJ4c8QaS2hV
	 QGo/QsmvpdqEq/kq01REHsBWkLq3fW0qjqopWSM5C2CUiVxXvRK/PvZvSgmM/d+gq2
	 vkuYDSlSY9QburnVW4lgSJundH8Bhnxs7+4gQ/Qw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Usyskin <alexander.usyskin@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 055/163] mei: demote client disconnect warning on suspend to debug
Date: Tue, 23 Jul 2024 20:23:04 +0200
Message-ID: <20240723180145.602062055@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240723180143.461739294@linuxfoundation.org>
References: <20240723180143.461739294@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Usyskin <alexander.usyskin@intel.com>

[ Upstream commit 1db5322b7e6b58e1b304ce69a50e9dca798ca95b ]

Change level for the "not connected" client message in the write
callback from error to debug.

The MEI driver currently disconnects all clients upon system suspend.
This behavior is by design and user-space applications with
open connections before the suspend are expected to handle errors upon
resume, by reopening their handles, reconnecting,
and retrying their operations.

However, the current driver implementation logs an error message every
time a write operation is attempted on a disconnected client.
Since this is a normal and expected flow after system resume
logging this as an error can be misleading.

Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Link: https://lore.kernel.org/r/20240530091415.725247-1-tomas.winkler@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/mei/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/misc/mei/main.c b/drivers/misc/mei/main.c
index 79e6f3c1341fe..40c3fe26f76df 100644
--- a/drivers/misc/mei/main.c
+++ b/drivers/misc/mei/main.c
@@ -329,7 +329,7 @@ static ssize_t mei_write(struct file *file, const char __user *ubuf,
 	}
 
 	if (!mei_cl_is_connected(cl)) {
-		cl_err(dev, cl, "is not connected");
+		cl_dbg(dev, cl, "is not connected");
 		rets = -ENODEV;
 		goto out;
 	}
-- 
2.43.0



