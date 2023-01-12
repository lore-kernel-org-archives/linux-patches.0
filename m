Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE301749D
	for <patches@lists.linux.dev>; Thu, 12 Jan 2023 14:13:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 214FAC433EF;
	Thu, 12 Jan 2023 14:13:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673532794;
	bh=IFufFr5shijfvZjZeeSf1x558OZUSMpI17VuVT47SBA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wzVDrzrs9VpbIU1c8zMJwWX2DURF5FXkfGPEy/vF8J01OqkbK6YYxxMZBRXVS7qz+
	 N2Y+35Lg+6KFBTet3xGdT891bAJ44EWJWEovpg1IFkmps1JRbnLn7cBbgABy25l8x5
	 XEA1UL5Pzq7DYmySUkKLRAiiogO20nz4m8vmNLAU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 279/783] apparmor: Fix abi check to include v8 abi
Date: Thu, 12 Jan 2023 14:49:55 +0100
Message-Id: <20230112135537.328988063@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
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
index 556ef65ab6ee..519656e68582 100644
--- a/security/apparmor/policy_unpack.c
+++ b/security/apparmor/policy_unpack.c
@@ -964,7 +964,7 @@ static int verify_header(struct aa_ext *e, int required, const char **ns)
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



