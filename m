Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35D1D2F24
	for <patches@lists.linux.dev>; Wed, 12 Apr 2023 08:39:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2B1CC433EF;
	Wed, 12 Apr 2023 08:39:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681288768;
	bh=bDiQ9Xf5Nu54cyd6oFCPEX6z/JVwq9+vIKyU5/l60ug=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=An5JN9+MzhlHhW0mgGpJspdH31uFnL/W7E1jPv1TNEt48taSZEMNyTNgXcOpz5tvL
	 CdXNQ4jnqGbA+pObbEhNMKnB8bg59K/I+aA6pSkREzz7oQzTVBiOPUL/mgjwDnMwz1
	 S/LsS15H2UgsP0NSTalwKycOCSYF3M8BGJmiYaGk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mohammed Gamal <mgamal@redhat.com>,
	Dexuan Cui <decui@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 010/164] Drivers: vmbus: Check for channel allocation before looking up relids
Date: Wed, 12 Apr 2023 10:32:12 +0200
Message-Id: <20230412082837.257440117@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082836.695875037@linuxfoundation.org>
References: <20230412082836.695875037@linuxfoundation.org>
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
index 9dc27e5d367a2..da51b50787dff 100644
--- a/drivers/hv/connection.c
+++ b/drivers/hv/connection.c
@@ -409,6 +409,10 @@ void vmbus_disconnect(void)
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



