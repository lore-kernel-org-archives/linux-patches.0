Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9648B46D549;
	Tue, 21 Jul 2026 19:38:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662709; cv=none; b=h7hjKase4dd0A2mP2/6S9JD6/Ip7LnPJhKHkrRyOJsLu0n694lfbmtirDPXJOwpxVKMkyj+g3SHsi8I++D5yqHoflOv6UqJVGMxlkEyWnsjrnVAnJC6/AKiu6RTHoPuqKIp0l89TBnnZQwfc5irZztTW3C++L5gge3P4hI+CmUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662709; c=relaxed/simple;
	bh=Ya7h57cd21eCDpDxkYdzA9zeVHcnE0GvliwybgHt2YA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LV0gKrqbPjZi05KpCnKFKWEIMis2fSdE2dbQLtCPMYfB4+ZEKiwGEGAyMM49+2bkgDF/UwbIe8h5WcCRdOKMEBsMoFaLqLO2D1oNrege/FNpY8G6aZssZ2jBkQJxMqL0/7XSwpmV9QIjiIu4Wph3F8wfT3DpvY2h5CKIPe0ZBTo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g5V5NTEx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g5V5NTEx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 809DD1F00A3A;
	Tue, 21 Jul 2026 19:38:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662703;
	bh=muueKJFwisZfphM7IPThQJCzgsetw0GIri5Orao95HM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g5V5NTExTRSmlljaue0yFzdPuvcPtPvSr5DN1f7PoYgA5+1atTdNHf1AreoQVGFUS
	 bZfQ5h29gkwL96yffUFvqbO8pbp0uUk1GwovEOFK0kK6+venGiFK/J07kE6W+rKVUy
	 ZtUGe+SZr0xgMwFGzg124430yf7fj0sMYmHlNSPY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zygmunt Krynicki <me@zygoon.pl>,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0544/1276] apparmor: put secmark label after secid lookup
Date: Tue, 21 Jul 2026 17:16:27 +0200
Message-ID: <20260721152458.294175466@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index b6df6ff6bd9c1a..6e989184e40863 100644
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



