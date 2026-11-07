Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063781;
	b=ggo/lQ5d3eiQfBLTIM1R4okgYCM4babrxpFnsL6ukPfDPZ/krMRUXWfji7rSpzLDdL6X
	 ZdYbm5EXaw10yi93BQZxILArvCMBUkOt54TNBH3s7Ve4xZtfrzvVD0+sXu4V53TSMrVLT
	 evrHUnqRAQQbgGd765QDcsCwT7oWDLISmds4zNcChM8SUCcuCjJNwjPLgMIhLdBw/ooj2
	 8U1GnsYazDqLIJIsTOjCeHMvDiRwJfgtGB5KZtRkSoMFcmfnxrgsFfxsATc60xG5HM4ym
	 QoQPpjyEI/yTiEIZhTjtxYS8tvoVrhBS5/mLRA9zLabKmh5hqeH4+eJ9AIkno3l3K2Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063781;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=A38hx1y/EJwBoi7CMyp/7z5AvSLDkDNJ3f5cLoOk2WU=;
	b=EoHivOa9F+R2GswFe4RaNShcaHeDzmc7IOYQJQZB/rm9YTIgz0LMbQOsbYz9lxlYAMZq
	 LgDi3wvX2mRHUIeBrFZ3mnuWG4uGoUKPYceCPE6PVT3jbIh+m2+4ZokgG/eTVYsrwtIPL
	 6A7M2/topGbaj6YGW6SNf0J1bPvMAGIWzZjpbowYtO5Hwj1TIabKgDDo+VkiAGaJPfZTD
	 xXQDV33a/hiWeH6NsWPoFyQYpI172kWqsQ4yWmJhRBbReN0yA98v2t7yPQm1f2FNpWNm5
	 8GlFC9zPhHupfkp5pxnzEN7yCCOoDr/d6AqyUEQh8duD0C94Ynnh1+YOw9hamHhQ2Pg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bZzWgVvc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13975606EE98;
	Sat,  7 Nov 2026 15:03:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bZzWgVvc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BC351F0089F;
	Sat,  7 Nov 2026 15:03:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063780;
	bh=A38hx1y/EJwBoi7CMyp/7z5AvSLDkDNJ3f5cLoOk2WU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bZzWgVvc6lUFLU2Oh65o9GUBoFowp++PYU9+AKdK8YwtQOtdkoqdYSyhKCugSWYyv
	 3fEkBjH/ETdP0Fks/3ISezfLSwvPmbaJaao4XKHueSyBfpVbJU8MR5wekkPyAhue7l
	 wGwAhOtVtXKVYXcx2M0ET603SmaKsC9ZcvtabAio=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 869/869] apparmor: on failed load ensure profile files are removed before parent
Date: Sat,  7 Nov 2026 08:59:11 -0500
Message-ID: <20261107134922.273242956@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 14c91fc94b22e..230d8428b4d31 100644
--- a/security/apparmor/policy.c
+++ b/security/apparmor/policy.c
@@ -1404,8 +1404,10 @@ ssize_t aa_replace_profiles(struct aa_ns *policy_ns, struct aa_label *label,
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



