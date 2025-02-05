Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAB7A2A1BB;
	Wed,  5 Feb 2025 15:01:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738767705; cv=none; b=Zs8NHc+0XyCkVAyWmqVvPOHR0N6f2BXMmIa3cQvpknj0h32xxRK5WN4CDMmQFZhTghoFajzOqnbB7mp8iXVzlIouEGWtQd7atDPusEGFWgH4PrikI1YtjKmH//xJ1slS51sAxLUGkpGM+aWoH2OnW89zQ2AcsRXG6xe5Wl55cPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738767705; c=relaxed/simple;
	bh=CdRhpaBsKa0MKtXn9VaoB4S+grkwl99dvC0X2b2ThqQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=noHYJk5LI9dRL/hUZKz+IbO8FQkE8FyDPIKVMvDXSwToiPNSGWATuiFdcMQqtyZNcteRYfk4S5z1755NJqON0yxd1q6E55mS+KGMHp6RYscb5sAAqSjYhx4iIP3Y7Jvvoh1rRzTPDO+xMkrV736Qyls3RzG0blLfZfzI9aJfdts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YVsoMv9p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YVsoMv9p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E1F5C4CED1;
	Wed,  5 Feb 2025 15:01:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738767705;
	bh=CdRhpaBsKa0MKtXn9VaoB4S+grkwl99dvC0X2b2ThqQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YVsoMv9pF/uGKS5Z1Q9GaQXijJKdGtp4sJZrbb6SGObNw2zOfIxDEGjMZGRbVv6t4
	 ifh4Bu/yFKKwfgdtYtNi4cbCAu4AU2reB7Xe1fs2/6JNiPl9fM54cNPyStFWYadv1J
	 yv6VwPqOj9OgGZHq2A6OyJKSh0rtoNBb+WyAoICU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Donald Hunter <donald.hunter@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 495/590] tools: ynl: c: correct reverse decode of empty attrs
Date: Wed,  5 Feb 2025 14:44:10 +0100
Message-ID: <20250205134514.207963638@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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



