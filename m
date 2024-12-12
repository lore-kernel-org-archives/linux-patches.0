Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5725C2144C4;
	Thu, 12 Dec 2024 17:24:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734024269; cv=none; b=EUiD49ZYlA9x39fqjxD0HSfcf4i6GEGsZu07nCvgjAi6mtiKEWE5HyoCeI7nLWTjYBdDrGl0iySFCLQsMPjnAYM9P6dWsTkvoAK5vkemi+Zx5t2x2AtaT8vMK8YrPEzBmE3uE7Qem1NoKmhBZqtepRBjvhPZ0hcLbtbyIXUkeVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734024269; c=relaxed/simple;
	bh=4DJ1F8K4jk21OW/eE0QXOymxqbdEVDb+LlMvxzV96pU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gKJ7TTqdKCN7ymp8g4HaeQRoNPpy0X4lxc0lwG1ZN6AKSD3VR4k6nBRWFGtpTQBblQtcjxn448j9EH6BaiLn4rydpQoZXn/QahiZPMvtbe5bpmTzLur39YUOzOcTFiTgPR9RJ/XHTeWG2QDobDoE2Jry4e9k0E4C4PEllP7pKxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qAA8Prn3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qAA8Prn3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D32BC4CECE;
	Thu, 12 Dec 2024 17:24:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734024268;
	bh=4DJ1F8K4jk21OW/eE0QXOymxqbdEVDb+LlMvxzV96pU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qAA8Prn3s504r3Z2JuSAlUtdAFNkdQSqCyP4xBpiEU/q5fx07Dywr5hjbJ+sPGwH3
	 6jC1tEuTRfZxcaoPMdUaedJBT+3MJ4ixkCHUo6aNpgMvIz7VgiRNB5uujqGrttQCTv
	 D3Nt3c+pY7BTeFT+ZHuipA1Kbwmpv8jYU9m3ZwRs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	chao liu <liuzgyid@outlook.com>,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 240/459] apparmor: fix Do simple duplicate message elimination
Date: Thu, 12 Dec 2024 15:59:38 +0100
Message-ID: <20241212144303.062512321@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144253.511169641@linuxfoundation.org>
References: <20241212144253.511169641@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: chao liu <liuzgyid@outlook.com>

[ Upstream commit 9b897132424fe76bf6c61f22f9cf12af7f1d1e6a ]

Multiple profiles shared 'ent->caps', so some logs missed.

Fixes: 0ed3b28ab8bf ("AppArmor: mediation of non file objects")
Signed-off-by: chao liu <liuzgyid@outlook.com>
Signed-off-by: John Johansen <john.johansen@canonical.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/apparmor/capability.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/security/apparmor/capability.c b/security/apparmor/capability.c
index deccea8654ad8..1b13fd89d5a9f 100644
--- a/security/apparmor/capability.c
+++ b/security/apparmor/capability.c
@@ -94,6 +94,8 @@ static int audit_caps(struct common_audit_data *sa, struct aa_profile *profile,
 		return error;
 	} else {
 		aa_put_profile(ent->profile);
+		if (profile != ent->profile)
+			cap_clear(ent->caps);
 		ent->profile = aa_get_profile(profile);
 		cap_raise(ent->caps, cap);
 	}
-- 
2.43.0



