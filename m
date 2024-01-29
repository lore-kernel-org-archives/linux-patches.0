Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3038415B960;
	Mon, 29 Jan 2024 17:16:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548614; cv=none; b=FVttRlyi1w6vGbXOQDoTMJAY9wwd77EiaU37fsyQKmEaNm6DheSoidqdjpwljdEPuwaBsdk9VM2vGbBYc3miOepemHwLUZYZ7twAPqu9RLwkABrlJt5y+X32dqu9v+F2DsoOTwdGh97T3fFunExW8v7xQh7CG/B1pC9Af/xk7qc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548614; c=relaxed/simple;
	bh=mKDiog61/upL5zmtDxFeX4sUPU87hSJYTX19ovsZSco=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AQ74k6zcsg5Tp0k8qzyIuBeK5oNeXTcOUSbCFTNthC3etaiMDQ6/U6wWGsutwlaSw73r4/bk+ksMkX4DR3O8b8pa0unITveBNf3+dfHNo0bF6CJCK363HZu+5hnxMpcwMDub9v6KLnwci/wqXeV546/s1HrP1z/GUH/dcBW0AFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e61PoEfC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e61PoEfC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA3FBC433F1;
	Mon, 29 Jan 2024 17:16:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548614;
	bh=mKDiog61/upL5zmtDxFeX4sUPU87hSJYTX19ovsZSco=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e61PoEfCAb6Xz5K18/sZMkSa48W/zIs0cD6T5SpGH9A26pSRc+eQx2QET8vkh/81E
	 d+Rf/NI7q3MCbF/DTVvi9j0NFihdnq6Y1+O8+3RGhY544aDQTsP54GqnJOEdHc+gqM
	 7WKb8BKpFX1UJ9UX/yiIiuHn5BqfxISDA8b+Q1ek=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	Kuniyuki Iwashima <kuniyu@amazon.com>
Subject: [PATCH 6.6 273/331] net/bpf: Avoid unused "sin_addr_len" warning when CONFIG_CGROUP_BPF is not set
Date: Mon, 29 Jan 2024 09:05:37 -0800
Message-ID: <20240129170022.854794125@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170014.969142961@linuxfoundation.org>
References: <20240129170014.969142961@linuxfoundation.org>
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

From: Martin KaFai Lau <martin.lau@kernel.org>

commit 9c1292eca243821249fa99f40175b0660d9329e3 upstream.

It was reported that there is a compiler warning on the unused variable
"sin_addr_len" in af_inet.c when CONFIG_CGROUP_BPF is not set.
This patch is to address it similar to the ipv6 counterpart
in inet6_getname(). It is to "return sin_addr_len;"
instead of "return sizeof(*sin);".

Fixes: fefba7d1ae19 ("bpf: Propagate modified uaddrlen from cgroup sockaddr programs")
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Reviewed-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Link: https://lore.kernel.org/bpf/20231013185702.3993710-1-martin.lau@linux.dev
Closes: https://lore.kernel.org/bpf/20231013114007.2fb09691@canb.auug.org.au/
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/af_inet.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -823,7 +823,7 @@ int inet_getname(struct socket *sock, st
 	}
 	release_sock(sk);
 	memset(sin->sin_zero, 0, sizeof(sin->sin_zero));
-	return sizeof(*sin);
+	return sin_addr_len;
 }
 EXPORT_SYMBOL(inet_getname);
 


