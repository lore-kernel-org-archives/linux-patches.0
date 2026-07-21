Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCB763B7763;
	Tue, 21 Jul 2026 20:47:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784666828; cv=none; b=o6IfJqK97gD7XLJV7VNiMLjm8ihphLkiAoeimeAFk7H+T7+3+ikNWMWG8cyyYmd2q0XfHVmoYwqJpA21GBgV/OoOH0suB+Ne1/Ok7KXu8Cp7KLbg0TDc8DM52g/+wMRF+e7wFOb+WZKzWexuLakXDbQNDeujpeHsT+zidYqjGvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784666828; c=relaxed/simple;
	bh=NZJjHx+uQjZIhTovyNwAhJZZPNZqn3VWrPTO8+PjbXY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TKtaDqBSXtPq94su5iTIpGDl5OobGS3CPlXoFdhbddh/+26lgmCymT0g0HV4dwTcFwD+83T7z3YRgX6XN45s8f/PvtPb8waoBcUN+MPM+Yj3CBJ+8JtUBpjs8/ujjfSKYQXm1VZdtAhk3mAGtqZF5HPWeNvWQ1n8/jPpUOBMQfA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VumxokLE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VumxokLE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DCEE1F000E9;
	Tue, 21 Jul 2026 20:47:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784666826;
	bh=Qw7mwfLrSgZveHCnm3cr5xDMFsboEh0QkEAuABgbO3o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VumxokLEp10c0WNmKyGIPMm58dxh1oqf25J3G2A1f1ZBJc/Vh1QberBEGUsBygRyb
	 EhsBSgQ71gefFZnYQnKEGnipO5nC/dKmhFDrHXYNJe2R2tTKDIPC8h525TKunJrgBa
	 QApcnvoTqm4FynG/Z16/Ok9Kf0sUo0lwx/MyWfh4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolas Dichtel <nicolas.dichtel@6wind.com>,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0787/1266] ipv6: fix error handling in disable_ipv6 sysctl
Date: Tue, 21 Jul 2026 17:20:24 +0200
Message-ID: <20260721152459.472875927@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 5f32793a29eafa..e8ca9f56658eaa 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -6441,6 +6441,8 @@ static int addrconf_sysctl_disable(struct ctl_table *ctl, int write,
 	lctl.data = &val;
 
 	ret = proc_dointvec(&lctl, write, buffer, lenp, ppos);
+	if (ret)
+		return ret;
 
 	if (write)
 		ret = addrconf_disable_ipv6(ctl, valp, val);
-- 
2.53.0



