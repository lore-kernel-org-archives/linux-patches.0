Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2696122173D;
	Thu, 13 Feb 2025 15:00:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739458817; cv=none; b=Gz5U6Waj8jeJ/lrOHdfwX47/EH2d1/mrZKM5Z/Bcy4BNi4Sbyan8CVtTdNnNPu6rcn8ZZ6S1jRI5LsWem8QTmvea0yZUBxwusN4NHzNdDia3ucpBJBZBj0j+4vBxLErYWa7+TJV2LV2LCeTt1appEaA/sgw9FM7w/ZfddgYfHqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739458817; c=relaxed/simple;
	bh=UnSPvKcgVW+UF7nuABf0wVwCg5+wKo7xSqQgubYKqdA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VeQ6t7tJ4ZFZFvQFADpGo8ogPzKw+UgZKBnHDhhjMERBxJdQP4/eHbpZhDYyHdV2IYBddLDT0yOIKNXo05BRt+rTBve4GrVEDiY90vKGjIWUubTx0E+3AAyoEcmPfcyKs4E4FVCwW+NLF38BNdAz2KmYnaGklk97h1RXhLTupL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aakP8l9F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aakP8l9F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86BB3C4CED1;
	Thu, 13 Feb 2025 15:00:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739458817;
	bh=UnSPvKcgVW+UF7nuABf0wVwCg5+wKo7xSqQgubYKqdA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aakP8l9FaaaSWkIWfzY7SaF9F7yLIJFEjVODGux48HVd6nM0FY+2Ckio6UuoySU+b
	 HhGk/XtTg53BfjI2UGtGoomSAUaF67CKMcL7g/xtQineT5CAn4rJDIMB39ceqgNul5
	 0WeMz2n0opzSupk9qqPJb/W3tBtRjO73DKtzDfyc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liu Ye <liuye@kylinos.cn>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 085/443] selftests/net/ipsec: Fix Null pointer dereference in rtattr_pack()
Date: Thu, 13 Feb 2025 15:24:10 +0100
Message-ID: <20250213142443.890532826@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Liu Ye <liuye@kylinos.cn>

[ Upstream commit 3a0b7fa095212b51ed63892540c4f249991a2d74 ]

Address Null pointer dereference / undefined behavior in rtattr_pack
(note that size is 0 in the bad case).

Flagged by cppcheck as:
    tools/testing/selftests/net/ipsec.c:230:25: warning: Possible null pointer
    dereference: payload [nullPointer]
    memcpy(RTA_DATA(attr), payload, size);
                           ^
    tools/testing/selftests/net/ipsec.c:1618:54: note: Calling function 'rtattr_pack',
    4th argument 'NULL' value is 0
    if (rtattr_pack(&req.nh, sizeof(req), XFRMA_IF_ID, NULL, 0)) {
                                                       ^
    tools/testing/selftests/net/ipsec.c:230:25: note: Null pointer dereference
    memcpy(RTA_DATA(attr), payload, size);
                           ^
Signed-off-by: Liu Ye <liuye@kylinos.cn>

Link: https://patch.msgid.link/20250116013037.29470-1-liuye@kylinos.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/ipsec.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/ipsec.c b/tools/testing/selftests/net/ipsec.c
index be4a30a0d02ae..9b44a091802cb 100644
--- a/tools/testing/selftests/net/ipsec.c
+++ b/tools/testing/selftests/net/ipsec.c
@@ -227,7 +227,8 @@ static int rtattr_pack(struct nlmsghdr *nh, size_t req_sz,
 
 	attr->rta_len = RTA_LENGTH(size);
 	attr->rta_type = rta_type;
-	memcpy(RTA_DATA(attr), payload, size);
+	if (payload)
+		memcpy(RTA_DATA(attr), payload, size);
 
 	return 0;
 }
-- 
2.39.5



