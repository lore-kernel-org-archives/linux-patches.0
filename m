Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F14A115B0E2;
	Mon, 29 Jan 2024 17:13:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548422; cv=none; b=hJYSIb8mNaZ6/LF7zS8QtOWLv6haTTgaOOqKPGu/ublFoTD1iX5yrJInfhc60qi8yEnZg/itFN1rPHR4dQPHzNwi0VXp5jkUa3jdfqSgfaFQQGxZKqCBG3q/AJGkpg8BAte/89J5TpW0zmRA13FGMNWo05VGLBNt8Xj3TyDzJso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548422; c=relaxed/simple;
	bh=E/6cmeuJtXjhiZpySgFkzpMxf8oI0SlqKRAzpbwVdkk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W0scuzJx/A4Cy4NkDSphbyYjNN1IJTSgyWCSqCGCC+EvzZkRahKKDAZyVITDoRoPpa7/eb37rHWFTF31AbuLb98gJjiBQOhs1P5E4Rr+z6Bq/f95IJGjuqc/D/tMVpXW2Tq0kyqfB378bkCvehXBBWwWzE9KVikHqikZ06R/wtI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lCm9/38w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lCm9/38w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B96ABC433C7;
	Mon, 29 Jan 2024 17:13:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548421;
	bh=E/6cmeuJtXjhiZpySgFkzpMxf8oI0SlqKRAzpbwVdkk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lCm9/38wgehTgXTupRVyIRTnqLGt0ooZXKRZa1DiVOZabTH3tuDZPBQxgAbRCCYl7
	 SD4sPxfTTbkb8e1Mn69j2aO/TjKMhY4/LT0iznzkVLSllyAvySJ0mv3PCteNcc8bKC
	 P7JTeRkJNUXenBo4uzleS5baJlHvq6goh15+6MjI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paulo Alcantara <pc@manguebit.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 020/331] smb: client: fix parsing of SMB3.1.1 POSIX create context
Date: Mon, 29 Jan 2024 09:01:24 -0800
Message-ID: <20240129170015.554339125@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170014.969142961@linuxfoundation.org>
References: <20240129170014.969142961@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paulo Alcantara <pc@manguebit.com>

[ Upstream commit 76025cc2285d9ede3d717fe4305d66f8be2d9346 ]

The data offset for the SMB3.1.1 POSIX create context will always be
8-byte aligned so having the check 'noff + nlen >= doff' in
smb2_parse_contexts() is wrong as it will lead to -EINVAL because noff
+ nlen == doff.

Fix the sanity check to correctly handle aligned create context data.

Fixes: af1689a9b770 ("smb: client: fix potential OOBs in smb2_parse_contexts()")
Signed-off-by: Paulo Alcantara <pc@manguebit.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/smb2pdu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index 5276992e3647..888eb59ad86f 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -2185,7 +2185,7 @@ int smb2_parse_contexts(struct TCP_Server_Info *server,
 
 		noff = le16_to_cpu(cc->NameOffset);
 		nlen = le16_to_cpu(cc->NameLength);
-		if (noff + nlen >= doff)
+		if (noff + nlen > doff)
 			return -EINVAL;
 
 		name = (char *)cc + noff;
-- 
2.43.0



