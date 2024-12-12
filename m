Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD0D513BC26;
	Thu, 12 Dec 2024 15:17:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734016667; cv=none; b=cgPftURLhLJpce0QLKi3XnqfTuhWtgoL/5t4wbGT32aoc75enf6cZmo3WgrJsaW9IwOtPPk4r4dbE038tsLN81vEv5YUNAVv2Ffe9CE3niMJObXKHLWYmG+ATD0hcnUwstWwI/AkUPKZKDz5OmnrUqrgErLcRE0K9xKzyLT6biw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734016667; c=relaxed/simple;
	bh=VPDfMqqzcNfuo+DLxvNMR2GACQvivbs1G0wk4wDrvTE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MWtYcnVWiflLy25miifSSThIV0XvUMPtJ1pqjdia9pH1SuEbEHWikAFMZVK/n+YSGyzCBniYGjztJR5pbUoRwuUgPFKIKmidHuqN0b3RDms6amjpCPlqz03zzRtJEXsHM+eCCdLNB59ZCXQ+wP1C/PxuMzQ47+vz3lPPbPn5PXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IkRym9sD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IkRym9sD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49C6CC4CECE;
	Thu, 12 Dec 2024 15:17:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734016666;
	bh=VPDfMqqzcNfuo+DLxvNMR2GACQvivbs1G0wk4wDrvTE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IkRym9sDSuFoNBgYcH4nCovSSrP7tzu/GYup5NBL/RCL6P9AtmoIAttHzXIqsXMx5
	 Okc9CeAei7AiMGOur1AN708LdsH2Hhfk2lVKmMmGifGOmnHeutR3kZAoKZy6LARLql
	 1sXAyUVSf6+xLvmVGouc1fhlqdJgDQek3OBqP1qo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Brown <broonie@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 223/466] kselftest/arm64: Dont leak pipe fds in pac.exec_sign_all()
Date: Thu, 12 Dec 2024 15:56:32 +0100
Message-ID: <20241212144315.590653329@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Brown <broonie@kernel.org>

[ Upstream commit 27141b690547da5650a420f26ec369ba142a9ebb ]

The PAC exec_sign_all() test spawns some child processes, creating pipes
to be stdin and stdout for the child. It cleans up most of the file
descriptors that are created as part of this but neglects to clean up the
parent end of the child stdin and stdout. Add the missing close() calls.

Signed-off-by: Mark Brown <broonie@kernel.org>
Link: https://lore.kernel.org/r/20241111-arm64-pac-test-collisions-v1-1-171875f37e44@kernel.org
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/arm64/pauth/pac.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/testing/selftests/arm64/pauth/pac.c b/tools/testing/selftests/arm64/pauth/pac.c
index b743daa772f55..5a07b3958fbf2 100644
--- a/tools/testing/selftests/arm64/pauth/pac.c
+++ b/tools/testing/selftests/arm64/pauth/pac.c
@@ -182,6 +182,9 @@ int exec_sign_all(struct signatures *signed_vals, size_t val)
 		return -1;
 	}
 
+	close(new_stdin[1]);
+	close(new_stdout[0]);
+
 	return 0;
 }
 
-- 
2.43.0



