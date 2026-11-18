Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050308;
	b=kRlyRXXoae4wLxHQbrL3lOG5F0WTP8EBxsjDfSop1mcqB5CXgPjgyrA1OHHZMgX+xD2j
	 gRbFEkmqQEDxbrk/Zq2+i6rFT4IL3OZvlMdR+cfqIbfizSBLdnWqJfUrf1bPOP+wmdawp
	 okJ0UUWdnrMKMb+hqBk4cDxUcStIY195cwOwjICzT9ffA/CVKE7NwDooSQ/iRtozS04m2
	 EDXo3lSQgJSKSh9aR4+pvhUzQYirxfQJfzsCZisvvkR/MgWI9YmZWsAfiEBilbpmmvDHv
	 117ElWq9UAq5FAT83n9kHNF36gQ6ACmRiWHLLzuQQXLMkNKnunJbm5+VkqBfI/OW52A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050308;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CRehUOLOvC0jwUPGA0fs4s6x826sdXfJOINu9Ncrezg=;
	b=e9n20VCJlusRGe+vJlAkwk7+TaLRyGH8eI75YDajoXB2QoRD8VlgXjtfpx8PxSHwaA5i
	 aStpbJ+wZgTV8wzCBAV6NpJiZ+15POH1sGg12qFCYfkKqNFES7PAr/h6IbNrcCgOUwTb7
	 zAHMXx7w1TF8CexytUkHcyvhszP6w157wLLzHHcQX57Ewr4UKm1OEDYnZjq/KO+1WL+hX
	 CwtcneUZtin0YArnf3dT/kyMWVfDbDDlU0/OeFo3Gq27wnpnJOpeVlRAc3CT1258wYCTd
	 j4ZZ1RLqGpFsZZgBUtMmILkGoG/YV1XIZHPdj4k6+Nxws6Ogbn51+SQko9/VNWM4Wfg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=V5gP5ckC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7122606A33D;
	Thu, 19 Nov 2026 01:05:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=V5gP5ckC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21FC11F000C4;
	Thu, 19 Nov 2026 01:05:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050308;
	bh=CRehUOLOvC0jwUPGA0fs4s6x826sdXfJOINu9Ncrezg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=V5gP5ckC+EIndTysqkxQ9aHlArLYqmvQ3Abew423YX7qaUyDrC7gGtc4fuqIb0IPf
	 Drmcz6A7mKpIrkh9nrncUMJwSnZgaDpWPbq77ObUsKImctM7b0sY77DwBpfHz2Vqtn
	 lgVwOsPLU0ko7lSJTXw6eqULOfw7cfTuXGqV6bQc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot+sashiko@kernel.org>,
	Henry Hu <huhai@kylinos.cn>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2661/2857] ksmbd: fix invalid Next offset in interface info replies
Date: Wed, 18 Nov 2026 16:01:35 +0100
Message-ID: <20261118150337.389908682@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Henry Hu <huhai@kylinos.cn>

[ Upstream commit 2c50a4a5e75db55880eca43c035649cb51fcb52a ]

fsctl_query_iface_info_ioctl() assigns nii_rsp to the next output
slot before checking whether the interface has an in_device or
inet6_dev. If either lookup returns NULL, the loop continues without
advancing nbytes, leaving nii_rsp pointing at an uncommitted slot. If
no later entry is committed, clearing nii_rsp->Next updates that slot
instead of the last returned entry, leaving the latter with a nonzero
Next offset.

Fix this by using nbytes to locate the last committed entry and clear
its Next field, but only when the response contains at least one entry.

Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Reported-by: Sashiko <sashiko-bot+sashiko@kernel.org>
Link: https://sashiko.dev/#/patchset/20260910090818.24479-1-15815827059%40163.com
Signed-off-by: Henry Hu <huhai@kylinos.cn>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/smb2pdu.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 53c2cda2581e6..7a54dc3bf0165 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -7823,9 +7823,15 @@ static int fsctl_query_iface_info_ioctl(struct ksmbd_conn *conn,
 	}
 	rtnl_unlock();
 
-	/* zero if this is last one */
-	if (nii_rsp)
+	/*
+	 * nii_rsp may point to an entry not included in nbytes if the IPv4
+	 * or IPv6 device lookup failed. Clear Next in the last returned entry.
+	 */
+	if (nbytes > 0) {
+		nii_rsp = (struct network_interface_info_ioctl_rsp *)
+			  &rsp->Buffer[nbytes - sizeof(*nii_rsp)];
 		nii_rsp->Next = 0;
+	}
 
 	rsp->PersistentFileId = SMB2_NO_FID;
 	rsp->VolatileFileId = SMB2_NO_FID;
-- 
2.53.0



