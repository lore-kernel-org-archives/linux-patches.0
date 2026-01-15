Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EC5528725F;
	Thu, 15 Jan 2026 17:37:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768498656; cv=none; b=eJDS1OzbpazQJw0tx+bi1KFBPikTLQ3egrLzHk/B1MrJC8I/cegXfTJvcUM/I+xG5eZYQ9Xdv1Wy92Ja260nKAqK1TZTOxv2nRwnb+b5fpB5kFjqZIMVP03PPVyybLKPS2vea+VETO3HABA3PZmyvaLMSug+dupfLFKKoEKJS9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768498656; c=relaxed/simple;
	bh=bwOqhAWAPLGzByZr71W+hEH2p948Pu95j2nfYNk/dhA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AzLS24F5bBCWgsfndV9hd/k6Drht1FMG8Dzy6LUhWcA7VRMZMyQKUijCsquNS80zUqwD3U+k/i2GNfq0Xyj1lqZ4nZLWqDcYBkPabQrqB0BkfP5DjgD3AtIRrp9263R5wUssS8ajYRGQHle9W7D63lOyGKJpfqgGPSdxrjSSF5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PqocHsFm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PqocHsFm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A2D7C116D0;
	Thu, 15 Jan 2026 17:37:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768498656;
	bh=bwOqhAWAPLGzByZr71W+hEH2p948Pu95j2nfYNk/dhA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PqocHsFmcLmSbzpOizGga8CRXsTO0rZiz1XnFXVid9w06MBAnP/O2DGT3X+NsUfzg
	 VMfcP2Egcoe4o9s/wqv1G+tKvGH6B2VxXlVAovMIJRD74m3DbWyUNiOfs1lzodKxq1
	 ssXZaGZyTRPZTxhQaIsXZz2Iwwnp/0K28kAvxp5I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tuo Li <islituo@gmail.com>,
	Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>,
	Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 5.15 509/554] libceph: make free_choose_arg_map() resilient to partial allocation
Date: Thu, 15 Jan 2026 17:49:35 +0100
Message-ID: <20260115164304.740598423@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


