Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054350;
	b=L1kAHVt2q3ZUQr6EoY8Sp2q4Hrt/Te7W3SB9c6qI8ohRxqwRSV/SSdo68t2FLiqMQ1kl
	 J3FINnwUXz6CPyqXN1qv4XrWSVu3OKYdv/NjUrv/lpXtO+s4Ey2JtdTrKwAaQl2VA8ljI
	 U9ZRO52eo8PUqDXPK8xlD1OEjk6Yi1EQgjnsQMNp8ijVuj/OZo0GW+NbYgVVf3KkYGuaz
	 F3mPKN0Co6rNLnDr6kU8mhb7lPefhT2geOoB9X3nTym2Qfeel1BQOQhPwnWtY+KM0v/4s
	 TOC+FZTss9QmZxC4c2VEx674xZ2w6OJCOWj0TA0rMJOIytvIAm/hrNx//J2SG8AXMHQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054350;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HPM7SSxtdtJbaxldmENkzCc3mYHzf8OTs6ou0e+MCXg=;
	b=crFx0sUxEe/HrcyBXyjuTBW/cC5BXkQJCoMWmT/Kj7GbhNREKRap/OYS1MFVqcSdZRul
	 pNKt0hBiDmuIs1NPXL6+FqzL9/N9Bji4PV+oAMwQnMrj1sQUtsBJoTiIt2x7ZepBsZMs9
	 xd/F/wRB3lNQa37qsPzLKrHdy3LBHT2Apb1Xk/1W7ZCj+WDe70vMHTl3Hi5t/wz7evtI+
	 6RDca0zsiJQsdYdmcFqgt195RmpAeyIn+H/taS1zmpDStyg5DBzr5MJQ5lo7pg9VBYA+w
	 5aeDHsPp/NrCA+ejr4CwwgiBz8Qn0aZaEjelVSkCLxEuq1OU9WUKx82ui8JQVICKl0g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2fHivah6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E65D8606A337;
	Thu, 19 Nov 2026 02:12:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2fHivah6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F196B1F000C4;
	Thu, 19 Nov 2026 02:12:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054349;
	bh=HPM7SSxtdtJbaxldmENkzCc3mYHzf8OTs6ou0e+MCXg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2fHivah6UhcEtTZR/HbIqPT0K7pwSBmMYm7jOllFyCC56srj8D/za9+AncA8iUmkx
	 fO7Yua3JLRlIEkB5TIS6MB6A1p2Ozn2109QJOcDPWEcESI3U12XVnb93keOaqrUGpT
	 /THrajuaf3T4RFfSObC7tQqLx7qsVAhdc/dFzNcY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1241/2214] apparmor: on failed load ensure profile files are removed before parent
Date: Wed, 18 Nov 2026 15:48:37 +0100
Message-ID: <20261118150101.365682158@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index dd8439e9cf55b..de6ccef62e968 100644
--- a/security/apparmor/policy.c
+++ b/security/apparmor/policy.c
@@ -1126,8 +1126,10 @@ ssize_t aa_replace_profiles(struct aa_ns *policy_ns, struct aa_label *label,
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



