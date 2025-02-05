Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87C561607B7;
	Wed,  5 Feb 2025 15:11:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738768282; cv=none; b=AIL37DyRiT2x10rt3ab6JgYEeaxDB69cHktMGOvA9kn+kcp926gAUtnMqTmE++k5LP+5ipTUIUd2AC4DenSDp0+1EFMkxNQ5gL6wmzuFvcJC9QeZvy1mlayDYM1I2/2R83DZmZiOhdBdTQa3fWkDk2+rxQFn9woRHM9WoFUVzf4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738768282; c=relaxed/simple;
	bh=jgYna+Zo2nWBerAZaf5ztbaQ0bWuya+/RILwOW5Zyg0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vF8/VCAW8uN1lInc+pUzjb5yrVdx06UZuWLEQoj4jxlPOUifibwhUjcR7zWIIV2fPmrXh5P+j1YzVV6pwrh8ScZq7Q5zEIKW6TfveGYZBGTT32ah0CDdlsTT4nC5ANk4RHv1lZBqcumTkstoMotqV6oo0PX0YEQsT3UXLemBE+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TMCuWwor; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TMCuWwor"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0F3FC4CED6;
	Wed,  5 Feb 2025 15:11:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738768282;
	bh=jgYna+Zo2nWBerAZaf5ztbaQ0bWuya+/RILwOW5Zyg0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TMCuWworb3kwQlTlbDwc2JGo0DYuxxC0lBvAHprzcAU7Jr3qggnatioFDyCqTvzpd
	 uuAMAebYDPf6FbJzM4yEyr9XZWCWZY5/cs5ypngnWZ6OE4LDIA89fpcFIgeNy40enm
	 CJWmYZmMjvnnpYZQXXvBUKzY1tooipvHMh/LLSRo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Simon Horman <horms@kernel.org>,
	Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH 6.12 579/590] xfrm: Fix acquire state insertion.
Date: Wed,  5 Feb 2025 14:45:34 +0100
Message-ID: <20250205134517.415920360@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Steffen Klassert <steffen.klassert@secunet.com>

commit a35672819f8d85e2ae38b80d40b923e3ef81e4ea upstream.

A recent commit jumped over the dst hash computation and
left the symbol uninitialized. Fix this by explicitly
computing the dst hash before it is used.

Fixes: 0045e3d80613 ("xfrm: Cache used outbound xfrm states at the policy.")
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/xfrm/xfrm_state.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/xfrm/xfrm_state.c
+++ b/net/xfrm/xfrm_state.c
@@ -1512,6 +1512,7 @@ found:
 			x->km.state = XFRM_STATE_ACQ;
 			x->dir = XFRM_SA_DIR_OUT;
 			list_add(&x->km.all, &net->xfrm.state_all);
+			h = xfrm_dst_hash(net, daddr, saddr, tmpl->reqid, encap_family);
 			XFRM_STATE_INSERT(bydst, &x->bydst,
 					  net->xfrm.state_bydst + h,
 					  x->xso.type);


