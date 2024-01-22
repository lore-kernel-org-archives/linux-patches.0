Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D9C62B9B7;
	Tue, 23 Jan 2024 01:41:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974108; cv=none; b=fXhOpxxNjhX4a/H/Cb7a9xbC5AIZn05CumO+OyLEXRIa25Znzrhtf4vku4pg/ZKfxZo1islyhKo+knw4r2Fog7eQ4U1fb3JjirKLUu60jV/gpkH3A6Vu5I7FamKxqzu0UzW0srtA3T2jnGoBzKHoRrY34vyFhyxksXsTyHSHtlA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974108; c=relaxed/simple;
	bh=2tkxMR1zeh97f3NX7x79QwVPXJUtSmzb8WNfO/TZpPc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uOiPaFuIR/Hk/FnAIg3bVT08SRucnJmSGRDzzF4F4RQiLGyKvrYQgY+5/9JbZKCNA9x6TMfCAcgJEoP07GElgICOQVNyYSIWO3HA/y5ixMY/ygBP8pkPJnhzfoFpru4swejsesHtcTskLocSM4SP38BTxMcNt3RMtrAEaMiQ1Nc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HRvyLqNV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HRvyLqNV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E527EC43390;
	Tue, 23 Jan 2024 01:41:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974108;
	bh=2tkxMR1zeh97f3NX7x79QwVPXJUtSmzb8WNfO/TZpPc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HRvyLqNVbhpp7VYgBbW8AaVp98CgXCEoIhwmIwCKdnouCsA1AYdHxSlQZriOEFXjV
	 l5wfemyw706sQTpLbsdJ6PQvFN/jUU/cJzOLPlkUJi5B0AkqIXvWCw8ehRbrXRKpew
	 1Es/bDmbZpU4PzhIFSGRMRiEjLtjrNCTQC2XneM4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Paris <eparis@parisplace.org>,
	Konstantin Meskhidze <konstantin.meskhidze@huawei.com>,
	Paul Moore <paul@paul-moore.com>,
	Stephen Smalley <stephen.smalley.work@gmail.com>,
	Muhammad Usama Anjum <usama.anjum@collabora.com>,
	=?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 041/583] selinux: Fix error priority for bind with AF_UNSPEC on PF_INET6 socket
Date: Mon, 22 Jan 2024 15:51:32 -0800
Message-ID: <20240122235813.406072843@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Mickaël Salaün <mic@digikod.net>

[ Upstream commit bbf5a1d0e5d0fb3bdf90205aa872636122692a50 ]

The IPv6 network stack first checks the sockaddr length (-EINVAL error)
before checking the family (-EAFNOSUPPORT error).

This was discovered thanks to commit a549d055a22e ("selftests/landlock:
Add network tests").

Cc: Eric Paris <eparis@parisplace.org>
Cc: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
Cc: Paul Moore <paul@paul-moore.com>
Cc: Stephen Smalley <stephen.smalley.work@gmail.com>
Reported-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Closes: https://lore.kernel.org/r/0584f91c-537c-4188-9e4f-04f192565667@collabora.com
Fixes: 0f8db8cc73df ("selinux: add AF_UNSPEC and INADDR_ANY checks to selinux_socket_bind()")
Signed-off-by: Mickaël Salaün <mic@digikod.net>
Tested-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Signed-off-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/selinux/hooks.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 208503340721..aa0afc122f09 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -4661,6 +4661,13 @@ static int selinux_socket_bind(struct socket *sock, struct sockaddr *address, in
 				return -EINVAL;
 			addr4 = (struct sockaddr_in *)address;
 			if (family_sa == AF_UNSPEC) {
+				if (family == PF_INET6) {
+					/* Length check from inet6_bind_sk() */
+					if (addrlen < SIN6_LEN_RFC2133)
+						return -EINVAL;
+					/* Family check from __inet6_bind() */
+					goto err_af;
+				}
 				/* see __inet_bind(), we only want to allow
 				 * AF_UNSPEC if the address is INADDR_ANY
 				 */
-- 
2.43.0



