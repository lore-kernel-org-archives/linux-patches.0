Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19F7F35201C;
	Tue, 21 Jul 2026 20:45:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784666719; cv=none; b=FUMjm3IbDlbhMeHmNRPduzjYMUBFk1WBV6B9hyVq95XBsbopanTVXQFbge9eZvBsE217gs9ojXnocxRyXNZtbl2Kpqa+quIWJQ8T1Q4BI0tP+FXeXRVpH9PL9KlmySBS9qswYE8BxbFHfVzpd1ZEY67jevrEAnNJROzjJ8NM2Xs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784666719; c=relaxed/simple;
	bh=IN/PhNsZ9wanZAcGFpcia9+w1NHba+hOvJgUg36Hs3c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LCUq2fprMNplX+oxERx2RhGCigS8fnKj2v4Up3IczVA5dRHLYZtJF+5eKXRFYjDyHMAXas3Fm3sHl+FOnZCMBd6epCcKqk0iGzW6/UJXfDt4pXnDvQYHuQgRbuMpDvshdUdY56lNgoP3IdFrwMBTVX0osB0Ftu+doPWJURZCxDM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Jm1qRUmo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Jm1qRUmo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7ECDE1F000E9;
	Tue, 21 Jul 2026 20:45:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784666718;
	bh=FyB1VapXMCwOTIpxIRO10WaC1jwY7Nl6lKR38U7noy0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Jm1qRUmov/0chsTxFI1Xu2G92gcxkDe9u/llTAQDTFYIRgELZ1xg3EirG3QStkcLp
	 Vqy6kcZ+9F3hy3rohIULdsFfWEl88QnFn+IGyhXykyUyC1EWslcTCkopAt4H56IUiX
	 BaDAWfL16lvDcefxMXXxdOMQF/3llaQ/h78vsP38=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolas Dichtel <nicolas.dichtel@6wind.com>,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0790/1266] ipv6: fix error handling in disable_policy sysctl
Date: Tue, 21 Jul 2026 17:20:27 +0200
Message-ID: <20260721152459.538317558@linuxfoundation.org>
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
index de50c77f087ff7..83dc90a8990c92 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -6738,6 +6738,8 @@ static int addrconf_sysctl_disable_policy(struct ctl_table *ctl, int write,
 	lctl = *ctl;
 	lctl.data = &val;
 	ret = proc_dointvec(&lctl, write, buffer, lenp, ppos);
+	if (ret)
+		return ret;
 
 	if (write && (*valp != val))
 		ret = addrconf_disable_policy(ctl, valp, val);
-- 
2.53.0



