Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52B151F5421;
	Tue, 21 Jan 2025 17:54:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737482073; cv=none; b=jvnePoBwRp9NrziX03qDZ3uZQanv9klvyPWJsZ972luAOctD4ZEveqY+anGsHcbJs1zDyi2lx9qGhM0kpFOZ1e5u3Lv+x2SY+qk94/eX6KDA0RqKmqpTDQtJ0s0rN22Yhg01JcbxgzY/p50l5Iv4nxSGvzuy4CSpJSEbsiiCjy4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737482073; c=relaxed/simple;
	bh=m5UQ3R0QNsyK1GoXRrePok3GQOmacZk+iGQ4GJXiaJw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qjTdtpnu4z8svjUanIIWLQolNw/Ftpjh3r2VE3F0/HdzAlH4ATa0FGzAd7oeimMnT5gPsza7fQ5FZHNlz0FqFeEqOGBaEBXbjeNybAI6wLELqJov27poiKZSnXya+hFKI2JrOifYvnWA3Zdmko2klk7JhAIO/O9ydEgWsJE40DI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v0E1UQWn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v0E1UQWn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4ED32C4CEE1;
	Tue, 21 Jan 2025 17:54:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737482072;
	bh=m5UQ3R0QNsyK1GoXRrePok3GQOmacZk+iGQ4GJXiaJw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v0E1UQWnN8epPT9eUBLXVbYWGNsyLVjToUzKqRXbkKlcg7lDWWv3dbXKysovfz44N
	 CZ0wdO9gsN6+pnR9G2HeuKgO8jQ9zkTo4LaxFVdYhZxEfQnrA5ad/qG+nAKc9Vg/f/
	 oYjXZUOFt7wRXn6NOHm0bFfrr0nA9cByKF9L5JQg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 09/72] nfp: bpf: prevent integer overflow in nfp_bpf_event_output()
Date: Tue, 21 Jan 2025 18:51:35 +0100
Message-ID: <20250121174523.787542389@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174523.429119852@linuxfoundation.org>
References: <20250121174523.429119852@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



