Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B582E33EC
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:01:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34B32C433D2;
	Mon, 16 Jan 2023 16:01:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673884861;
	bh=dlFOpmziZRUU5m6MsqiE3Wyh+VArNTtiq7v1LckFR1c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1igfvXJqdnmBPnvcStupSkSP9+qQDa208l4SUFbtmtDUYDtnXbjpt5tj24c7ZmTdF
	 ejERdztrc/3TmYfDVbBbVIx5gIyylyH9slArxBg9KJ00+XW1j50roFp8IMDYG0CXxk
	 Pm8bkhhTELGfkc4mQAmoNtEXf4RzpJyV0JsPpZg4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuan Can <yuancan@huawei.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Gurucharan G <gurucharanx.g@intel.com>
Subject: [PATCH 6.1 139/183] ice: Fix potential memory leak in ice_gnss_tty_write()
Date: Mon, 16 Jan 2023 16:51:02 +0100
Message-Id: <20230116154809.234797075@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154803.321528435@linuxfoundation.org>
References: <20230116154803.321528435@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yuan Can <yuancan@huawei.com>

[ Upstream commit f58985620f55580a07d40062c4115d8c9cf6ae27 ]

The ice_gnss_tty_write() return directly if the write_buf alloc failed,
leaking the cmd_buf.

Fix by free cmd_buf if write_buf alloc failed.

Fixes: d6b98c8d242a ("ice: add write functionality for GNSS TTY")
Signed-off-by: Yuan Can <yuancan@huawei.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Tested-by: Gurucharan G <gurucharanx.g@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_gnss.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/intel/ice/ice_gnss.c b/drivers/net/ethernet/intel/ice/ice_gnss.c
index b5a7f246d230..a1915551c69a 100644
--- a/drivers/net/ethernet/intel/ice/ice_gnss.c
+++ b/drivers/net/ethernet/intel/ice/ice_gnss.c
@@ -363,6 +363,7 @@ ice_gnss_tty_write(struct tty_struct *tty, const unsigned char *buf, int count)
 	/* Send the data out to a hardware port */
 	write_buf = kzalloc(sizeof(*write_buf), GFP_KERNEL);
 	if (!write_buf) {
+		kfree(cmd_buf);
 		err = -ENOMEM;
 		goto exit;
 	}
-- 
2.35.1



