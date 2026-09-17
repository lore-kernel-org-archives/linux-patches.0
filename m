Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF9DC8003D;
	Thu, 17 Sep 2026 15:46:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659973; cv=none; b=tsseKeBR6PukKjp7Q3Rk5qBg+2ICGFecD5zXyXoSK3TWs2TSMJHWeOyKHJazwJ/D4v1cILLLwPN/ssEva1/tTQnPEx8KLXffeTme1O/J0CHWDmrqnWQLbnbyrG4fJv2ZhnK6WrgFHmcULNv3E8GDZ0pgn1jCth9AVsG0f4RRHCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659973; c=relaxed/simple;
	bh=CqUYbRRPda0zRdoIJxKFKhj7vAwUI5njS0/erHhTZmo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AjYMzU34BWWEt+PasPUV/3GYONIxW7WlDTPoeYScnT8Sp3s+pQOZYTH1VonIoXN4SF1OkmnhlmAZcu98coefRkZEgATS+cpuHcVXTWSdZlx0P1C7ZuZilpGmrQcfq4Y8QB6ymxZ9Jck/wITy5Co0U5mg/idHQWdtFzaQvzrEi2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UV6CEw08; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UV6CEw08"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BE831F00893;
	Thu, 17 Sep 2026 15:46:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659964;
	bh=DBS9DJFeprZwMWnfhlzvpq29vQ65A6XE0p3YXa82PSk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UV6CEw08XF7nweugVXzVd52CT5zqQ8+BeZMmLsmoug1d1eLVdvWF3EkKcQgm7SmKH
	 XiEhm7zot1ziCYfuffMA9GBXKD9JWVvh3ZMB3qB9V+XadAd8EuRXzsCkYZn9S+F8ul
	 9eQGuV+A1bWu9obQKIpW9undaJy5OjIfiIGOezUQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Long Li <longli@microsoft.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 433/733] net: mana: restore the XDP program pointer when pre-allocation fails
Date: Thu, 17 Sep 2026 16:12:21 +0100
Message-ID: <20260917151402.632492957@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Long Li <longli@microsoft.com>

[ Upstream commit 4c46beb807efcc93f5899ebe1f5958248eb296c6 ]

mana_xdp_set() publishes the new program into apc->bpf_prog before it
allocates anything, because mana_pre_alloc_rxbufs() sizes the buffers
from it via mana_get_rxbuf_cfg(). When that allocation fails the
function returns the error directly, skipping the err_dealloc_rxbuffs
label which is the only place that restores the previous pointer.

The attach is reported as failed, so the BPF core drops the reference it
held for the caller and the program can be freed, while apc->bpf_prog
still points at it. The next consumer of mana_xdp_get() - typically
mana_chn_setxdp() from mana_alloc_queues() on the following ifup, or
after a TX timeout reset - then calls bpf_prog_add() on freed memory.

This is reachable from an ordinary "ip link set dev ethX xdp obj ..."
whenever the per-queue RX buffer pre-allocation cannot be satisfied.

Restore the previous program on that error path.

Fixes: 730ff06d3f5c ("net: mana: Use page pool fragments for RX buffers instead of full pages to improve memory efficiency.")
Signed-off-by: Long Li <longli@microsoft.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260904202640.3900685-1-longli@microsoft.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/microsoft/mana/mana_bpf.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/microsoft/mana/mana_bpf.c b/drivers/net/ethernet/microsoft/mana/mana_bpf.c
index 53308e139cbe9..5c9961ee9747a 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_bpf.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_bpf.c
@@ -208,6 +208,7 @@ static int mana_xdp_set(struct net_device *ndev, struct bpf_prog *prog,
 		if (err) {
 			NL_SET_ERR_MSG_MOD(extack,
 					   "XDP: Insufficient memory for tx/rx re-config");
+			apc->bpf_prog = old_prog;
 			return err;
 		}
 
-- 
2.53.0



