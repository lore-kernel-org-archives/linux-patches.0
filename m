Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED22F7F47B;
	Thu, 13 Jun 2024 12:24:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718281466; cv=none; b=rw8bwPrsJCkxqGbCyHXAYxK7N5ukiPbQgXF81zbqqKkW/ghScqq5lDB5W1OzFicRffVBugPqaxyyP/hEVFVGAoNTua4GYLjtWQ8Jlmvy8nVo/C+ahZq1aisGTlz9pKSK3yzkBWlwhEOuvDmn2C6xYVnZb0G/6ibrSc7i1eqpThE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718281466; c=relaxed/simple;
	bh=KSWV19/cZO9X584RhCgZfHPzeihIF2suZK17mIV5LM4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PliUP5uPYCiRqifDSgwuEYW71PBqiqM9Wnr50v/u/yPsGYAzKSmkJKTWxeHzYoAXgo6F4cavyOv2jZ1k3oaem71ZyaasrrVyQiYkwRaY1rwMO1vu1ec/lEsNaWCDcI2H8uekUwTVMmL94OeTc5ecxG5hM/RZv4ujmP2UkMsrTRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H6I6O9VW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H6I6O9VW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72B0CC2BBFC;
	Thu, 13 Jun 2024 12:24:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718281465;
	bh=KSWV19/cZO9X584RhCgZfHPzeihIF2suZK17mIV5LM4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H6I6O9VWSYyOTtbEwSqMWvtg9zsddfVE0QI9ILj2/qaIVfsmbboiXbM9vM6WUrfH+
	 B6tjxNsWZdCC4m7gjEmlvKsmlwUic9XJM/CsQ20tKvXnICP8KqPCvabufgv0E6WAZV
	 fuywSXPCLMBEF2MMYl00hQL56am5kuYph56mxMno=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
	Hannes Reinecke <hare@suse.com>,
	Sagi Grimberg <sagi@grimberg.me>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 233/317] params: lift param_set_uint_minmax to common code
Date: Thu, 13 Jun 2024 13:34:11 +0200
Message-ID: <20240613113256.563556896@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113247.525431100@linuxfoundation.org>
References: <20240613113247.525431100@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 6388eb9734a51..f25a1c4843903 100644
--- a/include/linux/moduleparam.h
+++ b/include/linux/moduleparam.h
@@ -431,6 +431,8 @@ extern int param_get_int(char *buffer, const struct kernel_param *kp);
 extern const struct kernel_param_ops param_ops_uint;
 extern int param_set_uint(const char *val, const struct kernel_param *kp);
 extern int param_get_uint(char *buffer, const struct kernel_param *kp);
+int param_set_uint_minmax(const char *val, const struct kernel_param *kp,
+		unsigned int min, unsigned int max);
 #define param_check_uint(name, p) __param_check(name, p, unsigned int)
 
 extern const struct kernel_param_ops param_ops_long;
diff --git a/kernel/params.c b/kernel/params.c
index 164d79330849a..eb00abef7076a 100644
--- a/kernel/params.c
+++ b/kernel/params.c
@@ -243,6 +243,24 @@ STANDARD_PARAM_DEF(ulong,	unsigned long,		"%lu",		kstrtoul);
 STANDARD_PARAM_DEF(ullong,	unsigned long long,	"%llu",		kstrtoull);
 STANDARD_PARAM_DEF(hexint,	unsigned int,		"%#08x", 	kstrtouint);
 
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
index ae5b5380f0f03..0666f981618a2 100644
--- a/net/sunrpc/xprtsock.c
+++ b/net/sunrpc/xprtsock.c
@@ -3166,24 +3166,6 @@ void cleanup_socket_xprt(void)
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



