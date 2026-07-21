Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C020046D090;
	Tue, 21 Jul 2026 17:34:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655254; cv=none; b=eI/OtxvFqnO6kcKjUsqljKxfJfwOKQHuDOCV4XjNvFmAVA2KxdR1zSSd+prrCBw9uf2+5CHJCQXKTM/9bE93A84f/Qy/MUAz4T+4aWi1vC7wF/j0ZxcCg/OZKCGySC16eUhVDT59Ln67auHiQD1gryr8q2JckoMRCxlQEJz5/iw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655254; c=relaxed/simple;
	bh=sbl8kxGMLnsbLI/MvJPKXZ7rwXzv/v1SU+wlAWPxy3Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q2F9OBP3HFiCrq9/GByr7sseZZA3cXHqhjy1QULEvuLVMQY+24qy5fk6jMSIVtdLSWVAf1DiLLRV+lhoBesiAV8jfdkNiFoKKQsi9J7f0BIlYV2uTEviZkscVICeMCK08fkJlpz5ErJDA+HMerJrNBEJrUghzYlZF//KS8BZBnY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cqAIwTon; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cqAIwTon"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 337781F000E9;
	Tue, 21 Jul 2026 17:34:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655253;
	bh=EV9tKuslq45EnBMqyf9LW9TmBhvZsa+747UwCSDHbyk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cqAIwTone16WsEyL3bSqkbRIoCUwIZnAIwnM/qRSCrylpm99FdpuviX7nWPKjzKfp
	 pbkZvwCvlPndEA8DpF7anXABcUd2ui+27fXPsSJjegW5X8lrOa0CuyN3nFEhuMSE9o
	 Yde1sIqLPcPzNJhcpnkyE/MKi+DVCc+JD5KBQGPE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xuanqiang Luo <luoxuanqiang@kylinos.cn>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 7.1 2013/2077] llc: fix SAP refcount leak when creating incoming sockets
Date: Tue, 21 Jul 2026 17:28:06 +0200
Message-ID: <20260721152640.186264990@linuxfoundation.org>
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

From: Xuanqiang Luo <luoxuanqiang@kylinos.cn>

commit 2c72eb6286347d05a885412fb076993bd5286b53 upstream.

llc_sap_add_socket() takes a SAP reference for each socket added to a SAP,
and llc_sap_remove_socket() releases it. llc_create_incoming_sock() takes
an additional SAP reference after adding the child socket.

This extra reference was balanced by an explicit llc_sap_put() in
llc_ui_release() until commit 3100aa9d74db ("llc: fix SAP reference
counting w.r.t. socket handling") removed that put. The corresponding hold
in the accept path was left behind.

When such a child socket is removed, only the reference taken by
llc_sap_add_socket() is released. The extra reference keeps the SAP alive
after its last socket is removed. Remove the obsolete hold.

Fixes: 3100aa9d74db ("llc: fix SAP reference counting w.r.t. socket handling")
Cc: stable@vger.kernel.org
Signed-off-by: Xuanqiang Luo <luoxuanqiang@kylinos.cn>
Link: https://patch.msgid.link/20260712130343.518797-1-xuanqiang.luo@linux.dev
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/llc/llc_conn.c |    1 -
 1 file changed, 1 deletion(-)

--- a/net/llc/llc_conn.c
+++ b/net/llc/llc_conn.c
@@ -773,7 +773,6 @@ static struct sock *llc_create_incoming_
 	newllc->dev = dev;
 	dev_hold(dev);
 	llc_sap_add_socket(llc->sap, newsk);
-	llc_sap_hold(llc->sap);
 out:
 	return newsk;
 }


