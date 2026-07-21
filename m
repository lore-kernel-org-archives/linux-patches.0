Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F6E1471250;
	Tue, 21 Jul 2026 18:17:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657856; cv=none; b=av8WIGyBR1YyiYHGwklnvqQ79RpqU4ztF1LNRnSOVd1u1gwqxApGRppEpNPQmRUCvjx9Jm8VyvCJdOcPW63OjJm4yR0Otma8shXZbQl+fxiDmlaJ5X8Iu+qLiz0dJX6IxUJ9yY7RlqqprgVt+AzU3rA82JS0dntPF10bkPPPJCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657856; c=relaxed/simple;
	bh=9VkEUu0fdoCCsDl5kOsnGahGC0BkBQv6T0YaGBxnnfI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OrHc8+watINhoyAjhZ6hENcyz2wEj140DQExpw2MC/k05oUM4irzjAFxe8lHRJ+eQRyP5rsywcDoqFyZChWOAENuBU0e7o6cAkkdxQjasmpILO3EIUT8I5B5qfl2dpN1kWX5mGdST8PFSLoFSSCaS5WLxoIHwXUMU5uC10mFKb0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SNk52QpJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SNk52QpJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A9A81F000E9;
	Tue, 21 Jul 2026 18:17:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657854;
	bh=LMfVBBkouw8tUXy6u2YM6u8jfFUMxfnLdMFqXG1ZO6U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SNk52QpJI3qK58Pg4RyHviDVDOkifWYf5JNzTbZ1qgevaga7Zk+LPKvRJU1+bE4Hb
	 763fgGcwYwVDDtlsxqv72/xf3FUDLaU/SsPWFfyEQM0k0pH2YItZZWZ+jk0TA3OTzC
	 gLWLMjruODHm2nE7uovzvh6PIC52CYegPN4J+J4g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolas Dichtel <nicolas.dichtel@6wind.com>,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0921/1611] ipv6: fix error handling in disable_policy sysctl
Date: Tue, 21 Jul 2026 17:17:17 +0200
Message-ID: <20260721152536.103028661@linuxfoundation.org>
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
index 3ea6b4c6192d10..b2a8a058f2d284 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -6749,6 +6749,8 @@ static int addrconf_sysctl_disable_policy(const struct ctl_table *ctl, int write
 	lctl = *ctl;
 	lctl.data = &val;
 	ret = proc_dointvec(&lctl, write, buffer, lenp, ppos);
+	if (ret)
+		return ret;
 
 	if (write && (*valp != val))
 		ret = addrconf_disable_policy(ctl, valp, val);
-- 
2.53.0



