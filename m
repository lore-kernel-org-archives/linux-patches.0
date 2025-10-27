Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C00E52F8BD1;
	Mon, 27 Oct 2025 19:03:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761591787; cv=none; b=OIUOgDMH7p50sFzNlkkgy35S1mexup+p69kCvDEIaP2itRlRDcfIY9NFuwFPI4pg2VcL3Q/mMLlyKsz5OJfBHAissPm/ni6uxz5qDZR+ijVifxRToNvdPEuYtosE7KUQDjOKeMXUGBQYQOT9/IcAcxi+yHefvCq2l/U11MhAWPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761591787; c=relaxed/simple;
	bh=dd6H32s+lNkWmY+gnP3871zALo4R0y+saVwxwzpmrEk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IET7mzPIWPHPnJ3boQUz3zcQb+2608BP2i/2cdyaSRjsd9C1kOtwGEyF/tVua9WEidmRQ/THQGQ7jAuV9qN5nl0MKFBqwG6x9q6O5LoVEFj+JLHQR+zFLhZAkzdJ56vkgOymIxWeOOi1jxerMU7nmDielhokxOc1WyElOi5OAP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MkA1bR1a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MkA1bR1a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5444AC4CEF1;
	Mon, 27 Oct 2025 19:03:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761591787;
	bh=dd6H32s+lNkWmY+gnP3871zALo4R0y+saVwxwzpmrEk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MkA1bR1aTyfVb0NtmefBU9G93O1nighPdmVoYvgQUngkNUt6rXcL+2oF2VDLbBi8x
	 V2xjPsVikYTUUI0vW4Pndnirb3R5Ef/g6zxvScqQBVr2UBPfwCKRl8gxSWFcoIrPVO
	 dp3Xtu8lWa2VtJCT3UYqfDwzrPqeDG59pgFyKJVc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhengchao Shao <shaozhengchao@huawei.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 330/332] net: rtnetlink: fix module reference count leak issue in rtnetlink_rcv_msg
Date: Mon, 27 Oct 2025 19:36:23 +0100
Message-ID: <20251027183533.609456044@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183524.611456697@linuxfoundation.org>
References: <20251027183524.611456697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhengchao Shao <shaozhengchao@huawei.com>

commit 5b22f62724a0a09e00d301abf5b57b0c12be8a16 upstream.

When bulk delete command is received in the rtnetlink_rcv_msg function,
if bulk delete is not supported, module_put is not called to release
the reference counting. As a result, module reference count is leaked.

Fixes: a6cec0bcd342 ("net: rtnetlink: add bulk delete support flag")
Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
Acked-by: Nikolay Aleksandrov <razor@blackwall.org>
Link: https://lore.kernel.org/r/20220815024629.240367-1-shaozhengchao@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/rtnetlink.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -5624,6 +5624,7 @@ static int rtnetlink_rcv_msg(struct sk_b
 	if (kind == RTNL_KIND_DEL && (nlh->nlmsg_flags & NLM_F_BULK) &&
 	    !(flags & RTNL_FLAG_BULK_DEL_SUPPORTED)) {
 		NL_SET_ERR_MSG(extack, "Bulk delete is not supported");
+		module_put(owner);
 		goto err_unlock;
 	}
 


