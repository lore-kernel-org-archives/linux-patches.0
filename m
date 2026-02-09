Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2ADF37B409;
	Mon,  9 Feb 2026 14:52:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770648732; cv=none; b=qnPMQ4GuP4OHNlIv2Uo7U+pIMkvLmARto5d3TWMnkWxyIJYlzgxIXUzAkDWVONNa1gSWh6KIkzxdMWsaReB1PNVYs5dXw16E7H2pXsm1Tumwo4J22/8YEYBv4YdUJmSBahhEJGogkMstky4OKoMEVPeV04cZ63PlMYh46xxi4CY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770648732; c=relaxed/simple;
	bh=5zRwebnF3bto3RifpwM9+8/aJPk+KQWDYxVwpOy1kLQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=INp375ByyaveipXAfMsZVpKwAJ8BLFAIfGnVlDEgqDkSRBGbh1H1uKlRWQHxUBtb083YAsqxUXwnxeiNPtDpm349z32yxVuIT2EQV6eAFVGD6nf3n0wwj2vnH5xlMZRP+fk9Eii/HjuuXN0dMC3/WiueWTBtml1qfkThpW9OhrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uvBy9RNi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uvBy9RNi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4054DC116C6;
	Mon,  9 Feb 2026 14:52:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770648732;
	bh=5zRwebnF3bto3RifpwM9+8/aJPk+KQWDYxVwpOy1kLQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uvBy9RNi3GZ0N3dxnbp6ab/vDU9YpTDl/QY6h0GLbHBgF9jzOze/zXJvwGD0kZuwa
	 1Yi+XEfVohMUXCRh2BhjXuJRdEYFO8GLvksGpccOeqMpDKK4Te5pibJEn7RWTl2zEx
	 gUg+wkNjs3e18LNPmlR3gbSzl6XpV4fycUqJgOjs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rakshana Sridhar <rakshanas@chelsio.com>,
	Varun Prakash <varun@chelsio.com>,
	Sagi Grimberg <sagi@grimberg.me>,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>
Subject: [PATCH 5.10 41/41] nvmet-tcp: pass iov_len instead of sg->length to bvec_set_page()
Date: Mon,  9 Feb 2026 15:25:02 +0100
Message-ID: <20260209142258.308006560@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142256.797267956@linuxfoundation.org>
References: <20260209142256.797267956@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Varun Prakash <varun@chelsio.com>

commit 1f0bbf28940cf5edad90ab57b62aa8197bf5e836 upstream.

iov_len is the valid data length, so pass iov_len instead of sg->length to
bvec_set_page().

Fixes: 5bfaba275ae6 ("nvmet-tcp: don't map pages which can't come from HIGHMEM")
Signed-off-by: Rakshana Sridhar <rakshanas@chelsio.com>
Signed-off-by: Varun Prakash <varun@chelsio.com>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvme/target/tcp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/nvme/target/tcp.c
+++ b/drivers/nvme/target/tcp.c
@@ -329,7 +329,7 @@ static void nvmet_tcp_build_pdu_iovec(st
 		}
 
 		iov->bv_page = sg_page(sg);
-		iov->bv_len = sg->length;
+		iov->bv_len = iov_len;
 		iov->bv_offset = sg->offset + sg_offset;
 
 		length -= iov_len;


