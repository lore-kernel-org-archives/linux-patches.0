Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA6F946C4A6;
	Tue, 21 Jul 2026 19:43:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784663004; cv=none; b=ZtjZA9tVlcCI+NSxIwFhc+jWjgTXanf0w0w43htTfiD48oX5X2r4w2QAkNZ2OJ+cCpthl3J8EDsJMGQYSliJQ7/hcANOVhaUAbeiFvimV3vB0RC1j6vRWL/aHTzjOpG1WOrTODHqN8e5RUP/LQGEjM0LG076MEMm/oOJy4VIscQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784663004; c=relaxed/simple;
	bh=uDNYWlxDBiIPQ/fxKCW8sGpn80MWbGNKCOAuXPxX+q0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m3MELITZLnXdt+vgE0Xd74egZcZgJ3IgiLtWH5kq4lQNQHzJzUbsviobusijIc7xmlaauzgKPYC0Z2XdPSC18ARHfoFJUvechyR4FSIeEd8yzsngOMuiYiTqNdYZq5XOvOUyJXe3FeC3jPx3DE6FvY5ftgmJZP6/OzdIvwKCCBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rnBQWAP/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rnBQWAP/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B9DB1F000E9;
	Tue, 21 Jul 2026 19:43:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784663003;
	bh=ugtDT4q3PWf+1tCGEBvN6bHnCBgu2ymx/V3ZrcjEikE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rnBQWAP/7InWfGL+w4GT7suaWOoy2Y56RUJCT2dKeaStkQXo3E/rc0SF2NdgFHRIV
	 N/1++lPJRhL3nlT/VCkTh5S7VwGBMPrsBY4PvMpn5FkVOmAyU+oHev6l36p3hUkjpJ
	 Z1iUhXk5Fz7/hTSmojIIzxsr8nVNAFJp9cq60UbY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolas Dichtel <nicolas.dichtel@6wind.com>,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0660/1276] ipv6: fix error handling in disable_policy sysctl
Date: Tue, 21 Jul 2026 17:18:23 +0200
Message-ID: <20260721152500.876487649@linuxfoundation.org>
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
index 7b65f150b72cc5..cbf5a51567e44b 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -6756,6 +6756,8 @@ static int addrconf_sysctl_disable_policy(const struct ctl_table *ctl, int write
 	lctl = *ctl;
 	lctl.data = &val;
 	ret = proc_dointvec(&lctl, write, buffer, lenp, ppos);
+	if (ret)
+		return ret;
 
 	if (write && (*valp != val))
 		ret = addrconf_disable_policy(ctl, valp, val);
-- 
2.53.0



