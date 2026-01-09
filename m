Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBC8915ADB4;
	Fri,  9 Jan 2026 12:47:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767962823; cv=none; b=GL2GE9dD6DH57J/Kem5aE22l3skVQbY7ntiy9e/X1PM2D99KBzAnvCdRxF20F5mSTBoWfJuidlPK2oC9Uby7POYnwOo5UKlo7tQaD0C5WuI45+Ma+FwmQCBeP8IfJd5WbKt+oA3Zg+2CwaFuuxHhhVYoeLgvZ7hnTW8UY38HimY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767962823; c=relaxed/simple;
	bh=bVvtZpavxpKQ31Ugg/3yANPTbR5kie45AkhTTAQvxhM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cxg2a9nEJrReaHq9kRq3MuV28qDxjDM2PzPpmIZuRjJJayDK3EyKgFe2XALTnggsuvnY9Y51+deJeZA+I3NjX+kqBtqe0Ua37kh16WMfpxOnmcgcSRwvAhYiYqFGShMgCaMoDjF4n3ff9RXKva0zHccmRO/ZdGflABXRQPBxl3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z3B4XBXg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z3B4XBXg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51151C4CEF1;
	Fri,  9 Jan 2026 12:47:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767962823;
	bh=bVvtZpavxpKQ31Ugg/3yANPTbR5kie45AkhTTAQvxhM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z3B4XBXgdYSnCt1t0DXzNerWETMYObeHcHhecSj9XWWTUeej/4ylG+mx9c+PBwEXy
	 wccaXSASBeAbRClFVCcZTlzsjAr8EQmYsc1Bxcd1H30e/ZHd4K2EyFgqPbeHnEweoa
	 MDUtJHgK3lBpiI7bc81+vosUbKkOqgBUinERyeIc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.1 501/634] nfsd: Drop the client reference in client_states_open()
Date: Fri,  9 Jan 2026 12:42:59 +0100
Message-ID: <20260109112136.405798993@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>

commit 1f941b2c23fd34c6f3b76d36f9d0a2528fa92b8f upstream.

In error path, call drop_client() to drop the reference
obtained by get_nfsdfs_clp().

Fixes: 78599c42ae3c ("nfsd4: add file to display list of client's opens")
Cc: stable@vger.kernel.org
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfs4state.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -2804,8 +2804,10 @@ static int client_states_open(struct ino
 		return -ENXIO;
 
 	ret = seq_open(file, &states_seq_ops);
-	if (ret)
+	if (ret) {
+		drop_client(clp);
 		return ret;
+	}
 	s = file->private_data;
 	s->private = clp;
 	return 0;


