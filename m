Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DDBB3CAE7F;
	Tue, 21 Jul 2026 22:44:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784673878; cv=none; b=M1jRH5KGnFWXMsTBuGR+s0Vfb1hzUPt+fTKndmjs/fQa+SmeIUvTI1yOEDIrisFtSxl140wNbGUu9RqF40WUwPE8IFi8NBo2BNzJ3y3Wj8R18ptYDYrz3pWwhOmBHVYKfe14NLU9ksu6Nuj7pZXh4VsucPaimR6jq04yhr8jerE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784673878; c=relaxed/simple;
	bh=vzzjR+5duJeWEmGTRosy7yJb1wHtGHx8RMzu8G6g84Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q+Evv+gErzi5dRCLra1JPceAk9TaO7GveNo3HIxVLfgGo9EcJZaXYa3ZsThMFQTfFw4sYpjYs8FLBjU2+oLZ5TS4UFoML0bzZlVrCV7G/FNq9xxC4MXjHIXGK6UQ3CtcWsNmcTr13Jew5WE3gpSCzBvlRkHO8a2l1+ZlMSllkJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XrsO9plJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XrsO9plJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E6AA1F000E9;
	Tue, 21 Jul 2026 22:44:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784673877;
	bh=KgRs9KoKksKmbsHDzdobohA2hrE1Q6HZbAlMy654nVY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XrsO9plJUhkFGgij4EdnrxbgAme65N3iAuKcJe9EfY1Zgx4k4cry0bkstnNYlWkKY
	 SDcuKx7uyIpTlT5FCh+2kJYLjtdLYf5mqniprwQPnGPPhFVJVfM5zzoxZ/to1ov+7g
	 gHzb8bqKj11WbCvX7nZrd5d1qInl2R9CFuLPZdME=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zygmunt Krynicki <me@zygoon.pl>,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 330/699] apparmor: put secmark label after secid lookup
Date: Tue, 21 Jul 2026 17:21:29 +0200
Message-ID: <20260721152403.136355384@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index fbbfedd253f69b..1ca5702d3facce 100644
--- a/security/apparmor/net.c
+++ b/security/apparmor/net.c
@@ -208,6 +208,7 @@ static int apparmor_secmark_init(struct aa_secmark *secmark)
 		return PTR_ERR(label);
 
 	secmark->secid = label->secid;
+	aa_put_label(label);
 
 	return 0;
 }
-- 
2.53.0



