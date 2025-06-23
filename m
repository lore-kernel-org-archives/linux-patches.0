Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21C2B19049B;
	Mon, 23 Jun 2025 22:05:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750716309; cv=none; b=FDFs3w30rbZsUdtn4xYZPhyBgwV9wF08qw6eYvCO5sUP+7k3shgR941GP/hMjCEFrAKUTbUWs6NIW+whCGW0GnZVcUyHMm+2+26uH60I/ZKl25a4mZxKRY+ddeLAgikZPawsXVu/uon8Xes4PB2PsDs2h//mI/UFjBcEwX3IaT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750716309; c=relaxed/simple;
	bh=2xYohnZv0S2BG9OUEXS2t1e4z9HMQsIQ7/HPI75UpTk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IfuIp1qTZGvFOcqzBenTUIlKd89LYx/W6Xq4NiGWBNoO9QpMD5tZ+sup7Zz4skRF7geN0sC3X0oRU3gxmtfX39uweMV0VRLUqzORbD3Ix2EMiZvTMpca3Bm78bIr46IaQEbXaPcSvqGoIusrGyVvvfTC3nR2IOuwPXBmAXrfocs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EiFPTDS1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EiFPTDS1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2CB2C4CEEA;
	Mon, 23 Jun 2025 22:05:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750716309;
	bh=2xYohnZv0S2BG9OUEXS2t1e4z9HMQsIQ7/HPI75UpTk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EiFPTDS1sAQrO1kEqueKw4h/A4Xw1TOkVKBOT7D3qxq1tg0J4B7kNs+aYpPp8Msrg
	 1RZV+qBtJeM5iTEOxhV+KyUDpS4CsPrbSiB+0gYkk413loBZPj9zwGJWuHS72Rulb0
	 S45IogSis3VIhAiZb/UV3EKJ84YnX+ujN1u9xz50=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.1 294/508] io_uring: account drain memory to cgroup
Date: Mon, 23 Jun 2025 15:05:39 +0200
Message-ID: <20250623130652.516075126@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
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

From: Pavel Begunkov <asml.silence@gmail.com>

commit f979c20547e72568e3c793bc92c7522bc3166246 upstream.

Account drain allocations against memcg. It's not a big problem as each
such allocation is paired with a request, which is accounted, but it's
nicer to follow the limits more closely.

Cc: stable@vger.kernel.org # 6.1
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/f8dfdbd755c41fd9c75d12b858af07dfba5bbb68.1746788718.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/io_uring.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1654,7 +1654,7 @@ queue:
 	spin_unlock(&ctx->completion_lock);
 
 	io_prep_async_link(req);
-	de = kmalloc(sizeof(*de), GFP_KERNEL);
+	de = kmalloc(sizeof(*de), GFP_KERNEL_ACCOUNT);
 	if (!de) {
 		ret = -ENOMEM;
 		io_req_complete_failed(req, ret);


