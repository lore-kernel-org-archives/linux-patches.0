Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3606D21660C;
	Thu, 12 Dec 2024 15:09:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734016152; cv=none; b=TOttks9K7+O/swgMCHQQLviBlmIUE6R8ebcEahFZ42G5OdvA7p/OZeyQ9RGUtC1J6p598Ko0vmw85EemNMomzP9RoKr4KUVeriX6G4Q9D038smZYr+8XfmGuRVKD15agOcBW6ekGM1p+WeE48E0UEZhnv41YxDyFw/h69fs9caQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734016152; c=relaxed/simple;
	bh=TRr0fjNalF84kZBPirA0y6RwCSQCMTVPkzByZo6GdFA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I23a7uYa35vKzH9McHem/QN5b9n4l8WdAzEjCtXqYroMHV0fWSJ90MkHC1BfxY61tQU9fgZyAxkcWjEyT8VI6rBYs3HOFS1VfSxRRV3ww2wGOS+VJq1o/ExGgten2J3VjO5v2WA6615ZIKEsOZTJ0l5DNIfs0C4S/zQU7gCHeYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pn90AS64; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pn90AS64"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 991E9C4CECE;
	Thu, 12 Dec 2024 15:09:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734016152;
	bh=TRr0fjNalF84kZBPirA0y6RwCSQCMTVPkzByZo6GdFA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pn90AS64DBzBlxiOTuI+MHxF2N+nPnVMQA/5SYcSKf0mokRLBFpMATwGb7IN3WEz6
	 Z92MHCcE9+GouWSgPhueAWRSoO8H2xwj9xjTSiXzUyFcUC4Nwx+YzJigce/l3ugP+s
	 D7ppSZ3Sr0H/CwmjXtk6bZdpiHx/rLrJt6RjhWKY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jordy Zomer <jordyzomer@google.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.12 127/466] ksmbd: fix Out-of-Bounds Write in ksmbd_vfs_stream_write
Date: Thu, 12 Dec 2024 15:54:56 +0100
Message-ID: <20241212144311.822735638@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jordy Zomer <jordyzomer@google.com>

commit 313dab082289e460391c82d855430ec8a28ddf81 upstream.

An offset from client could be a negative value, It could allows
to write data outside the bounds of the allocated buffer.
Note that this issue is coming when setting
'vfs objects = streams_xattr parameter' in ksmbd.conf.

Cc: stable@vger.kernel.org # v5.15+
Reported-by: Jordy Zomer <jordyzomer@google.com>
Signed-off-by: Jordy Zomer <jordyzomer@google.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/smb2pdu.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -6868,6 +6868,8 @@ int smb2_write(struct ksmbd_work *work)
 	}
 
 	offset = le64_to_cpu(req->Offset);
+	if (offset < 0)
+		return -EINVAL;
 	length = le32_to_cpu(req->Length);
 
 	if (req->Channel == SMB2_CHANNEL_RDMA_V1 ||


