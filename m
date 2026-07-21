Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5B19443A9D;
	Tue, 21 Jul 2026 22:48:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784674097; cv=none; b=Pv7xdHeAEsp3xMwXdQuae9vgd3ioPJSNVovXN22J0U9w+YqhlobmO9meWk2t9NIOeSUkCP59d9ICIDCP/r0XBZT38Vrvp5+0Iw4OVhUXT/SdwUBfWwKmxEKUK8Ezt5Ad7PgRBv1Z4j9pA5Yytck8HlUwKAN87f9xilxIFweb0oc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784674097; c=relaxed/simple;
	bh=3xwtTri2vnXX9zA/JiE8W4G1rFd0mczvMoTlww17Lng=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k7jWYVOX5wVNk0xFd4JX0hKjJrD9xhiatvVvTfJXvvDofx72QNG0e9Ri2QF3KrYi6JyRzVveQkQ0lRQnO9fUgG+Uxd6VzgrtM5yPSlA/W4MmyNCvyfiR3Cvap0yhfPI7n4eHPgk6tnXIHe0YMi6Nu3D3SVYsAYejFbCcBcCi+ow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TR4sHC0y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TR4sHC0y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13D351F00A3A;
	Tue, 21 Jul 2026 22:48:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784674088;
	bh=EpYmeRjfQBCd1Qp8+DmBhk2ytt1gtbI5z/duBTQZKhs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TR4sHC0yqCJaMyLNzQ2NMBkv815Ce26wdJ58tqboYdKAOaQZx9wp40c+GD+pOuLYi
	 N151ycIwrZs5BsVmgc9P+h0eKywmRv12ngU8s/rO2lySKh+WirRikhfTEu95da/Hum
	 qPqIWcaLWVKJ6ssxX1KWmHmokdHBdTNZiI7ypynA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolas Dichtel <nicolas.dichtel@6wind.com>,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 366/699] ipv6: fix error handling in disable_policy sysctl
Date: Tue, 21 Jul 2026 17:22:05 +0200
Message-ID: <20260721152403.951834361@linuxfoundation.org>
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
index 288178ee2c72ce..199c14504444bd 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -6588,6 +6588,8 @@ static int addrconf_sysctl_disable_policy(struct ctl_table *ctl, int write,
 	lctl = *ctl;
 	lctl.data = &val;
 	ret = proc_dointvec(&lctl, write, buffer, lenp, ppos);
+	if (ret)
+		return ret;
 
 	if (write && (*valp != val))
 		ret = addrconf_disable_policy(ctl, valp, val);
-- 
2.53.0



