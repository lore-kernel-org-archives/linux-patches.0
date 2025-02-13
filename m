Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E69551CB31D;
	Thu, 13 Feb 2025 15:36:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739461009; cv=none; b=NCW6IAm/DpQZNCqT6n3lvaZzVi8cEJudz/WM25xFGnlAnpampfQSZUi8hK2s+DC6hGzjNjfkWCyo6fHjyFiGmK6OKRzJMyUQnzHEsyhWD9Xs85tPje3re4QRHjDxAPJ3HFTNHYDur3aMPSLdO8YqYPNrQmPu0z3+9/TcB3S0EwE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739461009; c=relaxed/simple;
	bh=c/V7JJlEgjH2Uh5tGnrj49JU+QIYlxMk0L0d8FSptHo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EndOnLM55/6x9bhcnnd1TYmc1od2b5liVxFhd+cFGQ5zil67aUo325G/Ozq8JKY2I00H2zmK9+x+jbVD27fe42b65uFmuNSzFGPNxs1rUB1vztp4kbLk+cVFqH/4pCUv3ybcTjBR9vCUVHgo/9UAshLcyM/D9qC0K33v50LK+bY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XU/kTmFd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XU/kTmFd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56863C4CED1;
	Thu, 13 Feb 2025 15:36:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739461008;
	bh=c/V7JJlEgjH2Uh5tGnrj49JU+QIYlxMk0L0d8FSptHo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XU/kTmFdacw1SKYZxnW78tTADshB56dnHT+P/FErZEJMg/CHULuwhJFSyRA1yJRT/
	 Yngd+XVKUG2/4/qOThQ9NRav1jurXt8hhLdNqRsTBGH8Q9na4VirHdQPAOAmqJ1gjM
	 2PEHXj00wmMlpwrEzVccxKtx5aLQzE/cyKMqkMBc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Ekansh Gupta <quic_ekangupt@quicinc.com>,
	Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: [PATCH 6.6 244/273] misc: fastrpc: Fix copy buffer page size
Date: Thu, 13 Feb 2025 15:30:16 +0100
Message-ID: <20250213142417.077997424@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142407.354217048@linuxfoundation.org>
References: <20250213142407.354217048@linuxfoundation.org>
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
@@ -1015,8 +1015,8 @@ static int fastrpc_get_args(u32 kernel,
 					(pkt_size - rlen);
 			pages[i].addr = pages[i].addr &	PAGE_MASK;
 
-			pg_start = (args & PAGE_MASK) >> PAGE_SHIFT;
-			pg_end = ((args + len - 1) & PAGE_MASK) >> PAGE_SHIFT;
+			pg_start = (rpra[i].buf.pv & PAGE_MASK) >> PAGE_SHIFT;
+			pg_end = ((rpra[i].buf.pv + len - 1) & PAGE_MASK) >> PAGE_SHIFT;
 			pages[i].size = (pg_end - pg_start + 1) * PAGE_SIZE;
 			args = args + mlen;
 			rlen -= mlen;


