Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6C3133A9FC;
	Tue, 21 Jul 2026 19:03:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660635; cv=none; b=fDG0142+fqXxENsBlaO8b3lWYnv64l2ePTH41EIIhjO2S3RqbanLmjJvL0+P4Z83tREjl+w4dcvOvp2wSCGLGklrjnBIHW1glR2qYk418iasYVV/439cLA86wa8nwLMRjTCffPtOgrMtIBSHrElrlGKIbwbguhBudZ2XNQvijqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660635; c=relaxed/simple;
	bh=Kp5oFkXyngkHSbyx8WDmbCfmO3Y5v5Q5E9vPNnqsP/s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bdCdZizCznyZnQuOlkNH7HQhUTfc0nE5P9mw55QQeoPkloIdkusZSe7pDSLqwZY6EiqvkukuE0YQ5EbmqI3NEFzPO/SWf14eHNIT9sWsBzJgjUZejLOVPSy6U5XIjTyn68h5TiXBKCN0LEbZZYfOHb1rBMSYquYbsZnwffkCRLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uanYUFH1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uanYUFH1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 182F31F00A3A;
	Tue, 21 Jul 2026 19:03:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660634;
	bh=eVBy3CDY8x97HVS4nyEcUAlY4EO3OpnD61X1wcmR5sc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uanYUFH1l64ZszhmRNCkDzCOCUVOJQ3MfNy/tQVLqMB/EN7B+XJyr37EPgt1DQUw0
	 LYoOCdyqAldGzw8e7ucTDdrsN+FjarjFhVjV0UIyvb+oFIGXkU3ALIFwrD1yn+JdU1
	 Sc/wr7/cF80WoQgFQmKDRKdscUhu3ITD+DNSndS4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zygmunt Krynicki <me@zygoon.pl>,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1052/2077] apparmor: put secmark label after secid lookup
Date: Tue, 21 Jul 2026 17:12:05 +0200
Message-ID: <20260721152617.629000379@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index 1fc6145ccbb8d4..cf590dd08540c8 100644
--- a/security/apparmor/net.c
+++ b/security/apparmor/net.c
@@ -356,6 +356,7 @@ static int apparmor_secmark_init(struct aa_secmark *secmark)
 		return PTR_ERR(label);
 
 	secmark->secid = label->secid;
+	aa_put_label(label);
 
 	return 0;
 }
-- 
2.53.0



