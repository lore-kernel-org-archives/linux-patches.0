Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FB1A1993A0;
	Thu,  6 Jun 2024 14:14:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683252; cv=none; b=PKlQrjbiMRTBFF6HhQHTuc4uqpH+0MVA0+403wq8x+dVO7evS3y5IZp9FmGO4DDLBpmrMvnG3vwYJiqwuHPh+FQRC3ueAW+LFlSQPpECAlnuGiSah3TgSatBGSUcGfsojLelDEHrSD+zCkJlMQIkF0bXM/Wb5rTZJT/La3DzWqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683252; c=relaxed/simple;
	bh=y4xnlno9mfklZF3zfqN540qewM5tToNmjEHkrCXcIdA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WK1h7sITRyD1y5CWOzZboUkBQl03yUxtCCo5fds/EwECK2dUr4BdDiOurY8ghv9VVW04Qn6oaoNS6i6psTUvHOmRZemjF9EJqV9qzH3XCjffu6OpQq/3U/QX8PsbEFu3vpCJRBiUBOWw6LTCLdHZu2dze23p7C3MOw2dAkxCQJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Pm5rWTqt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Pm5rWTqt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6619AC32782;
	Thu,  6 Jun 2024 14:14:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683252;
	bh=y4xnlno9mfklZF3zfqN540qewM5tToNmjEHkrCXcIdA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Pm5rWTqtuOzdP6Xb87d5Tii0ZhzR3plR0NkVr61Sl8Fs7YW9pAvwCxIQyvjM0QbRm
	 jEDf5+0wx2OkcZrrR/R6ObLnY9kvWUFISRRZ3DMDef+/uqNdaqkYq0KeQoyweae0FH
	 2CzTbungxtQxf4TNnh8HhaNplA8o+UnQbqtuxqpY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geliang Tang <tanggeliang@kylinos.cn>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 196/744] selftests/bpf: Fix a fd leak in error paths in open_netns
Date: Thu,  6 Jun 2024 15:57:48 +0200
Message-ID: <20240606131738.722124487@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

From: Geliang Tang <tanggeliang@kylinos.cn>

[ Upstream commit 151f7442436658ee84076681d8f52e987fe147ea ]

As Martin mentioned in review comment, there is an existing bug that
orig_netns_fd will be leaked in the later "goto fail;" case after
open("/proc/self/ns/net") in open_netns() in network_helpers.c. This
patch adds "close(token->orig_netns_fd);" before "free(token);" to
fix it.

Fixes: a30338840fa5 ("selftests/bpf: Move open_netns() and close_netns() into network_helpers.c")
Signed-off-by: Geliang Tang <tanggeliang@kylinos.cn>
Link: https://lore.kernel.org/r/a104040b47c3c34c67f3f125cdfdde244a870d3c.1713868264.git.tanggeliang@kylinos.cn
Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/network_helpers.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/testing/selftests/bpf/network_helpers.c b/tools/testing/selftests/bpf/network_helpers.c
index da72a3a662300..0877b60ec81f6 100644
--- a/tools/testing/selftests/bpf/network_helpers.c
+++ b/tools/testing/selftests/bpf/network_helpers.c
@@ -427,6 +427,8 @@ struct nstoken *open_netns(const char *name)
 
 	return token;
 fail:
+	if (token->orig_netns_fd != -1)
+		close(token->orig_netns_fd);
 	free(token);
 	return NULL;
 }
-- 
2.43.0



