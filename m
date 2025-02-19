Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 189AD1DE4C6;
	Wed, 19 Feb 2025 09:26:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739957181; cv=none; b=EG6e2kkRAf5CzitehnFD3jlxGNN/vUCt2i5IDV9R1/IoqEpavr6tiogRCGiHgZ0/aY9oO92J2a7J0ZpL0hnwV9XQwGO9Z/eu6T4ehjwzYr6mfnDLU7EzMMyB0eX2eEWGElvwdbajXeRcMWARs9yBb2tFc7AxUsNju/ZU9iU6m5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739957181; c=relaxed/simple;
	bh=5LSYFfR1uY5WYLVtUHpIxvTGinuWTPiLdOyGU7pOg54=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mJVgylzFQ2vNpINt7GVPvE6jMvZM0KLi9RHXxsRNx4Zd389vGy+2bFqWZXi+hD/RamZn8MwrMQsl0g1+R2Ig3nHTyMZ5bpZE8qUqr/yxsNZXGDFP6XoROgI60o7PL/dS95VJxbYMqLUVnIdp5zVvQ+KQrYpL39AL15OxxUmb66A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LC/Gpfgh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LC/Gpfgh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89E00C4CED1;
	Wed, 19 Feb 2025 09:26:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739957180;
	bh=5LSYFfR1uY5WYLVtUHpIxvTGinuWTPiLdOyGU7pOg54=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LC/Gpfgh6hfdo5xGLABr3XW0TpR/RXXtAgAo3Wm+0YrRnJ5WKdkDLtgR8J13b9QBp
	 Sn18Wq5gvbrY/6mHw4bcPTDCe4Or8W9A5wtocZ+VzKW/p/svcOGdlYsBjFyI6KeB2h
	 NYy9jw9oeKcL+7F1R1StfLqyd4GIv2+v7qQG+Yic=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Ekansh Gupta <quic_ekangupt@quicinc.com>,
	Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: [PATCH 6.1 436/578] misc: fastrpc: Fix copy buffer page size
Date: Wed, 19 Feb 2025 09:27:20 +0100
Message-ID: <20250219082710.161256753@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

From: Ekansh Gupta <quic_ekangupt@quicinc.com>

commit e966eae72762ecfdbdb82627e2cda48845b9dd66 upstream.

For non-registered buffer, fastrpc driver copies the buffer and
pass it to the remote subsystem. There is a problem with current
implementation of page size calculation which is not considering
the offset in the calculation. This might lead to passing of
improper and out-of-bounds page size which could result in
memory issue. Calculate page start and page end using the offset
adjusted address instead of absolute address.

Fixes: 02b45b47fbe8 ("misc: fastrpc: fix remote page size calculation")
Cc: stable@kernel.org
Signed-off-by: Ekansh Gupta <quic_ekangupt@quicinc.com>
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20250110134239.123603-4-srinivas.kandagatla@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/fastrpc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/misc/fastrpc.c
+++ b/drivers/misc/fastrpc.c
@@ -961,8 +961,8 @@ static int fastrpc_get_args(u32 kernel,
 					(pkt_size - rlen);
 			pages[i].addr = pages[i].addr &	PAGE_MASK;
 
-			pg_start = (args & PAGE_MASK) >> PAGE_SHIFT;
-			pg_end = ((args + len - 1) & PAGE_MASK) >> PAGE_SHIFT;
+			pg_start = (rpra[i].buf.pv & PAGE_MASK) >> PAGE_SHIFT;
+			pg_end = ((rpra[i].buf.pv + len - 1) & PAGE_MASK) >> PAGE_SHIFT;
 			pages[i].size = (pg_end - pg_start + 1) * PAGE_SIZE;
 			args = args + mlen;
 			rlen -= mlen;


