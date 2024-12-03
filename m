Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82A361F4704;
	Tue,  3 Dec 2024 14:39:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733236741; cv=none; b=VXn+tnTwPgJYPeLtafNIv5aL7MR5hRTeP90NR0mPTWfX4DhDKYB7okBS3tyrt6twdfeWWD4Yq9SyJDoExLugBWHEViICV4P/ylGzgIb7yqH3met5YmTEk9SNu5hplzeDr1dV6R/FSBL9wXGCxJoNoTanjGNYGaXmArirweThASc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733236741; c=relaxed/simple;
	bh=iX0hZw0BPQv2t6Q8ncQTP9CD93EWYtU+0mXVdFx33nM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mISBq2JQXe/ScZ+jwiaaNK/GEuaDDfHTrHUl1SbQOSbHvHQBhHTneM2qlUHacbJtcHL+/DHTaLIGsd2KEngrJ3rQbBUCl++j48hz3MUMJ+T9fMC5raLHQOiq+Yw9VM81Hzx/2DUQfG7+K+XxLNHc3Fy9tlqzZ/6PafmuD7O4Sac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=naStaWR7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="naStaWR7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3009C4CECF;
	Tue,  3 Dec 2024 14:39:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733236741;
	bh=iX0hZw0BPQv2t6Q8ncQTP9CD93EWYtU+0mXVdFx33nM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=naStaWR7V0hdd8DWCXm5nHc3IKsUw2KhcPYi0WbR3v8Crl2FTAUYvohgrSKxlmXm6
	 80ciBTa2Tbzk+dr5PV38+NDjK9335wEC6rs8rrbfdsLdfLI4fvcJf2Kn/svPMHB6Kf
	 5JVxvkYCrkNfimFTT4Rz4ujASzEz7iSFVBioyTP8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	chao liu <liuzgyid@outlook.com>,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 098/138] apparmor: fix Do simple duplicate message elimination
Date: Tue,  3 Dec 2024 15:32:07 +0100
Message-ID: <20241203141927.313387817@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203141923.524658091@linuxfoundation.org>
References: <20241203141923.524658091@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index 752f73980e308..8c99e8150bab9 100644
--- a/security/apparmor/capability.c
+++ b/security/apparmor/capability.c
@@ -98,6 +98,8 @@ static int audit_caps(struct common_audit_data *sa, struct aa_profile *profile,
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



