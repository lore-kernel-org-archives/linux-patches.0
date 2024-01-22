Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0459212A17F;
	Tue, 23 Jan 2024 00:13:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705968815; cv=none; b=qNnDHJyr/d/JdAEqny5hDJSH9ejf+9+43g/Elt6wOyfc6H8v1J7t3fWyoQ1SWvV0qfVqEicWIAV94RITb0xrEkJItsGhHSyFKd/5NVMWG64iLeKog4B03V84qXzLm9oycGIoXBZbmD9sH4HuC8YiY4r3YiBB4OkSdxoXE7l/BWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705968815; c=relaxed/simple;
	bh=nrvrjUWAGSMPt0k2fO36dR4kDH9ZVBPSGdNiUil5DBU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JXovCHrpipLVWtMfXs1AnukAX/hlh3O+s6Y+PUvSQV8hkFQFzLEr0Pa3KJOBoISYk87gl31TdgsIygRPoBEeMURzdzv40BQG1E6YrDWPpWjeL7GRpzxBcdGi/rPkam95eovEbRWMH3oVMDs6tpMGgJ4axsX/mTH9+JnjbzzgjWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2PjF8jYt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2PjF8jYt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38245C433F1;
	Tue, 23 Jan 2024 00:13:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705968814;
	bh=nrvrjUWAGSMPt0k2fO36dR4kDH9ZVBPSGdNiUil5DBU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2PjF8jYtrAN+hT4gumkGh13Gey5B8eeYrOasRSkfF7OmYYfwHK9gAjMA7vRAgtLjz
	 E1Zry0OA1WT/Q+SCEK3nczPcfu9vXI+hJaZZbgAgrCaV1GD1SZrh7y0CNiweEGCvhi
	 gF22NucjwIdYuhWDkrTSvkWN/1WAZJarOS0w7Lcw=
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
Subject: [PATCH 5.4 059/194] selinux: Fix error priority for bind with AF_UNSPEC on PF_INET6 socket
Date: Mon, 22 Jan 2024 15:56:29 -0800
Message-ID: <20240122235721.731227356@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235719.206965081@linuxfoundation.org>
References: <20240122235719.206965081@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index d9f15c84aab7..c1bf319b459a 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -4625,6 +4625,13 @@ static int selinux_socket_bind(struct socket *sock, struct sockaddr *address, in
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



