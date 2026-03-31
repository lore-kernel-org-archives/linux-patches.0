Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A3D5425CC6;
	Tue, 31 Mar 2026 16:48:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774975686; cv=none; b=jTCYqDTDoYyNOZcjQJr+YBufuE0THil1ZvPmqNWl3bTtOwUFa+1ZsAu4WkcRKigTKcRoqNaJKah+8KSYJVo4hC6GpYc8V5vu3BpgRPmi0dTL7BpcISTKpakLOf9mmXzlGKwe/NkfE8+v50a9m1wtuhJqPXjdcPCRCUjr5P+kph8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774975686; c=relaxed/simple;
	bh=laVTlMn/lz/f9XLD3pHFGtVMsoRZa9dWm0smI6Z0UwE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fuqpSfdqd5+IQyWA56qMYQcw6dLsbYMD1TRoDGpFzizKp/VNRT/1MUT7C7Nrd1HnW7YQT//nRmrL4ghr26ZUCen7kz52xoylI7XO7aj561hE3rpSyyXvVoSOMVfPTmkVq0WtMxnLuRY9UiqBAQVGGeBOBfDYzY8bwzqjWySjU3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZdQeUN45; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZdQeUN45"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17358C19423;
	Tue, 31 Mar 2026 16:48:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774975686;
	bh=laVTlMn/lz/f9XLD3pHFGtVMsoRZa9dWm0smI6Z0UwE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZdQeUN45M5kaB6YdPmdh85nKY3H3+j/+23r9uPYTRMcz1AqSBARXIffGOkaYKf8VJ
	 gaBvQ7G/hYLhUw/S58V02V6SD3tYUfNuS9ZMrimNIt3YkaKPoSG7afwBsikq7+Fzqd
	 st7TzAeUivJXBbPyz9wyHORid3FFamMGoTSh3X4E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sabrina Dubroca <sd@queasysnail.net>,
	Simon Horman <horms@kernel.org>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 048/244] xfrm: fix the condition on x->pcpu_num in xfrm_sa_len
Date: Tue, 31 Mar 2026 18:19:58 +0200
Message-ID: <20260331161743.469855125@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161741.651718120@linuxfoundation.org>
References: <20260331161741.651718120@linuxfoundation.org>
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

From: Sabrina Dubroca <sd@queasysnail.net>

[ Upstream commit b57defcf8f109da5ba9cf59b2a736606faf3d846 ]

pcpu_num = 0 is a valid value. The marker for "unset pcpu_num" which
makes copy_to_user_state_extra not add the XFRMA_SA_PCPU attribute is
UINT_MAX.

Fixes: 1ddf9916ac09 ("xfrm: Add support for per cpu xfrm state handling.")
Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xfrm/xfrm_user.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/xfrm/xfrm_user.c b/net/xfrm/xfrm_user.c
index 7d03a6e486b34..419def2cd1280 100644
--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -3577,7 +3577,7 @@ static inline unsigned int xfrm_sa_len(struct xfrm_state *x)
 	}
 	if (x->if_id)
 		l += nla_total_size(sizeof(x->if_id));
-	if (x->pcpu_num)
+	if (x->pcpu_num != UINT_MAX)
 		l += nla_total_size(sizeof(x->pcpu_num));
 
 	/* Must count x->lastused as it may become non-zero behind our back. */
-- 
2.51.0



