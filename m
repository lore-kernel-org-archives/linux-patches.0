Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5DB225DD00;
	Tue, 11 Mar 2025 15:04:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741705496; cv=none; b=ZQGefraMwzbi385p29EgG27ISqqxnAEXcphCZb1uZTpfwykN0khiWMh1OLO3at4iqNx7ZSo7lnF9eDzOGfWIyT47m9BCTyesNkvVsb3aLN3swWEa5mNSOPF4sljjJWGL4pQEb/3UDjwKa8XC0tT6+OI7z9jQPcoDKvn0k/mkCbk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741705496; c=relaxed/simple;
	bh=/c/N3wVi6o07S7ECS/KCn57g5EwjFzEB1Nb9vBULMtE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ryw8/UiKT7zIGfxTySbxAwjn6Fgwki9mmdVRKMLz/zJ6tMku5BZzUkNWtdANb2qcXKGP6ENZx9sf0dSuIzlon1Tj952wy0FKFtAgtOqJVAe2JmG1HefuLX9sR3kUDlEvkXHXqOv38hp3JI3eAs6ctdhRtnwyWVSnl8PAfo41k38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yQ4IVJ8Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yQ4IVJ8Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0957AC4CEE9;
	Tue, 11 Mar 2025 15:04:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741705495;
	bh=/c/N3wVi6o07S7ECS/KCn57g5EwjFzEB1Nb9vBULMtE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yQ4IVJ8QSYbgfLDzQ9RjNpBbAhFwiRtr4AJ22vJf+PG2Zwuiy3hkP5Dmf3mjdg7uL
	 B5GSadeVhwiXw/d10w8xsEDiCeF4+JD0L4gUBDqO1g5K0tU0I+3A1lUXO4yUZxEeG8
	 HaXaQMFp9Id/OnjzCLfdLQWAPYGk9+TeFzEmhRMw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 038/328] padata: fix sysfs store callback check
Date: Tue, 11 Mar 2025 15:56:48 +0100
Message-ID: <20250311145716.408816969@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145714.865727435@linuxfoundation.org>
References: <20250311145714.865727435@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Weißschuh <linux@weissschuh.net>

[ Upstream commit 9ff6e943bce67d125781fe4780a5d6f072dc44c0 ]

padata_sysfs_store() was copied from padata_sysfs_show() but this check
was not adapted. Today there is no attribute which can fail this
check, but if there is one it may as well be correct.

Fixes: 5e017dc3f8bc ("padata: Added sysfs primitives to padata subsystem")
Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/padata.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/padata.c b/kernel/padata.c
index a544da60014c0..47aebcda65d5d 100644
--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -940,7 +940,7 @@ static ssize_t padata_sysfs_store(struct kobject *kobj, struct attribute *attr,
 
 	pinst = kobj2pinst(kobj);
 	pentry = attr2pentry(attr);
-	if (pentry->show)
+	if (pentry->store)
 		ret = pentry->store(pinst, attr, buf, count);
 
 	return ret;
-- 
2.39.5



