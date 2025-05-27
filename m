Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FD1E1DC998;
	Tue, 27 May 2025 17:00:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748365208; cv=none; b=scsMTPfD0XY7bLDHoyyLNdF0GdnmEbb6V0fqA3y/BtSr40XVdWRP2OHqJrS7fpwB/kWRaqlqkrBB//nqbuUEs5e7aBrhjgnu/IDV/ztN9bFdkd9pCEss068XqBhvxbJnxa7gOfHqKlbXser0RT83Eyo/EQPY/zX18ODwghJj7Tc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748365208; c=relaxed/simple;
	bh=SzuFBPtVM1sD6rZCwQ74VyU9f/EJP8gCjwbUc/xr+kE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pt5++Rj221O7eqdcpKQ1vJ/FM+uVlmbiQqbKbNWHteYzuVVxBu7G31spsMKuRkRVevYLi6gJCVOBnPgy+8CLr8Bx3/1GWWSM27sVo7ZG6CyjOi35cPD85z499LKZYwP/a/hPp9g8xL13H2kqYHNS7RL7MjIliFsc3bbekuy+QPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q/eyLMqL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q/eyLMqL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A725C4CEEB;
	Tue, 27 May 2025 17:00:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748365208;
	bh=SzuFBPtVM1sD6rZCwQ74VyU9f/EJP8gCjwbUc/xr+kE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q/eyLMqL4t/VgNLNo0tv7y5FBiRfHFgWTPrTc1n06OqZAaLtUTg9MG5Vk7/r7Kwlg
	 PLH20ASvvYn/jDV/mH79qHf3lWTHboEzYk4el7Z1m0XUKSlHbSDGWnDNEPNXdXIs2G
	 4+nzhwci2PUyLz0IddvbWsCG7DmuNmwUEHePK8gY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nandakumar Edamana <nandakumar@nandakumar.co.in>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 301/626] libbpf: Fix out-of-bound read
Date: Tue, 27 May 2025 18:23:14 +0200
Message-ID: <20250527162457.257299063@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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

From: Nandakumar Edamana <nandakumar@nandakumar.co.in>

[ Upstream commit 236d3910117e9f97ebf75e511d8bcc950f1a4e5f ]

In `set_kcfg_value_str`, an untrusted string is accessed with the assumption
that it will be at least two characters long due to the presence of checks for
opening and closing quotes. But the check for the closing quote
(value[len - 1] != '"') misses the fact that it could be checking the opening
quote itself in case of an invalid input that consists of just the opening
quote.

This commit adds an explicit check to make sure the string is at least two
characters long.

Signed-off-by: Nandakumar Edamana <nandakumar@nandakumar.co.in>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20250221210110.3182084-1-nandakumar@nandakumar.co.in
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/libbpf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 5b45f76059296..a6bbae1e4c6b9 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -2074,7 +2074,7 @@ static int set_kcfg_value_str(struct extern_desc *ext, char *ext_val,
 	}
 
 	len = strlen(value);
-	if (value[len - 1] != '"') {
+	if (len < 2 || value[len - 1] != '"') {
 		pr_warn("extern (kcfg) '%s': invalid string config '%s'\n",
 			ext->name, value);
 		return -EINVAL;
-- 
2.39.5



