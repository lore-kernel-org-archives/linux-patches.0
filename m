Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41A06256C63;
	Thu, 17 Apr 2025 17:56:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744912564; cv=none; b=G/pt9o0GAnoBqc8j8C34IsapN7099esapmeqzE9tGk7Z93ucxkdQ47ubNNtkYcYxmY6xOKNs2bMG9L5Wk6HLiXR2ENVweebwRJvwjxcnebpVnfLAcEgsp+THwtt35o8raUsoJv/Evh3Yvrhou8K2kOrhrmnnVdzBk+mGxu5GgZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744912564; c=relaxed/simple;
	bh=t2ycWohxaTmkWayE+ikuVxxdwXRMkD3ss/c/CsBHCJE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lZCa87azwtHDJya1Ne5jL62k6isaixKBg38Uw+zHIZHqIIXyQNT/jiEuntCyE59gj7A/yyfPhugLYMIsdtXro/QoeSUJ/sfxAvXK/slpS02WLJ4lunX97BD1pXZAo0kYd0PWmPqZXBi6Hs7G5x/gsRXoqwQ6Qo7LAh18FeNVbW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gqi+Pk0x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gqi+Pk0x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B00D9C4CEE4;
	Thu, 17 Apr 2025 17:56:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744912564;
	bh=t2ycWohxaTmkWayE+ikuVxxdwXRMkD3ss/c/CsBHCJE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gqi+Pk0xUGKSzJ2iFmOWD02LXB+0xmTvUmD064bjDrRhqxxvi71ylCP+S5F2P84l6
	 Mup4W1aro2NYjDoHAHJdI71ESpk/SbjPYGU19m/rg1SKtFlQh0PDuBWKMDw0O07J7e
	 xYZ6OfNPfAsIpE+nmPP0nqJoWenY9+hCWW32gDKI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhongqiu Han <quic_zhonhan@quicinc.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 052/449] pm: cpupower: bench: Prevent NULL dereference on malloc failure
Date: Thu, 17 Apr 2025 19:45:40 +0200
Message-ID: <20250417175120.082762630@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175117.964400335@linuxfoundation.org>
References: <20250417175117.964400335@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
index 080678d9d74e2..bd67c758b33ac 100644
--- a/tools/power/cpupower/bench/parse.c
+++ b/tools/power/cpupower/bench/parse.c
@@ -121,6 +121,10 @@ FILE *prepare_output(const char *dirname)
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



