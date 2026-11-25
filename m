Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620944;
	b=OtZBbniflcTdelqcqKc88QRwPJpyqf43XgvjkR/HZvIZEwv1r4GUT0j0uUO5UTZyVR1E
	 dg7Lmq34/nU1nWicDmcOEc42GS6+MUpFnSIeaGfIqfumNINRncJBjzz7g9YtTHu8bjkpm
	 5cysn7DYz0TLYlvSnKUQLb34Slen9hxylN6nLO62zgcOwQpYB32LXodnWnAmMm8XzOWI0
	 YQQ3ZUlPlmq8ia3k7jmyiQVPO0wp1UAOdgE+LfFds4u9xfkGV6pVJ8PjOU7VkWN7KYRSs
	 6QPvue80AWBnXAo9izCXMFYmYAGtCCBOX2jFxfeuIqy/Co8TXBp8T7BIXAZCYpPQJXg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620944;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Mc5SvHdRNO+NciBKL7HO5HAoCwtmwvTzuWvhi5O7y6I=;
	b=c69qPKkEujjDzWzkzmszvylUOrvLUpFOTEUeOm5hxcBQK7UaLt6Yotg5d159GMzq2ZHA
	 Uauol6QEWq17J2+gtgncsHeqtp3jb8089o9HEqvz/IdU1XVHuCRsVCsX5mt/nPhCymCQz
	 CAKWyVLOulX8EaWeJbZBmxrJdvhT3Cm3fA9BQE7hdrhoXp/V32MgOsViEhCYYtXswE9vd
	 hzQcCzzCGcjz0yzA/z23mahppmNtVaFT//9+GH34nnS7/HA2xD+SCPMykTrcU7WwaP6Ob
	 30Sb36t1QchqNTPHG0q9AbpQMV1y+NkswzMkMnqn7dp5IcnkdoSljYynyc2Dtl5v/kw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xlhjh7O7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A383260A380C;
	Wed, 25 Nov 2026 15:35:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xlhjh7O7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 870031F000D1;
	Wed, 25 Nov 2026 15:35:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620944;
	bh=Mc5SvHdRNO+NciBKL7HO5HAoCwtmwvTzuWvhi5O7y6I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xlhjh7O7FIg7xYArbfiC0dByVwvsfFcXuqPbWLgGLRQEvrKGP0UQPn/M8yYejCJXX
	 RbFhwTogKDaiE3a41AbIkpvzu6TL1AjL//Bd0sf47KkmLPuuQ0M6GWLXapoDff8Li3
	 vWBvIOb/UGvdMV5NDVh5+EkhR2lgrwEiEVqkgCU4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Giuseppe Piscitelli <ooonea@gmail.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 073/990] scsi: scsi_debug: Drain target cleanup before module exit
Date: Wed, 25 Nov 2026 15:24:00 +0100
Message-ID: <20261125143823.797782308@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Giuseppe Piscitelli <ooonea@gmail.com>

[ Upstream commit 34c99ce2993971712d89010a948d2f650687b796 ]

Target destruction queues cleanup in an exclusive async domain. The module
loader's async_synchronize_full() does not wait for exclusive domains. Wait
for target cleanup after removing the hosts and before removing the debugfs
root and returning from module exit.

Fixes: b402a0dce64a ("scsi: scsi_debug: Fix create target debugfs failure")
Signed-off-by: Giuseppe Piscitelli <ooonea@gmail.com>
Link: https://patch.msgid.link/20261026202342.668361-1-ooonea@gmail.com
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/scsi_debug.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index ebb651a6d7c06..524e0fa457a83 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -8713,6 +8713,7 @@ static void __exit scsi_debug_exit(void)
 
 	sdebug_erase_all_stores(false);
 	xa_destroy(per_store_ap);
+	async_synchronize_full_domain(&sdebug_async_domain);
 	debugfs_remove(sdebug_debugfs_root);
 }
 
-- 
2.53.0



