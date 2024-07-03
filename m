Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D65918734B;
	Wed,  3 Jul 2024 11:09:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720004998; cv=none; b=JDk67t9Dg5wDSoEK1OFCS+2dVCVWCr15rdZUefahoSvcTjZI8ku1tGoOv5DsHHLiqh9oitwS23HAR8h5XxZLwF2Dag+uJ0nSixT8XYJ2+LoSh9kEyenlc8sCgoxC23753q48MKl2WkdIkvysjr2H4CHx5uXXi7kPHtom2/uULdA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720004998; c=relaxed/simple;
	bh=K7co3tV1KZ/JDkY7NzJ8vFWs9Akxij3jx0SvD5D07wc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VlODFHgJqu88iYKeEh2/UN9FYg8rEBLHllFszk/CMOKHDVP92HAAcpoO3g+PUDJ7nX+JPsejJ55YmisSfrsdO38WQNIFVmoiihzbgX+ICA6+3/9xG6SNGwXpkjf16vnMe83MIFaf0x1asugq8AiEWcl6CijNKGxi5Ayitz7LHAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tzM1lDJ3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tzM1lDJ3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C53A0C2BD10;
	Wed,  3 Jul 2024 11:09:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720004998;
	bh=K7co3tV1KZ/JDkY7NzJ8vFWs9Akxij3jx0SvD5D07wc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tzM1lDJ3U/9RlPsv+tm+M0KBI34G1jwaU42MpHhaashs6VJdFXCphsRTV1d7XbHdV
	 DxHYoHAG2Q6ml6YE4+Tu5LOzi/j0SeE86LEfcpD4TYvX3OrCBM4SaZYrPtt1UdkD7O
	 CIL1zUv0kwmdcotGEemuELugQTwZBMN8SS1/+tGA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shyam Prasad N <sprasad@microsoft.com>,
	Aurelien Aptel <aaptel@suse.com>,
	"Paulo Alcantara (SUSE)" <pc@cjr.nz>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 195/290] cifs: missed ref-counting smb session in find
Date: Wed,  3 Jul 2024 12:39:36 +0200
Message-ID: <20240703102911.531065387@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102904.170852981@linuxfoundation.org>
References: <20240703102904.170852981@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shyam Prasad N <sprasad@microsoft.com>

[ Upstream commit e695a9ad0305af6e8b0cbc24a54976ac2120cbb3 ]

When we lookup an smb session based on session id,
we did not up the ref-count for the session. This can
potentially cause issues if the session is freed from under us.

Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
Reviewed-by: Aurelien Aptel <aaptel@suse.com>
Reviewed-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
Signed-off-by: Steve French <stfrench@microsoft.com>
Stable-dep-of: 02c418774f76 ("smb: client: fix deadlock in smb2_find_smb_tcon()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/smb2transport.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/fs/cifs/smb2transport.c b/fs/cifs/smb2transport.c
index d659eb70df76d..f40b8de2aeeb3 100644
--- a/fs/cifs/smb2transport.c
+++ b/fs/cifs/smb2transport.c
@@ -154,6 +154,7 @@ smb2_find_smb_ses_unlocked(struct TCP_Server_Info *server, __u64 ses_id)
 	list_for_each_entry(ses, &server->smb_ses_list, smb_ses_list) {
 		if (ses->Suid != ses_id)
 			continue;
+		++ses->ses_count;
 		return ses;
 	}
 
@@ -205,7 +206,14 @@ smb2_find_smb_tcon(struct TCP_Server_Info *server, __u64 ses_id, __u32  tid)
 		return NULL;
 	}
 	tcon = smb2_find_smb_sess_tcon_unlocked(ses, tid);
+	if (!tcon) {
+		cifs_put_smb_ses(ses);
+		spin_unlock(&cifs_tcp_ses_lock);
+		return NULL;
+	}
 	spin_unlock(&cifs_tcp_ses_lock);
+	/* tcon already has a ref to ses, so we don't need ses anymore */
+	cifs_put_smb_ses(ses);
 
 	return tcon;
 }
@@ -239,7 +247,7 @@ smb2_calc_signature(struct smb_rqst *rqst, struct TCP_Server_Info *server,
 		if (rc) {
 			cifs_server_dbg(VFS,
 					"%s: sha256 alloc failed\n", __func__);
-			return rc;
+			goto out;
 		}
 		shash = &sdesc->shash;
 	} else {
@@ -290,6 +298,8 @@ smb2_calc_signature(struct smb_rqst *rqst, struct TCP_Server_Info *server,
 out:
 	if (allocate_crypto)
 		cifs_free_hash(&hash, &sdesc);
+	if (ses)
+		cifs_put_smb_ses(ses);
 	return rc;
 }
 
-- 
2.43.0



