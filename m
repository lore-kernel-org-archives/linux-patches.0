Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 604E42DFF1B;
	Tue, 17 Jun 2025 16:07:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750176424; cv=none; b=UI3W3E8uf2uW3a1tdNK1wtzJI3wZee5pivf0w7Lbi9YkWOvkkpHz26rOI3aME6LSZlgsTjdBLkkAl+5BGSxQp25DIReYZQB2W203yKTQC71MQJFHnn9uXJXEihDRvA8Y+oXX/KKiqVqCKDF3cl/3WvKgccCiUSPT1LyRudovDFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750176424; c=relaxed/simple;
	bh=WWEqq9yoUgZxIVYTQBvTiCuvK7FhrG1r/446Uqniv70=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d+RzXzlao64DFfv9Lo+bQm4KHvg9Q/oP7OHsr+7VIMXeDmF3BKABKipO2pRmGvg6Dpc8FZ6xsEJccAfyKCUFpTGsHVaTHyIM0hD38dnOpseMv9xU7OTPsx7WaqYoYnihxJkNfHgTSH4QZ/iDiMVBTbE7iiVHEV4vePXXtKHz7xs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B3e7b04b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B3e7b04b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD8A4C4CEE7;
	Tue, 17 Jun 2025 16:07:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750176424;
	bh=WWEqq9yoUgZxIVYTQBvTiCuvK7FhrG1r/446Uqniv70=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B3e7b04bHvGsRB2HO47U6JST0Ybrc4rIxljcYb2S/QoIpxxiVACTIckarq6QFFKXK
	 hV8+L/b6/ipZpVQArzvrYm+qaf5G+H4VE72Tk9NWvNnmmvwp7T4YwaXpzvOK0xcO8O
	 jxmJdw79rVW9fWv97KF53qPAJ1t/5/lalEOhk9sc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Brauner <brauner@kernel.org>,
	"Orlando, Noah" <Noah.Orlando@deshaw.com>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 276/356] do_change_type(): refuse to operate on unmounted/not ours mounts
Date: Tue, 17 Jun 2025 17:26:31 +0200
Message-ID: <20250617152349.302755393@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152338.212798615@linuxfoundation.org>
References: <20250617152338.212798615@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Al Viro <viro@zeniv.linux.org.uk>

[ Upstream commit 12f147ddd6de7382dad54812e65f3f08d05809fc ]

Ensure that propagation settings can only be changed for mounts located
in the caller's mount namespace. This change aligns permission checking
with the rest of mount(2).

Reviewed-by: Christian Brauner <brauner@kernel.org>
Fixes: 07b20889e305 ("beginning of the shared-subtree proper")
Reported-by: "Orlando, Noah" <Noah.Orlando@deshaw.com>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/namespace.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/namespace.c b/fs/namespace.c
index 4d8afd0e1eb8f..eab9185e22858 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -2557,6 +2557,10 @@ static int do_change_type(struct path *path, int ms_flags)
 		return -EINVAL;
 
 	namespace_lock();
+	if (!check_mnt(mnt)) {
+		err = -EINVAL;
+		goto out_unlock;
+	}
 	if (type == MS_SHARED) {
 		err = invent_group_ids(mnt, recurse);
 		if (err)
-- 
2.39.5



