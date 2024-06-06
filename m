Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60A371AB51C;
	Thu,  6 Jun 2024 14:14:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683257; cv=none; b=UydTfa8TCOhjs252lHwAxqJQL2reSIAv8wC5K0f4Zm5blwJ6v7Mb2qWBDLQVGA9IXc1gMPhC1aI8LMctpW53fDZ0xy6cTZmKtQGQUNmPIUHLfYlU5Y27blYN0YHx38t4b3Yvx8iVXDvupaEWk4q5OFvsBVrtDkP87TX9xE44KPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683257; c=relaxed/simple;
	bh=AxsdZ22BOHfUpYza+cranvNRez9Yoell06OzK6w6QR4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZrWGZdCA3mjdB2ca13VsG2VIBo2Slbvixt3uDpNqtg1RL7QiB2Jv6D6yVkE1MQTwTCg5BShoRFdTNZQi5gaaeNqIIOK18rx5s8C9mUOx7IxP+nczfAoGGidL3LD3nrA2tFU0OG4OkvmoigpN3I6CoYKCQ1yQtI5Fcl8pwhcCZ4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EJ9N5hnc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EJ9N5hnc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 343E6C2BD10;
	Thu,  6 Jun 2024 14:14:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683257;
	bh=AxsdZ22BOHfUpYza+cranvNRez9Yoell06OzK6w6QR4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EJ9N5hncwUe+WI/g9nfEOLaFbxmns0E/NQxOBZdbbJEtVFYO6IKSF8xte1H05qe+8
	 bHHMimR67dO9oRVRocPKGNzAGfnabc62ZteRv7sG/n9Nwq3ZR39lyF4qkp2SB5yHBZ
	 uWuDT1fHWb8werG6Rk1v1QeWC73zucYYNKAgAgEM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geliang Tang <tanggeliang@kylinos.cn>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 133/473] selftests/bpf: Fix a fd leak in error paths in open_netns
Date: Thu,  6 Jun 2024 16:01:02 +0200
Message-ID: <20240606131704.326260710@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 1fa4672380a92..9448d075bce20 100644
--- a/tools/testing/selftests/bpf/network_helpers.c
+++ b/tools/testing/selftests/bpf/network_helpers.c
@@ -459,6 +459,8 @@ struct nstoken *open_netns(const char *name)
 
 	return token;
 fail:
+	if (token->orig_netns_fd != -1)
+		close(token->orig_netns_fd);
 	free(token);
 	return NULL;
 }
-- 
2.43.0



