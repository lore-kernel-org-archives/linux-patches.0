Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F3962D023;
	Mon, 10 Mar 2025 17:55:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741629319; cv=none; b=hujxoetmBqwrrG5uJq4O2Kt2jJXPhAyAzuPnDw4EA9oux07dsBTOHaLrfpdGWzuWZV4uPvR2dHRtYFvfFZQrCJgoJwu9xi+YUj0vR6+C402m5O/RotwyDahO3dntvMrdYTNCCOa5siIsOLChddSwKIWnN55cLz9wzoyRA2VC8FA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741629319; c=relaxed/simple;
	bh=5UyX8yvYY/l0qV+QIgGtOTLCwxGG+MKDbg+Z5ITAo3w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BBxp/6BkeJbSQ+oMC/dXHZpPHKwci/05ogmqeAshbFdm0Uq3pHVseZ6gaY/IVIVrzxPyq4cZiPIzACSWkLHo3TljT9fIg4XRwMiFA6MejgKmjCuX2FY7xqMc1TG9yYK4NHP5b8Ro6gJB7R5pLhPqM7+4XsKckfKpwYnsx1UFzRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YFA7Yc7z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YFA7Yc7z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 803D7C4CEE5;
	Mon, 10 Mar 2025 17:55:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741629318;
	bh=5UyX8yvYY/l0qV+QIgGtOTLCwxGG+MKDbg+Z5ITAo3w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YFA7Yc7zKeSgBIxVMrOb/+r5w3wT2Ir68QeI/rxaJLAJ25tbeA1ePF2OI1JikECxe
	 6FLbijRwY60J5nKGglbu3qhbgodB/ZFllbZ3QC7mDuIhLDyXMyKye21g39RFazMh9N
	 G4lLD42k8odfjZGC9+EAVbfQc6kzHs0SjEH/Nbm0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liu Ye <liuye@kylinos.cn>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 222/620] selftests/net/ipsec: Fix Null pointer dereference in rtattr_pack()
Date: Mon, 10 Mar 2025 18:01:08 +0100
Message-ID: <20250310170554.384322847@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index c5be3f390849b..ae3da27b00973 100644
--- a/tools/testing/selftests/net/ipsec.c
+++ b/tools/testing/selftests/net/ipsec.c
@@ -189,7 +189,8 @@ static int rtattr_pack(struct nlmsghdr *nh, size_t req_sz,
 
 	attr->rta_len = RTA_LENGTH(size);
 	attr->rta_type = rta_type;
-	memcpy(RTA_DATA(attr), payload, size);
+	if (payload)
+		memcpy(RTA_DATA(attr), payload, size);
 
 	return 0;
 }
-- 
2.39.5



