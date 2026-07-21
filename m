Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 870263D3CE4;
	Tue, 21 Jul 2026 21:34:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784669671; cv=none; b=QQSyrOP2WoD/0/+7gcbhfk9mpot29jvqovjG/hJvDpcdbNk9nq2AwU+rLQDpc9vaR8abgOconLhYzekaVFtizSrM0UGHehRg25taNNO+TYMScQNdWfKe81cES0nKC1HvxPOiMm0cS7y1NWGwqnRQ13SDNiHkPJG4Ztd7MCd3PUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784669671; c=relaxed/simple;
	bh=GUMpkGj/fmfw6kXfVl4MLeIt0WsLMqAIfaa4UbXii68=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=smtrUsHmR7OAL0wtuCI2yTVWT/WzNDzX9iugh0KyEOU/y2Dn47ujja7mOdI7XW7ke90ZqGmgoLfGZdYfQtKplBFW3ay0YNParx+OiHZyktWcN4BUOn3CgtHKSBZMapCF1fpfCNaSRYnRQlTvjKdmJuQ0s8ACuOZ3NACJIlC7KLY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VTFpQZKh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VTFpQZKh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11FF61F00A3A;
	Tue, 21 Jul 2026 21:34:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784669663;
	bh=Opyo2Y9q/qqFrbSjgMbaeAne+aYYPPOEkpTO/ydPJg8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VTFpQZKhreB5QK2XohXCqXLAIvjeCuD9WVs8ifucUxXJIrKOXfHXkztlHBD+uiO6y
	 To3zkxDD+NkaelKgYKfYTYMz3FxidiNrLxZO28rFeyUHnpSCklGrUirt+o0+NQ66k2
	 O97RokZBTj9KEBXnKuom5audrqO3241zKAwbwfkA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolas Dichtel <nicolas.dichtel@6wind.com>,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0639/1067] ipv6: fix error handling in disable_policy sysctl
Date: Tue, 21 Jul 2026 17:20:40 +0200
Message-ID: <20260721152438.888113639@linuxfoundation.org>
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

From: Fernando Fernandez Mancera <fmancera@suse.de>

[ Upstream commit 3e0e51c0ee1d08cc9d48dc17f3248d5b31cf8066 ]

When writing to the disable_policy sysctl, if proc_dointvec() fails to
parse the input, it returns a negative error code. The current
implementation is resetting the position argument even if an error
occurred during proc_dointvec() and not only during sysctl restart.

Fix this by checking the return value of proc_dointvec() and returning
early on failure.

Fixes: df789fe75206 ("ipv6: Provide ipv6 version of "disable_policy" sysctl")
Reviewed-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/20260622130857.5115-5-fmancera@suse.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/addrconf.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index db66a8f1e16885..9fe1f67ceacd43 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -6673,6 +6673,8 @@ static int addrconf_sysctl_disable_policy(struct ctl_table *ctl, int write,
 	lctl = *ctl;
 	lctl.data = &val;
 	ret = proc_dointvec(&lctl, write, buffer, lenp, ppos);
+	if (ret)
+		return ret;
 
 	if (write && (*valp != val))
 		ret = addrconf_disable_policy(ctl, valp, val);
-- 
2.53.0



