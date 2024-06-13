Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC97A142911;
	Thu, 13 Jun 2024 11:42:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718278944; cv=none; b=JGF0BgQYfxzZIQdesGVcfwdDAXfZ8P11F9Fd55i1ugW5dj1Qt90nQYlD0rNtkl2YQy4Ic2Qy9R6VnRXNPEybV01cc5hspI2p4l3qbIyAMpqrMbAHWRP/EbPfK+MR2r7Gu+kkua0ElD5mnf3EFnbwAPugdwn8ezsDyUMCKm94HKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718278944; c=relaxed/simple;
	bh=rw/0ubg8VrJy+87zwIN3GiNcgoQSSZywSw3yNF+2Lyk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i7WZ04fXsGAFLncIPWmDE8VAnVsQxCtL/p9wToE9Ch0z/DYkRjpqm+x4z5slp8MBdSEDlWMYIG3l6TgnczL35I7hk2SpnAwYutAMIK6/gN3DY9AUq1eTyravK6xVTDlst+pwiSZyepMW7uWvHthfcGUcclY4zQoxAesjzIri50M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r+kQnLQS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r+kQnLQS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71EC8C2BBFC;
	Thu, 13 Jun 2024 11:42:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718278943;
	bh=rw/0ubg8VrJy+87zwIN3GiNcgoQSSZywSw3yNF+2Lyk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r+kQnLQSQzx79iwKpPtlzIRv5fYev5qnXGhgi6d9aBJ93Q6Vq80p7pMMmq1/7TmXo
	 Mv7PIC86cT1gfN6ETigJFMftr8fzgv022OnHO0jPRMV8r6yChkQ9NY9hPkPwiLI4Bz
	 vuid13xfLKTz2MNFV42MK7NRTJiUTtxwiP23ee28=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
	Hannes Reinecke <hare@suse.com>,
	Sagi Grimberg <sagi@grimberg.me>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 123/213] params: lift param_set_uint_minmax to common code
Date: Thu, 13 Jun 2024 13:32:51 +0200
Message-ID: <20240613113232.741933063@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.969123070@linuxfoundation.org>
References: <20240613113227.969123070@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sagi Grimberg <sagi@grimberg.me>

[ Upstream commit 2a14c9ae15a38148484a128b84bff7e9ffd90d68 ]

It is a useful helper hence move it to common code so others can enjoy
it.

Suggested-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Reviewed-by: Hannes Reinecke <hare@suse.com>
Signed-off-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Stable-dep-of: 3ebc46ca8675 ("tcp: Fix shift-out-of-bounds in dctcp_update_alpha().")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/moduleparam.h |  2 ++
 kernel/params.c             | 18 ++++++++++++++++++
 net/sunrpc/xprtsock.c       | 18 ------------------
 3 files changed, 20 insertions(+), 18 deletions(-)

diff --git a/include/linux/moduleparam.h b/include/linux/moduleparam.h
index ba36506db4fb7..dee4c402c040e 100644
--- a/include/linux/moduleparam.h
+++ b/include/linux/moduleparam.h
@@ -361,6 +361,8 @@ extern int param_get_int(char *buffer, const struct kernel_param *kp);
 extern const struct kernel_param_ops param_ops_uint;
 extern int param_set_uint(const char *val, const struct kernel_param *kp);
 extern int param_get_uint(char *buffer, const struct kernel_param *kp);
+int param_set_uint_minmax(const char *val, const struct kernel_param *kp,
+		unsigned int min, unsigned int max);
 #define param_check_uint(name, p) __param_check(name, p, unsigned int)
 
 extern const struct kernel_param_ops param_ops_long;
diff --git a/kernel/params.c b/kernel/params.c
index ce89f757e6da0..8339cf40cdc72 100644
--- a/kernel/params.c
+++ b/kernel/params.c
@@ -245,6 +245,24 @@ STANDARD_PARAM_DEF(long,	long,			"%li",  kstrtol);
 STANDARD_PARAM_DEF(ulong,	unsigned long,		"%lu",  kstrtoul);
 STANDARD_PARAM_DEF(ullong,	unsigned long long,	"%llu", kstrtoull);
 
+int param_set_uint_minmax(const char *val, const struct kernel_param *kp,
+		unsigned int min, unsigned int max)
+{
+	unsigned int num;
+	int ret;
+
+	if (!val)
+		return -EINVAL;
+	ret = kstrtouint(val, 0, &num);
+	if (ret)
+		return ret;
+	if (num < min || num > max)
+		return -EINVAL;
+	*((unsigned int *)kp->arg) = num;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(param_set_uint_minmax);
+
 int param_set_charp(const char *val, const struct kernel_param *kp)
 {
 	if (strlen(val) > 1024) {
diff --git a/net/sunrpc/xprtsock.c b/net/sunrpc/xprtsock.c
index a0a82d9a59008..938c649c5c9fa 100644
--- a/net/sunrpc/xprtsock.c
+++ b/net/sunrpc/xprtsock.c
@@ -3306,24 +3306,6 @@ void cleanup_socket_xprt(void)
 	xprt_unregister_transport(&xs_bc_tcp_transport);
 }
 
-static int param_set_uint_minmax(const char *val,
-		const struct kernel_param *kp,
-		unsigned int min, unsigned int max)
-{
-	unsigned int num;
-	int ret;
-
-	if (!val)
-		return -EINVAL;
-	ret = kstrtouint(val, 0, &num);
-	if (ret)
-		return ret;
-	if (num < min || num > max)
-		return -EINVAL;
-	*((unsigned int *)kp->arg) = num;
-	return 0;
-}
-
 static int param_set_portnr(const char *val, const struct kernel_param *kp)
 {
 	return param_set_uint_minmax(val, kp,
-- 
2.43.0



