Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046248;
	b=hdPT+KbdV05LPGqNNXZWVyD7ic2aLUYee7+aNODQEI0XWv8UzbSzEOzWMcprFdjTXcJe
	 gJ6ux/2ZmZZrnaLfiuli4rkVN5o8yFGpFX3NugsPNvCbe03Yv47S557wkygkssYJfMZ6s
	 XL8RlNoG3RSdj+1Q/c30i+ECYMfqds+ItP+6688Tsvgu9GTsaoJAzEvCDHJ7MZWjkYMGA
	 tymHvU4jf0YAnJ6OhHq2+eelMkwxdCAEfvW+oLE5sF0w7S7OCSweYNXeY6ri3nAgA5zdn
	 j05hIx1dbwe51gf16/I+TbMcSKrIB0JV54bTgSGEKY1hd/muAu+5pyTw6khzB5x7lXg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046248;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=49vbpSJa2isPfku7XznhncVe4Ye+hfnf9QXdxDjPaL4=;
	b=LrL8J7MRvCr6SR0/blitYSfWXI3WoOd+s8LeYXLBXs1+bA9+6dtLmW2zyl/M5ZqvoX1t
	 5qQwxA7EBwrazfDM8h7NqxHLq4/7hSEwAonEQRQ4cbp+zqA2MvyPgzfgbNZaeSy2vkwWr
	 fS46Njar7Hm8zFRgVi9cVXhWuxCQavy+zunMNGkr6R0FipKRoNldg2gK28D6JnVhZ53mC
	 gwYf19pvFeH6ZyAFqXxTOGjycbbZCuD4RIVxr0/u0l1z3PcFoIL80jTyEJpbiplSuVgnG
	 eRUaT6wLnLT1YsqDkqKvWYTSFTRjEeb8igspogpMIijYt0WyEnI2OQ0JrFBXPH56NVg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yiTRiUqS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E996606A330;
	Wed, 18 Nov 2026 23:57:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yiTRiUqS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B007B1F000C8;
	Wed, 18 Nov 2026 23:57:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046248;
	bh=49vbpSJa2isPfku7XznhncVe4Ye+hfnf9QXdxDjPaL4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yiTRiUqSpujcuFHrqoBZiTSyziBiCl3Tc44ME3wiUKBG5hB2MLnU11/wi7ZDnqtbA
	 1pYhAN4nOpgDPCFEhRlc1oUsZShYFjogTYmYFeiNo6NPGchNE3tbqB8Jtnoio61RKu
	 uWDbU1S2QOA32//hk5FIrToQ0HjCGZSrxuGxXgt8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shao Mingyin <shao.mingyin@zte.com.cn>,
	Bodo Stroesser <bostroesser@gmail.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1214/2857] scsi: target: tcmu: Fix divide-by-zero in data_pages_per_blk store
Date: Wed, 18 Nov 2026 15:37:28 +0100
Message-ID: <20261118150245.295752993@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shao Mingyin <shao.mingyin@zte.com.cn>

[ Upstream commit b8d0bb6a8ba0d3878940a914a19336844101867b ]

tcmu_set_data_pages_per_blk() only validates the upper bound of the value
parsed from data_pages_per_blk=. Zero passes that check and is then used as
the divisor when computing udev->max_blocks:

  divide error: 0000 [#1] SMP
  ...
  tcmu_set_data_pages_per_blk
  tcmu_configure_device

Reject non-positive values, as the neighbouring max_data_area_mb and
cmd_ring_size setters already do.

Fixes: 08976cb548d6 ("scsi: target: tcmu: Make data_pages_per_blk changeable via configfs")
Signed-off-by: Shao Mingyin <shao.mingyin@zte.com.cn>
Cc: stable@vger.kernel.org
Reviewed-by: Bodo Stroesser <bostroesser@gmail.com>
Link: https://patch.msgid.link/20261026195245337ktSXy9G17VCcXyw760g9s@zte.com.cn
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/target/target_core_user.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index adf68323d0d68..be3eafc7fb4b7 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -2514,6 +2514,11 @@ static int tcmu_set_data_pages_per_blk(struct tcmu_dev *udev, substring_t *arg)
 		return ret;
 	}
 
+	if (val <= 0) {
+		pr_err("Invalid data_pages_per_blk %d.\n", val);
+		return -EINVAL;
+	}
+
 	if (val > TCMU_MBS_TO_PAGES(udev->data_area_mb)) {
 		pr_err("Invalid data_pages_per_blk %d: greater than max_data_area_mb %d -> %zd pages).\n",
 		       val, udev->data_area_mb,
-- 
2.53.0



