Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C46F198E77;
	Wed,  5 Feb 2025 15:13:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738768425; cv=none; b=t9Jq+ttC9C6V7dHHG5T3lIEa0UqP3un2hFV4wFF2XNRegy9Qkayt9SfehznVFY3zBhPQr/jyAyIwZFiXW/GOT2L1YRKcxrhRHAk+uxsBt1ynA2W3pvm8LGh4cQ+Pjuj9rQVoCZjqtA+ov1tbaoluvFFyL0Pe9evSFX/dEo+7wdc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738768425; c=relaxed/simple;
	bh=Su8lCGG+jmYr/3C5APRMMkcvzohrK+yqeyNnrt6Fdzg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BEksWbDapF88EL4wWPEz+aUbC8lMXhUn6Sa1a01s07dVS48+idHLgvIRnLQ9k3gvF6XHnLGSfx8i1RagHrbpLiuJHUG3byJcAdzTrOwyO8DWh9dMKWIf/kM3XHcK/fv0XcEk8390KvR5ushzGhGPhoYoZ9I3TmN6mTiSTalya4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ylIb1sul; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ylIb1sul"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCFA6C4CED1;
	Wed,  5 Feb 2025 15:13:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738768425;
	bh=Su8lCGG+jmYr/3C5APRMMkcvzohrK+yqeyNnrt6Fdzg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ylIb1suljYcQ62VunnAYweKk3Pz6ZuGDUz8MbUsBgXntjkaLJP2aqIe5zE/YjSnZN
	 j6xZF7jAe80UYqEa4fm/+INRw3KHHq8OheUH7FcNps1X7854wJ9fcCLpHaHvM4IwFr
	 5VKohJAaws/Z8p4wHNynHV2rP7t/bPhzXnv2SAC8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Everest K.C." <everestkc@everestkc.com.np>,
	Simon Horman <horms@kernel.org>,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH 6.12 578/590] xfrm: Add error handling when nla_put_u32() returns an error
Date: Wed,  5 Feb 2025 14:45:33 +0100
Message-ID: <20250205134517.378610800@linuxfoundation.org>
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

From: Everest K.C <everestkc@everestkc.com.np>

commit 9d287e70c51f1c141ac588add261ed2efdd6fc6b upstream.

Error handling is missing when call to nla_put_u32() fails.
Handle the error when the call to nla_put_u32() returns an error.

The error was reported by Coverity Scan.
Report:
CID 1601525: (#1 of 1): Unused value (UNUSED_VALUE)
returned_value: Assigning value from nla_put_u32(skb, XFRMA_SA_PCPU, x->pcpu_num)
to err here, but that stored value is overwritten before it can be used

Fixes: 1ddf9916ac09 ("xfrm: Add support for per cpu xfrm state handling.")
Signed-off-by: Everest K.C. <everestkc@everestkc.com.np>
Reviewed-by: Simon Horman <horms@kernel.org>
Reviewed-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/xfrm/xfrm_user.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -2609,8 +2609,11 @@ static int build_aevent(struct sk_buff *
 	err = xfrm_if_id_put(skb, x->if_id);
 	if (err)
 		goto out_cancel;
-	if (x->pcpu_num != UINT_MAX)
+	if (x->pcpu_num != UINT_MAX) {
 		err = nla_put_u32(skb, XFRMA_SA_PCPU, x->pcpu_num);
+		if (err)
+			goto out_cancel;
+	}
 
 	if (x->dir) {
 		err = nla_put_u8(skb, XFRMA_SA_DIR, x->dir);


