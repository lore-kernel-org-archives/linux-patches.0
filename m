Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50A383ADB9A;
	Tue, 12 May 2026 17:46:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778607975; cv=none; b=mRqp87e35nNpg63ORdQM6YFMchwBImFnA9uj1/psM5Cot7+ASs2yU/CjiZao7VDXvhCLVOnxt3PmM2Ite34wrP1BlCaakz25+vzLwO2mOZa+R9WW1uCRIpu2CVrE6PAvvFbEREh9BeRr3XNwHRpUu0G/SbfrghTyfqVoAZizSKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778607975; c=relaxed/simple;
	bh=KqOf0mL9zQ6XIAGbD+pYuOkOXcTnLQAjjH2HHGjBHIk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TA+Yeai1zDE+br2P24QjVX7d6w89e1BQDLHU+9p8T/TK/zQiZyA+/mLV00/v4RqGljji8P4aAFndhxzuE7rL8qm7V0qtQJNMQTY9qyCSrRFoA9y7nfghHjx6LsmWktPFQZ37GyX+jsNltdafsDalyyqCFgMuoTHssL9r0YwsxbM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dBpLS8lD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dBpLS8lD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD0E3C2BCB0;
	Tue, 12 May 2026 17:46:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778607975;
	bh=KqOf0mL9zQ6XIAGbD+pYuOkOXcTnLQAjjH2HHGjBHIk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dBpLS8lDnvTCce6Cn+GJuU0qaB+su5gcvxNQ6UZPsbM1FeT7/8RmFfGSboyXw7xyD
	 UZL2gd6K4fNO8iU3QnRjLVMDnP7niacFfOYQNj9vEiybv4BQInjWLWoz2FjObQzozw
	 B+ia5M6dPN95VJ3LO3iH9hXHhpcyULorD++B83Ho=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Siwei Zhang <oss@fourdim.xyz>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.12 065/206] Bluetooth: L2CAP: Fix null-ptr-deref in l2cap_sock_new_connection_cb()
Date: Tue, 12 May 2026 19:38:37 +0200
Message-ID: <20260512173934.221056386@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173932.810559588@linuxfoundation.org>
References: <20260512173932.810559588@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Siwei Zhang <oss@fourdim.xyz>

commit 0a120d96166301d7a95be75b52f843837dbd1219 upstream.

Add the same NULL guard already present in
l2cap_sock_resume_cb() and l2cap_sock_ready_cb().

Fixes: 80808e431e1e ("Bluetooth: Add l2cap_chan_ops abstraction")
Cc: stable@kernel.org
Signed-off-by: Siwei Zhang <oss@fourdim.xyz>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/l2cap_sock.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/bluetooth/l2cap_sock.c
+++ b/net/bluetooth/l2cap_sock.c
@@ -1467,6 +1467,9 @@ static struct l2cap_chan *l2cap_sock_new
 {
 	struct sock *sk, *parent = chan->data;
 
+	if (!parent)
+		return NULL;
+
 	lock_sock(parent);
 
 	/* Check for backlog size */


