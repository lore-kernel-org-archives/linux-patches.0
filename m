Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA5922D8376;
	Tue, 21 Jul 2026 20:41:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784666486; cv=none; b=I1g2WEwBJbix6qNKBMRKqiFDGN1Ihrd7R0tYbL81hTURRT7M2oCSvco2poTwFB6VXoiVOvlrZUTjOh/Dg0iq58xLi2qhdTXK5iYvTGLJgWO9NLORXtK5B6QNFcTUmQz0xtbnUFpaBYPGFZ5Ku6+giTEEGTQnV2cTc1FGA65bzf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784666486; c=relaxed/simple;
	bh=Iep9UXvFyo7yHDROsu+YwxB69CNqPiQ/sti5X2ZC80U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bfBrFlPMURlFwN/nU1WvCts+1dC8MSTZP+Fi/S/io6sa6shJa5jdWKblFMAmGOPZiXqlUiRz4Iv5kZRq5lBl1xxEfJ96LC7DuiIPpB4vWyeA/xjBNlxcnbw8U4hzjfJQkMavey9QGVumQ7FsL8wsjZv6iJYiqy0DXJHCDR/aa0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S/Y9R9bC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S/Y9R9bC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E634B1F000E9;
	Tue, 21 Jul 2026 20:41:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784666485;
	bh=JGESd6jAOytPkBE/mKLLtvKgdXyGv4Pb88jbqA2OsxA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S/Y9R9bCT4iEsO/vzD7tDjYZOJUGEAubOwWdDeRObuDhxPQDviAjecQGpsAhk3n0A
	 swnfOfcNVn/S+7n6sv0TtHozOUuiRcgDPG3eK8XRuRVnndOzuH7/QjzpXNWPNfjWca
	 wWYfBvJmFmDUji+E1xuftcNClsVF1mMVU5vriOss=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tyler Hicks <code@thicks.com>,
	Ryan Lee <ryan.lee@canonical.com>,
	Zygmunt Krynicki <me@zygoon.pl>,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0702/1266] apparmor: aa_getprocattr free procattr leak on format failure
Date: Tue, 21 Jul 2026 17:18:59 +0200
Message-ID: <20260721152457.567943897@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Zygmunt Krynicki <me@zygoon.pl>

[ Upstream commit fea23bf73f0cae8ccb1d0684e4a3003874771f41 ]

aa_getprocattr() allocates the output string before rendering the label
into it. If the second aa_label_snxprint() call fails, the function
returned without freeing that allocation.

Free and clear the output pointer on the uncommon formatting failure path
before dropping the namespace reference.

Fixes: 76a1d263aba3 ("apparmor: switch getprocattr to using label_print fns()")
Reviewed-by: Tyler Hicks <code@thicks.com>
Reviewed-by: Ryan Lee <ryan.lee@canonical.com>
Signed-off-by: Zygmunt Krynicki <me@zygoon.pl>
Signed-off-by: John Johansen <john.johansen@canonical.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/apparmor/procattr.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/security/apparmor/procattr.c b/security/apparmor/procattr.c
index 197d41f9c32b7b..542c3f0255ea9a 100644
--- a/security/apparmor/procattr.c
+++ b/security/apparmor/procattr.c
@@ -53,6 +53,8 @@ int aa_getprocattr(struct aa_label *label, char **string)
 				FLAG_SHOW_MODE | FLAG_VIEW_SUBNS |
 				FLAG_HIDDEN_UNCONFINED);
 	if (len < 0) {
+		kfree(*string);
+		*string = NULL;
 		aa_put_ns(current_ns);
 		return len;
 	}
-- 
2.53.0



