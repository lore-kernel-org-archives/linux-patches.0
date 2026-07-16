Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D126043303D;
	Thu, 16 Jul 2026 14:27:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784212079; cv=none; b=HUXo2o746ZtUHmIBF8lM9G2UdxW4LUqqEWp5FHIYDdMdtFEsO1neS9gOW79De0WAKXxF3ElDjqurGxVHqwPmYhOVJEAfpx+lqHlrvtlhEorz6g/HrZZQFc9Dzz4SzMwB1wIf+qKv6/pUdT9XgTgrfhGq4Kok1hGlmKx576qH/rA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784212079; c=relaxed/simple;
	bh=tQKqmni8+1x60NHuaxAglm/Y9SmteR6WZduc11akzAA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TjWRZXIFdauklzcAeFZmt5p+4lG04+pE2Bejo6jDd2vIiWPcfGCjazWjBR0kG67oU0z4kDEgpPpi3TDVUtpOia+xBh12Vm9oU5CUHt34GE/li3Fw5smzzLBe0Hvm/8cIQCu4NJRkovqI9rDJZQOitCKKmuG23RVgJ+SixxTPeaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Va9+QKEu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Va9+QKEu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41A181F000E9;
	Thu, 16 Jul 2026 14:27:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784212078;
	bh=2w54GmhN0I8FgaBJoZ8K9V4mXBbhEVojCg2UHE/g050=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Va9+QKEuPao6XpyeL1Lp4Mp0I0/oMQBeQv9fQ6Oabx7jO0yxk+HvWE0Zqqc7P/lss
	 NzBCFMAmZtk8AXasfMUGgcrjfBvB6JkMuoNDJELFOVoWfsyDeiwVazmrKydmVDMNzz
	 goJT9WuW3h5g018Vi69ZOq18cU1hZ2MjezbtDf3o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH 6.12 148/349] netfilter: ebtables: module names must be null-terminated
Date: Thu, 16 Jul 2026 15:31:22 +0200
Message-ID: <20260716133036.689398839@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133033.287196923@linuxfoundation.org>
References: <20260716133033.287196923@linuxfoundation.org>
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

From: Florian Westphal <fw@strlen.de>

commit 084d23f818321390509e9738a0b08bbf46df6425 upstream.

We need to explicitly check the length, else we may pass non-null
terminated string to request_module().

Cc: stable@vger.kernel.org
Fixes: bcf493428840 ("netfilter: ebtables: Fix extension lookup with identical name")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bridge/netfilter/ebtables.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/bridge/netfilter/ebtables.c
+++ b/net/bridge/netfilter/ebtables.c
@@ -402,6 +402,9 @@ ebt_check_match(struct ebt_entry_match *
 	    left - sizeof(struct ebt_entry_match) < m->match_size)
 		return -EINVAL;
 
+	if (strnlen(m->u.name, XT_EXTENSION_MAXNAMELEN) == XT_EXTENSION_MAXNAMELEN)
+		return -EINVAL;
+
 	match = xt_find_match(NFPROTO_BRIDGE, m->u.name, m->u.revision);
 	if (IS_ERR(match) || match->family != NFPROTO_BRIDGE) {
 		if (!IS_ERR(match))


