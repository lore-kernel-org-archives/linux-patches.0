Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019842;
	b=lgIDRj7Rm9IX4c1vmxrh8ZO7FrdZ/9qrdbFd4AfMzrRjcC2UuN66WxItOELOOXXlwuBQ
	 2kkbjmxskpVrnpaaOrPR7mTU6IVgJgop5xnA1gggUOcBbgwaREUjpPdgvqhnUwYvLUXEA
	 LJL23Pp8jhmOpfND72hMqW4d0uCl9bJbZTD+uuOxKuIcwZ0HQfUfzmNva7emnlndFjqhY
	 U/KPEnILXXacnCLLHrMLqfyO0I1+xSVwlgP1aj66C6d4zp4JOXrEKhmlXTpsKb5OxYkXT
	 xTtk7PTdI/LtBXaBEDOzeq1zBCpNB33f6sVZ1CzUpAjC1XJ5pkqGmXJcAds529ImY7g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019842;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=E87GI17vsz69vgv2NGpsHRkiJhDHRMmMuG/FG8ynI6w=;
	b=aQGiMJ6K1U6kXIYRQCuzoFBjiqd/U+8WvRy5WekSCJ+L+NYJ9rGftr4fAjRRHH7DoxvD
	 HtqXmRJU9rE5HHTeqTOJWookJO8Wxi2gIyiC4SlUYSy/Lg4kSTF9/JrTZNYmBNhVaReQK
	 g9s43Xnq9B1S3qOcTGrUUzvZAeP5/WZz/lCrbBlhjmmNzZ/zj1dibDHWObiQOD6+zSK3X
	 U4B2FQZOluYGITS12Jsh0OlJ1EKSKobUKuVInMLVKgA2/svcgTE/4cTiP6NGQiXNCYate
	 XJbgOSjVbDL76VDwqVlRB+8Uh2RELtpVCik5UXp1vAcoRDtOqugLL6UGQDsxRI/ZLtQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sHHUbtiZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA0E0606A330;
	Wed, 18 Nov 2026 16:37:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sHHUbtiZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2B5F1F000C4;
	Wed, 18 Nov 2026 16:37:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019842;
	bh=E87GI17vsz69vgv2NGpsHRkiJhDHRMmMuG/FG8ynI6w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sHHUbtiZ9ciD9iH9RRIcmy8uprPfhTBlQ0Ya6gg+HnaxI0JJha7I4AiWovsi3bMvf
	 6mPHTxh4lHSA+1VKZCZIfWohohdKj/ZQHdzKScyvIa1w/gNZTMD5PPW02rKUm5yZlO
	 bh6UDFAn6L422f2Wor88CnkCkxQIrkPRDL/+zbU8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Conor Dooley <mail@conchuod.ie>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1739/2651] soc: mpfs: use kref cleanup on probe failure
Date: Wed, 18 Nov 2026 15:49:39 +0100
Message-ID: <20261118150350.180169305@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guangshuo Li <lgs201920130244@gmail.com>

[ Upstream commit 6f77194e1147d85c10b4964edee7091c701a25c2 ]

After kref_init(), the device_get_match_data() failure path frees the
mailbox channel and sys_controller directly, bypassing the matching
kref_put() for the initial reference.

Use mpfs_sys_controller_put() on this path so that the initial
reference established by kref_init() is released through the existing
kref release callback.

Rename the error label to reflect that cleanup is now performed
through the kref helper.

This issue was found by manual code inspection.

Fixes: 75ef23397558 ("soc: microchip: mpfs-sys-controller: fix resource leak on probe error")
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Signed-off-by: Conor Dooley <mail@conchuod.ie>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/microchip/mpfs-sys-controller.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/soc/microchip/mpfs-sys-controller.c b/drivers/soc/microchip/mpfs-sys-controller.c
index 0400a01b2338d..ef27e1083f0f7 100644
--- a/drivers/soc/microchip/mpfs-sys-controller.c
+++ b/drivers/soc/microchip/mpfs-sys-controller.c
@@ -159,7 +159,7 @@ static int mpfs_sys_controller_probe(struct platform_device *pdev)
 	of_data = (struct mpfs_syscon_config *) device_get_match_data(dev);
 	if (!of_data) {
 		ret = dev_err_probe(dev, -EINVAL, "Error getting match data\n");
-		goto out_free_channel;
+		goto out_put;
 	}
 
 	for (i = 0; i < of_data->nb_subdevs; i++) {
@@ -173,8 +173,9 @@ static int mpfs_sys_controller_probe(struct platform_device *pdev)
 
 	return 0;
 
-out_free_channel:
-	mbox_free_channel(sys_controller->chan);
+out_put:
+	mpfs_sys_controller_put(sys_controller);
+	return ret;
 out_free:
 	kfree(sys_controller);
 	return ret;
-- 
2.53.0



