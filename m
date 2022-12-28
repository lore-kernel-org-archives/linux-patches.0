Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29B751C07
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:06:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EA43C433EF;
	Wed, 28 Dec 2022 16:06:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672243603;
	bh=NCDusXs63H3DTZi81Gd9ZlJEWUg7qva/XiXOrTJPvg4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QkTjZYDxU6l+i1xbQ0+tf3WEgZnnTh/ZIjm2D47oONc3NfbDL27cb9krGulSAi9Xs
	 7CMKw5ZBQsUfQ01c5TPRNXiK1WfNRmkMZiwM+ohdYwYUkAW9o5eG8ICHNOhkfU7iB6
	 PgJAybKDNwkN73Y1tIR322HoC11/3ShZmK+9ftKY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0555/1073] apparmor: Fix abi check to include v8 abi
Date: Wed, 28 Dec 2022 15:35:43 +0100
Message-Id: <20221228144343.130558143@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: John Johansen <john.johansen@canonical.com>

[ Upstream commit 1b5a6198f5a9d0aa5497da0dc4bcd4fc166ee516 ]

The v8 abi is supported by the kernel but the userspace supported
version check does not allow for it. This was missed when v8 was added
due to a bug in the userspace compiler which was setting an older abi
version for v8 encoding (which is forward compatible except on the
network encoding). However it is possible to detect the network
encoding by checking the policydb network support which the code
does. The end result was that missing the abi flag worked until
userspace was fixed and began correctly checking for the v8 abi
version.

Fixes: 56974a6fcfef ("apparmor: add base infastructure for socket mediation")
Signed-off-by: John Johansen <john.johansen@canonical.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/apparmor/policy_unpack.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/security/apparmor/policy_unpack.c b/security/apparmor/policy_unpack.c
index 55d31bac4f35..9d26bbb90133 100644
--- a/security/apparmor/policy_unpack.c
+++ b/security/apparmor/policy_unpack.c
@@ -972,7 +972,7 @@ static int verify_header(struct aa_ext *e, int required, const char **ns)
 	 * if not specified use previous version
 	 * Mask off everything that is not kernel abi version
 	 */
-	if (VERSION_LT(e->version, v5) || VERSION_GT(e->version, v7)) {
+	if (VERSION_LT(e->version, v5) || VERSION_GT(e->version, v8)) {
 		audit_iface(NULL, NULL, NULL, "unsupported interface version",
 			    e, error);
 		return error;
-- 
2.35.1



