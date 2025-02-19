Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A771B1DE887;
	Wed, 19 Feb 2025 09:20:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739956837; cv=none; b=u+yj8+J8USSMNRK1qFkI7HilmE6nn6Z9U4NS/HMZp+pXWBpJwBZ2d1atFN94mgA5uPb2eOBo3J6DDZDzbXZVyyPAV6Q8LcPgRJ4DzXoquphGHdh3VVuK3zrHq0xdk423wTIvq8XN4rxPwaDsAFZnqX2SyxEZcLML+RVyoxXnI8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739956837; c=relaxed/simple;
	bh=83y1f1O7zfQi4Ta/vihwa9eVEtLgE0rB0RdlltCdAXg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PU/FrqsjQQ08rh0JmtS31Uz28/4tHMXoCTGlgp9I416kqTNVlSfSFmteRZ+fk/ImdlmTCPGbIrjFu3NYoH4LSL26T0GszSBw5AQgbemfSjL2pLrN2hZHGsmc6RHiOSF8Bn9FftITil79re7BzRQDsqDp9SSV3n5Vqw8uGNoln4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hTvjYa8t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hTvjYa8t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D5A9C4CED1;
	Wed, 19 Feb 2025 09:20:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739956837;
	bh=83y1f1O7zfQi4Ta/vihwa9eVEtLgE0rB0RdlltCdAXg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hTvjYa8twcDQxCv6FoDTmNHlA+GCAH7P4yvv5CCGzeJ3REIh/09mh8Jf4wRq0gRvW
	 VniO0bQ13zbjNecanlfa/rC8KN6C9MhA2+9cwaSo3VglO8t2KJaMYUSmfuh8rT5R0K
	 Ar9EvFxVT1gzGmjdeQmJtLZb5idPIUsd21ADCjXE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+4eb7a741b3216020043a@syzkaller.appspotmail.com,
	Leo Stone <leocstone@gmail.com>,
	Paul Moore <paul@paul-moore.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 285/578] safesetid: check size of policy writes
Date: Wed, 19 Feb 2025 09:24:49 +0100
Message-ID: <20250219082704.224660247@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



