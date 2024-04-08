Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03D647E572;
	Mon,  8 Apr 2024 13:59:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584748; cv=none; b=JCCvfhpwJePWs69YfOxwy/dhojLfSAt4ZeTemoXVLvXTDjG34LJeOD9tydQwYQDV6fv4Jrepj292FdX5jGsd3eOUHztF1etoP0f65wc9mwAZn4eBwmw504ka0aQMJtLLVpinOx3lljP52YjO6m5j+nbG2zI9+rYI3wEG//+5WBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584748; c=relaxed/simple;
	bh=kWW/vn0irVchTGyua5shYOeqCyQjPcmaIT45qHkTDMQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rHNIkAND/nIh5Z6JFNUHG5FaHXrqjYlq56ySsEGf9MeakUIJ0avpNp+9yM/jFqYKWnyNyFGArLw4QjQquK8SjEfpxaqtPVQVw+fN7852zfZQ505M1dzLtS/HxzjgyckgXgog9Zl3mSDRj0ksFo+iQ/CAg2niXo7rUTwTY9AQKIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XubQfFie; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XubQfFie"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EBF7C433F1;
	Mon,  8 Apr 2024 13:59:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584747;
	bh=kWW/vn0irVchTGyua5shYOeqCyQjPcmaIT45qHkTDMQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XubQfFier1V8j5RGN7Y3gQyvlog2htmPIZ7Qkgv91h1DTYLsxcT0rOgGW0ObhAIJC
	 I3sJ76hTZGf2UrVFOSw2CpmjhVccqo6sc/R978sFQ4rkacrXK1UCkAH8TGT74a5uqh
	 umdEWmeZIXj80Oh/N+6ewbktgqxBTC7zc/LQIU7k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	JianHong Yin <jiyin@redhat.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 516/690] nfsd: dont destroy global nfs4_file table in per-net shutdown
Date: Mon,  8 Apr 2024 14:56:22 +0200
Message-ID: <20240408125418.338949026@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Layton <jlayton@kernel.org>

[ Upstream commit 4102db175b5d884d133270fdbd0e59111ce688fc ]

The nfs4_file table is global, so shutting it down when a containerized
nfsd is shut down is wrong and can lead to double-frees. Tear down the
nfs4_file_rhltable in nfs4_state_shutdown instead of
nfs4_state_shutdown_net.

Fixes: d47b295e8d76 ("NFSD: Use rhashtable for managing nfs4_file objects")
Link: https://bugzilla.redhat.com/show_bug.cgi?id=2169017
Reported-by: JianHong Yin <jiyin@redhat.com>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/nfs4state.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index 22799f5ce686e..5c261cc807e8e 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -8183,7 +8183,6 @@ nfs4_state_shutdown_net(struct net *net)
 
 	nfsd4_client_tracking_exit(net);
 	nfs4_state_destroy_net(net);
-	rhltable_destroy(&nfs4_file_rhltable);
 #ifdef CONFIG_NFSD_V4_2_INTER_SSC
 	nfsd4_ssc_shutdown_umount(nn);
 #endif
@@ -8193,6 +8192,7 @@ void
 nfs4_state_shutdown(void)
 {
 	nfsd4_destroy_callback_queue();
+	rhltable_destroy(&nfs4_file_rhltable);
 }
 
 static void
-- 
2.43.0



