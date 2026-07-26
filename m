Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA30931AA9B;
	Sun, 26 Jul 2026 12:05:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785067505; cv=none; b=Cdaob4eD7PdoN6uSKVdwE5mlvoq9X2MmlHlmVd+LWkEDRf5YmxfMQn1mDYUtfIfEEXmfSm9Xl3iMJG6dL6GiWfBFrh8W4vBfuirWjhu1yrjtNUBM+qHWH6ySywljZjXIpNviWubfbOByEfgaflUCiQac0XSfSyR03IPXQ3rFn3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785067505; c=relaxed/simple;
	bh=B2SnDdkdbdmABHfBPTgwz7tOTGUL61k3cOobH9Q3hHY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M+wYQfP+VdrHR6cvLGaAtZTh8XLQnYGkk/lug5KeeYFWcZjUMtgQaGeli+qyJu9cEgltE9ZSIEzy6inoh3fG+aSNdAly9DiPwvcbYAgIMjixYtVt4+Xxy8g55HXA4ObGpg+Z1evjhofNNw54+tgvWjpO/gsbzIf/5itX7tDUUVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Qtiqnac5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Qtiqnac5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E7B31F000E9;
	Sun, 26 Jul 2026 12:05:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785067504;
	bh=aD8H5JamrhFnaK4gmLDfbDG6/ZlfFVbH/BsDgpNaEpU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Qtiqnac5/1B2QV0s6QNN2UCjoCDRuRmtFx+1gwrHOLbGgi01SVPZzDpjbTLGKs65R
	 Gaj29cpFohwmfPb3iejxYrahrutEKfPwlQc5LtS7P2E1qo9+RkQ4nAYOGch7Stj105
	 36/bU9TyCl1XO++wTh6OMtfw0QBPSrTL2k6P2TqwJ1md4hR8+WL9YEH0IuU1j9h+5e
	 kvwI6gjbWPl7xGztDzJ/nmCiABSWiF7tybHnVwI5bsBbISQt35z8kTx/CFHJJfC6ww
	 3qeIky9MTGCUGc0/bWWbq+qhRTF1VoEEmBtZUWxU3B9cIvcbP3kwlai2efhC9kOH52
	 rDTijkkW5+9IQ==
From: Sasha Levin <sashal@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	patches@lists.linux.dev,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Ivan Abramov <i.abramov@mt-integration.ru>,
	Stefan Schmidt <stefan@datenfreihafen.org>,
	vegard.nossum@oracle.com,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Subject: Re: [PATCH 6.12 0588/1276] ieee802154: Remove WARN_ON() in cfg802154_pernet_exit()
Date: Sun, 26 Jul 2026 08:04:46 -0400
Message-ID: <20260725192000.stable-0007@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <fe4c6d82-b1d8-4421-b581-3ce231798165@oracle.com>
References: <fe4c6d82-b1d8-4421-b581-3ce231798165@oracle.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> So I think we should drop this patch for now until 0569f67ed6a7
> ("ieee802154: Avoid calling WARN_ON() on -ENOMEM in
> cfg802154_switch_netns()") is backported. Thats not a clean cherry-pick
> and needs adaption which I think we could do later ?

You're right about the missing coverage, but I'd rather keep the patch
as-is. The prerequisite 0569f67ed6a7 doesn't backport cleanly here (it
needs the netns_local -> netns_immutable rename chain and the
goto-errout restructure, none of which are on 6.12 and older), and the
only downside of removing the caller WARN_ON() without it is that a
non--ENOMEM failure on the initial dev_change_net_namespace() break path
becomes silent. That's a lost warning on a rare error path, not a crash,
so I'll leave the queued patch in rather than churn the chain. Thanks
for the careful review.

-- 
Thanks,
Sasha
