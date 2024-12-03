Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 338D31EF0AE;
	Tue,  3 Dec 2024 15:24:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733239457; cv=none; b=EnrXYWZnq/awvCqZmUq8Mu+xaAJrZssNet+D0gBpIiQnnv0DRW69SrSlIEDOiCHPWRZUpo2/wWQbkg0D6iugAy/TKRsoKhmR7G9LUpXVWIrR36XoQVov7i7A9HJhUI1ql/9gOxmFA94hwgfq3T/ldUpL+j9Eg9dK6q6M8UGcHoc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733239457; c=relaxed/simple;
	bh=MeSXWBiuo7dspF6YeGHLtxCLezGhZDp9TJ8eCwFcAIQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gbMhW5x8div4MYToqy2Hf3TBn1Mt2tzoageNKd/St+Jcl/jmw5o4BN7gX3nvn3y9yUzv8RZFGmSOwflMltsvB91F9NkFJfHgHEby0oJao8OyUYKRKQBQ6IVGGAZnH3inJ112Teu3NbWPSPwuvfuvGnzbamT63WZuKVuuJOeO6qw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NeDDvE2J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NeDDvE2J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE5FEC4CECF;
	Tue,  3 Dec 2024 15:24:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733239457;
	bh=MeSXWBiuo7dspF6YeGHLtxCLezGhZDp9TJ8eCwFcAIQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NeDDvE2JQtQrpTx3pJ2ZVa3epajyiSEtEXFiy0GgLXI2P9OMGV+fsksWMYtVnD7oh
	 eJYr+NmVppUuCCxkORHvpXTONY6XxnccLiV6bAUkpdkYwT8Ofqg8sMiooZTsIuKBsa
	 NnAztgSaONkOn26mHi9lcOY9UuKOcGwyF5KYXKDY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	chao liu <liuzgyid@outlook.com>,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 621/817] apparmor: fix Do simple duplicate message elimination
Date: Tue,  3 Dec 2024 15:43:13 +0100
Message-ID: <20241203144020.175913407@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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



