Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 409C22D73BE;
	Thu, 15 Jan 2026 17:01:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496466; cv=none; b=f8AiOIJZcfDF9ba5x62a1Rq5+0HIHu20+IOKqmoRlnSE3PCx+oUPYcb9m765F/B20FFn6CBWSIdF43TwxwiO9HlfxmAhNP3t3+gbuMBKbTavxM6GPeqPuim8b4Nd1k8rt9Ihpz6LroQ1KZ9DjKE46nFlMoBIhWz8vx9OP6dmdrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496466; c=relaxed/simple;
	bh=1klvs3qLx9P7D87HHTMOMu8lmv50aAGQoEEjBxXCzNE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L/nGPwU5HvBOKQ/prGY3/dpcar6T+ZJtNiGPJnV8B9sxNm8RRsMbaEQtFsFAMkOvMovaW3OnHJHkBB5/JtvaE4cxFyAuBsG0l3qZLpEq4+sW9KBc4wPiKWnv/H1k2Zopyav/QqxZ02Fzmf82BZa//OLB6CC+/UFrshDIh1qUYZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WL3hx9fE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WL3hx9fE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94A0FC116D0;
	Thu, 15 Jan 2026 17:01:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496466;
	bh=1klvs3qLx9P7D87HHTMOMu8lmv50aAGQoEEjBxXCzNE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WL3hx9fEUGt5ehRJoGeNt10QzldsZdB1K45T15yb8ShrgbtArMV2vHIsAWaFKBeu+
	 ikmiEg7UgwH/GQHRWvP5GRBfRwtEgyPtWlkadkW5bg+uzECfV0Ho90JxWvjEBpyHWc
	 FwfnnO1mwOS2QJ5sYIKuThVmzR70MJ/obE4jYUsg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ziming zhang <ezrakiez@gmail.com>,
	Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 6.12 022/119] libceph: prevent potential out-of-bounds reads in handle_auth_done()
Date: Thu, 15 Jan 2026 17:47:17 +0100
Message-ID: <20260115164152.762313676@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164151.948839306@linuxfoundation.org>
References: <20260115164151.948839306@linuxfoundation.org>
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

From: ziming zhang <ezrakiez@gmail.com>

commit 818156caffbf55cb4d368f9c3cac64e458fb49c9 upstream.

Perform an explicit bounds check on payload_len to avoid a possible
out-of-bounds access in the callout.

[ idryomov: changelog ]

Cc: stable@vger.kernel.org
Signed-off-by: ziming zhang <ezrakiez@gmail.com>
Reviewed-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ceph/messenger_v2.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/ceph/messenger_v2.c
+++ b/net/ceph/messenger_v2.c
@@ -2405,7 +2405,9 @@ static int process_auth_done(struct ceph
 
 	ceph_decode_64_safe(&p, end, global_id, bad);
 	ceph_decode_32_safe(&p, end, con->v2.con_mode, bad);
+
 	ceph_decode_32_safe(&p, end, payload_len, bad);
+	ceph_decode_need(&p, end, payload_len, bad);
 
 	dout("%s con %p global_id %llu con_mode %d payload_len %d\n",
 	     __func__, con, global_id, con->v2.con_mode, payload_len);


