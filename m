Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC28344AB8D;
	Tue, 21 Jul 2026 21:30:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784669452; cv=none; b=u/oP+KSQhXc3sjfw0g5WtgLZ70m51DxOZm2Y3dZcRzTlnRxMx/nc5asuO1SUbg6uy77oOYiYTbfAIQ3Bo/9V3S+K/5HS1JPCBlm1E+ddhq8CdoFyqb5xtbfFOa6MpG+OGgtJczCK4qnA2GD9BeG61Q/+HUdL4m9alewXMW45dKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784669452; c=relaxed/simple;
	bh=DvAOtcphiZ9qN8U4wIMsQogTliTgOiJ3rfTsMYPfHcI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OUm+lWY0taiL0smbDTMWD7r/NrpxfHUKUS0Q7zWD7EXyzlr1zvEXt5Wg6bofwkuNtzHgQszM7XiIKWzGIufi6b7VIZB11Upp6EQjfD1igvXtm5Hl34odjVqgsMiLrBeEjc7vJ8XlRoEXBBQWwFNMHmePlLnAP3NAug7tjsI232E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PuKvIKc+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PuKvIKc+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4ABF81F000E9;
	Tue, 21 Jul 2026 21:30:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784669451;
	bh=y6OExukkeeou15iUQ3p4NXJGA8bbmHC5r4rTWqShER0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PuKvIKc+tv4cO1WQUWESNU56Ap0kEoIVZaEqZvNbYgVm4u+EElDEVTwceH4hCwAeP
	 ZykJoakhA5E/MGBMysifcKANmRZ2fe8BivJsPfIGzpI1N2udJT2CBv/uIM8uEvkh+Q
	 qrS4trs3g7ZQsinfiODVl04+wsdojtEgNGrHqiYw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zygmunt Krynicki <me@zygoon.pl>,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0558/1067] apparmor: put secmark label after secid lookup
Date: Tue, 21 Jul 2026 17:19:19 +0200
Message-ID: <20260721152437.089482768@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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
index a7fe1167e0cd29..308c9656bfd73a 100644
--- a/security/apparmor/net.c
+++ b/security/apparmor/net.c
@@ -210,6 +210,7 @@ static int apparmor_secmark_init(struct aa_secmark *secmark)
 		return PTR_ERR(label);
 
 	secmark->secid = label->secid;
+	aa_put_label(label);
 
 	return 0;
 }
-- 
2.53.0



