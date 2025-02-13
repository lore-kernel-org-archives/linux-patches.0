Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83E53335BA;
	Thu, 13 Feb 2025 15:22:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739460144; cv=none; b=rzQLpsl+oVfk2MLfBpCPTOWpuf6eWUn1/e3VMZIL9n4n9vICEXFn4SdDLkeD1RxaEdDj5FkM/Kyg6zNFxUCvj6uEBCKaSBCAGf59jULS4jbCN5bJw/mmZj+rfsbIbngmiQyyWcfa8PNjoWY2/xyvuSf+A1jav8qG/DojWPBtLZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739460144; c=relaxed/simple;
	bh=ARQTZPh502VMO4VS2GQ7ctflrxYVKuDQVDIYiPMcnBA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dzaeoxJeGbhSB7qSGUusMuhxtv1dIRlaRJRx2V1TOH2jb/B00IjfEIyU9ji7gh+gv4f+4o+mCeC8+UwLMoa/SNdGa66WbFzwMvC67Jv6s5G8YCSZXjHID6hGEufdz5QN1VtXkTwOKw7kNrb8wONdzL5gT7RJzuGUDdsAbh9x8XQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aVrPGQBR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aVrPGQBR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 597AEC4CEE8;
	Thu, 13 Feb 2025 15:22:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739460143;
	bh=ARQTZPh502VMO4VS2GQ7ctflrxYVKuDQVDIYiPMcnBA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aVrPGQBRvhkfWxBBEuQJwTDHu0QyXoi+2UCVBOLRB9XBKWNa23WUYRRPmi9PTcecL
	 jnhcfhQJvgtmlH9sVCm5IE/bjhsl5L+l+jIaPqJF8FYI1jAW0dFXMZeMJV/5XvXmIa
	 IumiPaWc+Z8VkVOPO7iW4XUO5h5LGs9cgxIoOSLI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+4eb7a741b3216020043a@syzkaller.appspotmail.com,
	Leo Stone <leocstone@gmail.com>,
	Paul Moore <paul@paul-moore.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 027/273] safesetid: check size of policy writes
Date: Thu, 13 Feb 2025 15:26:39 +0100
Message-ID: <20250213142408.432390351@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142407.354217048@linuxfoundation.org>
References: <20250213142407.354217048@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Leo Stone <leocstone@gmail.com>

[ Upstream commit f09ff307c7299392f1c88f763299e24bc99811c7 ]

syzbot attempts to write a buffer with a large size to a sysfs entry
with writes handled by handle_policy_update(), triggering a warning
in kmalloc.

Check the size specified for write buffers before allocating.

Reported-by: syzbot+4eb7a741b3216020043a@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=4eb7a741b3216020043a
Signed-off-by: Leo Stone <leocstone@gmail.com>
[PM: subject tweak]
Signed-off-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/safesetid/securityfs.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/security/safesetid/securityfs.c b/security/safesetid/securityfs.c
index 25310468bcddf..8e1ffd70b18ab 100644
--- a/security/safesetid/securityfs.c
+++ b/security/safesetid/securityfs.c
@@ -143,6 +143,9 @@ static ssize_t handle_policy_update(struct file *file,
 	char *buf, *p, *end;
 	int err;
 
+	if (len >= KMALLOC_MAX_SIZE)
+		return -EINVAL;
+
 	pol = kmalloc(sizeof(struct setid_ruleset), GFP_KERNEL);
 	if (!pol)
 		return -ENOMEM;
-- 
2.39.5



