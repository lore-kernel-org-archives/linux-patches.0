Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8BA64A997;
	Wed, 20 Dec 2023 16:18:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qf5Z+kNg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B848C433C8;
	Wed, 20 Dec 2023 16:18:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1703089094;
	bh=JwMo3pMBlgaRIvoB55hVGBZt4ibfkM6pU2JY6teda70=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qf5Z+kNgBvP3G7e7fL53m8hXXIr9cdMBqM83K+Besg2OfSL0YU3KvBnkdWj+HF5Pf
	 PR1HJUM9QSlxWhF46REdQSmRw76L177iFgidED26oejaf7TG57efaZNcAqhDm8iyU2
	 UYoMkD1LD33ltGWiiRQvJ8WfV6A0asa5dHxPj7bU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.15 154/159] ksmbd: dont update ->op_state as OPLOCK_STATE_NONE on error
Date: Wed, 20 Dec 2023 17:10:19 +0100
Message-ID: <20231220160938.500792910@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231220160931.251686445@linuxfoundation.org>
References: <20231220160931.251686445@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit cd80ce7e68f1624ac29cd0a6b057789d1236641e ]

ksmbd set ->op_state as OPLOCK_STATE_NONE on lease break ack error.
op_state of lease should not be updated because client can send lease
break ack again. This patch fix smb2.lease.breaking2 test failure.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ksmbd/smb2pdu.c |    1 -
 1 file changed, 1 deletion(-)

--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -8237,7 +8237,6 @@ static void smb21_lease_break_ack(struct
 		return;
 
 err_out:
-	opinfo->op_state = OPLOCK_STATE_NONE;
 	wake_up_interruptible_all(&opinfo->oplock_q);
 	atomic_dec(&opinfo->breaking_cnt);
 	wake_up_interruptible_all(&opinfo->oplock_brk);


