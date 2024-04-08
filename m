Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA763811FB;
	Mon,  8 Apr 2024 13:47:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584071; cv=none; b=TvL4FtdIjDJnbp9+zBSqIW8IitU9n3JxvoWoGGWlSy3XQWJRt4vomfCyRkiyRBPc64LGqM0zV3gQKrvpXgI8i4wbAq5Vre4kvCwouu6fx+xubT3uDtnTTi1IkbyhTkZFzCt7EYYPN8hQZOeumKmFeZ4qO3VcAY6tstvSFx3451w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584071; c=relaxed/simple;
	bh=XYi3AVwYcuy9LbL87wC4npvIstcvSSEOB7LY8a1TBW4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lSFd8w3fH2EDVRISFsy+Diik7iDi8CYDpzwu+tDkUd7/ocEcD/wM/iE+pWbjpk83RS0BY/FOvdDUOQXG1Bo8Xkq0cQK7aoPTeteANXzKvTczQ6TEhV2S96okdTAK88mTV6MPKaZfcTLFvDNvjiYtlaSpDXjndsEVBRK7eLga7uQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P0BJ9ELF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P0BJ9ELF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 649B5C43390;
	Mon,  8 Apr 2024 13:47:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584071;
	bh=XYi3AVwYcuy9LbL87wC4npvIstcvSSEOB7LY8a1TBW4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P0BJ9ELFwlAEe48uEukhwg2RqqpOvcFmRrIIVkOfs78XgrxmlMuPkS4+7q1wAzT2a
	 c/lsMTL6dAUKYZILKvE9KxEJswRk0ruhBLbyFjiE+QvdE8YA/J5L5FhcwuADWkhBcY
	 tlADJsL3d3fNA5HKjiBHnrsyik/2B3oJf1VLj998=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.8 257/273] smb: client: fix potential UAF in cifs_signal_cifsd_for_reconnect()
Date: Mon,  8 Apr 2024 14:58:52 +0200
Message-ID: <20240408125317.444788435@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125309.280181634@linuxfoundation.org>
References: <20240408125309.280181634@linuxfoundation.org>
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

From: Paulo Alcantara <pc@manguebit.com>

commit e0e50401cc3921c9eaf1b0e667db174519ea939f upstream.

Skip sessions that are being teared down (status == SES_EXITING) to
avoid UAF.

Cc: stable@vger.kernel.org
Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/connect.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -178,6 +178,8 @@ cifs_signal_cifsd_for_reconnect(struct T
 
 	spin_lock(&cifs_tcp_ses_lock);
 	list_for_each_entry(ses, &pserver->smb_ses_list, smb_ses_list) {
+		if (cifs_ses_exiting(ses))
+			continue;
 		spin_lock(&ses->chan_lock);
 		for (i = 0; i < ses->chan_count; i++) {
 			if (!ses->chans[i].server)


