Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8523C39A7FD;
	Tue, 21 Jul 2026 19:13:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661183; cv=none; b=DoON1qmfPjHbyTjBgDeizos8r9i+gnwE9k+kw03rx5dalFDUhfkGVHmajyx5j55HeAIuyj7sFh7CdTabmb9RPA7GKarU0PgxbdK1FM6MGtfroFSRojAPZasss82xzNFs4RbpapNqhAI+dtkUpJmV2C6ncJo97+k8dvel+D5/veg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661183; c=relaxed/simple;
	bh=RyY4uMF/9PPeaoXgjnXooTgHPV65Goa+qWtw38ol8OU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lK8Y+cv+HqLgRpZ/V/AIbqbaNRY+RQPPV1sig1LApPCM/g9N7hv1yU5ZzuZDnM8W7WXrvpfNu8IAt/zSayeYtyztxZP0zpVLARVpSjaTuiGSvS7xH65JMfVN1lg1GrWsvKJP8lhd00NlnOjHZiNxiX7QOVZmz8YROT/TLY75Wc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2FOCBOMM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2FOCBOMM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B0371F000E9;
	Tue, 21 Jul 2026 19:13:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661182;
	bh=2wPMQta1pIaQgkcJHQPZNL22Fkhlrr+ZtjgK3vgSRws=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2FOCBOMMa5PwimHOnoEzmBxXyzC1DyUN5914u8DCaNlp0X04f9h8Krql46eGGIU8w
	 LVOckn2XqiAye2UQ3Iw2dauU3/ZYZCtr2TQMu4n8BX6UmBGI6LWb8MKdtglnpQPbN9
	 Jsm6oYeLUXz2cpBq9lrtuVzlKv6I3XMRCBmoorfg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolas Dichtel <nicolas.dichtel@6wind.com>,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1262/2077] ipv6: fix error handling in disable_policy sysctl
Date: Tue, 21 Jul 2026 17:15:35 +0200
Message-ID: <20260721152622.581457679@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index c15c9e63a2ccf3..9d8268f36c7ed2 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -6761,6 +6761,8 @@ static int addrconf_sysctl_disable_policy(const struct ctl_table *ctl, int write
 	lctl = *ctl;
 	lctl.data = &val;
 	ret = proc_dointvec(&lctl, write, buffer, lenp, ppos);
+	if (ret)
+		return ret;
 
 	if (write && (*valp != val))
 		ret = addrconf_disable_policy(ctl, valp, val);
-- 
2.53.0



