Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC71F1D078B;
	Wed,  2 Oct 2024 14:27:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727879279; cv=none; b=u4J3l3HiSdjFJqF5bzC21CskkEgGexVhCgWvJ5cxfNlxHl7F7KfnhWmBhHMPQdKVpElww3pFB5QRS5ByjQTbyuC4TR9+d1aaUrwn8qq1KHsyVobSYsFN6HKgrZmxkR9XhSCWTD62MHwuJgdmXgo8dWcUWo6wclywsebP0X1k+2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727879279; c=relaxed/simple;
	bh=54esUmjSEtQhQkA4Ee5BlLBHqmBRzpdKuSljRLPeHqI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ahNQILT71le7lEvRjJq1ZCsrM4Aw02S0I8S+onrCoyKaV+10vytOODIYX8XPlsxSMTeRmHniMOxU3l8k8JXMlMk/80j+yqRcD7AUAaIcSxRCZLbCYfc58TzIS7Kiii49j4yh5bLPGHqdBs/AbHgIYQzD7a6j+fAzAhoLhZjQyaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I46zxR6x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I46zxR6x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A7BAC4CEC2;
	Wed,  2 Oct 2024 14:27:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727879279;
	bh=54esUmjSEtQhQkA4Ee5BlLBHqmBRzpdKuSljRLPeHqI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I46zxR6xY2FhKXVqT7kBwSA2mS96pXbS51R7e4DNEokiH8ERm6e2yXdw7zrYnAEG7
	 X2cLRi8e6zAdnLC0tiFnO7debiWIOeBYpSkL6SYR8/N8RMXKN/PjwQzW4z6JAsnMQ1
	 w6h3/SpxDyFOiG7WPCGnJZBufDl3Kfc+zDo6XOwk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 033/538] netfilter: nf_tables: elements with timeout below CONFIG_HZ never expire
Date: Wed,  2 Oct 2024 14:54:32 +0200
Message-ID: <20241002125753.331976781@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index da5684e3fd08c..b28acdaaf9709 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -4462,7 +4462,7 @@ int nf_msecs_to_jiffies64(const struct nlattr *nla, u64 *result)
 		return -ERANGE;
 
 	ms *= NSEC_PER_MSEC;
-	*result = nsecs_to_jiffies64(ms);
+	*result = nsecs_to_jiffies64(ms) ? : !!ms;
 	return 0;
 }
 
-- 
2.43.0



