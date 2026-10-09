Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFEF53C9893;
	Fri,  9 Oct 2026 14:34:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556502; cv=none; b=Q+NnrI/GE2oEEhTFT8pHU8C66s+tFWAEL+W7pEhG4wlg/uPQgTpcAML56HGI5iQdAeFh6Dtt99YSopKx21uRqKMWVGIXkDtSDi+cwy3bnX/RKpSuLSXxFVnznRiY2CuBzJGZBj3UC9EtXf1H6nmoH27uNmUdsi1aGvUfiXogmCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556502; c=relaxed/simple;
	bh=qJmFVCqivo+lmAo0s/75cJOiWqjjZlxCe6xjV0XeBm8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YWWSgrX5tlEVYyOiXvGqYZQxbhU4Z+axf0e09QnH7uV6Js0XzTpaoys8L20TZ9dzmaBd53cbCpAEnFXaE1UPANRUNEFxlZO5UlsWw1IDKNk4jQET+COkcXHnBYTh/p4K8eutspbYSaAknbtZRTBMjxi/eqTO5C0+/RSooql8zIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AQOP6TpF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AQOP6TpF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 191DE1F000FF;
	Fri,  9 Oct 2026 14:34:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556499;
	bh=JI0denhpjK6tglKnXkL6xo4V6Dqs70+57VVcjIZegt8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AQOP6TpFn2/Ps3ouszcIMVmV5o6UB+HIx6j6cA3cTVwtKWBR++RcW0ZkEtbBlF6kn
	 PKGo3QBwidoHallPvaDGbnzCMmKttxyr5+gs7OR94ivH5CCV707pn3L8gZFgjfrQgO
	 INEoE9ql5/HLEM7x9VfTfCTtfpLLkS9mFC3lM5yE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Daehyeon Ko <4ncienth@gmail.com>,
	Keith Busch <kbusch@kernel.org>
Subject: [PATCH 6.18 245/403] nvme-multipath: fix underflow in ANA log bounds checks
Date: Fri,  9 Oct 2026 16:10:06 +0200
Message-ID: <20261009140957.896078506@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daehyeon Ko <4ncienth@gmail.com>

commit 63fa2d9c9c37020bd2703fe2a6a38027b5abeb15 upstream.

The number of ANA groups advertised through Identify Controller sizes the
ANA log buffer. The ANA log header and group descriptors independently
supply the number of groups and namespace IDs to parse.

Both bounds checks subtract an untrusted object size from ana_log_size
before comparing the current offset. If the object is larger than the
buffer, the size_t subtraction underflows and lets the parser read beyond
ana_log_buf.

Check the current offset before the first subtraction and compare each
object size with the remaining buffer instead. This rejects inconsistent
ANA data before dereferencing a truncated group descriptor or walking an
oversized namespace ID array.

Fixes: 0d0b660f214d ("nvme: add ANA support")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Daehyeon Ko <4ncienth@gmail.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvme/host/multipath.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/nvme/host/multipath.c
+++ b/drivers/nvme/host/multipath.c
@@ -834,7 +834,8 @@ static int nvme_parse_ana_log(struct nvm
 		u32 nr_nsids;
 		size_t nsid_buf_size;
 
-		if (WARN_ON_ONCE(offset > ctrl->ana_log_size - sizeof(*desc)))
+		if (WARN_ON_ONCE(offset > ctrl->ana_log_size ||
+				 sizeof(*desc) > ctrl->ana_log_size - offset))
 			return -EINVAL;
 
 		nr_nsids = le32_to_cpu(desc->nnsids);
@@ -850,7 +851,7 @@ static int nvme_parse_ana_log(struct nvm
 			return -EINVAL;
 
 		offset += sizeof(*desc);
-		if (WARN_ON_ONCE(offset > ctrl->ana_log_size - nsid_buf_size))
+		if (WARN_ON_ONCE(nsid_buf_size > ctrl->ana_log_size - offset))
 			return -EINVAL;
 
 		error = cb(ctrl, desc, data);


