Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A27DF32936C;
	Fri,  9 Jan 2026 12:17:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767961036; cv=none; b=Y3NwHUvJiQXFlQVbPhA/AiITHAV/Gj7yBXn2BBfgyZQrHQOCwxYaKkFN0qlmQact+CT0/M8mRd2VcQJErv7sM7cUmwqs2WkUz9UH4DwGm2oG1Ff+Attzm/zvqtaYvXLj+rKdhzSF1OXOzuyva0u45wS+TLIvWy44KRM5vXyZlJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767961036; c=relaxed/simple;
	bh=KwW10t7iv3JQY7YJhUToeAKmcWBzBOeYtmi1Falo4j4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GxGu0Hzvn+hMmmqWnAxdUE4L7Wq+rsjneKvUV0PGQfxHdbDDNa7n8VsIid1i5utuCsW6ak6EGk8l0Yz4rx01iBwyfDI/2OmD6MIAyc7SbQoNmqMhazzi756TwpJmffr2oJ2wB/u8E9FJEXsZEyR1xfab+vUC+pqW9+cWh6/ENfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EgZEW2Ta; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EgZEW2Ta"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02D66C4CEF1;
	Fri,  9 Jan 2026 12:17:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767961036;
	bh=KwW10t7iv3JQY7YJhUToeAKmcWBzBOeYtmi1Falo4j4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EgZEW2Tav8uYC5k9g2edaDG3KZh8yOD1ZEzdcLxB7/ul6Izrpcv8VBcr8G/kLqYNb
	 YZnSTwUJBK1vPCtTIxxA14q78cX7o1LvQBt9PLQkTJ44WoERl3cPfxuTi5cHmKrwXQ
	 sTZISjoU21OPrkV7Svy6Fek+OutTTk4vKJHHGrwU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.6 613/737] nfsd: Drop the client reference in client_states_open()
Date: Fri,  9 Jan 2026 12:42:32 +0100
Message-ID: <20260109112157.064780045@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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
@@ -2801,8 +2801,10 @@ static int client_states_open(struct ino
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


