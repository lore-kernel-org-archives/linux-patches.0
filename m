Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38BE0262BE;
	Mon, 27 May 2024 19:27:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716838024; cv=none; b=fs9EvmHCEJdUpbNyKXO7Rk4wA4e0BlVj609Y+kZ80FoQ/badDG1oA9cOCc8cagOY3J78MsdOw/lqphWm9cW6Xs1jEMOWmmSzCDqKmbrMuVzyBN4BjC5VHXI9+XF0JjXyXL1rY1Y0BdS96W3fi9vsjGF4CwnLYlscelG3evFdOcs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716838024; c=relaxed/simple;
	bh=talgTT9SGEQnnI7QQGTI2W7f7xxz103kyEqVuAn+VTY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q4pAgKecz/pVWOreWa749/Er0cnHhb35IgnygsJnJU0QL+nOUhl1B7NDmr/jWwu4gTeKTouymAl950USp1JArm/WnYAiWeBzbmWVNdYLfaXGl+MLGEEpI/4iFWO1AI7642nWGKrLiuddBi9qAKU/wC7TwGI2Td6Cx1RkmKTAKiI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dHzz21PJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dHzz21PJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C23CCC2BBFC;
	Mon, 27 May 2024 19:27:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716838024;
	bh=talgTT9SGEQnnI7QQGTI2W7f7xxz103kyEqVuAn+VTY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dHzz21PJDS17Gc0W4FsbJQEnkqgrFGG58bq2Jo7hX7IUB1iZfq7OT8QyjEeOuPmJ1
	 IZx+LmcWdcUomrN64fM7Dt7XZmWWP1SkOGFejKvzeHy9AuhMnG7SmUuZ3uFXKjitxL
	 wijqEyUdgaUclzmb6s+ysnGbqk+9Gr+QdeZxwcM4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geliang Tang <tanggeliang@kylinos.cn>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 237/493] selftests/bpf: Fix a fd leak in error paths in open_netns
Date: Mon, 27 May 2024 20:53:59 +0200
Message-ID: <20240527185638.051978977@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
index 6db27a9088e97..be96bf022316f 100644
--- a/tools/testing/selftests/bpf/network_helpers.c
+++ b/tools/testing/selftests/bpf/network_helpers.c
@@ -461,6 +461,8 @@ struct nstoken *open_netns(const char *name)
 
 	return token;
 fail:
+	if (token->orig_netns_fd != -1)
+		close(token->orig_netns_fd);
 	free(token);
 	return NULL;
 }
-- 
2.43.0



