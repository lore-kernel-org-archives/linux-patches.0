Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78A0A7B
	for <patches@lists.linux.dev>; Wed, 23 Nov 2022 08:59:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA450C433D6;
	Wed, 23 Nov 2022 08:59:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669193992;
	bh=kJ54kQwvYYVFdgE1bUWDINk7Vi8pAsHGDMtpQe3PfF0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kx1yemuGvn6vKEgwt3aUK4RzrY6pORy1Z8rwsY61IC1hO2hFLCOV1uEtWSqV4313P
	 7WY6ZlDGy80bnOR0q49rhwhaiDTY56A84dYmyUCIAgAHavIYQ+bE5kYrv508V1ChwC
	 CX5b8HvpeVF4dKJpJs9LfaundtCp92YHRutDAlts=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Duoming Zhou <duoming@zju.edu.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 40/88] tty: n_gsm: fix sleep-in-atomic-context bug in gsm_control_send
Date: Wed, 23 Nov 2022 09:50:37 +0100
Message-Id: <20221123084549.888167886@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084548.535439312@linuxfoundation.org>
References: <20221123084548.535439312@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Duoming Zhou <duoming@zju.edu.cn>

[ Upstream commit 7b7dfe4833c70a11cdfa51b38705103bd31eddaa ]

The function gsm_dlci_t1() is a timer handler that runs in an
atomic context, but it calls "kzalloc(..., GFP_KERNEL)" that
may sleep. As a result, the sleep-in-atomic-context bug will
happen. The process is shown below:

gsm_dlci_t1()
 gsm_dlci_open()
  gsm_modem_update()
   gsm_modem_upd_via_msc()
    gsm_control_send()
     kzalloc(sizeof(.., GFP_KERNEL) //may sleep

This patch changes the gfp_t parameter of kzalloc() from GFP_KERNEL to
GFP_ATOMIC in order to mitigate the bug.

Fixes: e1eaea46bb40 ("tty: n_gsm line discipline")
Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
Link: https://lore.kernel.org/r/20221002040709.27849-1-duoming@zju.edu.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/n_gsm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/tty/n_gsm.c b/drivers/tty/n_gsm.c
index 1d50f3ab4e5a..97f6860c911e 100644
--- a/drivers/tty/n_gsm.c
+++ b/drivers/tty/n_gsm.c
@@ -1425,7 +1425,7 @@ static struct gsm_control *gsm_control_send(struct gsm_mux *gsm,
 		unsigned int command, u8 *data, int clen)
 {
 	struct gsm_control *ctrl = kzalloc(sizeof(struct gsm_control),
-						GFP_KERNEL);
+						GFP_ATOMIC);
 	unsigned long flags;
 	if (ctrl == NULL)
 		return NULL;
-- 
2.35.1



