Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB3F081ADA;
	Tue,  3 Dec 2024 16:10:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733242241; cv=none; b=NTnOqJhxMLFOlqC4T/OjBdjCqLrOaYApMXxWEFgY0U15eijbhtmzdAGzobufDAYFNccHuPck0SF6tpvga2n2haPRMEfxGXKBnuglWRnTDmIs3SiKg/ij/3MQEvy5DL4XWAEcJLgTZrzKmzCx1vjpgV9yFXSs8NAxQAUK/sfLTdM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733242241; c=relaxed/simple;
	bh=3YqjeaJYLo4yG4zBgvDjUifmJzVybl1rg5iHsy5GL+k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l9OyDkIKvluROGKPWRalx4Kv7gGALHqSMmh+6iR6QkHS0Yy5szU+3fSBGKK/EonoWqimO8w7UvWdiRdxLHPdsQn1QtBrw9I/ZA3KmAXTCd+EYCDiBTmd8peCRpWhwbpO5chvSsSBIK6eGUOhACkuwo3hkhT9Pi7ZVGbr5Pr75yU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PdsXxwvP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PdsXxwvP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BBFDC4CECF;
	Tue,  3 Dec 2024 16:10:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733242241;
	bh=3YqjeaJYLo4yG4zBgvDjUifmJzVybl1rg5iHsy5GL+k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PdsXxwvPrRAs89JqjRXnez6FDo47BMGGeqzeqUl40B06Ts3qHVKfUYZ5G0Cir1y5p
	 ai/Ql+d9bPy75nK6QhhGQ6tMe3+grZ1KnQ1tTGs1X/NpH75siVEKuZonmtSTKyUq18
	 q9PwFuaf6CjQ2DtqLu2BmPNPoWDFZJK+DAT7a3Ag=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	chao liu <liuzgyid@outlook.com>,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 617/826] apparmor: fix Do simple duplicate message elimination
Date: Tue,  3 Dec 2024 15:45:44 +0100
Message-ID: <20241203144807.822510245@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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
index 9934df16c8431..bf7df60868308 100644
--- a/security/apparmor/capability.c
+++ b/security/apparmor/capability.c
@@ -96,6 +96,8 @@ static int audit_caps(struct apparmor_audit_data *ad, struct aa_profile *profile
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



