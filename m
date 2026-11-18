Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060016;
	b=yPKUCKLlgE63UVlQBgwKu8G2xnhNY6sENr04n0Prk6fglHdZEiJW5jQSczZH3W109Ofh
	 OrEA0UPQvC0uX4o/HbcwkE8QDeouxuRIQL0LpRxkPpMr4cpC1w0nMct6TJ4ArQGNYncYQ
	 cCwdDJ3ZxIC2OfM+rzc0ndtAYYtOur5JUGu6OLl2JXRkv739ArRZNDcIwmf8fRL6WUSUV
	 j6GHymP4TtMIYERtVXfu0tsdYr+qdDztu3AEYLt3dPltCfgwgj3ZEV3CogWvWDo5EUOFc
	 0muZMML6WPjGa93XvScHv3YnPbGYwKtAraIYs8sQNukI2R9cR+L9QJAdOxoMESmbrWg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060016;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZR+fPvmpbuBLreU5ZdTzDwvcbTfKwBa39jGX1JrXSW8=;
	b=l4+EsPZZhe1akA+ugy4uWsg8f3BnUz4GktcZD0HihJSGB1uLk1mQsekXuva0dZa3LsNs
	 HGvHmJ/D5yg3uOUwzwinU5Oecfv9PjS78iX5F9D8eBIjMwBggl+oX0D8hI0fyGUFWT+q3
	 HnK6yNpA2BpZVMJCXVChNrtjZ9M8ZewU/xLCUE3AItCN6DTtazXO7bV+xR9aEN83SoYzr
	 qOFUPwr1BhYIwb3gAnh5TJ/x2q+ZxS0BVZ4D3+pJGyJYXnkMPRR5r/GWgM14lmK0ytJLj
	 O5uOfTWrdnfaF+KeOudVjVo7zAMYFKo4yICFjP/si3zInY0HGTcEQUQsEZxbBg5myuQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=izBFMEL9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62623606A320;
	Thu, 19 Nov 2026 03:46:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=izBFMEL9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE2251F000C4;
	Thu, 19 Nov 2026 03:46:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060016;
	bh=ZR+fPvmpbuBLreU5ZdTzDwvcbTfKwBa39jGX1JrXSW8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=izBFMEL9zv0D6XazTV8i3Urc7chy1eeik0KSdc+7rTY3lmfDEM2Kji6QGZvIqVXpE
	 zRGWd/CS53lAS3FIr4cctrtnog2zVsr91wdsLcL6qya1VQvBpt8Srj7pIc3w/2URwF
	 oJclJsZKU8nkb35md5HdhYmWerQ0thdNKs/G0IeA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1047/1848] apparmor: on failed load ensure profile files are removed before parent
Date: Wed, 18 Nov 2026 15:51:25 +0100
Message-ID: <20261118150001.144286206@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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



