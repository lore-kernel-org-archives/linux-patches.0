Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A10F2846D;
	Tue, 11 Mar 2025 15:24:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741706687; cv=none; b=HGvtP08zVv6wPIvbx200PlIP9SHdfJBpJ7PA4jDiqIUvtSKH3gvNMDvEQpV5xMdcndR4diC+K1urEdxwdVskrKqDWrVc9/cZFVMTHPJOvv32VhryZuwQ5dTgqpHBR9x4G19o5kefgowSBkIXfekuZ/0E/VUBvp0UJHlm/+jq5NI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741706687; c=relaxed/simple;
	bh=e93lx+sw2uo9RdgDqAAvlvy8wEh3m6I9jIGEoWU0yEU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GOUkp6KMXy+jS2LOaJTPDPL1hmWXam6snrkfJ3VZjqva/r6bkthQ0jiH1h0PlprpVnZ4TQalBNZ38qblzzetGRk3JbGI24mMPOv5zxOhisp7TJX2O7VU7JKoYtGc6b2woQx8VROPWueMnjkXqAl7H81T6E4fcB/aTA8DeW4yOUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lMA2qdk9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lMA2qdk9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6902C4CEE9;
	Tue, 11 Mar 2025 15:24:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741706687;
	bh=e93lx+sw2uo9RdgDqAAvlvy8wEh3m6I9jIGEoWU0yEU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lMA2qdk9E5R8JqcoKVjv6wWIK7b9Bd+TnDrONshsBa3C3mFDpJRQlBQt73luHcxtV
	 EF2fRCNheI1yFPQyBvQqv2CF6mEyaxM5HT57kK8U1ZBvKqbkX/QVZGcgS1IJZB3iig
	 Kjk/nRci48xaB7kBy4H3gSFHWLUzg3cPDPosSRC4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+4eb7a741b3216020043a@syzkaller.appspotmail.com,
	Leo Stone <leocstone@gmail.com>,
	Paul Moore <paul@paul-moore.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 132/462] safesetid: check size of policy writes
Date: Tue, 11 Mar 2025 15:56:38 +0100
Message-ID: <20250311145803.573653360@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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



