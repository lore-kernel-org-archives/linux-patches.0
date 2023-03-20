Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69B951C29
	for <patches@lists.linux.dev>; Mon, 20 Mar 2023 15:27:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE4C5C433EF;
	Mon, 20 Mar 2023 15:27:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1679326058;
	bh=iZc8cK3WnRqKcUjoa8VMjQKs2QCAtuLG9QxtGfUmNzg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e4CGcIijZDT0GmKks4DJNFq4UT2D4M2a1+hRJM7UEqAJ2haVi5Bf31j0/JBQgFJhr
	 tDmP6VFWE5wdPvm2E14VrU3hOA2Kgi+JwAW8HR/TshGENK9se3V3dbEPB98bR60jyP
	 E8DZM0MJEgMjb4oTLY6vHBsLsJ/A1LTdF8r5QhTs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paulo Alcantara (SUSE)" <pc@manguebit.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.2 151/211] cifs: return DFS root session id in DebugData
Date: Mon, 20 Mar 2023 15:54:46 +0100
Message-Id: <20230320145519.764147471@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145513.305686421@linuxfoundation.org>
References: <20230320145513.305686421@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Paulo Alcantara <pc@manguebit.com>

commit f446a630802f154ef0087771683bd4f8e9d08384 upstream.

Return the DFS root session id in /proc/fs/cifs/DebugData to make it
easier to track which IPC tcon was used to get new DFS referrals for a
specific connection, and aids in debugging.

A simple output of it would be

  Sessions:
  1) Address: 192.168.1.13 Uses: 1 Capability: 0x300067   Session Status: 1
  Security type: RawNTLMSSP  SessionId: 0xd80000000009
  User: 0 Cred User: 0
  DFS root session id: 0x128006c000035

Signed-off-by: Paulo Alcantara (SUSE) <pc@manguebit.com>
Cc: stable@vger.kernel.org # 6.2
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/cifs/cifs_debug.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/fs/cifs/cifs_debug.c
+++ b/fs/cifs/cifs_debug.c
@@ -419,6 +419,11 @@ skip_rdma:
 				   from_kuid(&init_user_ns, ses->linux_uid),
 				   from_kuid(&init_user_ns, ses->cred_uid));
 
+			if (ses->dfs_root_ses) {
+				seq_printf(m, "\n\tDFS root session id: 0x%llx",
+					   ses->dfs_root_ses->Suid);
+			}
+
 			spin_lock(&ses->chan_lock);
 			if (CIFS_CHAN_NEEDS_RECONNECT(ses, 0))
 				seq_puts(m, "\tPrimary channel: DISCONNECTED ");


