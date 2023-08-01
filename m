Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7AA01F95A
	for <patches@lists.linux.dev>; Tue,  1 Aug 2023 09:22:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 278EFC433C7;
	Tue,  1 Aug 2023 09:22:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690881748;
	bh=7v8GOkOQdnq5lwWnm8T/uHx542JNSayag1BtgtKWKvw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DrYePSk8sRpYHp/dFP8mvX1YRE0Pg/QoCoByfAbzplvTFdWe/tBao7rGDLTFJeFIm
	 rbKwhT2EZ0Sk4C3gDBpFHnu7zjdAjmkpldvAzb0qs0GDTff9FnY1RXvUdAVq9Qdi4j
	 J2UjT+/fHowdTaF5B0imLemNwwGSmGIglFVwa9w8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ondrej Mosnacek <omosnace@redhat.com>,
	Jeff Moyer <jmoyer@redhat.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 003/155] io_uring: dont audit the capability check in io_uring_create()
Date: Tue,  1 Aug 2023 11:18:35 +0200
Message-ID: <20230801091910.298403372@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230801091910.165050260@linuxfoundation.org>
References: <20230801091910.165050260@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ondrej Mosnacek <omosnace@redhat.com>

[ Upstream commit 6adc2272aaaf84f34b652cf77f770c6fcc4b8336 ]

The check being unconditional may lead to unwanted denials reported by
LSMs when a process has the capability granted by DAC, but denied by an
LSM. In the case of SELinux such denials are a problem, since they can't
be effectively filtered out via the policy and when not silenced, they
produce noise that may hide a true problem or an attack.

Since not having the capability merely means that the created io_uring
context will be accounted against the current user's RLIMIT_MEMLOCK
limit, we can disable auditing of denials for this check by using
ns_capable_noaudit() instead of capable().

Fixes: 2b188cc1bb85 ("Add io_uring IO interface")
Link: https://bugzilla.redhat.com/show_bug.cgi?id=2193317
Signed-off-by: Ondrej Mosnacek <omosnace@redhat.com>
Reviewed-by: Jeff Moyer <jmoyer@redhat.com>
Link: https://lore.kernel.org/r/20230718115607.65652-1-omosnace@redhat.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/io_uring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index d7f87157be9aa..f65c6811ede81 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -10602,7 +10602,7 @@ static int io_uring_create(unsigned entries, struct io_uring_params *p,
 	if (!ctx)
 		return -ENOMEM;
 	ctx->compat = in_compat_syscall();
-	if (!capable(CAP_IPC_LOCK))
+	if (!ns_capable_noaudit(&init_user_ns, CAP_IPC_LOCK))
 		ctx->user = get_uid(current_user());
 
 	/*
-- 
2.39.2



