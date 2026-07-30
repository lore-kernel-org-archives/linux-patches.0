Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B57245199A;
	Thu, 30 Jul 2026 16:19:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785428343; cv=none; b=bkXFX0h9dvMSgcNVnAyiFXqf9uHSd7FU9UMzpoeW04QfAz0p/NhnIcKgZ9i0KtvqXOxZkwky5aeyRjtGI/5039sHlpPeSx6nfyazOhHIzT7kFjOk1+GgB2yL8rrVhfpL6wHMFUt3Gg5kEEz551boqQbWqan2BOoZJ1GwroExrxE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785428343; c=relaxed/simple;
	bh=ih2hT20mRZL28IUbWnTCg2rN8EXG4l+8Hk8FGdbT3T0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XKN3Nm+joZ9J/hh4bIsL/TjWLprr+8sgnRlEfqAQBxbd8rnLGFQiTnLfhyf54SBDylZ8ryMfnxmwsbDnRwoUqr4AU/t6qdYvsLB6OCNxnrLr118BwTR57oxSYVCBJ9rym4A2x4eN++RU2/ATvQgshtyRFWUKnwzlxFZaXVogmdw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=djUYWtGA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="djUYWtGA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E14161F000E9;
	Thu, 30 Jul 2026 16:19:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785428342;
	bh=v/IPfXXgA6tDApxnUrjR4lgR+q1el+Gp71XDvS5s2XM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=djUYWtGAZG8P5ba/Ht12Z2FFBJJWFgBVyI4Yzo8b6pKPoU58N6JcLeh0WqWVASD7J
	 ZAwgsraAi9lZWfCQX19wcspLSJnakBouKJOMXJLxEi/vFRAy1Z/2kb9l+m8eqjb4i+
	 AexYyDurwkG5+Ufgt3CrvKEenUdlH4QKSpb7IKUU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Corey Minyard <corey@minyard.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 469/484] ipmi: fix refcount leak in i_ipmi_request()
Date: Thu, 30 Jul 2026 16:16:06 +0200
Message-ID: <20260730141433.675868191@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
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

From: Wentao Liang <vulab@iscas.ac.cn>

[ Upstream commit a3f3859cecacb64f18fd446271ece9a3b3f2d4de ]

When a caller provides a `supplied_recv` message to i_ipmi_request(),
the function increments the user's `nr_msgs` reference count. If an
error occurs later, the out_err cleanup path only frees the recv_msg
if the function allocated it itself (i.e., !supplied_recv). In the
supplied_recv case the cleanup is skipped, leaving the reference count
elevated. The caller ipmi_request_supply_msgs() does not release the
supplied_recv on error, so the reference is permanently leaked.

Fix this by explicitly reverting the reference count operations when a
supplied recv_msg with a valid user pointer is present in the error
path: decrement nr_msgs and drop the user's kref.

Cc: stable@vger.kernel.org
Fixes: b52da4054ee0 ("ipmi: Rework user message limit handling")
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Message-ID: <20260603120634.3758747-1-vulab@iscas.ac.cn>
Signed-off-by: Corey Minyard <corey@minyard.net>
[ changed `free_ipmi_user` to `free_user` in the two added `kref_put()` calls ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/ipmi/ipmi_msghandler.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/char/ipmi/ipmi_msghandler.c
+++ b/drivers/char/ipmi/ipmi_msghandler.c
@@ -2331,6 +2331,10 @@ static int i_ipmi_request(struct ipmi_us
 		if (smi_msg == NULL) {
 			if (!supplied_recv)
 				ipmi_free_recv_msg(recv_msg);
+			else if (recv_msg->user) {
+				atomic_dec(&recv_msg->user->nr_msgs);
+				kref_put(&recv_msg->user->refcount, free_user);
+			}
 			return -ENOMEM;
 		}
 	}
@@ -2373,6 +2377,10 @@ out_err:
 			ipmi_free_smi_msg(smi_msg);
 		if (!supplied_recv)
 			ipmi_free_recv_msg(recv_msg);
+		else if (recv_msg->user) {
+			atomic_dec(&recv_msg->user->nr_msgs);
+			kref_put(&recv_msg->user->refcount, free_user);
+		}
 	} else {
 		dev_dbg(intf->si_dev, "Send: %*ph\n",
 			smi_msg->data_size, smi_msg->data);


