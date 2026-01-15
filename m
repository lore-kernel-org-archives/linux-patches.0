Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B64813BC4E8;
	Thu, 15 Jan 2026 17:06:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496790; cv=none; b=JtEApnuuTt8gtbhttBzAdC7IO2gnFkjn367nfgBFbcSyJs63WePeBIsfRpjfdHn3Xkd5SgilDuUEf1PhcK7RDPgosh35ys6jXpHgRscyT0ERtLyf6XRyhadPuTcrqGysQAh5DIBq7wHR4DhJcO3/YviJOhhMIKgTtrrIIv4Xy1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496790; c=relaxed/simple;
	bh=p4J3+7vKN6ct16YCHdxnVFbty/nYgeetTWznw3nSDm8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HjgUpgp/0qN+ruRtW3fOwMjf7ZFOUqg03fndhZ3DDA5G9p/pGwxJf9ZCfTAI3gcD+m88+2VzsfZohhDf02hAhWknMCOEOJ6GAlbhfeefNhYtZEoSg+t5gvnaqtgtdO68kYzHXcWPXmIGC7sBKEoUl7mphnUjY+kmjy3Zk0MVWZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kjgdDxtX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kjgdDxtX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 440FEC116D0;
	Thu, 15 Jan 2026 17:06:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496790;
	bh=p4J3+7vKN6ct16YCHdxnVFbty/nYgeetTWznw3nSDm8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kjgdDxtXHVEedczYtL+umcB7NQFyZjeOlhEO8agyruRcDobB0OMnJb/Ed9FVbE0GD
	 PgXMEv56nFNhQdCPdLie/kFFUI/vB2fRFCOjFmu0ANo0rEpscBKI/K+M/nOlX1RY7m
	 oKII35u8JlP99ctrgTqaYZQNRSUWNopRYxvLa4Eo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tuo Li <islituo@gmail.com>,
	Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>,
	Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 6.6 17/88] libceph: make free_choose_arg_map() resilient to partial allocation
Date: Thu, 15 Jan 2026 17:48:00 +0100
Message-ID: <20260115164146.941255245@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164146.312481509@linuxfoundation.org>
References: <20260115164146.312481509@linuxfoundation.org>
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
@@ -241,22 +241,26 @@ static struct crush_choose_arg_map *allo
 
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


