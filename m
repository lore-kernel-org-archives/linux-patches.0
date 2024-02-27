Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30BB116423;
	Tue, 27 Feb 2024 14:02:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709042534; cv=none; b=UPxoL4xMXNx7RVxgRnZzp/wMN3Mklin60JwNPTU/LHhoc715RJzUa60pcB0NFd/J6aLMczKMjA7ZP9nBL/mK5LwCT95O9930IGrdT4uQpuY7D7QORG02aj1PMBwtza9iDqd5we0HrRUepkqiscWu74CuCGX7lxkQKikYzWCF1OU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709042534; c=relaxed/simple;
	bh=r2mZJXi6wUp84amlDF5MqoDKH+RLOFydfxK7uXXPC2o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TT9okkZrYqwvXBANCIp29EqFmJTkW9zPdI88/k4FwqiWchIrvBEPu4qAsv7msifqI91YQOH/P4MkShVSwmZ7uXZDCunWdpW50W76PxfXhXvWWm5oK32RtH+CGLcozORrHn6eUYhnWZ54tVWaOqAG5rRLcZbJEb95Z+Cj6A0teEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WT4ZupY4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WT4ZupY4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60B03C433F1;
	Tue, 27 Feb 2024 14:02:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709042533;
	bh=r2mZJXi6wUp84amlDF5MqoDKH+RLOFydfxK7uXXPC2o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WT4ZupY4P09Fd/36kGwG8+9bL23S1ufhtKbsK1OiCJjbEyszC6JXPZmkdLxBDuR3E
	 ePpe0071NMEPyWcrFCI6QqFuLEIlF7Uo7yoBYKMb9AoEuRmucIopfoQ00SdWStvtwV
	 evu79IKTzKMyXyIc6p+FPlAEpHvXTritw9T9FLjc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paulo Alcantara <pc@manguebit.com>,
	Steve French <stfrench@microsoft.com>,
	Guruswamy Basavaiah <guruswamy.basavaiah@broadcom.com>
Subject: [PATCH 5.15 006/245] smb: client: fix parsing of SMB3.1.1 POSIX create context
Date: Tue, 27 Feb 2024 14:23:14 +0100
Message-ID: <20240227131615.314529804@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131615.098467438@linuxfoundation.org>
References: <20240227131615.098467438@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
[Guru:smb2_parse_contexts()  is present in file smb2ops.c,
smb2ops.c file location is changed, modified patch accordingly.]
Signed-off-by: Guruswamy Basavaiah <guruswamy.basavaiah@broadcom.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/cifs/smb2pdu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -2094,7 +2094,7 @@ int smb2_parse_contexts(struct TCP_Serve
 
 		noff = le16_to_cpu(cc->NameOffset);
 		nlen = le16_to_cpu(cc->NameLength);
-		if (noff + nlen >= doff)
+		if (noff + nlen > doff)
 			return -EINVAL;
 
 		name = (char *)cc + noff;


