Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADEA2379C48;
	Tue, 21 Jul 2026 15:59:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784649550; cv=none; b=h3yEURPsBdXbKTTUYsDNzbWVMBHnbgpXtvT9sn74APWAI61h8H3HoTm/OxuQZdiJBJb9RO9gQ+HnZxrzA3LfqwrWDpYlibnOm2NrT1CY40R6RMJAIy+oBcoGypYRYCJ+JTjUs38+YiOMx4u19I/RFPz7VO9FKC68b2+4x1/syag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784649550; c=relaxed/simple;
	bh=nkgQ+sYGBlbhSCsEqtt1pU85K1NQhMQk5zawp/QZ8dQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oqN+avvNZx9fMpJraLkz7KOSh/zuHc4mFMfygVAlGwPV+LycM+7bUPiKZvjQWsmnSCd3Rf7vz/8dHi3oOD0fHBJuGhB43P/obOXHTsIfWNKxbmrTTNJWJe26uUDxCMh7h7Zx+6zsOKxQn8pvmU4+bf/1kSUkkze2sWLw0K71vA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kSgQxqAb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kSgQxqAb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F59F1F00A3D;
	Tue, 21 Jul 2026 15:59:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784649548;
	bh=m6V4nBsanubFebzX4qJZknIaPXEQsWLjRZ24UJBL5Cw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kSgQxqAbnLHJ+TKa3RP5D8kfqzIKTUxjx2re3JVpwrLeJxKnIvPW+0vZKU5kFk19y
	 hqWzf0zviuMG2nBqct4lvvGrndRal5D0tpkAnEEZiOGB3T187y6uvHNnBD+Rf8MduM
	 d2ewcsAfGBMtGp8ceptg1X0AfLXR6tbqpmHy0o7o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0620/2077] lockd: Stop warning on nlm__int__drop_reply in !V4 cast_status
Date: Tue, 21 Jul 2026 17:04:53 +0200
Message-ID: <20260721152607.427371406@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 5cca6056f2bae9be14566e0f7f6e351103a6aef3 ]

cast_status folds internal lock-daemon sentinels into NLMv1/v3
wire status codes.  The !CONFIG_LOCKD_V4 variant warns when an
unrecognized status falls into the internal-sentinel range,
gated by be32_to_cpu(status) >= 30000.

nlm__int__drop_reply is defined as cpu_to_be32(30000), so it
sits at the lower edge of that range and trips pr_warn_once
("lockd: unhandled internal status %u").  The status is
returned unchanged so the reply is still dropped, but every
dropped reply on a !CONFIG_LOCKD_V4 build emits a spurious
warning.

Compare against nlm__int__drop_reply directly so the warning
still catches the genuinely unexpected sentinels deadlock,
stale_fh, and failed (30001 through 30003) but excludes the
legitimate dropped-reply marker.

Fixes: d343fce148a4 ("[PATCH] knfsd: Allow lockd to drop replies as appropriate")
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/lockd/svcproc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/lockd/svcproc.c b/fs/lockd/svcproc.c
index c0a3487719e283..110e186802b6cd 100644
--- a/fs/lockd/svcproc.c
+++ b/fs/lockd/svcproc.c
@@ -49,7 +49,7 @@ static inline __be32 cast_status(__be32 status)
 		status = nlm_lck_denied_nolocks;
 		break;
 	default:
-		if (be32_to_cpu(status) >= 30000)
+		if (be32_to_cpu(status) > be32_to_cpu(nlm__int__drop_reply))
 			pr_warn_once("lockd: unhandled internal status %u\n",
 				     be32_to_cpu(status));
 		break;
-- 
2.53.0



