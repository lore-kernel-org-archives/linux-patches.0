Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D9AF3803EA;
	Tue, 10 Mar 2026 11:28:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773142112; cv=none; b=kX2EdHnsXFnTWHW250m0P+q0DnMKf/MhGDaAVqvvmdedbaHdsFwYlN87sgiLWrOfDPKDGWMWsfQvIri6loL3DrIPDSDRc9Jq1FoVmS79JiRYYOoXeiCRYYOhK4f01Hme24hSFOOi+WzU8nXf9R1vovYeHm8USW1GzJn0xEVOiI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773142112; c=relaxed/simple;
	bh=LtZDzyPCXDKFEetIY916+626sqSmRBthZTuOCtk8f0s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=haaDLgGqZWRLevnt95hXzdyZAh4BVdArh45pqQGWazouUsJ6tDP788e+r6KbDx8zRgZvPTrNX651Idulo8K+CW8QdUqDT5zEv5WWnb5ReUpZX9NNlzJTaKuoSq9BMq5TCaJGs/XfPM0kcE2cS4xQGGEdXO58gQ3GD+0XW3ng9UI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bPkFoWKQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bPkFoWKQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93A12C2BCAF;
	Tue, 10 Mar 2026 11:28:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773142112;
	bh=LtZDzyPCXDKFEetIY916+626sqSmRBthZTuOCtk8f0s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bPkFoWKQ3Ip9/Jq15z8oK0Hdd+NimmMzcFPv85zPHor9xIYjGDQRKCdU+gYlLiP/M
	 9/WWGdUAsCmPr1F+7+bTqq/bBaK4bD7skCXYbarCVRX7NL76KficTNcw1x+y7wLYRL
	 qF8wosZ00eZizVtlR53B4c7bzh+Jl0JPSiXULmyrhczB6Vft4aBe0QZ+JcWav8HpY7
	 yOeT2U4i6lFVWQXFcaBAgNzNgvWkLFmwkf7oOhQ9zd1q3NkePby2wgwnJilLNwtTvs
	 pI8dbhhJdqH9H4Pg2/uZm7echE0WBoKk8uVBcmSKurJDfcZNPf/AxNWOwRw+dgspmz
	 wZhaFUf3ny0qg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Fedor Pchelkin <pchelkin@ispras.ru>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 6.18 200/314] ksmbd: call ksmbd_vfs_kern_path_end_removing() on some error paths
Date: Tue, 10 Mar 2026 07:17:39 -0400
Message-ID: <a142f1485b9e42fff1633d23a412ddef9355fe29.1773141555.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773141554.git.sashal@kernel.org>
References: <cover.1773141554.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Fedor Pchelkin <pchelkin@ispras.ru>

[ Upstream commit a09dc10d1353f0e92c21eae2a79af1c2b1ddcde8 ]

There are two places where ksmbd_vfs_kern_path_end_removing() needs to be
called in order to balance what the corresponding successful call to
ksmbd_vfs_kern_path_start_removing() has done, i.e. drop inode locks and
put the taken references.  Otherwise there might be potential deadlocks
and unbalanced locks which are caught like:

BUG: workqueue leaked lock or atomic: kworker/5:21/0x00000000/7596
     last function: handle_ksmbd_work
2 locks held by kworker/5:21/7596:
 #0: ffff8881051ae448 (sb_writers#3){.+.+}-{0:0}, at: ksmbd_vfs_kern_path_locked+0x142/0x660
 #1: ffff888130e966c0 (&type->i_mutex_dir_key#3/1){+.+.}-{4:4}, at: ksmbd_vfs_kern_path_locked+0x17d/0x660
CPU: 5 PID: 7596 Comm: kworker/5:21 Not tainted 6.1.162-00456-gc29b353f383b #138
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.17.0-debian-1.17.0-1 04/01/2014
Workqueue: ksmbd-io handle_ksmbd_work
Call Trace:
 <TASK>
 dump_stack_lvl+0x44/0x5b
 process_one_work.cold+0x57/0x5c
 worker_thread+0x82/0x600
 kthread+0x153/0x190
 ret_from_fork+0x22/0x30
 </TASK>

Found by Linux Verification Center (linuxtesting.org).

Fixes: d5fc1400a34b ("smb/server: avoid deadlock when linking with ReplaceIfExists")
Cc: stable@vger.kernel.org
Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
[ ksmbd_vfs_kern_path_end_removing() -> ksmbd_vfs_kern_path_unlock() ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/smb2pdu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index bf8c480594367..e52b9136abbff 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -6117,14 +6117,14 @@ static int smb2_create_link(struct ksmbd_work *work,
 				rc = -EINVAL;
 				ksmbd_debug(SMB, "cannot delete %s\n",
 					    link_name);
-				goto out;
 			}
 		} else {
 			rc = -EEXIST;
 			ksmbd_debug(SMB, "link already exists\n");
-			goto out;
 		}
 		ksmbd_vfs_kern_path_unlock(&path);
+		if (rc)
+			goto out;
 	}
 	rc = ksmbd_vfs_link(work, target_name, link_name);
 	if (rc)
-- 
2.51.0

