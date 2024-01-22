Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 228155732A;
	Tue, 23 Jan 2024 00:44:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970661; cv=none; b=IDdvaMEkT6S7xqZPNhxbmeU7rK3yE9GNpPOWEwZO6ZIFZPMwmI7TTbiwFc4NmZwVIxp75EYSgX3irmmWhBIvmkxqNisrH+00RqmVCtS/6NvlflGmA580QSXIUUTD7VDC5mwhQde1TePDRMq0M30nHdpLq4a1nRYfbQAIXsMcpVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970661; c=relaxed/simple;
	bh=oFPErOmnTzGFyqg3vSDPVQyEZpX5NEtaE5eXtNpmv8E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fkv4J6CIf3zi9IBml0Hj63yYmk4q/Nj16TvM/MXzj6KC9oCv/F7PRmjY7SdvsGbKkrMWJBqhpauV/2bl6LkQ1z71GAg8YOLhUDkkCURBEk1AQjz2TIO2GQocWWdxFupceLw2fRb1dm6mD7CD+9qUR6WM1qzMzfUM3EYdE7lZKEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B998zwTE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B998zwTE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2868CC433F1;
	Tue, 23 Jan 2024 00:44:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705970661;
	bh=oFPErOmnTzGFyqg3vSDPVQyEZpX5NEtaE5eXtNpmv8E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B998zwTEEOd2YuJNIQNer3OzLa8MyJ+90ePqctz8V9qhKSE5iVvRabw8s29qUNUQU
	 nTw2ncGIcWlhKb7abFF7SuJN/k7yXXMUA6ZCNfXzmuS/4ElRiIOkI3tyV57AjmprIU
	 o2QUgzcY+x9fNG+iVzc561tP6uQYPT5Txo2CjRvA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeroen van Ingen Schenau <jeroen.vaningenschenau@novoserve.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Minh Le Hoang <minh.lehoang@novoserve.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 081/417] selftests/bpf: Fix erroneous bitmask operation
Date: Mon, 22 Jan 2024 15:54:09 -0800
Message-ID: <20240122235754.511663085@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235751.480367507@linuxfoundation.org>
References: <20240122235751.480367507@linuxfoundation.org>
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

From: Jeroen van Ingen Schenau <jeroen.vaningenschenau@novoserve.com>

[ Upstream commit b6a3451e0847d5d70fb5fa2b2a80ab9f80bf2c7b ]

xdp_synproxy_kern.c is a BPF program that generates SYN cookies on
allowed TCP ports and sends SYNACKs to clients, accelerating synproxy
iptables module.

Fix the bitmask operation when checking the status of an existing
conntrack entry within tcp_lookup() function. Do not AND with the bit
position number, but with the bitmask value to check whether the entry
found has the IPS_CONFIRMED flag set.

Fixes: fb5cd0ce70d4 ("selftests/bpf: Add selftests for raw syncookie helpers")
Signed-off-by: Jeroen van Ingen Schenau <jeroen.vaningenschenau@novoserve.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Tested-by: Minh Le Hoang <minh.lehoang@novoserve.com>
Link: https://lore.kernel.org/xdp-newbies/CAAi1gX7owA+Tcxq-titC-h-KPM7Ri-6ZhTNMhrnPq5gmYYwKow@mail.gmail.com/T/#u
Link: https://lore.kernel.org/bpf/20231130120353.3084-1-jeroen.vaningenschenau@novoserve.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/progs/xdp_synproxy_kern.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/bpf/progs/xdp_synproxy_kern.c b/tools/testing/selftests/bpf/progs/xdp_synproxy_kern.c
index 736686e903f6..26bfbc73d129 100644
--- a/tools/testing/selftests/bpf/progs/xdp_synproxy_kern.c
+++ b/tools/testing/selftests/bpf/progs/xdp_synproxy_kern.c
@@ -447,13 +447,13 @@ static __always_inline int tcp_lookup(void *ctx, struct header_pointers *hdr, bo
 		unsigned long status = ct->status;
 
 		bpf_ct_release(ct);
-		if (status & IPS_CONFIRMED_BIT)
+		if (status & IPS_CONFIRMED)
 			return XDP_PASS;
 	} else if (ct_lookup_opts.error != -ENOENT) {
 		return XDP_ABORTED;
 	}
 
-	/* error == -ENOENT || !(status & IPS_CONFIRMED_BIT) */
+	/* error == -ENOENT || !(status & IPS_CONFIRMED) */
 	return XDP_TX;
 }
 
-- 
2.43.0



