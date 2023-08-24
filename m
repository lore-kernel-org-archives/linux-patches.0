Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 996F314A81
	for <patches@lists.linux.dev>; Thu, 24 Aug 2023 17:18:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B7CCC433C8;
	Thu, 24 Aug 2023 17:18:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1692897529;
	bh=Yhg2KtM0AIHTGUW9p9lPrihK7mIQvtQoxfgztKPxNC0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lytZ2BMzdD8B1Vbh/nIqCbH1F6Q94iM0F+5zHd3JagFO4UZF667X1M7X8CQc1TX+6
	 seo/UuWgCLmeN3WUc/z4e01N0QpNDEsShUt48r68sCYTsZIFJRsoKI6MzomPkSDGGe
	 Gam2Kn3W8IuuJZ6HOmUkoBbluRRn5ET8gKQTKkFA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Yi Yang <yiyang13@huawei.com>,
	Qiumiao Zhang <zhangqiumiao1@huawei.com>
Subject: [PATCH 5.10 072/135] tty: n_gsm: fix the UAF caused by race condition in gsm_cleanup_mux
Date: Thu, 24 Aug 2023 19:09:04 +0200
Message-ID: <20230824170620.329890738@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230824170617.074557800@linuxfoundation.org>
References: <20230824170617.074557800@linuxfoundation.org>
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

From: Yi Yang <yiyang13@huawei.com>

commit 3c4f8333b582487a2d1e02171f1465531cde53e3 upstream.

In commit 9b9c8195f3f0 ("tty: n_gsm: fix UAF in gsm_cleanup_mux"), the UAF
problem is not completely fixed. There is a race condition in
gsm_cleanup_mux(), which caused this UAF.

The UAF problem is triggered by the following race:
task[5046]                     task[5054]
-----------------------        -----------------------
gsm_cleanup_mux();
dlci = gsm->dlci[0];
mutex_lock(&gsm->mutex);
                               gsm_cleanup_mux();
			       dlci = gsm->dlci[0]; //Didn't take the lock
gsm_dlci_release(gsm->dlci[i]);
gsm->dlci[i] = NULL;
mutex_unlock(&gsm->mutex);
                               mutex_lock(&gsm->mutex);
			       dlci->dead = true; //UAF

Fix it by assigning values after mutex_lock().

Link: https://syzkaller.appspot.com/text?tag=CrashReport&x=176188b5a80000
Cc: stable <stable@kernel.org>
Fixes: 9b9c8195f3f0 ("tty: n_gsm: fix UAF in gsm_cleanup_mux")
Fixes: aa371e96f05d ("tty: n_gsm: fix restart handling via CLD command")
Signed-off-by: Yi Yang <yiyang13@huawei.com>
Co-developed-by: Qiumiao Zhang <zhangqiumiao1@huawei.com>
Signed-off-by: Qiumiao Zhang <zhangqiumiao1@huawei.com>
Link: https://lore.kernel.org/r/20230811031121.153237-1-yiyang13@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/n_gsm.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/tty/n_gsm.c
+++ b/drivers/tty/n_gsm.c
@@ -2159,12 +2159,13 @@ static void gsm_error(struct gsm_mux *gs
 static void gsm_cleanup_mux(struct gsm_mux *gsm, bool disc)
 {
 	int i;
-	struct gsm_dlci *dlci = gsm->dlci[0];
+	struct gsm_dlci *dlci;
 	struct gsm_msg *txq, *ntxq;
 
 	gsm->dead = true;
 	mutex_lock(&gsm->mutex);
 
+	dlci = gsm->dlci[0];
 	if (dlci) {
 		if (disc && dlci->state != DLCI_CLOSED) {
 			gsm_dlci_begin_close(dlci);


