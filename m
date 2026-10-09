Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B21C17A305;
	Fri,  9 Oct 2026 14:17:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791555476; cv=none; b=G7Jl1BR5OMd6czl4b3wRhFrHn9RWVv/uLSaOpkQON9gLZg+z3+Oq/zigJB7vB/bGeGPw7uZ/UcuuO9S+5BiEtkBHOYnA31qiasDs0DcZRDAHfyIhVEw3BVhwpRvUGJnwNVaM/NVtnx2yVNPZy5Zoq73y7uRQIwDxjXN9IDI/YtA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791555476; c=relaxed/simple;
	bh=d1vW2SkukRl3Iyu2e2FUreQfkuzF3rxwhfYUjmXXYg0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jQGJlvzM8zK2UqxbapUgLOTPO4Z2n6dg2C1TOUrp0RVYPzWPbMA075G/MjOFYOyjxpV+gfyt/QONLOysKPDeypPdiHzrRnWhBEZ9KsaPgXRjozmXAW+Rr2lyfc/6bD34V/uYQLwqJ9ZAUkwXMk7VKq7sLN9MmT0GpLxQb8HMACo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UbFrrBoZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UbFrrBoZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B20311F00893;
	Fri,  9 Oct 2026 14:17:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791555474;
	bh=qsVyJP//82e31L+frYMnBbsY9ZSTIEMLxKplSbydX7w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UbFrrBoZEk7nkqTPAsQHX6kaPvlrKmU6zAV6mu5kCBXYcm0ZO7Vu7i55afcY3SYXd
	 AuELlbGrJEeBER9bfCJVIGfFxhxwjHCuFVyq6oEA7PfqxVhIPg10gyQoWu2/IG7QUy
	 3di4GfTzp1Mcud7q0eBUMFmGiyNWN+HzOOalIpcA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdurrahman Hussain <abdurrahman@nexthop.ai>,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 064/403] of/overlay: dont create "//" paths for fragments targeting the root
Date: Fri,  9 Oct 2026 16:07:05 +0200
Message-ID: <20261009140953.594399686@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
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

From: Abdurrahman Hussain <abdurrahman@nexthop.ai>

[ Upstream commit 21c89ff1fc86ffa517f3a9ca1ba5c48e9e37c1ba ]

dup_and_fixup_symbol_prop() rewrites a symbol value by replacing its
"/fragment/__overlay__" prefix with the fragment's target path. When
the fragment targets the root node the target path is "/" and the
result starts with "//", which __of_find_node_by_full_path() cannot
resolve: symbols pointing into such fragments silently stop
resolving.

Drop the target path when it is the root and the tail is non-empty. A
value naming the fragment root itself (empty tail) keeps the "/".

Fixes: d1651b03c2df ("of: overlay: add overlay symbols to live device tree")
Assisted-by: Claude:claude-fable-5 [Claude Code]
Signed-off-by: Abdurrahman Hussain <abdurrahman@nexthop.ai>
Link: https://patch.msgid.link/20260831-nh-of-alias-overlay-v7-7-02754604805a@nexthop.ai
Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/of/overlay.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/of/overlay.c b/drivers/of/overlay.c
index 8e5b5e5d2bc4e..f987b0db24b3b 100644
--- a/drivers/of/overlay.c
+++ b/drivers/of/overlay.c
@@ -256,6 +256,9 @@ static struct property *dup_and_fixup_symbol_prop(
 	if (!target_path)
 		return NULL;
 	target_path_len = strlen(target_path);
+	/* a root target renders as "/"; drop it to avoid "//" results */
+	if (target_path_len == 1 && target_path[0] == '/' && path_tail_len)
+		target_path_len = 0;
 
 	new_prop = kzalloc(sizeof(*new_prop), GFP_KERNEL);
 	if (!new_prop)
-- 
2.53.0



