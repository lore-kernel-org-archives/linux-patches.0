Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9F7412D74E;
	Tue, 30 Apr 2024 10:53:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714474428; cv=none; b=hZw3oIQOhtkIF1mgjIYBamMcx+qIO4yqLoDJtUAlMcaNwgLtxItjJoJQeD+PkAPjtfOsSzsXfLm30KS+C+FtHVU0ZAS65YzSODyZ25DrmM3V+YCpqfKRbHL0M31NiaCF7WkwFju5WJGq3Aby7bUGWGdsv1ka9feJSoSBmcWeCf0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714474428; c=relaxed/simple;
	bh=ism03/T73x/IMDVKntwB7n5K5lzMiSvNmw4VFsFT5hk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nGJJbz5XPb8yZDpzWYDZW7LjLSKvi6XNfSRymKm9fye1bZpxPx8WMyRHBLe8rf0NX1JiDcROQBv1PIxI1ikbLsLIjNFxi8y1j1++tl+IMwQLD4quawsgz2uZXd2YYaKXvCfLT8FbXyadPShGhhyxuBCq5yG7nM2ZzCnlymFDjuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kOVMkdhv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kOVMkdhv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C6C9C2BBFC;
	Tue, 30 Apr 2024 10:53:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714474427;
	bh=ism03/T73x/IMDVKntwB7n5K5lzMiSvNmw4VFsFT5hk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kOVMkdhvogyAIPQuM7MPAhTfdJxsg3U+bcziKwB/3dZmsXR4P7EHvf2JgXYp0Z806
	 s+ZFhZw6YzjyD+rmUpxgzcZM1Dj7oehwXEJ78z2eQjf3/4w6m0Sc7bVg3lmHr81CDV
	 V54MG0dlNrc8GPQKdt93G1hwyIZTZo6MSvvSidQs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shyam Prasad N <sprasad@microsoft.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.8 154/228] smb3: missing lock when picking channel
Date: Tue, 30 Apr 2024 12:38:52 +0200
Message-ID: <20240430103108.250483717@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103103.806426847@linuxfoundation.org>
References: <20240430103103.806426847@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steve French <stfrench@microsoft.com>

commit 8094a600245e9b28eb36a13036f202ad67c1f887 upstream.

Coverity spotted a place where we should have been holding the
channel lock when accessing the ses channel index.

Addresses-Coverity: 1582039 ("Data race condition (MISSING_LOCK)")
Cc: stable@vger.kernel.org
Reviewed-by: Shyam Prasad N <sprasad@microsoft.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/transport.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/fs/smb/client/transport.c
+++ b/fs/smb/client/transport.c
@@ -1057,9 +1057,11 @@ struct TCP_Server_Info *cifs_pick_channe
 		index = (uint)atomic_inc_return(&ses->chan_seq);
 		index %= ses->chan_count;
 	}
+
+	server = ses->chans[index].server;
 	spin_unlock(&ses->chan_lock);
 
-	return ses->chans[index].server;
+	return server;
 }
 
 int


