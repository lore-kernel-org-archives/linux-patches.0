Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35F252566
	for <patches@lists.linux.dev>; Tue, 18 Apr 2023 12:32:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0957C433D2;
	Tue, 18 Apr 2023 12:32:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681821156;
	bh=EoOLxCmV6kN7YU5aurC6eXFUkIrnO02h3+33ND/B66s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aSQj2zDp9G4ryFz63tnlFLBqwZpxyzcoml3oYZ0LQFpVgWZda5lk2GosQyjl9Lk9j
	 MJ+K4LlzdbCBTrx4lgx+sA8AdhbXj1SJdwWDuTCeUXSr3xz4pOkY6VuMHzwQdtH8Bw
	 SU1AqSuTkOvex7AOauNtb/t3ZD6VhkuO/5r5Ca6A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mohammed Gamal <mgamal@redhat.com>,
	Dexuan Cui <decui@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 002/124] Drivers: vmbus: Check for channel allocation before looking up relids
Date: Tue, 18 Apr 2023 14:20:21 +0200
Message-Id: <20230418120309.648120834@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120309.539243408@linuxfoundation.org>
References: <20230418120309.539243408@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Mohammed Gamal <mgamal@redhat.com>

[ Upstream commit 1eb65c8687316c65140b48fad27133d583178e15 ]

relid2channel() assumes vmbus channel array to be allocated when called.
However, in cases such as kdump/kexec, not all relids will be reset by the host.
When the second kernel boots and if the guest receives a vmbus interrupt during
vmbus driver initialization before vmbus_connect() is called, before it finishes,
or if it fails, the vmbus interrupt service routine is called which in turn calls
relid2channel() and can cause a null pointer dereference.

Print a warning and error out in relid2channel() for a channel id that's invalid
in the second kernel.

Fixes: 8b6a877c060e ("Drivers: hv: vmbus: Replace the per-CPU channel lists with a global array of channels")

Signed-off-by: Mohammed Gamal <mgamal@redhat.com>
Reviewed-by: Dexuan Cui <decui@microsoft.com>
Link: https://lore.kernel.org/r/20230217204411.212709-1-mgamal@redhat.com
Signed-off-by: Wei Liu <wei.liu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hv/connection.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/hv/connection.c b/drivers/hv/connection.c
index bfd7f00a59ecf..683fdfa3e723e 100644
--- a/drivers/hv/connection.c
+++ b/drivers/hv/connection.c
@@ -305,6 +305,10 @@ void vmbus_disconnect(void)
  */
 struct vmbus_channel *relid2channel(u32 relid)
 {
+	if (vmbus_connection.channels == NULL) {
+		pr_warn_once("relid2channel: relid=%d: No channels mapped!\n", relid);
+		return NULL;
+	}
 	if (WARN_ON(relid >= MAX_CHANNEL_RELIDS))
 		return NULL;
 	return READ_ONCE(vmbus_connection.channels[relid]);
-- 
2.39.2



