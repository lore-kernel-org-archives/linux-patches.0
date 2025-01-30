Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD9091E3772;
	Thu, 30 Jan 2025 14:19:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738246766; cv=none; b=BWUDrDjqS2/Tnif3QjWzM1ijXbpPh/dD0hY9CD9/xcV7HXIQv4Xxmpd/nK2LCBrwvZ06jU74ZknnLwG7pK06h+3QtMN73TAeVDgLUoLFa2KBBF8gDoe2RfLwYFTNq7QXynFT4HQnSnDfXoUsl/XFfHs7vkftW+iVSyXAgZuBOHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738246766; c=relaxed/simple;
	bh=1ye3U2HpcEeyubcy2la6UmMS2LK4r/oaGnNiwTnt008=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UZpQ0Rfxtj9L/G9PD2qcQYL9vPxDeXUIxQuCvr1v7eIufb9cb1iCkWOm5IYNGVPdtIaF6yzLQx2uoToaU4GAjAJR+8Ay9063pb4vyQx3wwNokE/+oCOzMUC2p9b6WzS5IC2Bj/p14M+p8XBJ5ZRwGhspwfyQZIbuKVdkGKgUB1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MLE8efia; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MLE8efia"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9E24C4CEE2;
	Thu, 30 Jan 2025 14:19:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738246765;
	bh=1ye3U2HpcEeyubcy2la6UmMS2LK4r/oaGnNiwTnt008=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MLE8efiaIXsi/oe4WeouuYeFlkPTlj09DjD6f7pIG8ymK6p/ClRkERQzyggI9cBWn
	 iVMF7CJhuaBGd3/xiE0+APidFvCx0c5Y3p19Yigcoox9xYm1ctnBH2OlGn6Hrs0z6H
	 wjbEIxD24Wi5FTSEMuHOH38ddveYGNKlKdR2UeEs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 60/91] nfp: bpf: prevent integer overflow in nfp_bpf_event_output()
Date: Thu, 30 Jan 2025 15:01:19 +0100
Message-ID: <20250130140136.076379228@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130140133.662535583@linuxfoundation.org>
References: <20250130140133.662535583@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 7ff388ecc7e3a..409b636c76474 100644
--- a/drivers/net/ethernet/netronome/nfp/bpf/offload.c
+++ b/drivers/net/ethernet/netronome/nfp/bpf/offload.c
@@ -454,7 +454,8 @@ int nfp_bpf_event_output(struct nfp_app_bpf *bpf, const void *data,
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



