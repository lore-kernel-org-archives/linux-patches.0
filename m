Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25A878F57
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:58:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AEF4C433C8;
	Sun, 16 Jul 2023 20:58:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689541092;
	bh=RItXigIFTFqs8p6vAoDFKMRc7IwutNXRdSWAfjHFpak=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vhxLfMMSgtZX5bkb3VD3qryKMRxNjdI8K49dYy7/skZyiHDDQYXzqTfFHw5gpWEGg
	 Hibwjbt6goK6I1UP6Hr5hQdEpSMrsV1SEuqHldDZoOQOhhra/aLtWHA6Y0TIjcrtM/
	 XGYqZ6BAoofe/h54VJ9BFZPgwN1H1AkEKL+JU0TY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florent Revest <revest@chromium.org>,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 6.1 586/591] netfilter: conntrack: Avoid nf_ct_helper_hash uses after free
Date: Sun, 16 Jul 2023 21:52:05 +0200
Message-ID: <20230716194939.013910045@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194923.861634455@linuxfoundation.org>
References: <20230716194923.861634455@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Florent Revest <revest@chromium.org>

commit 6eef7a2b933885a17679eb8ed0796ddf0ee5309b upstream.

If nf_conntrack_init_start() fails (for example due to a
register_nf_conntrack_bpf() failure), the nf_conntrack_helper_fini()
clean-up path frees the nf_ct_helper_hash map.

When built with NF_CONNTRACK=y, further netfilter modules (e.g:
netfilter_conntrack_ftp) can still be loaded and call
nf_conntrack_helpers_register(), independently of whether nf_conntrack
initialized correctly. This accesses the nf_ct_helper_hash dangling
pointer and causes a uaf, possibly leading to random memory corruption.

This patch guards nf_conntrack_helper_register() from accessing a freed
or uninitialized nf_ct_helper_hash pointer and fixes possible
uses-after-free when loading a conntrack module.

Cc: stable@vger.kernel.org
Fixes: 12f7a505331e ("netfilter: add user-space connection tracking helper infrastructure")
Signed-off-by: Florent Revest <revest@chromium.org>
Reviewed-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nf_conntrack_helper.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/net/netfilter/nf_conntrack_helper.c
+++ b/net/netfilter/nf_conntrack_helper.c
@@ -358,6 +358,9 @@ int nf_conntrack_helper_register(struct
 	BUG_ON(me->expect_class_max >= NF_CT_MAX_EXPECT_CLASSES);
 	BUG_ON(strlen(me->name) > NF_CT_HELPER_NAME_LEN - 1);
 
+	if (!nf_ct_helper_hash)
+		return -ENOENT;
+
 	if (me->expect_policy->max_expected > NF_CT_EXPECT_MAX_CNT)
 		return -EINVAL;
 
@@ -513,4 +516,5 @@ int nf_conntrack_helper_init(void)
 void nf_conntrack_helper_fini(void)
 {
 	kvfree(nf_ct_helper_hash);
+	nf_ct_helper_hash = NULL;
 }


