Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BB04244686;
	Tue, 29 Apr 2025 17:40:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745948453; cv=none; b=RQSrfIWzmOzLfJbs2QfEffa1++9N/tTrSmFnIpC45xLq1CdZ90vg9vbPsufspI0NpgHvZ0h5o3aJbUdlFRHXQkbto/RnUHpI7P9gmy2rqMeQHCKm+An+v62xFaC26kWF7VMJ4dTMolVKLVTxt9M+HZ49PMiZfDaBRTZ5TJhH6Yo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745948453; c=relaxed/simple;
	bh=GAredgzsRt9CVbZkxIjsYQN5RQ5qoCQgqzw6+i+3Dp8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OOW6Jv8cehFWaiHMd7v0dBBpU8DRQ5JYlwos172FxWx9QhqudGcsp+O0SReTENSDpJuj/NhOdG328i8X8I1DdUc/JO5Ie6acFNTKSbNjxmS0scQ31oCCRb015mSQoSMw9wTvtD0JnHGZoOEvGWePeguliory2nzqIWXxORVRpDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A2vauu/A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A2vauu/A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7C78C4CEE3;
	Tue, 29 Apr 2025 17:40:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745948453;
	bh=GAredgzsRt9CVbZkxIjsYQN5RQ5qoCQgqzw6+i+3Dp8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A2vauu/AIf4ysDOWuhnbDaG8oV9S+FDDH2t0gvQ0GqdjA5bhSm3NUt7QcIR5I5rSG
	 hihw5O+Z181yBXzC0tz16IDVhrjLOYDX1RLTeFaAWSouZljcJyiTRYyCk1LgPPcsFh
	 t0eoizcqzczu0QO/ZYEq2AtnRvmE9/ehmyoYtgJU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhongqiu Han <quic_zhonhan@quicinc.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 012/373] pm: cpupower: bench: Prevent NULL dereference on malloc failure
Date: Tue, 29 Apr 2025 18:38:09 +0200
Message-ID: <20250429161123.639718071@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161123.119104857@linuxfoundation.org>
References: <20250429161123.119104857@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



