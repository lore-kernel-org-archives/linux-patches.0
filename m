Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4C9746E003;
	Tue, 21 Jul 2026 17:32:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655181; cv=none; b=p1URiDvOQEtRZb5Q2JIcZ8zxXgWXstd2zAlP68U6wKEZpzVm4WQBni93rBMS1eM5AB3iViWHXpeUqOeOBzfsdDpzlYyIR1VF8cOYdToFo6J8qLzseYfGcbXSxfDiy2sFm0YLoNZlWe51nX0YkdRsTtTSCDdVgSUMGYsk7K+05bc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655181; c=relaxed/simple;
	bh=WuLELtOfnu/RCVpGLMQW+uyP0XTGk/svJIBaphFMVg0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K88uwS1mv5dw3BbJ52fFDzOuKNxXzJM52fJDZbIrgPEPSX7ShY0saMurooi6lnhXRz9TWcnTs33MCHb2/mDD7mO41Ay7IBcBpXy3R/7Dj8fvO5iHumIZjkTzhET0o3DFye3bQ3NnjTXv+KkGQDkbPaaEeUq0XUpUlyI9cmV+6DE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HVRuCHUI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HVRuCHUI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 473351F000E9;
	Tue, 21 Jul 2026 17:32:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655179;
	bh=objwsKzarFqjJ6uT+mwZhq5QnFAFLAMyPnb2Ih39hAc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HVRuCHUI9pVCYs4fBGlKRtzKrpxBQ7DMyViYzvf6XVE3i2FacRjFy9vxAYT+wcIVb
	 fm6vcUxeZowYuQdwKVLQrdTqGiL67+jubccFsxNelavCOATiPnYPNV8d8qgysuCjvA
	 rJvVMyecIFa9jmsxASImSVw9Yc031p6uCAbC9SeE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Corey Minyard <corey@minyard.net>
Subject: [PATCH 7.1 1942/2077] ipmi: fix refcount leak in i_ipmi_request()
Date: Tue, 21 Jul 2026 17:26:55 +0200
Message-ID: <20260721152638.514203280@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Liang <vulab@iscas.ac.cn>

commit a3f3859cecacb64f18fd446271ece9a3b3f2d4de upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/ipmi/ipmi_msghandler.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/char/ipmi/ipmi_msghandler.c
+++ b/drivers/char/ipmi/ipmi_msghandler.c
@@ -2347,6 +2347,10 @@ static int i_ipmi_request(struct ipmi_us
 		if (smi_msg == NULL) {
 			if (!supplied_recv)
 				ipmi_free_recv_msg(recv_msg);
+			else if (recv_msg->user) {
+				atomic_dec(&recv_msg->user->nr_msgs);
+				kref_put(&recv_msg->user->refcount, free_ipmi_user);
+			}
 			return -ENOMEM;
 		}
 	}
@@ -2420,6 +2424,10 @@ out_err:
 			ipmi_free_smi_msg(smi_msg);
 		if (!supplied_recv)
 			ipmi_free_recv_msg(recv_msg);
+		else if (recv_msg->user) {
+			atomic_dec(&recv_msg->user->nr_msgs);
+			kref_put(&recv_msg->user->refcount, free_ipmi_user);
+		}
 	}
 	return rv;
 }


