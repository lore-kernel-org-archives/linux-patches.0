Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06497340A6F;
	Sat, 30 May 2026 18:07:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780164447; cv=none; b=eTpKeO5hQ42hRNZR2qBHvfKFCp3BYRCsl7k/eHG1EA/ZXoz6X1hmVwy/XNsWrYsvUki7P6p3xXCD0wa1kG0J/UC3PqHng/FpoxvM10CecsIT71uiQVT69r2V7I+69KMz6lYGQCuOW2pXs1EdzEG1NhnKz36gTexOsTe81lelUjg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780164447; c=relaxed/simple;
	bh=Q+83Cn62JP5DddR+Ska6ER1YXq7blono8DCruffo/oo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pqi093bv59/xSE1PgMVbT3aFNmD30nubfRsSy01HGin3qr0fd1Mxo5kZi+8KgVPpIZfeIqa8q+gIHLuCmlM9weK54OU/Wt4/v4b4ZWkxGBh1O/yqibgQiyTzwly2jCj5ARUW6OO/88lg9ysVneTDCvOAKgz3E0xaUJaCA4buZV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e4ls5Qc3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e4ls5Qc3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 076C11F00893;
	Sat, 30 May 2026 18:07:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780164446;
	bh=Emhk/zOnfPIn/siBYwvX6NGZParveabnXpiZVrH8Puw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e4ls5Qc3BKBbJL9rUyRhHxAaS9kIBxUBJNdJPpqDKHA7wdURmnXv1kGtjgFqhkpDG
	 KwiL3y/xPqN/iWptdcrr3wRn+OkRtpGvgL0ioSdEckiqjTfUe/2IFGaXiuA9SMZrXd
	 weXom9WgdwdlzpRzdJsG+zozJbnKjJzdNcoXd0BA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 529/776] mfd: mc13xxx-core: Fix memory leak in mc13xxx_add_subdevice_pdata()
Date: Sat, 30 May 2026 18:04:03 +0200
Message-ID: <20260530160253.882829531@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abdun Nihaal <nihaal@cse.iitm.ac.in>

[ Upstream commit a5a65a7fb2f7796bbe492cd6be59c92cb64377d1 ]

The memory allocated for cell.name using kmemdup() is not freed when
mfd_add_devices() fails. Fix that by using devm_kmemdup().

Fixes: 8e00593557c3 ("mfd: Add mc13892 support to mc13xxx")
Signed-off-by: Abdun Nihaal <nihaal@cse.iitm.ac.in>
Link: https://patch.msgid.link/20260120102622.66921-1-nihaal@cse.iitm.ac.in
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/mc13xxx-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/mc13xxx-core.c b/drivers/mfd/mc13xxx-core.c
index e281a9202f110..a2b016a9eeae6 100644
--- a/drivers/mfd/mc13xxx-core.c
+++ b/drivers/mfd/mc13xxx-core.c
@@ -377,7 +377,7 @@ static int mc13xxx_add_subdevice_pdata(struct mc13xxx *mc13xxx,
 	if (snprintf(buf, sizeof(buf), format, name) > sizeof(buf))
 		return -E2BIG;
 
-	cell.name = kmemdup(buf, strlen(buf) + 1, GFP_KERNEL);
+	cell.name = devm_kmemdup(mc13xxx->dev, buf, strlen(buf) + 1, GFP_KERNEL);
 	if (!cell.name)
 		return -ENOMEM;
 
-- 
2.53.0



