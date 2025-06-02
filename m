Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1A4E1FE45A;
	Mon,  2 Jun 2025 14:49:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748875748; cv=none; b=dvusZpxA5zVHYjEof7ID6U9Mmj8/gcnd2gIj4fjGkwbqesPCQDQjpPQI5oDtWSlZGyt0oPyQVLmmOGjQlkbJ5QeWQqbHVmPAPng1mXLvDZ8GvXJrbLB9nD2MtKNsRjSzkpm2TbWINFqXnRBGMc5bUG5NCkZHIr/iWn+1KMBtgTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748875748; c=relaxed/simple;
	bh=jQ7jTQcutNo1DPan2mIuth7S7d96ERcLgz3gxXLhKU4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cx31CqeBEiw0rFInomYAOwaA4/1dEeoRGJHbLKWBgqjmDzfs/lo9Rr1OREblz0vOI++WM1OxBGZuRPHMLu0yw3DKGn8gUNSO7+yoVnN7PnvgBwuDsFaETRyw1IY8UMtvvm4rDVcnSJ0Z5cuDPzJGMQ1sSLFC2QS9+7Hb33hNIgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UodkYT76; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UodkYT76"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 107AFC4CEEB;
	Mon,  2 Jun 2025 14:49:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748875748;
	bh=jQ7jTQcutNo1DPan2mIuth7S7d96ERcLgz3gxXLhKU4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UodkYT76CpSuziHjf4C005MzZyXiXYbAeTv9kzabX2gou3W1rh1ji6VGPvNxMB+zP
	 r4KTrVmsYbQwZhAckJHX8lkdYC3TvFWLVegWX1TZJynJvdNy8OkI6chQNlk5NLcRcL
	 QYP2e16nMWXN01MnwIN4liRjnAcjCV1kix7larug=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Seiderer <ps.report@gmx.net>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 191/270] net: pktgen: fix access outside of user given buffer in pktgen_thread_write()
Date: Mon,  2 Jun 2025 15:47:56 +0200
Message-ID: <20250602134315.012260147@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134307.195171844@linuxfoundation.org>
References: <20250602134307.195171844@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Peter Seiderer <ps.report@gmx.net>

[ Upstream commit 425e64440ad0a2f03bdaf04be0ae53dededbaa77 ]

Honour the user given buffer size for the strn_len() calls (otherwise
strn_len() will access memory outside of the user given buffer).

Signed-off-by: Peter Seiderer <ps.report@gmx.net>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20250219084527.20488-8-ps.report@gmx.net
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/pktgen.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/core/pktgen.c b/net/core/pktgen.c
index c2b3c454eddd9..57502e8628462 100644
--- a/net/core/pktgen.c
+++ b/net/core/pktgen.c
@@ -1770,8 +1770,8 @@ static ssize_t pktgen_thread_write(struct file *file,
 	i = len;
 
 	/* Read variable name */
-
-	len = strn_len(&user_buffer[i], sizeof(name) - 1);
+	max = min(sizeof(name) - 1, count - i);
+	len = strn_len(&user_buffer[i], max);
 	if (len < 0)
 		return len;
 
@@ -1801,7 +1801,8 @@ static ssize_t pktgen_thread_write(struct file *file,
 	if (!strcmp(name, "add_device")) {
 		char f[32];
 		memset(f, 0, 32);
-		len = strn_len(&user_buffer[i], sizeof(f) - 1);
+		max = min(sizeof(f) - 1, count - i);
+		len = strn_len(&user_buffer[i], max);
 		if (len < 0) {
 			ret = len;
 			goto out;
-- 
2.39.5



