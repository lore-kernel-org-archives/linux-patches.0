Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54A4B415F04;
	Tue, 21 Jul 2026 18:17:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657845; cv=none; b=aEulYB2nS3Xb+gLydjhHOYpyxyBGPElXwBQwisI4w/L7TTlXMhQb9iv+/XYs7jufEtA48ylxMQhg7bGVckbeKoPEh0NnEa2w5Iw6ucopltXNWe0DAboc6/cITl3I8ArvQlJsOdrFMRSa1vGd06HJ8GpHgv1ZY7Me6KO+ARPdSBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657845; c=relaxed/simple;
	bh=VjXKt/4lrPQRUYtN2H8C5JsewfPfjN3WIvhCcbZPnzM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ec6BBqXNKy1kArKPAfjSzU++Dsksl0YKAJ4CCzdTkK3eYx8OJL148foL9uPFF/yGf6Cl+VteyLQ7aPik5KlwgFWnJ7q7zQlnTelkOFnP8OZxX/KDyukr92S6HJj+N0eorvEW8f2m0OJGckrukvPAMcUajnKFZ4Vt+dgnu/wU0Zo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YzVFBoyI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YzVFBoyI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD7AE1F00A3D;
	Tue, 21 Jul 2026 18:17:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657844;
	bh=XsyeSg8aRHX9v4eThbmgUU7dG58V97XPQ0HdBFkIwWc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YzVFBoyIFWflWCdWKxIwJRlwylDh1l1vmeu9LL1t8tbzA4G69DlBCcqCMBnZh2Qua
	 hyjxdzTiCxfOUjVxfcC4L5pM/1WMYdjaqH/TNIv/XpIBmHqM5imH//whcigJMrogM8
	 ywbZB+6N0+XzbbOSh2bWhihI908/t+ndGiCLJFY0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolas Dichtel <nicolas.dichtel@6wind.com>,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0918/1611] ipv6: fix error handling in disable_ipv6 sysctl
Date: Tue, 21 Jul 2026 17:17:14 +0200
Message-ID: <20260721152536.034062153@linuxfoundation.org>
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

[ Upstream commit c779441e5070e2268bdfe77f6e2e0de926c431e3 ]

When writing to the disable_ipv6 sysctl, if proc_dointvec() fails to
parse the input, it returns a negative error code. The current
implementation is overwriting that error for write operations.

This results in a silent failure, it returns a successful write although
the configuration was not modified at all. When modifying the "all"
variant it can also modify the configuration of existing interfaces to
the wrong value.

Fix this by checking the return value of proc_dointvec() and returning
early on failure.

Fixes: 56d417b12e57 ("IPv6: Add 'autoconf' and 'disable_ipv6' module parameters")
Reviewed-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/20260622130857.5115-2-fmancera@suse.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/addrconf.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index c8c82891fe14c9..87c0cecc76bb94 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -6447,6 +6447,8 @@ static int addrconf_sysctl_disable(const struct ctl_table *ctl, int write,
 	lctl.data = &val;
 
 	ret = proc_dointvec(&lctl, write, buffer, lenp, ppos);
+	if (ret)
+		return ret;
 
 	if (write)
 		ret = addrconf_disable_ipv6(ctl, valp, val);
-- 
2.53.0



