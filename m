Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59CEB2DF3EA;
	Tue, 21 Jul 2026 18:39:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659193; cv=none; b=ZtrOHlZRp2RLkTd6LF+lFqThyJY4BPkXD9wjjRnutu7TClsv1Rxk3TD6FAQUtz2eXvGS7+hHWiTUSRzxR4IsEIfDPiEUi1JC7m/Xi436ioCxhnarfkl6y5260ASOaV8I+TTzsgO+qngK9FQJcUaEDIHZk+ObnaCrnh5Io1S8Nus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659193; c=relaxed/simple;
	bh=cy/JSVuXpXatkbCKCSMefQdwTEBamlhmfnlUtsF1ZUI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ajSZCEEoa9+c6Fsr0tyKP0PM7EhurvKmYWwk1ufTZucBbsrlh/eTAi1rq4oYDPkU4vw1uZKiQyQVGLhB0wAYYJu8cK0BsuT/QkZfWbRQ+AcLD8YIED5fhhRPnGIbGqevJlKkOxOA5w9E25F2CebG2Qx4A2psS+5V9csiUaEJtRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R1P8Fa2U; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R1P8Fa2U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E37C1F000E9;
	Tue, 21 Jul 2026 18:39:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659192;
	bh=1qrjWXPaokc790XDNgH2AZDu48B9VMqoN/+e8/NNDf8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=R1P8Fa2UwFnpfka9JPXyLl9HToi+l79OJfMjQOoOYzPFSzCTGKzpieidlSmVGLEMh
	 a8NurBf3v1i5BzslcGKIGm4aaPEI9AyYtJceg8KqeCVAAtN7zYKaUDesBSjdJJAZp1
	 +ip25eiuwuWAF4w23cD/BIGImiu5x1XyjibcOeKA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Corey Minyard <corey@minyard.net>
Subject: [PATCH 6.18 1427/1611] ipmi: fix refcount leak in i_ipmi_request()
Date: Tue, 21 Jul 2026 17:25:43 +0200
Message-ID: <20260721152547.533364033@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2349,6 +2349,10 @@ static int i_ipmi_request(struct ipmi_us
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
@@ -2422,6 +2426,10 @@ out_err:
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


