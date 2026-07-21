Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92F67388890;
	Tue, 21 Jul 2026 18:09:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657373; cv=none; b=kWp/2S1C417hrHfORdARgimQODxTCDWyMiyNvp66BifejLQJisUfRpqYmyopFCGy+hwbzs2/ugMtaQTcM+yFrYTf7GH8wp1Zfcb+HwoHRhBB5Goqecw4MSgJeUKrxPtKP/M+57joJ2kvXd0XuXnsmBjOeryAVpeeIVhGBey9Mp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657373; c=relaxed/simple;
	bh=kzA47Ba7nSRLOcQ/AUAbaZ+TU2I8D2M7DORA8ivhgvA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EoetTV+9cYP0tMUmr5l2aFqK5KUPVZrRk910b9Psc8SogO72oI/NwLlbDZH+W8a/ofoEu2gh+pAuh/1JGndw1zBfncid7S4UvAOS8WLBwMk5uyKyv8Rr6ZWhjjezdlCIMezSFeDn/UaNDtNcmv84WuWHZpjtJsDxRb6JauZmZZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U+dKYH/X; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U+dKYH/X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3D921F000E9;
	Tue, 21 Jul 2026 18:09:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657372;
	bh=y203DRpsgunOvnRdyOgNDY8Pf8zo7WUkCgpNXmHrE1w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U+dKYH/Xp3y8HBwHquVxhmcVWUasdZUKcTCm3+7YRpEwQJpIv05j8FKO/4A5zWaEH
	 ows9fcsLjO+QUawOIytEZhqU1XoLTZHsrweX4SOdrTOzozE+yjdKJj8YR6+h8b1Js2
	 VMNhQ6cM0gQekQnHyjvijSZtwLb93w8FdqLXXn8U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zygmunt Krynicki <me@zygoon.pl>,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0738/1611] apparmor: aa_label_alloc use aa_label_free on alloc failure
Date: Tue, 21 Jul 2026 17:14:14 +0200
Message-ID: <20260721152531.977740354@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 3bec1e33815e2f..d382ac772ca1da 100644
--- a/security/apparmor/label.c
+++ b/security/apparmor/label.c
@@ -458,7 +458,7 @@ struct aa_label *aa_label_alloc(int size, struct aa_proxy *proxy, gfp_t gfp)
 	return new;
 
 fail:
-	kfree(new);
+	aa_label_free(new);
 
 	return NULL;
 }
-- 
2.53.0



