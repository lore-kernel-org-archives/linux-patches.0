Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 431353C1400;
	Tue, 21 Jul 2026 22:44:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784673876; cv=none; b=MYH7X2pEjB85L63T6V29QJMsPzIchcy2Mlho4/xKYakSMFg3pBrkEtABVyNDo7rLFIIxP9J5zDwf+bqoX+wubnKIhb74nBVnfyVYNVNnjopVLrCnEoC0S0uPj1EmmX0UllIeFBuPcp7S0u0DlvwHmT79h3ygD4YNBJF8DpekbEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784673876; c=relaxed/simple;
	bh=mE+9wBJmLcSiyYonS61univylgALXdxPmMjO1eneVu4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bMNAy/GklOwG7dw+MTfM47C96ufpQAy3g17e5+u3eLQm4d1985knQ8XeshXjl8Ka8kSs94X9JA/GNKMaAaoDExPGpKwRhmI2uC/1elfB+6ca4w7U61kM8aTz/VPHAePOUr1AUhMVCIvu++UvVpU9+C8liEC+5xqw457a9pvhn78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EvnxQ230; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EvnxQ230"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 630751F000E9;
	Tue, 21 Jul 2026 22:44:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784673874;
	bh=+CjiU6PUPK1pW6OQeKLriaPZ731PnkVTbmR0fFVtQ3A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EvnxQ230H4somebnVsoavNK1X4NxZeqs0npnpW2S1miFjhst5fzNXxqKDShmm9YQ0
	 SiUcs/5O+UfcDtDe6jQxeQrTIBociA1uO3BhS186P4usPrf9tJ2p7deHQpVCp8Yfq5
	 mz4wazFjCJgKlJsWkAKJVNfJOPwIjlH4+wHdGCLA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tyler Hicks <code@thicks.com>,
	Ryan Lee <ryan.lee@canonical.com>,
	Zygmunt Krynicki <me@zygoon.pl>,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 329/699] apparmor: aa_getprocattr free procattr leak on format failure
Date: Tue, 21 Jul 2026 17:21:28 +0200
Message-ID: <20260721152403.113311709@linuxfoundation.org>
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

[ Upstream commit fea23bf73f0cae8ccb1d0684e4a3003874771f41 ]

aa_getprocattr() allocates the output string before rendering the label
into it. If the second aa_label_snxprint() call fails, the function
returned without freeing that allocation.

Free and clear the output pointer on the uncommon formatting failure path
before dropping the namespace reference.

Fixes: 76a1d263aba3 ("apparmor: switch getprocattr to using label_print fns()")
Reviewed-by: Tyler Hicks <code@thicks.com>
Reviewed-by: Ryan Lee <ryan.lee@canonical.com>
Signed-off-by: Zygmunt Krynicki <me@zygoon.pl>
Signed-off-by: John Johansen <john.johansen@canonical.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/apparmor/procattr.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/security/apparmor/procattr.c b/security/apparmor/procattr.c
index c929bf4a3df1c0..3beb0915892a16 100644
--- a/security/apparmor/procattr.c
+++ b/security/apparmor/procattr.c
@@ -56,6 +56,8 @@ int aa_getprocattr(struct aa_label *label, char **string)
 				FLAG_SHOW_MODE | FLAG_VIEW_SUBNS |
 				FLAG_HIDDEN_UNCONFINED);
 	if (len < 0) {
+		kfree(*string);
+		*string = NULL;
 		aa_put_ns(current_ns);
 		return len;
 	}
-- 
2.53.0



