Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE45E3F825C;
	Tue, 21 Jul 2026 17:24:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654697; cv=none; b=fb0HVY4IiLHiAiK4OqXKy+rfv7GY7rVOpinbVyuEZ9/dmBJjnSyNfG84OTPXrggRZAIkigBPL6YK9IRfyOIsAwLMy3nwairyoGMV4VB92fmFL+2/qno56OIEmo+RHf4SCDEZ6CH/5PET+x9OeJLl0t/hUsT1SB1/hzHRtc+TgIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654697; c=relaxed/simple;
	bh=RCNZj5QnAtpBc8g0AtUq6MuNhw+tj7siGHH9ZxoRODE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CAfen1d4c94y+ET7CujKZQBamj7WsY3/mTpl1P4QgNvGK0rFajqlIO3vXOSzBBeSe/QPRWjWgnbG2/N0QUfzmtHU+n5Sb+FMg53fDy5ce2SdHIITzCDrDZDgE77IOXtFYQd8DYdGmy4nk2ZIiMFrFQfx7peP/WfGfAoVyO5GUoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ek/l2Hv9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ek/l2Hv9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AD7F1F000E9;
	Tue, 21 Jul 2026 17:24:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654696;
	bh=0R4HK7jjiVF0hpnFSzwDHQVpN4NCgyV+JX7q/1UtiZY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ek/l2Hv9ROHGECBO3bHiLsIAICiIu/SIoI9lVDrpKyZlMnj+LyQDkuVqZqJPnXskk
	 oFr2q0OiNJKkVD/zWIF/0pzH1jVJSwxFiqmx0ATLfdWe+LmxeyFCB6qD5hwofD2omN
	 cl3F5JaDzeeBl5RqjUYGohd92e/lB8zF/A2Ck67c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Alba Vives <sebasjosue84@gmail.com>,
	Xu Yilun <yilun.xu@intel.com>,
	Xu Yilun <yilun.xu@linux.intel.com>
Subject: [PATCH 7.1 1760/2077] fpga: microchip-spi: fix zero header_size OOB read in mpf_ops_parse_header()
Date: Tue, 21 Jul 2026 17:23:53 +0200
Message-ID: <20260721152634.258787435@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sebastian Alba Vives <sebasjosue84@gmail.com>

commit 43a1974da6bc7ce8f4d1dc1d03d56997428c29c3 upstream.

mpf_ops_parse_header() reads header_size from the bitstream at
MPF_HEADER_SIZE_OFFSET (24). When header_size is zero, the expression
*(buf + header_size - 1) reads one byte before the buffer start.

Since initial_header_size is set to 71 in mpf_ops, the fpga-mgr core
guarantees the buffer is large enough to reach MPF_HEADER_SIZE_OFFSET.
The only real gap is the zero header_size case, which cannot be
resolved by providing a larger buffer, so return -EINVAL.

Fixes: 5f8d4a900830 ("fpga: microchip-spi: add Microchip MPF FPGA manager")
Cc: stable@vger.kernel.org
Signed-off-by: Sebastian Alba Vives <sebasjosue84@gmail.com>
Reviewed-by: Xu Yilun <yilun.xu@intel.com>
Link: https://lore.kernel.org/r/20260518190742.61426-4-sebasjosue84@gmail.com
Signed-off-by: Xu Yilun <yilun.xu@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/fpga/microchip-spi.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/fpga/microchip-spi.c
+++ b/drivers/fpga/microchip-spi.c
@@ -116,6 +116,9 @@ static int mpf_ops_parse_header(struct f
 	}
 
 	header_size = *(buf + MPF_HEADER_SIZE_OFFSET);
+	if (!header_size)
+		return -EINVAL;
+
 	if (header_size > count) {
 		info->header_size = header_size;
 		return -EAGAIN;


