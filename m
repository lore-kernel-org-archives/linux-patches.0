Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C910E1E1036;
	Wed,  6 Nov 2024 12:57:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730897847; cv=none; b=B6uhSyPqCTxYWdhkT0S35jT3JTo5Fd7Qxhvpx4t2ACKJdFq4Xud0ijckVqFlWl8OxJr21ZBNL0qAkreOKw3PEzmGV0A4GI9JUtlr4lZ/k/1Kwrw54j3TpNM+TiDBdSo7pjJLQj2fP8vw7rV1CDobbGmqyfrsxVKLMqwzlZXqiPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730897847; c=relaxed/simple;
	bh=ab3CuUoOhN4/wbdHpalsAUC0VfbIBKQI3YHxf18h4K0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fa94QrAaktl7LOZnbaxx9TgtGp0WZeMxl+bGVWKm+J9PndtBXnR3KJpUABn71pRdN03Hojoq/h5PS0vj+yxpUjmVxpScgIhIBX+ARs1hjMmXMQ64iLMLoC2YXa4HzHNkxQU8PHfJ9HzRGywpZ4mF4sVgJTTFJG7Ms2+FkIHeB1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CJhjqH4O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CJhjqH4O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C793C4CECD;
	Wed,  6 Nov 2024 12:57:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730897847;
	bh=ab3CuUoOhN4/wbdHpalsAUC0VfbIBKQI3YHxf18h4K0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CJhjqH4OoIBWlvOw4El5Vo6ggOtUlUnsEQUiXeRiNDG/3ZMK1u6cYBYy8XBgOct5M
	 0NTVOFuMnk8FcoVsXa99jlX8FBzSliWVREq/apEV/dmLETRqsl2vCSQpyOV7hCz6tn
	 k+FolMhYyjTEL0UTkM9cRFW1D2GvaGj3Intj4USk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 040/462] netfilter: nf_tables: elements with timeout below CONFIG_HZ never expire
Date: Wed,  6 Nov 2024 12:58:53 +0100
Message-ID: <20241106120332.511445727@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit e0c47281723f301894c14e6f5cd5884fdfb813f9 ]

Element timeout that is below CONFIG_HZ never expires because the
timeout extension is not allocated given that nf_msecs_to_jiffies64()
returns 0. Set timeout to the minimum value to honor timeout.

Fixes: 8e1102d5a159 ("netfilter: nf_tables: support timeouts larger than 23 days")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 1a132b800c8c2..f125d505c4519 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -3489,7 +3489,7 @@ int nf_msecs_to_jiffies64(const struct nlattr *nla, u64 *result)
 		return -ERANGE;
 
 	ms *= NSEC_PER_MSEC;
-	*result = nsecs_to_jiffies64(ms);
+	*result = nsecs_to_jiffies64(ms) ? : !!ms;
 	return 0;
 }
 
-- 
2.43.0



