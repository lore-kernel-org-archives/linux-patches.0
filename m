Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFE07253F03;
	Mon, 23 Jun 2025 13:29:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750685387; cv=none; b=tq6xihuzSSnUMlrqEkVVLu0HVfFzGgcYYX7Lj/Va7ppD6FVDOJKKCsI3SMTqKsZkddYAnRxzErP8d1JMBq/do8O5m7r829nm2Y6rvctrOgFONtvB34f4yzBItcXdO5rveTrSlQmAQ3Pe++c2ZFKBlf++f1jjv6dozzlqIjhIcS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750685387; c=relaxed/simple;
	bh=pLoRtMrRIefdovnOXptf1hVdoIuNWKcYzFq5eNWoNIo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OU3B/yZCx9gPAPyY2MCFybgIBh3SGWsfwqeD5Z3p/r34kEx1pIVJXdWLgPMPGBWruBHBq2aFJpoEIHG3+CvA7LRpFAYcRYXhOq+vKxU5Nnlv8lM69zNP7rvlW3BwQvnUT/9b99CmNpUeZZz5lHPZCgF8KVY2UMObGuguWZ6hVJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1pqn7EX1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1pqn7EX1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 857AEC4CEEA;
	Mon, 23 Jun 2025 13:29:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750685386;
	bh=pLoRtMrRIefdovnOXptf1hVdoIuNWKcYzFq5eNWoNIo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1pqn7EX1hUmOxtWFhwL22KsTIfpYTHl2ubWDKDUSw2ctH7jE+CX8W8K4VCqKHvyoX
	 oaj8QRjJL4qR7FXRmc+3gWGEwX0jgxXZKV25QG54yMf2ucmEJsj4M51CFVBttMaBqe
	 RKdWxJnQrJCBPysZJQIVRS8T+evDGUSOYVl5UmVs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrii Nakryiko <andrii@kernel.org>,
	Anton Protopopov <a.s.protopopov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 056/411] libbpf: Use proper errno value in nlattr
Date: Mon, 23 Jun 2025 15:03:20 +0200
Message-ID: <20250623130634.674081146@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130632.993849527@linuxfoundation.org>
References: <20250623130632.993849527@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 2dbe7b99f28f1..0e6df58fedae3 100644
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



