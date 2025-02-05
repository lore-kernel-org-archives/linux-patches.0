Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B673158536;
	Wed,  5 Feb 2025 15:11:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738768279; cv=none; b=alun077gUVWzg7y5yEt0ChVNCtUSRpWbMoz5GEYo6iGqQTPv54OQ/4CfjcH/Pol7jRsUYuAQ3YsKxA0HiIfTX8g90KbjzI+4/RJkq9VKCOiHlqcHMpauxOg4hNhqBPqXq3ZT/VW5bbgpFpKkRjrj8tef9Db79p/q8RBS3KEfETw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738768279; c=relaxed/simple;
	bh=pJT317Bke8G7FlSNQP51zuNQXxGbpMG3ngmaTgDOEMM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qEbnIlGFWOadkqTgYeeBpiKLt8wuYVTCY824QYAqDdPiGvnHEcbAcBQwCc0qMNzBOR3uYV5u3cEzDfdQdiYixwpj7UExwC0ZRZsUnWk8lkQTrisjMEH4AMh+WisAjWSAWZStlh8zmJA7bDxlanTKDKvvxgau9Vk9HuktDnqfa2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W+1dhvdI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W+1dhvdI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B581C4CED1;
	Wed,  5 Feb 2025 15:11:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738768279;
	bh=pJT317Bke8G7FlSNQP51zuNQXxGbpMG3ngmaTgDOEMM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W+1dhvdIVfnMW/lrmm0vOHe5jFTmqUm760QbJs/cpO6QIpgrfgT/0FF3cefIrlVCj
	 uXWFfO4P7V9rK6ds/k5XTjwdKRQNzPngKxcdG8HuPMPYEIVHw+4/pR9BgdjoT2AZLo
	 KbNF7xIvzmVJHnnq9fwOfOK5HCqoa+F767gGczIg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Donald Hunter <donald.hunter@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 525/623] tools: ynl: c: correct reverse decode of empty attrs
Date: Wed,  5 Feb 2025 14:44:27 +0100
Message-ID: <20250205134516.310721549@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 964417a5d4a06614ef7fb3ae69bb17c91a2dc016 ]

netlink reports which attribute was incorrect by sending back
an attribute offset. Offset points to the address of struct nlattr,
but to interpret the type we also need the nesting path.
Attribute IDs have different meaning in different nests
of the same message.

Correct the condition for "is the offset within current attribute".
ynl_attr_data_len() does not include the attribute header,
so the end offset was off by 4 bytes.

This means that we'd always skip over flags and empty nests.

The devmem tests, for example, issues an invalid request with
empty queue nests, resulting in the following error:

  YNL failed: Kernel error: missing attribute: .queues.ifindex

The message is incorrect, "queues" nest does not have an "ifindex"
attribute defined. With this fix we decend correctly into the nest:

  YNL failed: Kernel error: missing attribute: .queues.id

Fixes: 86878f14d71a ("tools: ynl: user space helpers")
Reviewed-by: Donald Hunter <donald.hunter@gmail.com>
Link: https://patch.msgid.link/20250124012130.1121227-1-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/net/ynl/lib/ynl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/net/ynl/lib/ynl.c b/tools/net/ynl/lib/ynl.c
index e16cef160bc2c..ce32cb35007d6 100644
--- a/tools/net/ynl/lib/ynl.c
+++ b/tools/net/ynl/lib/ynl.c
@@ -95,7 +95,7 @@ ynl_err_walk(struct ynl_sock *ys, void *start, void *end, unsigned int off,
 
 	ynl_attr_for_each_payload(start, data_len, attr) {
 		astart_off = (char *)attr - (char *)start;
-		aend_off = astart_off + ynl_attr_data_len(attr);
+		aend_off = (char *)ynl_attr_data_end(attr) - (char *)start;
 		if (aend_off <= off)
 			continue;
 
-- 
2.39.5



