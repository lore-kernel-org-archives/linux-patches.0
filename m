Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037110;
	b=hBSXwn099/Z8ny2YcfO1XgohzkwkUfmgKur7qYYOWxq9kFXRAQnu13HzwmnvQU+r1QTD
	 Zbql5oEP0mERjTBVf8umUlXNMoxqoIxfhL5MIsP5aG6bgAet7L+wptH+PwkXrpDQFyw7W
	 Rh5CfrS8Ma6PVx0to0F2/ImqEkcaaipJAOAMz5nPD3x2nyZfdshxmQz4ge0ysZ9YS18kd
	 B+pN9sHx9oPC59oEtNarz3OpwciHF3SB+xfqYr+7W4x8ak/cVPUWOJTJ1OwA3KUhf5b4d
	 3Uf+Ghu2S1q6HuKQRB6Ktf7lTwHl61DvKnEM3K2ODvJ7fW8ufC2ymMTDwYaqLK5u5Vg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037110;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cxLoJSvgF7VwEfKh4rDRsBNfDEiCYQE4nzRTDfHlSBg=;
	b=qe1vo/OjwdA/aZhFqhVE6XQOFm66u7W6J7B5ZfYjaUWhDbt+1HP+wz0JJExOyR7Z6+Et
	 rBPw5VVSjDMUaRIOZu1c1z4KqtX5ZbfFcxnQS8wsxatpiFFQusI9O1BlmcX7D3s9JMsdM
	 Ek6I+YPMyXScQy1VWfYfJc7RDLGCQhxsVxIAl+R9zNhVOj4H96F8hWXmTFTtXInd7cmg8
	 RcX/S73HxPIihzbiZGoY6B1UPI5yZ19hj/b5RgMYV9TYIf9RMNYlC8JBYp3YnEwkfCgdW
	 9FsrcTmuNb0r3/G/KGUE7cV4A2aMXuSLQSZb9yD8d1M13PL46sn3mEMNU19uCuAoHkg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vOJJ3XOu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 782EA606A320;
	Wed, 18 Nov 2026 21:25:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vOJJ3XOu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C494B1F000C4;
	Wed, 18 Nov 2026 21:25:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037110;
	bh=cxLoJSvgF7VwEfKh4rDRsBNfDEiCYQE4nzRTDfHlSBg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vOJJ3XOuOw5E0e3h5Cr9Bs4zLF0HR97yqwDBqD45Mvz3BsKaHYQSU0M88VcRdicfZ
	 8XJ9t0NYYKYz0TAhWR+RJ1mfpO6+WJodOrf20nNcjybyknX40WzBHT+RiNdXT1yHoa
	 UVjJbrTdtp122YE3lPvnp3NN6rlUeN+9Rrb1afAI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1298/3318] apparmor: on failed load ensure profile files are removed before parent
Date: Wed, 18 Nov 2026 15:32:00 +0100
Message-ID: <20261118150359.205481712@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index a6ce3f29480fc..79e7c7cb26b33 100644
--- a/security/apparmor/policy.c
+++ b/security/apparmor/policy.c
@@ -1356,8 +1356,10 @@ ssize_t aa_replace_profiles(struct aa_ns *policy_ns, struct aa_label *label,
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



