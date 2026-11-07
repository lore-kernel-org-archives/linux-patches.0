Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062674;
	b=tqL49V8ktMfFhCcUKP2zDV97IPU3lWfEI6qindhzkrZ5pf33N/Z7Z7O3w1cBrSSglNZr
	 5DtcsJ4Vgw33bQzUlYiDzy2cpzSvCO2FAmZE16bPeK2nx0MaOUwuM8J6c3AJn+thHhB0y
	 N5E+KXQdepVRKpemNjpWwfRn7+Ml76zw2MvIyyE5JT9jG1U0KM3x68xL8GtPybXDuZVQ0
	 EUqQvPFwZNCw49sQZmNB20SFRnrKWrqv8+4u6Xw5uiYzGolxq75uI1aqle8864cAiDwkv
	 q8J778nwWVvIT6bRUHbKBlXhAkZrzbmfWANHjX0xvdzQ1U1S374xrj/clV+2OJjZw3A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062674;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ejVzXlTFuZG7wcJBpNeRvVO5Fl9CYrRdJgHXv0TC5M4=;
	b=ROjOnCE7LBEJRa2MGT7SHaBew/LwOH4fv+5SnUwiMdNuSD6ifF8ml3Uzhb0MvJ3gfbNg
	 U3e77SayRw7/aWJSpA5O1PvLPI7xA8COXadeNnvBE9Lgr8IBjMH0Uf5KkhuuZnWbTtP+h
	 ai1Zp+X5yPgm2ujG7trGfredxUJPZd8iV0c9cGIv1Rk7YqJFdolO/eXxqieC8aSGmvXgS
	 PzEcHxtBhjX5AMSH7zTtn+3G8Mk3wPiUY8ZdpdYTN24N7CujXNk0Yl8XiisN/xTFFNu2F
	 Dzd6EFdzUIkAQNJtDcxx6PVlY+Bcobcjf505sZR1zrgpRSOfWKWNxaOQaOjlagQS+Ug==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lFRIWFfA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F2B1606A326;
	Sat,  7 Nov 2026 14:44:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lFRIWFfA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 060181F0089F;
	Sat,  7 Nov 2026 14:44:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062674;
	bh=ejVzXlTFuZG7wcJBpNeRvVO5Fl9CYrRdJgHXv0TC5M4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lFRIWFfAjXCzHO7VMsKprxYWSXcdQykRiQCnjXR4AOVtra4h22dZh1YGjsp6xzGcX
	 NZsfKdqge7KUBrqIJKacupec2IsONCr/uGPc982J/2PIUyJ4d1I85S7Ps7Z+CDIFCA
	 L9C13Ik9XQ7S6XL10YD4ADuqHNJ5edHWZAUtvrrs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1536/1536] apparmor: on failed load ensure profile files are removed before parent
Date: Sat,  7 Nov 2026 08:59:12 -0500
Message-ID: <20261107135041.029504753@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index efa11a1a297d4..c9ffb1eec7a7c 100644
--- a/security/apparmor/policy.c
+++ b/security/apparmor/policy.c
@@ -1373,8 +1373,10 @@ ssize_t aa_replace_profiles(struct aa_ns *policy_ns, struct aa_label *label,
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



