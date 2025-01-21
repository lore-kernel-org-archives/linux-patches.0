Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70F9E1F4275;
	Tue, 21 Jan 2025 18:04:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737482674; cv=none; b=hTuJltDiBuFmgeqHmWATbriDdo7RNtsUkVsq07YzJmfIDAWAqhi0B8cgpHM+DkIaZK9w+godydhrOFCbSjxntgzP2z0iP/K0rRwJskBz1avHYPzBrB/n16UcPBvJEpz7yGW+jRYvniWUBStbL06AQ3X/QHvQSEix/F2hDZqoUfw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737482674; c=relaxed/simple;
	bh=qe3OX2k8EkjZRYVCZQB4VscNIqlfyFyU5pi2VoKKkxI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aBDiGjGtkRxb0KWr4cw94GOnPbzIJlPxmp2FPD8P8/59tl2Ur7W5QJ6ONwTsVzNYUPz9Bcm2Zl96q+MFvySuYgiqp/aIGINPKWCRdEmlTxHy6Jlcyod+ohWCT+Oxt9ZRPt7+tJeNAMxnhsATkScimdCGqGGNek8QmkuJR+4sKm0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y+ffchsI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y+ffchsI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDD72C4CEDF;
	Tue, 21 Jan 2025 18:04:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737482674;
	bh=qe3OX2k8EkjZRYVCZQB4VscNIqlfyFyU5pi2VoKKkxI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y+ffchsI6MkCxvXSzMfjMq0R3iHXdrPydjGxNWK8hQ4YadfLczv8xqfwLhgg5T4ZK
	 6tp3DMCqeTJwDNHmqRtUeNptbFP2x8bqArbt1mgNgBYRn2CIu20VnISbn9IsbsaHj8
	 /asb1UMS3One881/iEueL2NmmwMiXSVO1tiU6NNk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 09/64] nfp: bpf: prevent integer overflow in nfp_bpf_event_output()
Date: Tue, 21 Jan 2025 18:52:08 +0100
Message-ID: <20250121174521.921866271@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174521.568417761@linuxfoundation.org>
References: <20250121174521.568417761@linuxfoundation.org>
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

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit 16ebb6f5b6295c9688749862a39a4889c56227f8 ]

The "sizeof(struct cmsg_bpf_event) + pkt_size + data_size" math could
potentially have an integer wrapping bug on 32bit systems.  Check for
this and return an error.

Fixes: 9816dd35ecec ("nfp: bpf: perf event output helpers support")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Link: https://patch.msgid.link/6074805b-e78d-4b8a-bf05-e929b5377c28@stanley.mountain
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/netronome/nfp/bpf/offload.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/netronome/nfp/bpf/offload.c b/drivers/net/ethernet/netronome/nfp/bpf/offload.c
index 9d97cd281f18e..c03558adda91e 100644
--- a/drivers/net/ethernet/netronome/nfp/bpf/offload.c
+++ b/drivers/net/ethernet/netronome/nfp/bpf/offload.c
@@ -458,7 +458,8 @@ int nfp_bpf_event_output(struct nfp_app_bpf *bpf, const void *data,
 	map_id_full = be64_to_cpu(cbe->map_ptr);
 	map_id = map_id_full;
 
-	if (len < sizeof(struct cmsg_bpf_event) + pkt_size + data_size)
+	if (size_add(pkt_size, data_size) > INT_MAX ||
+	    len < sizeof(struct cmsg_bpf_event) + pkt_size + data_size)
 		return -EINVAL;
 	if (cbe->hdr.ver != NFP_CCM_ABI_VERSION)
 		return -EINVAL;
-- 
2.39.5



