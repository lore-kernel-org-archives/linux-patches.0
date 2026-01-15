Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D6823BFE4C;
	Thu, 15 Jan 2026 18:01:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768500077; cv=none; b=ki9CfcDbV3uXvBrldNuX28Xej5lhZC3KwFp5CqXAeaKjCnVAioZTvV2JdNaW5SdNXudtSC0JS7IVygOpyn7a7/dZQJ5kfh3bnN61p5cWqi0I+jp0qOblRHPUk8C0Za1UAsISFisiAkzcgeeK+LGL9quU2nK8kAb3SKN7+465BNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768500077; c=relaxed/simple;
	bh=czIL0AtQvcuowK+lTNoS8i04d7IyhX3Os+ALZLB+wDI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mc5ojT51+CiIBbHXGq7NVwcmEPfP7nCpardARsfgBoLh0bh5gVFi9KLe8Ee0aeOndCgZMDhXLVbqkIc4EL/zBjlzL3+zbZBcqXvmucZJGHHsE1p0iW50mPiJOnLe4vZVxys4HKFyJx4VwjKm/+gjQVR0J2zaN1hAcMvHwvcQouA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tMKVsTTh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tMKVsTTh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1904CC116D0;
	Thu, 15 Jan 2026 18:01:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768500077;
	bh=czIL0AtQvcuowK+lTNoS8i04d7IyhX3Os+ALZLB+wDI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tMKVsTThm3tFrjy/F+XgORSt03qedJkcFDzixQ/KTL3jipZEhV2p4sKXxdMAxOhc7
	 nJ5DDaKZg51WMwwce5KxpMsk94Emu+//BUKYa8KvL77U6pIE477qjqLuxq1X8j1zos
	 RgBzOMHAo4pxrEQvSML0ANXHQyLCRPTFSGfaS1c8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tuo Li <islituo@gmail.com>,
	Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>,
	Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 5.10 417/451] libceph: make free_choose_arg_map() resilient to partial allocation
Date: Thu, 15 Jan 2026 17:50:18 +0100
Message-ID: <20260115164246.023378932@linuxfoundation.org>
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

From: Tuo Li <islituo@gmail.com>

commit e3fe30e57649c551757a02e1cad073c47e1e075e upstream.

free_choose_arg_map() may dereference a NULL pointer if its caller fails
after a partial allocation.

For example, in decode_choose_args(), if allocation of arg_map->args
fails, execution jumps to the fail label and free_choose_arg_map() is
called. Since arg_map->size is updated to a non-zero value before memory
allocation, free_choose_arg_map() will iterate over arg_map->args and
dereference a NULL pointer.

To prevent this potential NULL pointer dereference and make
free_choose_arg_map() more resilient, add checks for pointers before
iterating.

Cc: stable@vger.kernel.org
Co-authored-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Tuo Li <islituo@gmail.com>
Reviewed-by: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ceph/osdmap.c |   20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

--- a/net/ceph/osdmap.c
+++ b/net/ceph/osdmap.c
@@ -225,22 +225,26 @@ static struct crush_choose_arg_map *allo
 
 static void free_choose_arg_map(struct crush_choose_arg_map *arg_map)
 {
-	if (arg_map) {
-		int i, j;
+	int i, j;
 
-		WARN_ON(!RB_EMPTY_NODE(&arg_map->node));
+	if (!arg_map)
+		return;
 
+	WARN_ON(!RB_EMPTY_NODE(&arg_map->node));
+
+	if (arg_map->args) {
 		for (i = 0; i < arg_map->size; i++) {
 			struct crush_choose_arg *arg = &arg_map->args[i];
-
-			for (j = 0; j < arg->weight_set_size; j++)
-				kfree(arg->weight_set[j].weights);
-			kfree(arg->weight_set);
+			if (arg->weight_set) {
+				for (j = 0; j < arg->weight_set_size; j++)
+					kfree(arg->weight_set[j].weights);
+				kfree(arg->weight_set);
+			}
 			kfree(arg->ids);
 		}
 		kfree(arg_map->args);
-		kfree(arg_map);
 	}
+	kfree(arg_map);
 }
 
 DEFINE_RB_FUNCS(choose_arg_map, struct crush_choose_arg_map, choose_args_index,


