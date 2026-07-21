Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA0DE2EBB8D;
	Tue, 21 Jul 2026 20:41:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784666475; cv=none; b=nN68eXTa29FjoQ/QszY+Qivu3sG1uUJJQZpfFgKFYQZxResLMnM9Zzoj7IR+zt20nKJNzMfdAcxeF5dh0Jt1g4nqHhW1I50y2Dja4hakoApnI2Un3UWtnBsEQSskLs4qqCxCgmlSdzPsZ1VeQO2O+yxN5W+6tq8Z2EFzMKk6LGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784666475; c=relaxed/simple;
	bh=HSl7WJm4CltPqLIOOiQta+W4rN0JOvuOMW7ndOH7dsE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oN6q2IiyQJslX334to59iP1FJqhN4/yLswKWh+wPUnDKokYTT4gVtnr4e9Mkp4PC3zBPrLiDXTXuIPYLZO2LZdCvivYUR4MFIup91Qic2uKQjJcSIC4ZV92ZyO8e0y4tRgO6Jbyrrctv11tZ3Pzj/Gu+uaN3KSzWYoTZ4S54QDw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aTH0gK9e; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aTH0gK9e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B9711F00A3A;
	Tue, 21 Jul 2026 20:41:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784666474;
	bh=s35Ttn6kSJssw47lv3mGRT/c+VZfM69Xv7ASNerpdBA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aTH0gK9eeOCdRLgQfQXy2Lkl919l4B6YmoRW+INJIqZqEw8QZXnXRFyh/l27mq3nV
	 +FW6TX0uSlkAdjIzyoLbU7ffRai8OaQFmYqT5PF48u1skWpeA8XoCzWyEd1E2O5Zsf
	 jLfFJ03IMyuieSCKHUo1uar6aFZt6iTKjfFbvYrw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zygmunt Krynicki <me@zygoon.pl>,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0698/1266] apparmor: aa_label_alloc use aa_label_free on alloc failure
Date: Tue, 21 Jul 2026 17:18:55 +0200
Message-ID: <20260721152457.479007816@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

From: Zygmunt Krynicki <me@zygoon.pl>

[ Upstream commit 654fe7505dc6889724d4094fa64f89991afabfc3 ]

aa_label_alloc() allocates a secid before allocating or taking the label
proxy. If the later proxy step fails, the error path only freed the label
memory, leaking any resources initialized by aa_label_init().

Use aa_label_free() on the failure path so partially initialized labels
release their secid and other label resources before the backing memory is
freed.

Fixes: f1bd904175e81 ("apparmor: add the base fns() for domain labels")
Signed-off-by: Zygmunt Krynicki <me@zygoon.pl>
Signed-off-by: John Johansen <john.johansen@canonical.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/apparmor/label.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/security/apparmor/label.c b/security/apparmor/label.c
index 73428072a754f1..37282a3c68a720 100644
--- a/security/apparmor/label.c
+++ b/security/apparmor/label.c
@@ -452,7 +452,7 @@ struct aa_label *aa_label_alloc(int size, struct aa_proxy *proxy, gfp_t gfp)
 	return new;
 
 fail:
-	kfree(new);
+	aa_label_free(new);
 
 	return NULL;
 }
-- 
2.53.0



