Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73F957469
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 20:26:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C888FC433C9;
	Sun, 17 Sep 2023 20:26:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694982377;
	bh=uOYaHMUKmZ/eIBEfn9Cu3qu/Fb70ioGlMAnnQmLPpTs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P2zN0e+sxKzYoevIyhQJswXxj54NQsaLQNew+J9Ntm+I6bICxmw+YsPUavO5sR8zS
	 w1mdrJXXTUH51UlcWKoLPAg9/DczgQ2XdzMIXu7nsa4q3fSZdRaAO0k4mWuerGJWM8
	 PgmssKkIX49ool6w6wU7Orn8j1TipTP7+cQv92tM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Olga Kornievskaia <kolga@netapp.com>,
	Anna Schumaker <Anna.Schumaker@Netapp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 232/511] NFSv4.2: fix handling of COPY ERR_OFFLOAD_NO_REQ
Date: Sun, 17 Sep 2023 21:10:59 +0200
Message-ID: <20230917191119.411426173@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191113.831992765@linuxfoundation.org>
References: <20230917191113.831992765@linuxfoundation.org>
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

From: Olga Kornievskaia <kolga@netapp.com>

[ Upstream commit 5690eed941ab7e33c3c3d6b850100cabf740f075 ]

If the client sent a synchronous copy and the server replied with
ERR_OFFLOAD_NO_REQ indicating that it wants an asynchronous
copy instead, the client should retry with asynchronous copy.

Fixes: 539f57b3e0fd ("NFS handle COPY ERR_OFFLOAD_NO_REQS")
Signed-off-by: Olga Kornievskaia <kolga@netapp.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/nfs42proc.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/nfs/nfs42proc.c b/fs/nfs/nfs42proc.c
index bc07012741cb4..2975bbc33d280 100644
--- a/fs/nfs/nfs42proc.c
+++ b/fs/nfs/nfs42proc.c
@@ -462,8 +462,9 @@ ssize_t nfs42_proc_copy(struct file *src, loff_t pos_src,
 				continue;
 			}
 			break;
-		} else if (err == -NFS4ERR_OFFLOAD_NO_REQS && !args.sync) {
-			args.sync = true;
+		} else if (err == -NFS4ERR_OFFLOAD_NO_REQS &&
+				args.sync != res.synchronous) {
+			args.sync = res.synchronous;
 			dst_exception.retry = 1;
 			continue;
 		} else if ((err == -ESTALE ||
-- 
2.40.1



