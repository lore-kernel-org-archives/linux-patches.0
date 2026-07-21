Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7AA52D8376;
	Tue, 21 Jul 2026 20:41:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784666483; cv=none; b=G6NIzcTtUVWPjE4REu5pAD7M6jH3XlGTLd8sSgfVg0ZQnqSUYUCYwoa8BMiAePrvsFA0N6vXeQ39AmhvFX+zbqbEhFNprkIlaCOXmqJEYD6HNByLX+4a0eTREs32JptpHBEzd7MBWQbr7e3xxvIas1sl5Ok98tAsOlolGpaIeO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784666483; c=relaxed/simple;
	bh=o+3aPTjCvieG+at8LovGYrzGJw8YtcoTsPrpgertO0g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=C2Iqx7ftokeiutMmoPbxcWyDjZK8agnpwDBZ4qqzdutk+zOAWwfXvZqynAg3fAYMgE0IuhM59YoI7ML0pmbKR+XtlVsm272vuc9jdtDIeI9YJtwWLy1EAFWNmCPrDnpTxKiH+VFBUDIgBHpBvzIzVhP/OR3zCdiJvslS1f9kqJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f0wt2aNT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f0wt2aNT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48FD11F000E9;
	Tue, 21 Jul 2026 20:41:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784666482;
	bh=UCOdiZO5WSwz3rdPqkhlIaZYeWD6bRja9W292ieWNPQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f0wt2aNTaxYUeZEKYNOjAmGvhzI/mU7M4Fz6wSbUL05PVNE0L6bhyim8YtyyNDRXG
	 qsFH+f1Unbw4lyrZZuexs0oDgI5HtE3Kcm8zmLzYvCKxSNyQgUN/Z8661qytIP/awT
	 DkT9DIUBHtS2cYoB9qk4l0jx4f53Q7EffaYgUG6k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Georgia Garcia <georgia.garcia@canonical.com>,
	=?UTF-8?q?Maxime=20B=C3=A9lair?= <maxime.belair@canonical.com>,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0701/1266] apparmor: fix potential UAF in aa_replace_profiles
Date: Tue, 21 Jul 2026 17:18:58 +0200
Message-ID: <20260721152457.546079181@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maxime Bélair <maxime.belair@canonical.com>

[ Upstream commit 7b42f95813dc9ceb6bda35afcf914630909a19f9 ]

The function aa_replace_profiles was accessing udata->size after calling
aa_put_loaddata(udata), causing a potential UAF.

Fixed this by saving the size to a local variable before dropping the
reference.

Fixes: 5ac8c355ae001 ("apparmor: allow introspecting the loaded policy pre internal transform")
Reviewed-by: Georgia Garcia <georgia.garcia@canonical.com>
Signed-off-by: Maxime Bélair <maxime.belair@canonical.com>
Signed-off-by: John Johansen <john.johansen@canonical.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/apparmor/policy.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/security/apparmor/policy.c b/security/apparmor/policy.c
index c70e68977d6118..14306cfb1ae48e 100644
--- a/security/apparmor/policy.c
+++ b/security/apparmor/policy.c
@@ -1324,13 +1324,15 @@ ssize_t aa_replace_profiles(struct aa_ns *policy_ns, struct aa_label *label,
 	mutex_unlock(&ns->lock);
 
 out:
+	ssize_t udata_sz = udata->size;
+
 	aa_put_ns(ns);
 	aa_put_profile_loaddata(udata);
 	kfree(ns_name);
 
 	if (error)
 		return error;
-	return udata->size;
+	return udata_sz;
 
 fail_lock:
 	mutex_unlock(&ns->lock);
-- 
2.53.0



