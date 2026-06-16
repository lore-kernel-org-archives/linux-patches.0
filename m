Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 095B744E027;
	Tue, 16 Jun 2026 15:55:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781625336; cv=none; b=ZLdbmib536ZBI0ghffYMLUsmd3o5o1fxcvjBimyu97vDcr5s1pLlbppTnAPWlOC6ZYbvcfkbgbitZUP7u36KQnnIWj8xRmcNW8jjXoT86clQzIsxqKV+RWJEv+4Hwoe3bTKggW2pm2XWyYPO7fWKjL7UPodkyxPhjRuO0SalXqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781625336; c=relaxed/simple;
	bh=XxvSTalwbUbDsoU7FzsvmQ5+sG3PYsawLqkCq0AVbzg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LDZZaEepKeG3hIWWcnEVo0jVfsMU6I55JM17xfFvdPywubwXS4IDtaqFXFkz6nRExzOHWl8Kxzaj4ze8WgZVda2YOpxnE1SnnvDp1u9PNlPwbfQZNVUdQowm7+CrbtFD0ecbP7rHMzJOK7bK1Q+Obh2iuQNki4zptYPIeCbYR/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2pU4k6oq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2pU4k6oq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E15AB1F000E9;
	Tue, 16 Jun 2026 15:55:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781625334;
	bh=Zx8tQ+VvrY6dJUNbHIu1m4OefYeUI5xWf1vkzJ3yhKo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2pU4k6oqldok8ez/zD7T5Wffos8CoJECwA3rcpzkyuQY5o76lPvXN3ilADr3ACc1b
	 6RFmYkqw2Uy1MlLGjTj308472Ol+sDnBJXjcvTh08GVT+8+zWSD1hZUWzhkoWGAmcu
	 i2G8+KmqP1KnoHFzu9oRBABKSwM6i/zPwtJL0Oi8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Xin Long <lucien.xin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 115/325] sctp: fix uninit-value in __sctp_rcv_asconf_lookup()
Date: Tue, 16 Jun 2026 20:28:31 +0530
Message-ID: <20260616145103.432539458@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145057.827196531@linuxfoundation.org>
References: <20260616145057.827196531@linuxfoundation.org>
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

From: Michael Bommarito <michael.bommarito@gmail.com>

[ Upstream commit f8373d7090b745728de66308deeecc67e8d319ce ]

__sctp_rcv_asconf_lookup() in net/sctp/input.c only checks that the ASCONF
chunk can hold the ADDIP header and a parameter header, then calls
af->from_addr_param(), which reads the full address (16 bytes for IPv6)
trusting the parameter's declared length.

An unauthenticated peer can send a truncated trailing ASCONF chunk that
declares an IPv6 address parameter but stops after the 4-byte parameter
header; reached from the no-association lookup path, from_addr_param() then
reads uninitialized bytes past the parameter.

Impact: an unauthenticated SCTP peer makes the receive path read up to 16
bytes of uninitialized memory past a truncated ASCONF address parameter.

The sibling __sctp_rcv_init_lookup() bounds parameters with
sctp_walk_params(); this path open-codes the fetch and omits the bound.
Verify the whole address parameter lies within the chunk before
from_addr_param() reads it, the same class of fix as commit 51e5ad549c43
("net: sctp: fix KMSAN uninit-value in sctp_inq_pop").

Fixes: df2185771439 ("[SCTP]: Update association lookup to look at ASCONF chunks as well")
Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
Acked-by: Xin Long <lucien.xin@gmail.com>
Link: https://patch.msgid.link/20260608122234.459098-1-michael.bommarito@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sctp/input.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/net/sctp/input.c b/net/sctp/input.c
index e119e460ccde0b..864741fae4187e 100644
--- a/net/sctp/input.c
+++ b/net/sctp/input.c
@@ -1204,6 +1204,14 @@ static struct sctp_association *__sctp_rcv_asconf_lookup(
 	/* Skip over the ADDIP header and find the Address parameter */
 	param = (union sctp_addr_param *)(asconf + 1);
 
+	/* The whole address parameter must lie within the chunk before
+	 * af->from_addr_param() reads the variable-length address; otherwise a
+	 * truncated trailing ASCONF chunk lets it read uninitialized bytes past
+	 * the parameter.
+	 */
+	if (sizeof(*asconf) + ntohs(param->p.length) > ntohs(ch->length))
+		return NULL;
+
 	af = sctp_get_af_specific(param_type2af(param->p.type));
 	if (unlikely(!af))
 		return NULL;
-- 
2.53.0



