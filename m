Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CA854CA784;
	Wed, 30 Sep 2026 16:57:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790787478; cv=none; b=h9G2RVw0gL+yBpyC+VaVLZ9JRnDCsJ8rslBaMo9Q5WOBbRwdKLTdg/TxbZ6e/eSaWlofkzSDaCETuvNAfIkwT/u5z2OrAzo+ViOfYzV1i21u/c4cabkvj43NuMNGomAOwYQktoZumjsJ4AjGboxMQAFktiv/ja6ILgbFhSmJCrw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790787478; c=relaxed/simple;
	bh=eZp5g5pcvuxi5hpMoG+v/mXVBHpPeMUFLcg6TuY3S10=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y1y22tbhLKWUI2K5bPkflt+i8rrm0eQdEFzz7a4VuXsEWzg+U/nXeJ/tMtLjDk/3Wee3vlWNVp5QbxwQ8VgkaM9bZ2Drp/jewC4eMMdJnHstlX6X8GilaMZgja+MLX7kpXmq7q5KWSAGr2C3SARJyi6B8CMbxYgIZV8VWsm2kx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QlZi4EEh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QlZi4EEh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64EA41F000FF;
	Wed, 30 Sep 2026 16:57:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790787476;
	bh=msYaW8n4YHNq3ofVIGHj9C7/DI2hPgYPRMduuZoUH3A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QlZi4EEhG4FEP89N+oVwXzmcVOSCJLZn/WXSwKJwSAgyabvnV0dsGyyXjECWBqXX+
	 RBap0DqPl10ibTmvDDfSilfv5WdinP5+RmXZ9ACJJzfIOiyNcjcphuRQaXFfZ1uNq3
	 W59jtlX+0iw4ORyRSp+erILw7yWkxkE1FFLqBZk0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luigi Leonardi <leonardi@redhat.com>,
	Aldo Ariel Panzardo <qwe.aldo@gmail.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Bobby Eshleman <bobbyeshleman@meta.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.2 242/457] vsock: ignore empty child namespace mode writes
Date: Wed, 30 Sep 2026 17:25:47 +0200
Message-ID: <20260930152351.267788083@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aldo Ariel Panzardo <qwe.aldo@gmail.com>

commit 2ec28c09b320ba241bea8a70ee5cb9ccf4a099e8 upstream.

__vsock_net_mode_string() returns success without updating new_mode when
the transfer length is zero. Its caller then reads the uninitialized enum
and may permanently store a stack-derived value in the write-once child
mode.

Return before calling __vsock_net_mode_string() when *lenp is zero so
that the helper is never invoked with nothing to parse and new_mode is
never read uninitialized. This also prevents an empty write from
locking the current mode.

Fixes: eafb64f40ca4 ("vsock: add netns to vsock core")
Cc: stable@vger.kernel.org
Reviewed-by: Luigi Leonardi <leonardi@redhat.com>
Signed-off-by: Aldo Ariel Panzardo <qwe.aldo@gmail.com>
Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
Reviewed-by: Bobby Eshleman <bobbyeshleman@meta.com>
Link: https://patch.msgid.link/20260915173050.3176344-1-qwe.aldo@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/vmw_vsock/af_vsock.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -2873,6 +2873,9 @@ static int vsock_net_child_mode_string(c
 
 	net = container_of(table->data, struct net, vsock.child_ns_mode);
 
+	if (!*lenp)
+		return 0;
+
 	ret = __vsock_net_mode_string(table, write, buffer, lenp, ppos,
 				      vsock_net_child_mode(net), &new_mode);
 	if (ret)


