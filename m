Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B44C7EEB8;
	Mon, 11 Dec 2023 18:30:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HmrmweRE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A1A7C433C8;
	Mon, 11 Dec 2023 18:30:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702319455;
	bh=vbNJJAvd7r5VKRKrfgcUTiISHwfWiCqlQXLFjhrzEzk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HmrmweREoNa3ph/He1Eds5H+MWa69fc/Dh91VuU2XHhz+mm490ebGZ/oVQjCmWb8o
	 TVnDE25gPiPYHskKeSVLgOy1y2I+6fhB/WonJAJvIImqArqlT7CKBDR+JCVJ1kYWgY
	 h4EoPWYvMuXRpbMsUOZIHYWTnHgRgWbKNFW3WqlY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"The UKs National Cyber Security Centre (NCSC)" <security@ncsc.gov.uk>,
	Ido Schimmel <idosch@nvidia.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Jiri Pirko <jiri@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 071/244] psample: Require CAP_NET_ADMIN when joining "packets" group
Date: Mon, 11 Dec 2023 19:19:24 +0100
Message-ID: <20231211182048.986448070@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231211182045.784881756@linuxfoundation.org>
References: <20231211182045.784881756@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ido Schimmel <idosch@nvidia.com>

[ Upstream commit 44ec98ea5ea9cfecd31a5c4cc124703cb5442832 ]

The "psample" generic netlink family notifies sampled packets over the
"packets" multicast group. This is problematic since by default generic
netlink allows non-root users to listen to these notifications.

Fix by marking the group with the 'GENL_UNS_ADMIN_PERM' flag. This will
prevent non-root users or root without the 'CAP_NET_ADMIN' capability
(in the user namespace owning the network namespace) from joining the
group.

Tested using [1].

Before:

 # capsh -- -c ./psample_repo
 # capsh --drop=cap_net_admin -- -c ./psample_repo

After:

 # capsh -- -c ./psample_repo
 # capsh --drop=cap_net_admin -- -c ./psample_repo
 Failed to join "packets" multicast group

[1]
 $ cat psample.c
 #include <stdio.h>
 #include <netlink/genl/ctrl.h>
 #include <netlink/genl/genl.h>
 #include <netlink/socket.h>

 int join_grp(struct nl_sock *sk, const char *grp_name)
 {
 	int grp, err;

 	grp = genl_ctrl_resolve_grp(sk, "psample", grp_name);
 	if (grp < 0) {
 		fprintf(stderr, "Failed to resolve \"%s\" multicast group\n",
 			grp_name);
 		return grp;
 	}

 	err = nl_socket_add_memberships(sk, grp, NFNLGRP_NONE);
 	if (err) {
 		fprintf(stderr, "Failed to join \"%s\" multicast group\n",
 			grp_name);
 		return err;
 	}

 	return 0;
 }

 int main(int argc, char **argv)
 {
 	struct nl_sock *sk;
 	int err;

 	sk = nl_socket_alloc();
 	if (!sk) {
 		fprintf(stderr, "Failed to allocate socket\n");
 		return -1;
 	}

 	err = genl_connect(sk);
 	if (err) {
 		fprintf(stderr, "Failed to connect socket\n");
 		return err;
 	}

 	err = join_grp(sk, "config");
 	if (err)
 		return err;

 	err = join_grp(sk, "packets");
 	if (err)
 		return err;

 	return 0;
 }
 $ gcc -I/usr/include/libnl3 -lnl-3 -lnl-genl-3 -o psample_repo psample.c

Fixes: 6ae0a6286171 ("net: Introduce psample, a new genetlink channel for packet sampling")
Reported-by: "The UK's National Cyber Security Centre (NCSC)" <security@ncsc.gov.uk>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Link: https://lore.kernel.org/r/20231206213102.1824398-2-idosch@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/psample/psample.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/psample/psample.c b/net/psample/psample.c
index 81a794e36f535..c34e902855dbe 100644
--- a/net/psample/psample.c
+++ b/net/psample/psample.c
@@ -31,7 +31,8 @@ enum psample_nl_multicast_groups {
 
 static const struct genl_multicast_group psample_nl_mcgrps[] = {
 	[PSAMPLE_NL_MCGRP_CONFIG] = { .name = PSAMPLE_NL_MCGRP_CONFIG_NAME },
-	[PSAMPLE_NL_MCGRP_SAMPLE] = { .name = PSAMPLE_NL_MCGRP_SAMPLE_NAME },
+	[PSAMPLE_NL_MCGRP_SAMPLE] = { .name = PSAMPLE_NL_MCGRP_SAMPLE_NAME,
+				      .flags = GENL_UNS_ADMIN_PERM },
 };
 
 static struct genl_family psample_nl_family __ro_after_init;
-- 
2.42.0



