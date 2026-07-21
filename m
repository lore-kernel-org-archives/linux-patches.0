Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EAF23B2FC0;
	Tue, 21 Jul 2026 20:41:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784666489; cv=none; b=aRi9DyaXvZrJ1NmmAlckYR5sR/E8yJyGts2jR4Y/jkAAS/FDx3UVKnxDQouUhld09vvtvulK21hejkrCWp/BbwP2tdzy+hL9qcQe+tCxo5TRmWBXbmadSyfDL0yC5JylmuVGYEhJpst6m4idnU+8Gh4OmNpxIDRe0BBxCzQqOIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784666489; c=relaxed/simple;
	bh=+xcpbgOx55kx16xYTA5F20Bpdd8EksSZBQU8QenIhpg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RjBBYkMyS3khrqKQOzjNJVJMjR8HpLMas19HkeAg7ThHMEV0M05EH+TACV1XPlWm3c8SHBEPlWWfKaLW07YPJOIwWZhC4yFIgAbz0ydsQTyRMYBMD/YTBnUuxe3CMu3E/LaLx8D90z0UKqYpGO0TNvDaC8TcyEa6oCKoeEVgYh4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qIKsJ2ak; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qIKsJ2ak"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F9D01F000E9;
	Tue, 21 Jul 2026 20:41:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784666488;
	bh=QZnCBc1G3EYDWBjcDMg+DC4KF87tYXnalhh1juJmjDY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qIKsJ2ak8SktIJpTfkr6M9GJ7aUfEBym0AohSuKfSO5E0q6WSthcAUN+1j41rGADy
	 4J3xqkKOm8npoiEJN2hWCFnHSgrPMkbaNlw/t2/ghppnYXP7SBgsjm9OZLFoiQP3Cu
	 KJMiFczg2jrnZWLlFBvnsRR+z4aE+rN2l8Qb/ZnM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zygmunt Krynicki <me@zygoon.pl>,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0703/1266] apparmor: put secmark label after secid lookup
Date: Tue, 21 Jul 2026 17:19:00 +0200
Message-ID: <20260721152457.591441583@linuxfoundation.org>
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

[ Upstream commit 340372688bb87da45ff8d4e2f82ccfd1b64c65ff ]

apparmor_secmark_init() parses a configured secmark label to obtain its
secid.  aa_label_strn_parse() returns a refcounted label, but the success
path kept that reference after copying the secid.

Fixes: ab9f2115081a ("apparmor: Allow filtering based on secmark policy")
Signed-off-by: Zygmunt Krynicki <me@zygoon.pl>
Signed-off-by: John Johansen <john.johansen@canonical.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/apparmor/net.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/security/apparmor/net.c b/security/apparmor/net.c
index bcba4d2a7aa4d1..390947c9302082 100644
--- a/security/apparmor/net.c
+++ b/security/apparmor/net.c
@@ -217,6 +217,7 @@ static int apparmor_secmark_init(struct aa_secmark *secmark)
 		return PTR_ERR(label);
 
 	secmark->secid = label->secid;
+	aa_put_label(label);
 
 	return 0;
 }
-- 
2.53.0



