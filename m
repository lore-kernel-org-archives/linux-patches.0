Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 084B446EF88;
	Tue, 21 Jul 2026 19:03:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660633; cv=none; b=c6/yvNVR6HVl5I4Lco/WFkGL9RmHssHbV9QmChNrbn3bBgcQi6NW0vCd0TWrP6Xd5/qa+1TopmIspnAqh6RJFwTeSQFjpNTTJog2qV3tYortSE0e3Q5ccldT8pP9wVi7LxkY7bcqIBs12I7VWKw+YbxXX9j6M+Y3d98CIvUlwog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660633; c=relaxed/simple;
	bh=/EMbsVBQ87ZsLF/JyDXS8P3Hnh+bbB4eUQoE/2i+ufk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HucWtH4Cg8N2SxQc/R+aEOWLzx5J6MQxvOXJy3Lu/RSF9asg96kv5O2t1rQqnUDG67WDHkwZUgmUbpEUmsiZeMytmWHNC6Xi9VTV1E1oW963ntgguCzIWA7ca9S1ATwjzvXPQNoQSWDUvB+ZOoF2lWEnaA8Afw7C9tOaCdYTBMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hKOhfEoo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hKOhfEoo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EAA61F000E9;
	Tue, 21 Jul 2026 19:03:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660631;
	bh=MMwYY6nu11CMw2XfFr1u1jSmB5cG/38REORvZAQqkS8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hKOhfEooSeRrL8RCw8e0xLsdNM0MNFDcLQKX1h/ekmbxx4pCEVRdfxPVegmOwMnv7
	 2ly8caIE980mAw7ZshSm4HRBrp40UC5reSy7FPv9ZtO3Vh1iZlvv6l1OEfzqvsUo7s
	 6DmWop8VkbjX2sr5BkHD3EsaZwqZiepj1jiP7Uj4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tyler Hicks <code@thicks.com>,
	Ryan Lee <ryan.lee@canonical.com>,
	Zygmunt Krynicki <me@zygoon.pl>,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1051/2077] apparmor: aa_getprocattr free procattr leak on format failure
Date: Tue, 21 Jul 2026 17:12:04 +0200
Message-ID: <20260721152617.606189503@linuxfoundation.org>
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

From: Zygmunt Krynicki <me@zygoon.pl>

[ Upstream commit fea23bf73f0cae8ccb1d0684e4a3003874771f41 ]

aa_getprocattr() allocates the output string before rendering the label
into it. If the second aa_label_snxprint() call fails, the function
returned without freeing that allocation.

Free and clear the output pointer on the uncommon formatting failure path
before dropping the namespace reference.

Fixes: 76a1d263aba3 ("apparmor: switch getprocattr to using label_print fns()")
Reviewed-by: Tyler Hicks <code@thicks.com>
Reviewed-by: Ryan Lee <ryan.lee@canonical.com>
Signed-off-by: Zygmunt Krynicki <me@zygoon.pl>
Signed-off-by: John Johansen <john.johansen@canonical.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/apparmor/procattr.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/security/apparmor/procattr.c b/security/apparmor/procattr.c
index ce40f15d4952d6..c07b6e8fd9c93c 100644
--- a/security/apparmor/procattr.c
+++ b/security/apparmor/procattr.c
@@ -54,6 +54,8 @@ int aa_getprocattr(struct aa_label *label, char **string, bool newline)
 				FLAG_SHOW_MODE | FLAG_VIEW_SUBNS |
 				FLAG_HIDDEN_UNCONFINED);
 	if (len < 0) {
+		kfree(*string);
+		*string = NULL;
 		aa_put_ns(current_ns);
 		return len;
 	}
-- 
2.53.0



