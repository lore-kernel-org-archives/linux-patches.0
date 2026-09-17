Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09FBC563FA8;
	Thu, 17 Sep 2026 15:29:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789658975; cv=none; b=Fi8wcTw9NvRy4cqOr/bF6er1uPFYjvCedSxojB73ykVgYj+NxNbyCAn6cykHZ0zDN23gweui7ASEd0kydwvBY1KWKsP9oJAsIQSow7cuDvegYWTVOnPTAQB9AmKNffZI8eSbeX9NAzgY0wa/WLjaHb2Vft8T1RjzSiRRoXHehoA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789658975; c=relaxed/simple;
	bh=eK5FDZ0E/+PgUR1NG1vBu9PiGcilj2fyCSYatKwt81s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M11r/bqJXWqekGFEVtY4J49CeGzToKjUbPLijJfeiUhytiRfW5PitUBX7DWLOgq7DdtH1EI7VQJeHfFXbJ1wGwoIASsyQZ7D+glSECaRyo1ih/32HflG/Ra72JfjgusD9moymALaeD5b7qx+1Ig8sz6tEdX+SgKEzIf8j76yLKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CvCG/T70; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CvCG/T70"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3666C1F00893;
	Thu, 17 Sep 2026 15:29:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789658965;
	bh=8suCJiVH0T9mxowXgP2Vkdg5iNSRNPg01/x1lFSBO3M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CvCG/T70p8OaR6CacV+yUzKuJ3iumXpIXJnn/QLvm+McoeGW5toaSt1RNxO8QnGO+
	 bCQYKVliqqduZDTt6RP1sWjYscf6SMbsWaGaDq+qscjkXWNr2jjPJkNaeJbQU4Ygiz
	 GDXlXaFNjpE7yQKpC2GS2GVP/gZ5r6g8S0zxkWRg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cheryl Babcock <cheryl@renat.io>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 098/733] ksmbd: rate limit unmapped SID errors
Date: Thu, 17 Sep 2026 16:06:46 +0100
Message-ID: <20260917151353.390006955@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit feca5e70fc963b088377b20879e8cd8237c2fd7d ]

A client can include many structurally valid but unmapped SIDs in a DACL.
Logging every mapping failure lets one request generate hundreds of kernel
error messages.

Rate limit the message to prevent an authenticated client from flooding
the kernel log.

Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Reported-by: Cheryl Babcock <cheryl@renat.io>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/smbacl.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/smb/server/smbacl.c b/fs/smb/server/smbacl.c
index 7830f4fa836bb..ae1527aa62697 100644
--- a/fs/smb/server/smbacl.c
+++ b/fs/smb/server/smbacl.c
@@ -525,8 +525,8 @@ static int parse_dacl(struct mnt_idmap *idmap,
 			temp_fattr.cf_uid = INVALID_UID;
 			ret = sid_to_id(idmap, &ppace[i]->sid, SIDOWNER, &temp_fattr);
 			if (ret || uid_eq(temp_fattr.cf_uid, INVALID_UID)) {
-				pr_err("%s: Error %d mapping Owner SID to uid\n",
-				       __func__, ret);
+				pr_err_ratelimited("%s: Error %d mapping Owner SID to uid\n",
+						   __func__, ret);
 				continue;
 			}
 
-- 
2.53.0



