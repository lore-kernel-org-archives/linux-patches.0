Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E349D1487CB;
	Thu, 13 Jun 2024 12:01:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718280095; cv=none; b=bfDDC0T7XlwvFIBS+pH9azXB6u574bWRTDMYYL3Oam31clN9eOJIbWzUvk6W0C6SwLlemGd/VPD8DsgShirBVx8cZcSLoziQ8oR9teLsl12WpsVRHEmkg6U8PwOqHCa4QrpW8wDVIEIlh/RQPOqCO1UXsspodXZnyFLhlH9wGCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718280095; c=relaxed/simple;
	bh=KufkW4Yzw6XG5neDPkFgQmMXvQyH/Ia/sd+jY0Gv1qU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pvZMjLhM0gu1GIjS1u4CEj+sMj2+3B1CMmTquYCT7f+Nyhya08drdulBxLkOC/QeXNGCo0mtgqbk+/8oFtaD3cRBicUUpfVnJkuqKzk4ZU8mVW1cuYszzQqGEsw7xuveLKq8Gd1oxD0304yHyfUqmpEdHY61N5ppNTUdiw6PTEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l9lRXo/6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l9lRXo/6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DA80C4AF1A;
	Thu, 13 Jun 2024 12:01:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718280094;
	bh=KufkW4Yzw6XG5neDPkFgQmMXvQyH/Ia/sd+jY0Gv1qU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l9lRXo/6JV5rMl06gnsEZXVRANtYPs45BtPhaFEGuWu67ME3isJ/340CVlvPvoOMM
	 5sGSJ/fY6IGxgAJVivaiZ5iOnlzYqLAy0JZXSyzTDpqD5YNp4lGIi3Umid9Oh2g5Al
	 Yl9LVmY7eluCYZerxtTWPtrLZE8WYln25KELiBfs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
	Hannes Reinecke <hare@suse.com>,
	Sagi Grimberg <sagi@grimberg.me>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 140/202] params: lift param_set_uint_minmax to common code
Date: Thu, 13 Jun 2024 13:33:58 +0200
Message-ID: <20240613113233.162973640@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.759341286@linuxfoundation.org>
References: <20240613113227.759341286@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 5ba250d9172ac..4d5a851cafe8b 100644
--- a/include/linux/moduleparam.h
+++ b/include/linux/moduleparam.h
@@ -359,6 +359,8 @@ extern int param_get_int(char *buffer, const struct kernel_param *kp);
 extern const struct kernel_param_ops param_ops_uint;
 extern int param_set_uint(const char *val, const struct kernel_param *kp);
 extern int param_get_uint(char *buffer, const struct kernel_param *kp);
+int param_set_uint_minmax(const char *val, const struct kernel_param *kp,
+		unsigned int min, unsigned int max);
 #define param_check_uint(name, p) __param_check(name, p, unsigned int)
 
 extern const struct kernel_param_ops param_ops_long;
diff --git a/kernel/params.c b/kernel/params.c
index 8e56f8b12d8f7..b638476d12de1 100644
--- a/kernel/params.c
+++ b/kernel/params.c
@@ -242,6 +242,24 @@ STANDARD_PARAM_DEF(long,	long,			"%li",  kstrtol);
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
index 3095442b03822..39d0a3c434829 100644
--- a/net/sunrpc/xprtsock.c
+++ b/net/sunrpc/xprtsock.c
@@ -3302,24 +3302,6 @@ void cleanup_socket_xprt(void)
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



