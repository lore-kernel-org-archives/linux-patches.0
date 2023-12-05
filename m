Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87DF06FAF;
	Tue,  5 Dec 2023 03:24:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uOpgYnng"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22A5AC433C7;
	Tue,  5 Dec 2023 03:24:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701746670;
	bh=58/xryAtwbf82pTdTrEKD2oGKL+4o+47VM71PTpCkvw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uOpgYnngeEbRdDUePfXdZfuL+yvgTCfWts1luC60mt6ps+48nnaqZyS/6pCnb2jWm
	 qUrOg/Wiyj7roKGbubzSnmqCBkWkCORuma3JHVbCTtsVg7WM61GmQVbJovPUQcaq/i
	 4sY9zqlIheB7MCKAIHqGd9ycNhp6q2vAAfqwKt50=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+44c2416196b7c607f226@syzkaller.appspotmail.com,
	Stanislav Fomichev <sdf@google.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Dipendra Khadka <kdipendra88@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 078/134] netdevsim: Dont accept device bound programs
Date: Tue,  5 Dec 2023 12:15:50 +0900
Message-ID: <20231205031540.428169053@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231205031535.163661217@linuxfoundation.org>
References: <20231205031535.163661217@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stanislav Fomichev <sdf@google.com>

[ Upstream commit c0c6bde586c7dce82719b4ff32a2db6af9ee3d65 ]

Commit 2b3486bc2d23 ("bpf: Introduce device-bound XDP programs") introduced
device-bound programs by largely reusing existing offloading infrastructure.
This changed the semantics of 'prog->aux->offload' a bit. Now, it's non-NULL
for both offloaded and device-bound programs.

Instead of looking at 'prog->aux->offload' let's call bpf_prog_is_offloaded
which should be true iff the program is offloaded and not merely device-bound.

Fixes: 2b3486bc2d23 ("bpf: Introduce device-bound XDP programs")
Reported-by: syzbot+44c2416196b7c607f226@syzkaller.appspotmail.com
Signed-off-by: Stanislav Fomichev <sdf@google.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Reviewed-by: Jakub Kicinski <kuba@kernel.org>
Cc: Dipendra Khadka <kdipendra88@gmail.com>
Link: https://lore.kernel.org/bpf/20231114045453.1816995-2-sdf@google.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/netdevsim/bpf.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/netdevsim/bpf.c b/drivers/net/netdevsim/bpf.c
index f60eb97e3a627..608953d4f98da 100644
--- a/drivers/net/netdevsim/bpf.c
+++ b/drivers/net/netdevsim/bpf.c
@@ -93,7 +93,7 @@ static void nsim_prog_set_loaded(struct bpf_prog *prog, bool loaded)
 {
 	struct nsim_bpf_bound_prog *state;
 
-	if (!prog || !prog->aux->offload)
+	if (!prog || !bpf_prog_is_offloaded(prog->aux))
 		return;
 
 	state = prog->aux->offload->dev_priv;
@@ -311,7 +311,7 @@ nsim_setup_prog_hw_checks(struct netdevsim *ns, struct netdev_bpf *bpf)
 	if (!bpf->prog)
 		return 0;
 
-	if (!bpf->prog->aux->offload) {
+	if (!bpf_prog_is_offloaded(bpf->prog->aux)) {
 		NSIM_EA(bpf->extack, "xdpoffload of non-bound program");
 		return -EINVAL;
 	}
-- 
2.42.0



