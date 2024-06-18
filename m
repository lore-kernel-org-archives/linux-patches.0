Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 683D115747F;
	Tue, 18 Jun 2024 13:18:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718716685; cv=none; b=PUtlqttZTwqI86oxuJrQXc+Ax1on5V7ZEkdBEgOiJ1WtpFnCYWilIB+AuxlJoiAGziV3AcuOUTFwL/2vv/YrgtORmUW8wi2bHJk6N/izugV43pXGaCgL5/cruBqhNpWyWmINsifiss3UYwlZTrLoKAKbnGf3HA8e1Xi9qLYcmNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718716685; c=relaxed/simple;
	bh=7IXEP/OiCu0Q7Le6NJjj9L/7Dda8ynBJH4AIR8xvyE8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ETeVt8ASEtKTvGuWQoEJd0q+AnegTvu84xzY7dy8t507JTALCUUIU1IaKEyC9gFdcU2p+UdDJ0n3tSFCOnyG+Vbjdk97dkreJhPaqZAOIykVoLqBipI3Nqhs6lN9AhpVi+T3671wuVs6Bm9O6APoH+/rfTPI5TP2xdrSzS+kSao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0DCuQGLI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0DCuQGLI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8B44C3277B;
	Tue, 18 Jun 2024 13:18:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718716685;
	bh=7IXEP/OiCu0Q7Le6NJjj9L/7Dda8ynBJH4AIR8xvyE8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0DCuQGLIHYwmKTT3StUrq5/U0gb716h5q1MVkT5tNJmIvUek9lKRT4/gq1VcNXrB9
	 qWHvdQcY2R/kwTn4kca3OcDevYMmZIx7Uom6NrZ/tXHAv8SJqi1+vD4qbY487OEBhp
	 FrAfMWhAJo5iK+RtYbPLmYieE2uY0wt2JkebDyuc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	JianHong Yin <jiyin@redhat.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 729/770] nfsd: dont destroy global nfs4_file table in per-net shutdown
Date: Tue, 18 Jun 2024 14:39:42 +0200
Message-ID: <20240618123435.407462058@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240618123407.280171066@linuxfoundation.org>
References: <20240618123407.280171066@linuxfoundation.org>
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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4state.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index 3dd64caf06158..6c11f2701af88 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -8192,7 +8192,6 @@ nfs4_state_shutdown_net(struct net *net)
 
 	nfsd4_client_tracking_exit(net);
 	nfs4_state_destroy_net(net);
-	rhltable_destroy(&nfs4_file_rhltable);
 #ifdef CONFIG_NFSD_V4_2_INTER_SSC
 	nfsd4_ssc_shutdown_umount(nn);
 #endif
@@ -8202,6 +8201,7 @@ void
 nfs4_state_shutdown(void)
 {
 	nfsd4_destroy_callback_queue();
+	rhltable_destroy(&nfs4_file_rhltable);
 }
 
 static void
-- 
2.43.0



