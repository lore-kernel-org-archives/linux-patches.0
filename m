Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B887A2571AE;
	Thu, 17 Apr 2025 18:39:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744915191; cv=none; b=n2WB0nEeal1eqA+F/H1DO7qJWkGaB7fQ2wwk6ekIGI4XXCiBt/SVSL1ycKrEgrYTWw5BWAR/wzTlkzeBxysIpD3XHuwu7nXhv5hpgLEuEZQOPyLwnrs6AcSzZxut0xu6no0LSH8t0U1+//CrSC5JRIqJpeTfQrEytl14I15IMuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744915191; c=relaxed/simple;
	bh=IxBERqQFQlzKqyxFU9QYiP7cXb6R5O4tVnHgtK2UZ3w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dXSRkSzKaLyJReWmawASJc2Ar+beCnlI7rYXQVAnqJcNfbjYwhKxSJjgveUtfo+vXIcR4eTL5UiJ/NwlGlLayuqxjZ5+dFDBKXnkZjMjWO4uIB7JMDHP8YQVsjnnTPqDvdskfgZQkPyFWzSRGbhhZv0wYcPPd5uNgw/QbfQbVS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ryKijWOM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ryKijWOM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 287D1C4CEE4;
	Thu, 17 Apr 2025 18:39:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744915191;
	bh=IxBERqQFQlzKqyxFU9QYiP7cXb6R5O4tVnHgtK2UZ3w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ryKijWOMb6AvDUJnGpFovdKj/vVPa/Qg5jr9R+pHmhbbQYq9HX+R9WMu8bhDxbv9y
	 eyiFUUNDHiUYLwU8ZZSpdfwjKs/8Y6JtzHiTG+0z3oC/UQxVpKavN+OxZloiBZ8DBw
	 m+ZAAmSegF2mb9nTwMYWclx0PAdJmGBzW7qmCjY0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhongqiu Han <quic_zhonhan@quicinc.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 047/393] pm: cpupower: bench: Prevent NULL dereference on malloc failure
Date: Thu, 17 Apr 2025 19:47:36 +0200
Message-ID: <20250417175109.483993229@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175107.546547190@linuxfoundation.org>
References: <20250417175107.546547190@linuxfoundation.org>
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

From: Zhongqiu Han <quic_zhonhan@quicinc.com>

[ Upstream commit 208baa3ec9043a664d9acfb8174b332e6b17fb69 ]

If malloc returns NULL due to low memory, 'config' pointer can be NULL.
Add a check to prevent NULL dereference.

Link: https://lore.kernel.org/r/20250219122715.3892223-1-quic_zhonhan@quicinc.com
Signed-off-by: Zhongqiu Han <quic_zhonhan@quicinc.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/power/cpupower/bench/parse.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tools/power/cpupower/bench/parse.c b/tools/power/cpupower/bench/parse.c
index e63dc11fa3a53..48e25be6e1635 100644
--- a/tools/power/cpupower/bench/parse.c
+++ b/tools/power/cpupower/bench/parse.c
@@ -120,6 +120,10 @@ FILE *prepare_output(const char *dirname)
 struct config *prepare_default_config()
 {
 	struct config *config = malloc(sizeof(struct config));
+	if (!config) {
+		perror("malloc");
+		return NULL;
+	}
 
 	dprintf("loading defaults\n");
 
-- 
2.39.5



