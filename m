Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045931;
	b=IcWFViyaUYwKUVFFIk4zsjPIR8EzjSaj2nxSI5eWOVwRNsVRz3vVDL063DkOfuaxDLNf
	 nNvD2DTSqgUaxdvv3dtK7gPkW9CYNefgub2r34A696pTU1/5yQtUQhPIax7r9Os1YfMqW
	 dGkIW+x8tuObxk63nyI9YgHrLuh5qRlD2Pg+9ivZLq7thmrQKgbp2w3FV2Xcrb1m5BHci
	 W4B6j3l7OxIwRDZoF5an8JQoCdWZUb6u+JkWI5fKBIzUOW8MELk3/K1fznWR3BBkIQuVl
	 q1Ky0Kcuk6xwWdq2rbGQweUTOGpeuZOnD74Fj5p9QS/t2t6HdMCMyV6+5ppjmBHs8fg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045931;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RTUmZbBXF3WVwT4BTq/cykRgBYqylbgWtO37BgeWTPs=;
	b=tIITp3SO74J0weLiKLNA0p43pI5BUivc1Er0aiBAHNWDzVVB+hWW5IagpuoHlqoAa8PG
	 k9Hd/5i76V5qoH9uqENWCVgQTw0gudHidQIV9FIOKfRE3T0Obc5LGLcoeX66Mo1KxwCaD
	 UTgNfkpHzooIjOoYMN4SijhUjeLxcU5c1z3b7Le6/Lrxw8szgEw3l6hmcPmQGM0tIH2r/
	 cRBPqRVYKfQSn7VSZkzsSMxBW0leyaoHgK5mt30iKnmIKHhUrJZZ5ZcyZLInHYVi86YjH
	 HPuTcqK0MmLggblULU+OM9laaXyGY99M3Dlob5fqwv4ED70VRfSJrAf45AV+NInj/8g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xtu+tjGU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5572606A31C;
	Wed, 18 Nov 2026 23:52:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xtu+tjGU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 282F61F000C4;
	Wed, 18 Nov 2026 23:52:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045931;
	bh=RTUmZbBXF3WVwT4BTq/cykRgBYqylbgWtO37BgeWTPs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xtu+tjGUdzs9GBTgcA6gGUzlHTGhpwOWQLRmXjUo9K5zwxTiwcliIMYGF2bwz1Vzz
	 Z6YS4sFh6e+C6ThGPKwWZ3Ac2GcfEtrr/rsmVRuGnBtq501g5PDh8v0lEcBehYwigX
	 uhdJ/gRsyPqGAm/bFb1hq2ZR08ZjxZrhPHv3u97g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1100/2857] apparmor: on failed load ensure profile files are removed before parent
Date: Wed, 18 Nov 2026 15:35:34 +0100
Message-ID: <20261118150241.241511752@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: John Johansen <john.johansen@canonical.com>

[ Upstream commit 97ba44a2aa4c7ab011a93ce94cb595200fe4ea4f ]

The load interface does not guarantee the order profiles are loaded.
When a parent is loaded after its child, and the load fails, the
current code will issue a warning, and leak a dentry.

For the loaded set of profiles, ensure that on failure list is ordered
is traversed in reverse so any children processed after their parent
is freed first. We do not need to deal with the cases where the
children are processed before their parent, because either a parent
outside the list already exists or a dummy parent outside of the list
is created, and the list walk will not put those parents before their
children.

Fixes: 6ec46f8f1977d ("apparmor: remove fs entries created by a failed policy load")
Signed-off-by: John Johansen <john.johansen@canonical.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/apparmor/policy.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/security/apparmor/policy.c b/security/apparmor/policy.c
index c129f13fdeec6..dac3fb515814d 100644
--- a/security/apparmor/policy.c
+++ b/security/apparmor/policy.c
@@ -1182,8 +1182,10 @@ ssize_t aa_replace_profiles(struct aa_ns *policy_ns, struct aa_label *label,
 	 * them yet, and leaving them behind would leak the new profiles
 	 * (their dents pin the proxy) and make the next load at the same,
 	 * unbumped ns revision fail with -EEXIST on its raw_data dir.
+	 * ensure children (which are at the end of the list are removed
+	 * before their parent
 	 */
-	list_for_each_entry(tmp, &lh, list) {
+	list_for_each_entry_reverse(tmp, &lh, list) {
 		if (!tmp->old)
 			__aafs_profile_rmdir(tmp->new);
 	}
-- 
2.53.0



