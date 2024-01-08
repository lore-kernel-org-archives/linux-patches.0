Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C8A152F86;
	Mon,  8 Jan 2024 15:44:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m2PaKmz+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82ECFC433C7;
	Mon,  8 Jan 2024 15:44:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704728650;
	bh=MaxmP/xh5uBF6EKl0rGdtAxBwRRQnmonJLEEzC9o0f4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m2PaKmz+kacf6Gt/XzMUcJ49xOhyggfBGiNUa2B8w0hoVqc7hJthq48v+4IN/jUdc
	 vMjYvdGvyEDRXqRg141YgL3OH1z0Z2KhTGVPYoZvsf3n/vb8r1TdO3r+ueSVHLflNf
	 /2jwvEhCi3ikbfdFdn7qeH3mV1SLnO9mc7KYW1R8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Blakey <paulb@nvidia.com>,
	Vlad Buslov <vladbu@nvidia.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 6.1 144/150] net/sched: act_ct: additional checks for outdated flows
Date: Mon,  8 Jan 2024 16:36:35 +0100
Message-ID: <20240108153517.843163066@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240108153511.214254205@linuxfoundation.org>
References: <20240108153511.214254205@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vlad Buslov <vladbu@nvidia.com>

commit a63b6622120cd03a304796dbccb80655b3a21798 upstream.

Current nf_flow_is_outdated() implementation considers any flow table flow
which state diverged from its underlying CT connection status for teardown
which can be problematic in the following cases:

- Flow has never been offloaded to hardware in the first place either
because flow table has hardware offload disabled (flag
NF_FLOWTABLE_HW_OFFLOAD is not set) or because it is still pending on 'add'
workqueue to be offloaded for the first time. The former is incorrect, the
later generates excessive deletions and additions of flows.

- Flow is already pending to be updated on the workqueue. Tearing down such
flows will also generate excessive removals from the flow table, especially
on highly loaded system where the latency to re-offload a flow via 'add'
workqueue can be quite high.

When considering a flow for teardown as outdated verify that it is both
offloaded to hardware and doesn't have any pending updates.

Fixes: 41f2c7c342d3 ("net/sched: act_ct: Fix promotion of offloaded unreplied tuple")
Reviewed-by: Paul Blakey <paulb@nvidia.com>
Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sched/act_ct.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -277,6 +277,8 @@ err_nat:
 static bool tcf_ct_flow_is_outdated(const struct flow_offload *flow)
 {
 	return test_bit(IPS_SEEN_REPLY_BIT, &flow->ct->status) &&
+	       test_bit(IPS_HW_OFFLOAD_BIT, &flow->ct->status) &&
+	       !test_bit(NF_FLOW_HW_PENDING, &flow->flags) &&
 	       !test_bit(NF_FLOW_HW_ESTABLISHED, &flow->flags);
 }
 


