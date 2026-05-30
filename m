Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 063E41C5799;
	Sat, 30 May 2026 17:18:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780161503; cv=none; b=KFrxTbez0c6tf6Y+i9f4AZKPVPJrq3xO53YTA0KaAu0L4nUUtrQKL1XDmswo4hnoSIHH+oBmhWNZ0lZS7FStJWCGMYgG/IBM+/SM85BYKs1OxI14TXEL8WIriHIfYrN/1MhKTdiHyrkoyv6SBq9wwogm3vKlSxLY4T2HJg0D+VU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780161503; c=relaxed/simple;
	bh=6Ki/Z//N/42q9/+u9etZ5MbeTMKoeGuFWzGWNZms7C8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RUmvfmQ4Efx5mk0SnSjsxr5Czj3lBNh4y37GVAsMrkuPPd0DayZ/WLSySbuT1zNOjXgpgHf7jBp9KT+roYnyJ5DVaHIGZA/CbRufF9LJmrRBAZk2gbfXhq1BrtskEBZ0JzzH5rs2+XvWXAAbZMdkBVWiNls2Ilk0iKrDvM2Co4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lBmyhcc7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lBmyhcc7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A4C31F00893;
	Sat, 30 May 2026 17:18:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780161501;
	bh=weTOyuh5QLWyvRQEiTN5oq4SLKlMqMDxbM0LOl/5xDw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lBmyhcc7jQuPvUAzAiNSUmAS6c8bam4vs3aNsRWbgU25xAz4DZC5AwQh4zpsfKxqT
	 iQybR56WT/HzFNk9OhXFkHDR3oVw69xcyMHH2TbIzMsc7NyHPhq2dxS8xXFtxd2E8y
	 oUkMqTJ+lv+usoVUhNC+/QTUjH6+lay6eKG1J8gU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 643/969] mfd: mc13xxx-core: Fix memory leak in mc13xxx_add_subdevice_pdata()
Date: Sat, 30 May 2026 18:02:47 +0200
Message-ID: <20260530160318.214491432@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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
index 1000572761a84..ddc90cbb7be52 100644
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



