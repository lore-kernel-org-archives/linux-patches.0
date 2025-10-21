Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8411C350A3C;
	Tue, 21 Oct 2025 20:02:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761076945; cv=none; b=FYou8J4/7+BuN8lA2uir6YtViWTzUgdNM+4xaG7ImUrCXXKmA6VGELzaEMYJspYPL1zYrVrpa22A3EIsoxX06XGT43tkgvhH7VItU1zH5txJf+eD2B0/Lsw65Hmno3vBOIQqMVir1fLv/7NI5x/zzMuGot6/vUuHsdwgSbyk9BA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761076945; c=relaxed/simple;
	bh=ndB22XhyFUgpeuX/Rfwlm9jd5t2Z6albEYNLoeMmplk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=idWs2sGVTHbVzkAXek7nt+N3HWp8WtPGkQMbKlklN6UDlc9DK2UgGnv1cHCk132+t7plUHPAY3K19IcCFhbasmYgV8kuirzjWXg3xi8LcGY41A0H6a+2aAjTfbAVfa0xu4lIhcl/ir4iebOvE7ZNNmSNhIkaQThYlUE6YAOciXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yNMxsFkO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yNMxsFkO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A79DC4CEF1;
	Tue, 21 Oct 2025 20:02:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761076945;
	bh=ndB22XhyFUgpeuX/Rfwlm9jd5t2Z6albEYNLoeMmplk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yNMxsFkO9LMvQHl7OULxdqagBcV+b7In91hevGvJ0wPi/6Ym/9oTNpGo9lY5EORUP
	 /S8z3AFRU01+8uR638TENEm99Z+AjMmXaqskjz3EuMmS3jIErwT0DM7EI37tltBDHG
	 vmlKBKf1/ZGTTU9ZzPz5H1DS3RmQPT2AKW1gs3bM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Youssef Samir <quic_yabdulra@quicinc.com>,
	Youssef Samir <youssef.abdulrahman@oss.qualcomm.com>,
	Jeff Hugo <jeff.hugo@oss.qualcomm.com>,
	Carl Vanderlip <carl.vanderlip@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 085/136] accel/qaic: Treat remaining == 0 as error in find_and_map_user_pages()
Date: Tue, 21 Oct 2025 21:51:13 +0200
Message-ID: <20251021195038.007797659@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195035.953989698@linuxfoundation.org>
References: <20251021195035.953989698@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Youssef Samir <quic_yabdulra@quicinc.com>

[ Upstream commit 11f08c30a3e4157305ba692f1d44cca5fc9a8fca ]

Currently, if find_and_map_user_pages() takes a DMA xfer request from the
user with a length field set to 0, or in a rare case, the host receives
QAIC_TRANS_DMA_XFER_CONT from the device where resources->xferred_dma_size
is equal to the requested transaction size, the function will return 0
before allocating an sgt or setting the fields of the dma_xfer struct.
In that case, encode_addr_size_pairs() will try to access the sgt which
will lead to a general protection fault.

Return an EINVAL in case the user provides a zero-sized ALP, or the device
requests continuation after all of the bytes have been transferred.

Fixes: 96d3c1cadedb ("accel/qaic: Clean up integer overflow checking in map_user_pages()")
Signed-off-by: Youssef Samir <quic_yabdulra@quicinc.com>
Signed-off-by: Youssef Samir <youssef.abdulrahman@oss.qualcomm.com>
Reviewed-by: Jeff Hugo <jeff.hugo@oss.qualcomm.com>
Reviewed-by: Carl Vanderlip <carl.vanderlip@oss.qualcomm.com>
Signed-off-by: Jeff Hugo <jeff.hugo@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20251007122320.339654-1-youssef.abdulrahman@oss.qualcomm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/accel/qaic/qaic_control.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/accel/qaic/qaic_control.c b/drivers/accel/qaic/qaic_control.c
index d8bdab69f8009..b86a8e48e731b 100644
--- a/drivers/accel/qaic/qaic_control.c
+++ b/drivers/accel/qaic/qaic_control.c
@@ -407,7 +407,7 @@ static int find_and_map_user_pages(struct qaic_device *qdev,
 		return -EINVAL;
 	remaining = in_trans->size - resources->xferred_dma_size;
 	if (remaining == 0)
-		return 0;
+		return -EINVAL;
 
 	if (check_add_overflow(xfer_start_addr, remaining, &end))
 		return -EINVAL;
-- 
2.51.0



