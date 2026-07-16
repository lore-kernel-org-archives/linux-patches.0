Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42F2B3FE370;
	Thu, 16 Jul 2026 13:44:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784209473; cv=none; b=sbXAvwu0oC7lxS4cQxkk06Q41e/QNj6aJRKrobIVAzCKtwOFLDS78EEPAUT5dKPRbJLEpvaLejur6f+aRxOB5PInB3GRsmALXB3LeK7LzQ4iK6V3OMJusi9F5kQCMhJNQMJnt6kPn+XGsubBKNO/Ul3Wdqex7I7Z/d7Dhv60ppA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784209473; c=relaxed/simple;
	bh=1t3LGiguFsB8SmHtYPPk3CKm0ifakIDVG3aPdci5Hto=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H9A5PCSTbhMxl3Z7s4IFHErMPwKjtydqSJd5PNa/WFUUWtbL8ZV56LJB1uYBK693j7WfEn01MK9uXbdsN44p0iKlbCpZ8hTEKt2L5VnqtsU1P+akcsyITJwa66RDTfsuKtLMvgxpwG98d0W/+MZQvHhY/+aOqFfjcqYuTQO/ros=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y1EBgSyH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y1EBgSyH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E1EA1F000E9;
	Thu, 16 Jul 2026 13:44:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784209471;
	bh=FVsqoHTfXkMFLuenF7C1LNhsFcuPIzuuLS7czQb2hRU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Y1EBgSyHUs2Q8U8Wy9lpBuKjyXZ+uifjWqMUbngXkH/VD5XtfK4nevSvDO9MdMKI9
	 BxfqbvB68vk2MfAjR8ugPMrziBwXHCzxN8IaYQlFOcLKm38Jyb6UoS3buCq4rVrVbB
	 xUg8WeqVUPF2HmdkpbrsTWwbcdU/XwpbiQOYCyns=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pratham Gupta <pratham36gupta@gmail.com>,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH 7.1 197/518] netfilter: ctnetlink: use nf_ct_exp_net() in expectation dump
Date: Thu, 16 Jul 2026 15:27:45 +0200
Message-ID: <20260716133052.137410001@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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

From: Pratham Gupta <pratham36gupta@gmail.com>

commit a7f57320bbbc67e347bf5fff4b4a9bab980d5956 upstream.

Commit 02a3231b6d82 ("netfilter: nf_conntrack_expect: store netns and zone in expectation")
introduced exp->net so RCU-only expectation paths no longer need to
dereference exp->master for netns lookups.

Commit 3db5647984de ("netfilter: nf_conntrack_expect: skip expectations in other netns via proc")
updated the proc path accordingly, but ctnetlink_exp_dump_table() still
compares against nf_ct_net(exp->master).

Use nf_ct_exp_net(exp) here as well so the netlink dump path matches
the rest of the March 2026 expectation netns/RCU cleanup.

Fixes: 02a3231b6d82 ("netfilter: nf_conntrack_expect: store netns and zone in expectation")
Cc: stable@vger.kernel.org
Signed-off-by: Pratham Gupta <pratham36gupta@gmail.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nf_conntrack_netlink.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -3173,7 +3173,7 @@ restart:
 			if (l3proto && exp->tuple.src.l3num != l3proto)
 				continue;
 
-			if (!net_eq(nf_ct_net(exp->master), net))
+			if (!net_eq(nf_ct_exp_net(exp), net))
 				continue;
 
 			if (cb->args[1]) {


