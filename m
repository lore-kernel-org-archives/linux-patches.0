Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FE8A2ED171;
	Tue, 17 Jun 2025 15:56:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750175809; cv=none; b=DEp1BbDRAFOFoFunbqLIX61Sc5RFeqw3vI1gxMPu6fkS+tp+fv363BMn4rWb6msRqWi70bgTre4c1fNjxwQf880Yamp5qM/HHkC44+JZ+Y6bZP9+idgHEcN5Nsgfi9sAikaY7TrIzYxDAxg+xOId/8EVNJe6/JW4owT6YwGXhAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750175809; c=relaxed/simple;
	bh=4AFVNmvA4g3tBZ9Tw+BHIFAn1HbvB3PQrByKvkwqqdY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lWEpzMZbHAvZceK7Y6zmpRxUjZ9K2GdZ601jpZkH7BOoRok5nYDOHZovkr71Ltwsae3tYZqw6K5P3cSBUs34twhDozoT73Oa2W3Hwz+z9g5QjJXFAtUFCeC1N6Lde2V/DA9vo42f7ls7mcpVV96vS4a8vn7OwJcvRqpZedbZBT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VWKXC8NA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VWKXC8NA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A93CEC4CEE3;
	Tue, 17 Jun 2025 15:56:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750175809;
	bh=4AFVNmvA4g3tBZ9Tw+BHIFAn1HbvB3PQrByKvkwqqdY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VWKXC8NAoo540F5idP1J2VYfXgAaa2W9O66unsFo73XlxvkQkcIGc3CC8MTEfA0h9
	 fxHbybQgBjjG5tMvh80c5IeNn/9ikICfv6HwUCgCmkedDqZWcOikEdzJbaammhoTxU
	 meGCGbWWdL+hY1fmlnOSlkCLJjDg64CC0fFhodwU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrii Nakryiko <andrii@kernel.org>,
	Anton Protopopov <a.s.protopopov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 165/512] libbpf: Use proper errno value in nlattr
Date: Tue, 17 Jun 2025 17:22:11 +0200
Message-ID: <20250617152426.296032748@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Anton Protopopov <a.s.protopopov@gmail.com>

[ Upstream commit fd5fd538a1f4b34cee6823ba0ddda2f7a55aca96 ]

Return value of the validate_nla() function can be propagated all the
way up to users of libbpf API. In case of error this libbpf version
of validate_nla returns -1 which will be seen as -EPERM from user's
point of view. Instead, return a more reasonable -EINVAL.

Fixes: bbf48c18ee0c ("libbpf: add error reporting in XDP")
Suggested-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Anton Protopopov <a.s.protopopov@gmail.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20250510182011.2246631-1-a.s.protopopov@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/nlattr.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/tools/lib/bpf/nlattr.c b/tools/lib/bpf/nlattr.c
index 975e265eab3bf..06663f9ea581f 100644
--- a/tools/lib/bpf/nlattr.c
+++ b/tools/lib/bpf/nlattr.c
@@ -63,16 +63,16 @@ static int validate_nla(struct nlattr *nla, int maxtype,
 		minlen = nla_attr_minlen[pt->type];
 
 	if (libbpf_nla_len(nla) < minlen)
-		return -1;
+		return -EINVAL;
 
 	if (pt->maxlen && libbpf_nla_len(nla) > pt->maxlen)
-		return -1;
+		return -EINVAL;
 
 	if (pt->type == LIBBPF_NLA_STRING) {
 		char *data = libbpf_nla_data(nla);
 
 		if (data[libbpf_nla_len(nla) - 1] != '\0')
-			return -1;
+			return -EINVAL;
 	}
 
 	return 0;
@@ -118,19 +118,18 @@ int libbpf_nla_parse(struct nlattr *tb[], int maxtype, struct nlattr *head,
 		if (policy) {
 			err = validate_nla(nla, maxtype, policy);
 			if (err < 0)
-				goto errout;
+				return err;
 		}
 
-		if (tb[type])
+		if (tb[type]) {
 			pr_warn("Attribute of type %#x found multiple times in message, "
 				"previous attribute is being ignored.\n", type);
+		}
 
 		tb[type] = nla;
 	}
 
-	err = 0;
-errout:
-	return err;
+	return 0;
 }
 
 /**
-- 
2.39.5



