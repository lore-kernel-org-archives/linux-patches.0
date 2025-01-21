Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F99D1F707D;
	Tue, 21 Jan 2025 18:10:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737483011; cv=none; b=t1x3/sCjRT7em81hUtqFzDSReA1K+apQBEJ5fWDVaJqezRaMuaAhiPTrpZ3xpBMV3r+g3ROjVwnFGrKldSCZwJmxnJMOy4YT9GxMdq26B6BqdWZrxGwOqKGuoWYx/kJ6Q2ael1A1PxLtah0qt0DcgvxbbyJT997BeRSXr2wLqc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737483011; c=relaxed/simple;
	bh=7Dp73IrORN+wW1fNL/4FPq2Rs1Rk0w5qryUo8qrZFYE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I1JWpL2vmbwtUKDxRmgGjrbiqTou0eFWMJi6qCy5HFexKXlMXIBsT3jHFvqQVjG5TcpftT8BxDmVTZhGLk2rPYLSfreOM+Ae0A50pZIUKZgXRnZC4JkCyw6jt6VHjBtkLFfltf8rXucTpc3L3AsByo4HFHbG4HFcYH4U43rex1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qOVpR9gj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qOVpR9gj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 076DCC4CEE1;
	Tue, 21 Jan 2025 18:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737483011;
	bh=7Dp73IrORN+wW1fNL/4FPq2Rs1Rk0w5qryUo8qrZFYE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qOVpR9gjp/Kjuk+o/W/QGcoQ4xMMdncSLJkpbmcCqvasZ9bbjKxJr1bKdg8kMeZcA
	 dkyQhg+zKNIwdanu8imb/Ca5SbFH9kZ1qgZJNPFq68560thQNo4kuJ1fBxtvXdFkGl
	 zlxYZJ1Wl+c+HLiVhv3ffm+h9tXfzYwXoHe/cKCE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 086/127] nfp: bpf: prevent integer overflow in nfp_bpf_event_output()
Date: Tue, 21 Jan 2025 18:52:38 +0100
Message-ID: <20250121174532.970690168@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174529.674452028@linuxfoundation.org>
References: <20250121174529.674452028@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



