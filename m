Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EE15E555;
	Thu, 15 Jan 2026 17:43:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768498984; cv=none; b=RecZToII3R3qZV9Gljo/OwvhUcFBGuZs0dpv9BZ1hvQziWfDL4A1Ox9Bt45yy3AScWTzOmiJEHp26rjy1fLBt7qFxjQB4bp+xN/tAuNdeUT7cqASa/HGLlZQ0X8cOlr+mzmxCj1GBIa34kKnZ19q324A4YZxw37G4OqmKyiPKrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768498984; c=relaxed/simple;
	bh=JX1tmltUU/Ewean0fBovDGpBt+iOHBhdfbCURMK44rs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sA0C/TkiA4rFOBaCvNirdz3eGRCngcPk3ZfclWaA1ZETtuWFMKxH0mZIBBQ3RCztDJpQuiuqTTAqywjI4WCbCv1+FJicz7nUifOS3L7FSs1cvR4Wfeo3E52SCcdH7RmlNx7O19LKtQuBOC/l3CcTFwT6STqJP6vEn+2KNKpcpU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pbmQgNa+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pbmQgNa+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8006C116D0;
	Thu, 15 Jan 2026 17:43:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768498984;
	bh=JX1tmltUU/Ewean0fBovDGpBt+iOHBhdfbCURMK44rs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pbmQgNa+p27w/sd9sU2S5Dzlrf4AO+20E3EXFmPG7fF1PxAyOGGudcXGtVHd/jqyR
	 kjvtuUfVxnzzWWhSOeOgm630jZfEcd5+0Hxi0N0RyN5SSws/pmFLDeHjAqDR8T/63k
	 37y1XZ/ukR3kKclHFBMm7wzjSINFER3+vrrNZyPM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zheng Qixing <zhengqixing@huawei.com>,
	Yu Kuai <yukuai@fnnas.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 068/451] nbd: defer config unlock in nbd_genl_connect
Date: Thu, 15 Jan 2026 17:44:29 +0100
Message-ID: <20260115164233.362608555@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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

From: Zheng Qixing <zhengqixing@huawei.com>

[ Upstream commit 1649714b930f9ea6233ce0810ba885999da3b5d4 ]

There is one use-after-free warning when running NBD_CMD_CONNECT and
NBD_CLEAR_SOCK:

nbd_genl_connect
  nbd_alloc_and_init_config // config_refs=1
  nbd_start_device // config_refs=2
  set NBD_RT_HAS_CONFIG_REF			open nbd // config_refs=3
  recv_work done // config_refs=2
						NBD_CLEAR_SOCK // config_refs=1
						close nbd // config_refs=0
  refcount_inc -> uaf

------------[ cut here ]------------
refcount_t: addition on 0; use-after-free.
WARNING: CPU: 24 PID: 1014 at lib/refcount.c:25 refcount_warn_saturate+0x12e/0x290
 nbd_genl_connect+0x16d0/0x1ab0
 genl_family_rcv_msg_doit+0x1f3/0x310
 genl_rcv_msg+0x44a/0x790

The issue can be easily reproduced by adding a small delay before
refcount_inc(&nbd->config_refs) in nbd_genl_connect():

        mutex_unlock(&nbd->config_lock);
        if (!ret) {
                set_bit(NBD_RT_HAS_CONFIG_REF, &config->runtime_flags);
+               printk("before sleep\n");
+               mdelay(5 * 1000);
+               printk("after sleep\n");
                refcount_inc(&nbd->config_refs);
                nbd_connect_reply(info, nbd->index);
        }

Fixes: e46c7287b1c2 ("nbd: add a basic netlink interface")
Signed-off-by: Zheng Qixing <zhengqixing@huawei.com>
Reviewed-by: Yu Kuai <yukuai@fnnas.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/nbd.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
index faa3f6c52f5f9..649a1e8812652 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -2052,12 +2052,13 @@ static int nbd_genl_connect(struct sk_buff *skb, struct genl_info *info)
 	}
 	ret = nbd_start_device(nbd);
 out:
-	mutex_unlock(&nbd->config_lock);
 	if (!ret) {
 		set_bit(NBD_RT_HAS_CONFIG_REF, &config->runtime_flags);
 		refcount_inc(&nbd->config_refs);
 		nbd_connect_reply(info, nbd->index);
 	}
+	mutex_unlock(&nbd->config_lock);
+
 	nbd_config_put(nbd);
 	if (put_dev)
 		nbd_put(nbd);
-- 
2.51.0



