Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA30424E4AF;
	Mon, 13 Apr 2026 16:07:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776096436; cv=none; b=SaxEnfxD7aJ1IxFgvgtvUBlsNTPzvjDw/OJs6kTd6fqbNPHt7GklV9mlp0tbgRNW3XlgfoWjNkZL5kNhYyLbVzbGxZAByujvXJsqZiuiQwCBlGr/YAEPzw18iUcEInyjne1yfcBqq7N/mbm45xOVVKuPJPVyQJCWL//euG8X87k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776096436; c=relaxed/simple;
	bh=nP4K/kW8WoW6bFymw/uJTVwu2PNXE9UfFoiMsr06RPg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RYzS9eKbuOJ56z3vNMsPFAE6yRTmWNqfGO9uh5X9Z0/GuRVPVXwiaN/WZ0taEao00PXUwgZY5TqBTcDpDX1LqORve2P9UHP87xQYZlqVCmekFkwzk4M4qjRAhDucvvSZ0cWsI9O6KEOzsdzFDTPtHmnm44/dWV+rSg4NxRokfVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IyH8di/h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IyH8di/h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E2B2C2BCAF;
	Mon, 13 Apr 2026 16:07:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776096436;
	bh=nP4K/kW8WoW6bFymw/uJTVwu2PNXE9UfFoiMsr06RPg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IyH8di/hjBgF/dKijJQ+e1syw0Dcx6f7jozw9/+RzqDFIlHWCMFDLDVBbUe6XhF6d
	 ajjPjkIiuRcz1nLMQvxTk20utjCNli/5l46Hn8xfbTXwlJ7/scxqE14mQ0dtSJsh4b
	 0PFw6Dq6OGqLe7I+gaebVVtUfhFyErheyycHpBvI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>
Subject: [PATCH 6.18 03/83] xfrm_user: fix info leak in build_report()
Date: Mon, 13 Apr 2026 17:59:31 +0200
Message-ID: <20260413155731.153756149@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155731.019638460@linuxfoundation.org>
References: <20260413155731.019638460@linuxfoundation.org>
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

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit d10119968d0e1f2b669604baf2a8b5fdb72fa6b4 upstream.

struct xfrm_user_report is a __u8 proto field followed by a struct
xfrm_selector which means there is three "empty" bytes of padding, but
the padding is never zeroed before copying to userspace.  Fix that up by
zeroing the structure before setting individual member variables.

Cc: stable <stable@kernel.org>
Cc: Steffen Klassert <steffen.klassert@secunet.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Simon Horman <horms@kernel.org>
Assisted-by: gregkh_clanker_t1000
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/xfrm/xfrm_user.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -4108,6 +4108,7 @@ static int build_report(struct sk_buff *
 		return -EMSGSIZE;
 
 	ur = nlmsg_data(nlh);
+	memset(ur, 0, sizeof(*ur));
 	ur->proto = proto;
 	memcpy(&ur->sel, sel, sizeof(ur->sel));
 


