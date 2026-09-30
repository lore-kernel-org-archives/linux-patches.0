Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA3813749FA;
	Wed, 30 Sep 2026 16:51:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790787083; cv=none; b=JG9VaCbJ1nMjus6vRfTfR9ZDiFMAW+FJpcKr2UKSoQZs3XJ3dWwxfKNojsl0EKYWNoQvg/RVqk66cUvML7xzifrp8XiYomBxdEp6oAc1BC/3gfs+/1UKumjVWoiAdUBtcHNcq7rDu17+/fvWR328YNgwZL4cL4K/lCeG83A/dqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790787083; c=relaxed/simple;
	bh=6oDFCN3Lf89PsZCVRXe6FsRq+NZN1uuQSFErkIDQCpM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dtx559zz+tkyhsTyW6uvM0Mv0V7WXIFWX1VCHFRS3E+owAdE+RbW8SePjZ8k/wACHAz1uOdm9KXGI947WyFYgPXdEgJlaspwq7rR2eF4u3sBDWO9otahJUj+ll2pzsPxxWsELGy3UZDZOTW3gZlAbCHVp/3aHFdT6DPfNb6WkrA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=127N+QuG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="127N+QuG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 508031F000FF;
	Wed, 30 Sep 2026 16:51:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790787080;
	bh=IrtWD1oqf7IDfocn0ag8V2o8waaTeCaVIZ5c5gZAgm0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=127N+QuGsOgqpBzYMZRHCl1+0k9Vr/O7kWIzGbMLcxyCqoIVVgLacxI5ccGhcK23b
	 3xBt9dNpmbOF7XbPVQzhgirmGbsg+adDQ/ORpTvLXIOXTR7y2mEecdyuexQkz7rAWj
	 Hn9eOnUeRQIvtLICUKyDhNLHScW92xeYouZAhsuE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Quentin Armitage <quentin@armitage.org.uk>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 103/457] net: allow IFLA_INET_CONF messages when NLA_F_NESTED unset
Date: Wed, 30 Sep 2026 17:23:28 +0200
Message-ID: <20260930152348.273732548@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Quentin Armitage <quentin@armitage.org.uk>

[ Upstream commit 6c096bb08de97cdca051fecddad22cac6a1fd275 ]

Commit fa8fca88714c ("ipv4: validate IPV4_DEVCONF attributes properly")
added validation of IFLA_INET_CONF attributes, and in the process
changed the call of nla_for_each_nested() to nla_parse_nested(). A
side effect of this change is that the IFLA_INET_CONF option is now
tested for NLA_F_NESTED being set, and fails if it is not. Prior to the
commit there was no check of NLA_F_NESTED.

Change nla_parse_nested() to nla_parse(). This restores the previous
functionality of not checking NLA_F_NESTED, thereby allowing code that
(incorrectly) doesn't set NLA_F_NESTED to continue to work.

This issue was identified because keepalived started logging errors when
it was configuring macvlans that it created.

Fixes: fa8fca88714c ("ipv4: validate IPV4_DEVCONF attributes properly")
Signed-off-by: Quentin Armitage <quentin@armitage.org.uk>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/20260915213320.1527029-2-quentin@armitage.org.uk
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/devinet.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/devinet.c b/net/ipv4/devinet.c
index a35b72662e431..a80896647154c 100644
--- a/net/ipv4/devinet.c
+++ b/net/ipv4/devinet.c
@@ -2117,9 +2117,10 @@ static int inet_validate_link_af(const struct net_device *dev,
 		return err;
 
 	if (tb[IFLA_INET_CONF]) {
-		err = nla_parse_nested(nested_tb, IPV4_DEVCONF_MAX,
-				       tb[IFLA_INET_CONF], inet_devconf_policy,
-				       extack);
+		err = nla_parse(nested_tb, IPV4_DEVCONF_MAX,
+				nla_data(tb[IFLA_INET_CONF]),
+				nla_len(tb[IFLA_INET_CONF]),
+				inet_devconf_policy, extack);
 
 		if (err < 0)
 			return err;
-- 
2.53.0



