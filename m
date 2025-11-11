Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 179DC26AC3;
	Tue, 11 Nov 2025 01:37:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762825024; cv=none; b=qA6Yo23EToiU0JbN4Cp2KUl2SXm8GUTsFc4amXHzmMo6ya2Xxur1Yi3k38y3MagtKmDZuAy9mnIIvJEHViZz7o/TpJ6tm0gt43nPKz8Q//koG0ja1QzAaeNvN2nyL+4EcipIBrZ5SU+pMoOktM824hROsRZwut41K0Lb4rcqLZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762825024; c=relaxed/simple;
	bh=ySA+VaZ4ndNF7c6YK2GHXE694PIWjwzTyivZy9B+P3o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WI2eCV9SkoeNY+UZ8e9FWzOlhNMJL85rZdvohfE+FiY5z3mPFKw5Y2DgmUYnVK9qCxLnnBkTNMXWTtZ1tVer1cmpc+ewTsjUHXIVMjs/345qLjF02U9k5BMlihd6Vca1lJITYgsMxm9RRDX+OR3b6H4Nu9j34Pp7NqmTfW2bB3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nimlJi0z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nimlJi0z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A793AC4CEF5;
	Tue, 11 Nov 2025 01:37:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762825024;
	bh=ySA+VaZ4ndNF7c6YK2GHXE694PIWjwzTyivZy9B+P3o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nimlJi0zz3Rg2KXE+7a7p7eLFulKh0j107mLmvVn36h/zDJL+bk352GRHGNLMFS0M
	 8CqZFCQt9NJCdJmJo37RbGI8C5tQ8P86eCoObQoEx6zx9kpKBsiuGJvqiSNTFESnuU
	 3EiEdg+x+Yl0+uxdRjy61R5NkNRT9d7cjjnuBIPE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anthony Iliopoulos <ailiop@suse.com>,
	Anna Schumaker <anna.schumaker@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 629/849] NFSv4.1: fix mount hang after CREATE_SESSION failure
Date: Tue, 11 Nov 2025 09:43:19 +0900
Message-ID: <20251111004551.639871793@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anthony Iliopoulos <ailiop@suse.com>

[ Upstream commit bf75ad096820fee5da40e671ebb32de725a1c417 ]

When client initialization goes through server trunking discovery, it
schedules the state manager and then sleeps waiting for nfs_client
initialization completion.

The state manager can fail during state recovery, and specifically in
lease establishment as nfs41_init_clientid() will bail out in case of
errors returned from nfs4_proc_create_session(), without ever marking
the client ready. The session creation can fail for a variety of reasons
e.g. during backchannel parameter negotiation, with status -EINVAL.

The error status will propagate all the way to the nfs4_state_manager
but the client status will not be marked, and thus the mount process
will remain blocked waiting.

Fix it by adding -EINVAL error handling to nfs4_state_manager().

Signed-off-by: Anthony Iliopoulos <ailiop@suse.com>
Signed-off-by: Anna Schumaker <anna.schumaker@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/nfs4state.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/nfs/nfs4state.c b/fs/nfs/nfs4state.c
index 7612e977e80b5..01179f7de3225 100644
--- a/fs/nfs/nfs4state.c
+++ b/fs/nfs/nfs4state.c
@@ -2744,6 +2744,9 @@ static void nfs4_state_manager(struct nfs_client *clp)
 	case -ENETUNREACH:
 		nfs_mark_client_ready(clp, -EIO);
 		break;
+	case -EINVAL:
+		nfs_mark_client_ready(clp, status);
+		break;
 	default:
 		ssleep(1);
 		break;
-- 
2.51.0



