Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DD041DF721;
	Wed,  6 Nov 2024 12:20:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730895612; cv=none; b=lCpFYTI7BlV6LeezMV2Jj0yfKfdtD0GbnEPIj4cYCY0SCefk1HUml6ZmRqYtqoQB8wvPTf+Z2PNH1/IpGVvgK5WvmH/CfvGRJ2QH3+7K3ufZ1nufPMpzDwacVjtRoqdAw0g2qFtxAUxCowlCekODrb/LQQ7chydn8DvGnra96hU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730895612; c=relaxed/simple;
	bh=TECVM5jZ8Yvyoy+N7oaFx3FlU7wgfV28zMIy8fW0J/g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j+81kc4vXGpUGOA7iIbLaLBq3OFQ7ohoHkHMV7VhQyzkLtbZC6LK3uqIOx6XwkhSHOZIM+SF6bCwPh4WxHVzV9uUCcFcXhYbEwS6mTBM/9HXNE65esBZw5nXbNbkkMQEBBEzZR5hXo7MLYER8zUeXo/J1e4qs199bN1kOiM/Nkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pJRD6oKa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pJRD6oKa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4D31C4CED6;
	Wed,  6 Nov 2024 12:20:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730895612;
	bh=TECVM5jZ8Yvyoy+N7oaFx3FlU7wgfV28zMIy8fW0J/g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pJRD6oKaUfFY3ehXAvWC7QjKJRFcQSzpvFPFLrWWY38BYkWe3PLLD6EDFnS5wcieS
	 O2gmwxSLRODeTdqBFGfUmI8+UDpWZVBK6YU+srn7J7ALK43KXh8Qn9REnaPvlcnhc1
	 7RW2rRqJaAF6Kqc4sZ1vcUHjtRd3WKF98Ib31V1I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Anna Schumaker <anna.schumaker@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 249/350] SUNRPC: Fix integer overflow in decode_rc_list()
Date: Wed,  6 Nov 2024 13:02:57 +0100
Message-ID: <20241106120327.075095662@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120320.865793091@linuxfoundation.org>
References: <20241106120320.865793091@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit 6dbf1f341b6b35bcc20ff95b6b315e509f6c5369 ]

The math in "rc_list->rcl_nrefcalls * 2 * sizeof(uint32_t)" could have an
integer overflow.  Add bounds checking on rc_list->rcl_nrefcalls to fix
that.

Fixes: 4aece6a19cf7 ("nfs41: cb_sequence xdr implementation")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Anna Schumaker <anna.schumaker@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/callback_xdr.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/nfs/callback_xdr.c b/fs/nfs/callback_xdr.c
index 38dc33c537ab6..8f8b3a7868e8d 100644
--- a/fs/nfs/callback_xdr.c
+++ b/fs/nfs/callback_xdr.c
@@ -372,6 +372,8 @@ static __be32 decode_rc_list(struct xdr_stream *xdr,
 
 	rc_list->rcl_nrefcalls = ntohl(*p++);
 	if (rc_list->rcl_nrefcalls) {
+		if (unlikely(rc_list->rcl_nrefcalls > xdr->buf->len))
+			goto out;
 		p = xdr_inline_decode(xdr,
 			     rc_list->rcl_nrefcalls * 2 * sizeof(uint32_t));
 		if (unlikely(p == NULL))
-- 
2.43.0



