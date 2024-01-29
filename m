Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02EE015705F;
	Mon, 29 Jan 2024 17:08:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548115; cv=none; b=hrjYW49R+3/Fl53AFY+5q7nACLZJ05MJ3oh2tJZbWofr78zs4hVcczkUQpewQ3MuLndY5+61QJ5XEs2TgOxqn6umqEyukLJddIZxY4P6klFDbgBjwgyqx3SL8YQHwyZmCnBi1MGxWqTw+gynL5e0r9nvpxUS8CBj/cMJ4NqP+q4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548115; c=relaxed/simple;
	bh=3f6+o8Ez4HxvZeKPvzy2MQy6pQhHDIFWnwBSlFO7c04=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HBGI/llQVk8RYOOUbxMBWVwq2HhLZq5bP31wskevnJp0b5+ndGhHS8Gi+Kfk+yh7bQ3+EAnmJi/gdpzbm8mpAUPhh4Xu13XBs3LFRJhyi3Dvns1249GQxh4yJmR52TwUyfEHB7VVU27LmFd6OLldO7W7lsJcZiPxBMvrSABtcN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aUkjK+4G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aUkjK+4G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEB2FC43390;
	Mon, 29 Jan 2024 17:08:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548114;
	bh=3f6+o8Ez4HxvZeKPvzy2MQy6pQhHDIFWnwBSlFO7c04=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aUkjK+4GzjDtZThcfh2tsLZ2Fd42kDmSPp1Lta05fNts1zo1Q2TGfjbqp0XFidWpB
	 za/xrWs3e1HOLHgpdT2OfoSLWG8+Z3r7k/5DwaqliAI+Fy0DXYDlSTxl+7CHOgTy44
	 2SQco4kyomqYHDcWqY+evSk26Iy00csDFVL+Ljmg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Tom Talpey <tom@talpey.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.7 138/346] ksmbd: set v2 lease version on lease upgrade
Date: Mon, 29 Jan 2024 09:02:49 -0800
Message-ID: <20240129170020.450872733@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170016.356158639@linuxfoundation.org>
References: <20240129170016.356158639@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit bb05367a66a9990d2c561282f5620bb1dbe40c28 ]

If file opened with v2 lease is upgraded with v1 lease, smb server
should response v2 lease create context to client.
This patch fix smb2.lease.v2_epoch2 test failure.

This test case assumes the following scenario:
 1. smb2 create with v2 lease(R, LEASE1 key)
 2. smb server return smb2 create response with v2 lease context(R,
LEASE1 key, epoch + 1)
 3. smb2 create with v1 lease(RH, LEASE1 key)
 4. smb server return smb2 create response with v2 lease context(RH,
LEASE1 key, epoch + 2)

i.e. If same client(same lease key) try to open a file that is being
opened with v2 lease with v1 lease, smb server should return v2 lease.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Acked-by: Tom Talpey <tom@talpey.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/oplock.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/smb/server/oplock.c
+++ b/fs/smb/server/oplock.c
@@ -1036,6 +1036,7 @@ static void copy_lease(struct oplock_inf
 	lease2->duration = lease1->duration;
 	lease2->flags = lease1->flags;
 	lease2->epoch = lease1->epoch++;
+	lease2->version = lease1->version;
 }
 
 static int add_lease_global_list(struct oplock_info *opinfo)


