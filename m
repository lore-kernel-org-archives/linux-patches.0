Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83908348465;
	Thu,  2 Jul 2026 16:46:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783010780; cv=none; b=eq0zlEr5rAI392QLGoVB+fROLT+tTbWnH3w7F3eQM13A75O51CjyfNiuFlWUtGq3xODgr+St/YkSIl6qmHS+9XczNVlYxCGzqCL0/JgOtSGlVtHduISps6OM2FIiKXeG3tIquQP60vXXvnKc8UbXLze79dxH1qKsM1/J0gRaAPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783010780; c=relaxed/simple;
	bh=gmdsas5abTCj3EUPsH3OHVA1TDA4mlsewIJ8fpc5nAM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xspz0RDJH/j0jKM/qMXS2/HX0Sfd88vkOsOdwEsOLa0aKwijmFiNJhcz9D7W6VSmXZczipv1V76qn8qqejAgwUnZag8pbpQDnP/0kjXJAkIp9WCobLyu1RZoShAV9HTr1Rg1eHYIKHMwcaCHHZHoK7IpdkCrpDnNj6QTE8O7fVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Nzk0hIn8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Nzk0hIn8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E84091F000E9;
	Thu,  2 Jul 2026 16:46:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783010779;
	bh=lLyoBTwB+OOZ9s3gACW+eVGbQE1RaMlkvSOrbKVdSD4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Nzk0hIn8P489EjIcOzHV5T4QmKzEh1P4aBXwiRSEsEmCpeCYu+kae3r6oP6jVnfUf
	 GhI1m1vB2etsVMg7YgyetKoOspuKneV2e0hKmP/vlTtLtushz5b8YEt9ADMaaqn3+2
	 9lnZ6VtnHC7aj8EnEM1Z01OhcFvKKa6oOzvFFryY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Long Li <longli@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 033/175] hv: utils: handle and propagate errors in kvp_register
Date: Thu,  2 Jul 2026 18:18:54 +0200
Message-ID: <20260702155116.494377970@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155115.766838875@linuxfoundation.org>
References: <20260702155115.766838875@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thorsten Blum <thorsten.blum@linux.dev>

[ Upstream commit 3fcf923302a8f5c0dc3af3d2ca2657cb5fae4297 ]

Make kvp_register() return an error code instead of silently ignoring
failures, and propagate the error from kvp_handle_handshake() instead of
returning success.

This propagates both kzalloc_obj() and hvutil_transport_send() failures
to kvp_handle_handshake() and thus to kvp_on_msg().

Fixes: 245ba56a52a3 ("Staging: hv: Implement key/value pair (KVP)")
Cc: stable@vger.kernel.org
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Reviewed-by: Long Li <longli@microsoft.com>
Signed-off-by: Wei Liu <wei.liu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hv/hv_kvp.c |   27 ++++++++++++++-------------
 1 file changed, 14 insertions(+), 13 deletions(-)

--- a/drivers/hv/hv_kvp.c
+++ b/drivers/hv/hv_kvp.c
@@ -93,7 +93,7 @@ static void kvp_send_key(struct work_str
 static void kvp_respond_to_host(struct hv_kvp_msg *msg, int error);
 static void kvp_timeout_func(struct work_struct *dummy);
 static void kvp_host_handshake_func(struct work_struct *dummy);
-static void kvp_register(int);
+static int kvp_register(int);
 
 static DECLARE_DELAYED_WORK(kvp_timeout_work, kvp_timeout_func);
 static DECLARE_DELAYED_WORK(kvp_host_handshake_work, kvp_host_handshake_func);
@@ -127,24 +127,26 @@ static void kvp_register_done(void)
 	hv_poll_channel(kvp_transaction.recv_channel, kvp_poll_wrapper);
 }
 
-static void
+static int
 kvp_register(int reg_value)
 {
 
 	struct hv_kvp_msg *kvp_msg;
 	char *version;
+	int ret;
 
 	kvp_msg = kzalloc(sizeof(*kvp_msg), GFP_KERNEL);
+	if (!kvp_msg)
+		return -ENOMEM;
 
-	if (kvp_msg) {
-		version = kvp_msg->body.kvp_register.version;
-		kvp_msg->kvp_hdr.operation = reg_value;
-		strcpy(version, HV_DRV_VERSION);
-
-		hvutil_transport_send(hvt, kvp_msg, sizeof(*kvp_msg),
-				      kvp_register_done);
-		kfree(kvp_msg);
-	}
+	version = kvp_msg->body.kvp_register.version;
+	kvp_msg->kvp_hdr.operation = reg_value;
+	strcpy(version, HV_DRV_VERSION);
+
+	ret = hvutil_transport_send(hvt, kvp_msg, sizeof(*kvp_msg),
+				    kvp_register_done);
+	kfree(kvp_msg);
+	return ret;
 }
 
 static void kvp_timeout_func(struct work_struct *dummy)
@@ -186,9 +188,8 @@ static int kvp_handle_handshake(struct h
 	 */
 	pr_debug("KVP: userspace daemon ver. %d connected\n",
 		 msg->kvp_hdr.operation);
-	kvp_register(dm_reg_value);
 
-	return 0;
+	return kvp_register(dm_reg_value);
 }
 
 


