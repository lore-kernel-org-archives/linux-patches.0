Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE23B3BFE5F;
	Thu, 15 Jan 2026 17:37:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768498651; cv=none; b=CyPejHSuBlbsMoAk7kRGooeS8Ya5yWy/T010wyMV4bBpPrgfoD+C1KQU/4VReaYiBOXammrQ6nd+yKat6LXAJJV+6yUoaUTmlkymzckQm5jb2dPlAGNLM8iszs+n0VopUpQ5XSxcKr2emCWGqUbBGY9tqHo9vs11/MnF0L93zpw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768498651; c=relaxed/simple;
	bh=Lr8BD/FDf+tqt6L0uhZLLXSeawZhFd1ipkrHR5WclCs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BhjVpDusEhGriUWR5BU6i4qjuQs2tJNUEFq3M8qCeuQSbR61Rd2sMiLzFialyphtcdCeK0X44yvSVKBnQ/dZKg9rCvPQMce2KQ6AiMiflvEm0XP5BXVvbMFheLWQVffnKMSmo++Jbqd+YQoYrmi/oQuDK1JRd0se+jvS2AF/1jY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rXY2PRBP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rXY2PRBP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D895C116D0;
	Thu, 15 Jan 2026 17:37:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768498650;
	bh=Lr8BD/FDf+tqt6L0uhZLLXSeawZhFd1ipkrHR5WclCs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rXY2PRBPtbIWaqQ3my5Xx/zr7BAroNbwKihw/z4RTBcc4qG8uqdhDdGy+1vMqhL5B
	 Cgm00BatIg9FLTFQP2Jq43LpLZxabDYxX6+6gspfGG177YfQLgBWqpDZ9PmPMfdczf
	 7GlKC2sQBG4yh7dnxSM2DfM2m/QDxpz2WqGvKUao=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ziming zhang <ezrakiez@gmail.com>,
	Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 5.15 507/554] libceph: prevent potential out-of-bounds reads in handle_auth_done()
Date: Thu, 15 Jan 2026 17:49:33 +0100
Message-ID: <20260115164304.669339664@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2068,7 +2068,9 @@ static int process_auth_done(struct ceph
 
 	ceph_decode_64_safe(&p, end, global_id, bad);
 	ceph_decode_32_safe(&p, end, con->v2.con_mode, bad);
+
 	ceph_decode_32_safe(&p, end, payload_len, bad);
+	ceph_decode_need(&p, end, payload_len, bad);
 
 	dout("%s con %p global_id %llu con_mode %d payload_len %d\n",
 	     __func__, con, global_id, con->v2.con_mode, payload_len);


