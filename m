Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D34C3446C7;
	Mon,  9 Feb 2026 14:56:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770648986; cv=none; b=tzSdFOGyuwjjo0dEqiBzeerYZsiKn5TkRCWl+sUMGYMFfC4kmigiH7OamotJtHXf5m+nwQlMvGsb4kZuPF4CJFI70NeRUo70ANfrjicP8pDj9fJ5Kroba0Q/VwM6hDqiKEspx2ihqa6UqDzH9cl8Hddz6ecNqBsV25O3/pe2eIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770648986; c=relaxed/simple;
	bh=YjJ07m9XOJ6pt8cHeECRYasaHIzgpDUllDuzz2lAWGg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WgBdhfPz8rNZEi69cQ9WpJ85RgiMhRNqC4cHK+XOrl+O3zdcp1UCHmxwdiY8xQyTmlGY+rCLyc6xXduiOo5P1GiWrHt4TCt1l1slFahVCC56c5jUEpVvQ8ASgG5ELsVP1DBYYRXlw9xoPnUTQ9L8ZgmwX5TRxMiPck43Dv615io=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b/4Fwjs0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b/4Fwjs0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16F18C116C6;
	Mon,  9 Feb 2026 14:56:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770648986;
	bh=YjJ07m9XOJ6pt8cHeECRYasaHIzgpDUllDuzz2lAWGg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b/4Fwjs0e8Vf1K7VoGL1GRDfNTgGJc//CzCzMY2uJaXl5l+VXaNRM2s9dqqwWQ5sz
	 AtD5VPQ9uxxc2wS/3ka0/28p0hR2585guz1ov/4jeHR+nWG6KDI3oIvi9Ufn8S/cBq
	 FW72D+/AOz3skZK0vRZz/Hfkv/XzwENioZdTbOn0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rakshana Sridhar <rakshanas@chelsio.com>,
	Varun Prakash <varun@chelsio.com>,
	Sagi Grimberg <sagi@grimberg.me>,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>
Subject: [PATCH 5.15 75/75] nvmet-tcp: pass iov_len instead of sg->length to bvec_set_page()
Date: Mon,  9 Feb 2026 15:25:12 +0100
Message-ID: <20260209142304.557339475@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142301.830618238@linuxfoundation.org>
References: <20260209142301.830618238@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -341,7 +341,7 @@ static void nvmet_tcp_build_pdu_iovec(st
 		}
 
 		iov->bv_page = sg_page(sg);
-		iov->bv_len = sg->length;
+		iov->bv_len = iov_len;
 		iov->bv_offset = sg->offset + sg_offset;
 
 		length -= iov_len;


