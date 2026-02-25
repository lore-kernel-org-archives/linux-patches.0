Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF8D31D5141;
	Wed, 25 Feb 2026 01:42:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983722; cv=none; b=KAmHQ0Aj3LpjmDByJEvCdTaPC0ES5WTWc5D012ew3vKn8kqZotIQb2UyT+UJQMHZRA3vXkD2cMTS0KnqrhdSp87IQ61wr//8EhwSuY2ZPrz1Yu/s1RPglvgKeiIfMnwIombTGfLaunjz5apdqZ67HefchsjrXbJ/lpFNLGlPNI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983722; c=relaxed/simple;
	bh=QeTEYCHNKAMoXnIY/Yhge/lBbPcGfjPP7fTWHK/+g9I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fowgymDqbGpSZKWSxVZmzKY+2qQaHOREBsxWhqBVN/5gyk272wDvKewe3rhrxI4ofU2qywNEL/9BzVtg2pYq98rjgwQzRo3r43+fsIUppBFtMWsupHmryFBCg2VhxeukYvrED0Fq7qKzVxbAwAGkUpbt/Y7xiZrs9SB6zgsi5IU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ER2D4jIk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ER2D4jIk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B68B4C19424;
	Wed, 25 Feb 2026 01:42:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983722;
	bh=QeTEYCHNKAMoXnIY/Yhge/lBbPcGfjPP7fTWHK/+g9I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ER2D4jIkdzlRpjbiG9W4dzyjB2tHwa8lEsLlSOShmZNWg4QuKevM+eAvvkplws3NJ
	 O7UBbVulwF6Xs2XDqm9cpGEWvrXc4rtPMBTQFHQ4KtdHIzaCUxOWHLMRxHq00mRD/F
	 jH6ctbOZgGp2chUM85zBE8efk2CEPcltOasxnrIc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	YunJe Shin <ioerts@kookmin.ac.kr>,
	Leon Romanovsky <leon@kernel.org>
Subject: [PATCH 6.18 002/641] RDMA/umad: Reject negative data_len in ib_umad_write
Date: Tue, 24 Feb 2026 17:15:28 -0800
Message-ID: <20260225012348.986046651@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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

From: YunJe Shin <yjshin0438@gmail.com>

commit 5551b02fdbfd85a325bb857f3a8f9c9f33397ed2 upstream.

ib_umad_write computes data_len from user-controlled count and the
MAD header sizes. With a mismatched user MAD header size and RMPP
header length, data_len can become negative and reach ib_create_send_mad().
This can make the padding calculation exceed the segment size and trigger
an out-of-bounds memset in alloc_send_rmpp_list().

Add an explicit check to reject negative data_len before creating the
send buffer.

KASAN splat:
[  211.363464] BUG: KASAN: slab-out-of-bounds in ib_create_send_mad+0xa01/0x11b0
[  211.364077] Write of size 220 at addr ffff88800c3fa1f8 by task spray_thread/102
[  211.365867] ib_create_send_mad+0xa01/0x11b0
[  211.365887] ib_umad_write+0x853/0x1c80

Fixes: 2be8e3ee8efd ("IB/umad: Add P_Key index support")
Signed-off-by: YunJe Shin <ioerts@kookmin.ac.kr>
Link: https://patch.msgid.link/20260203100628.1215408-1-ioerts@kookmin.ac.kr
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/infiniband/core/user_mad.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/infiniband/core/user_mad.c
+++ b/drivers/infiniband/core/user_mad.c
@@ -514,7 +514,8 @@ static ssize_t ib_umad_write(struct file
 	struct rdma_ah_attr ah_attr;
 	struct ib_ah *ah;
 	__be64 *tid;
-	int ret, data_len, hdr_len, copy_offset, rmpp_active;
+	int ret, hdr_len, copy_offset, rmpp_active;
+	size_t data_len;
 	u8 base_version;
 
 	if (count < hdr_size(file) + IB_MGMT_RMPP_HDR)
@@ -588,7 +589,10 @@ static ssize_t ib_umad_write(struct file
 	}
 
 	base_version = ((struct ib_mad_hdr *)&packet->mad.data)->base_version;
-	data_len = count - hdr_size(file) - hdr_len;
+	if (check_sub_overflow(count, hdr_size(file) + hdr_len, &data_len)) {
+		ret = -EINVAL;
+		goto err_ah;
+	}
 	packet->msg = ib_create_send_mad(agent,
 					 be32_to_cpu(packet->mad.hdr.qpn),
 					 packet->mad.hdr.pkey_index, rmpp_active,


