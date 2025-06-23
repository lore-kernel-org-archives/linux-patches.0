Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DFC24C74;
	Mon, 23 Jun 2025 22:02:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750716137; cv=none; b=EBJcssi0kIIHknbDlexoaKw4BiJvnlBU0gDNTUtmOr3bJe3vk6hrjnBQOAiPGaUphHGAyuaxAEpNq5CKheYCgK7yXcGLVT+DHuOjQiXvoqHfMoISlkdOLI0xVNzzRDbvQkistDBEUzFTmE2HCgnEeYvLs9OZPhctk6Er2aSVleM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750716137; c=relaxed/simple;
	bh=I5784QhwCrI4bPjmLjC6CngW3k4BbxnqI0NyPRbP+AI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mji/Rg1M/ZVT7QkVNhVe5/CeyrI4m6sXx9pATPfGVjiXe4ESk+1dTuJBIxGVsZIdsSYpIpKRiL9PEoI21BiSMCqQi2ri3Rs5JlTpCPCjTdUMgRSgB2HCX3ZjR/s6vlPW7XO6ZQnHIWWrgQ0Ys/umT624f94E4i05xwH01Uc5PI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q4siDoUN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q4siDoUN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC80DC4CEEA;
	Mon, 23 Jun 2025 22:02:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750716137;
	bh=I5784QhwCrI4bPjmLjC6CngW3k4BbxnqI0NyPRbP+AI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q4siDoUNGgnr3myp7TW+RQL3eFzVl8/FXEylnPzP7OiPZIDLNcUezpHTlHCgUbeeJ
	 2AU7aTcMxu6EcBUli9axJ8+eG20kX8fVXniyEGA5Ir4Z5oz7HZ0AU/e1mK+XzOykt7
	 01GMC3Yjdo3+z5Fq0glRY4uA9rEOUrvUg/4aiUng=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shyam Prasad N <sprasad@microsoft.com>,
	Bharath SM <bharathsm@microsoft.com>,
	xfuren <xfuren@gmail.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.15 504/592] smb: fix secondary channel creation issue with kerberos by populating hostname when adding channels
Date: Mon, 23 Jun 2025 15:07:42 +0200
Message-ID: <20250623130712.423292018@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bharath SM <bharathsm@microsoft.com>

commit 306cb65bb0cb243389fcbd0a66907d5bdea07d1e upstream.

When mounting a share with kerberos authentication with multichannel
support, share mounts correctly, but fails to create secondary
channels. This occurs because the hostname is not populated when
adding the channels. The hostname is necessary for the userspace
cifs.upcall program to retrieve the required credentials and pass
it back to kernel, without hostname secondary channels fails
establish.

Cc: stable@vger.kernel.org
Reviewed-by: Shyam Prasad N <sprasad@microsoft.com>
Signed-off-by: Bharath SM <bharathsm@microsoft.com>
Reported-by: xfuren <xfuren@gmail.com>
Link: https://bugzilla.samba.org/show_bug.cgi?id=15824
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/sess.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/fs/smb/client/sess.c
+++ b/fs/smb/client/sess.c
@@ -498,8 +498,7 @@ cifs_ses_add_channel(struct cifs_ses *se
 	ctx->domainauto = ses->domainAuto;
 	ctx->domainname = ses->domainName;
 
-	/* no hostname for extra channels */
-	ctx->server_hostname = "";
+	ctx->server_hostname = ses->server->hostname;
 
 	ctx->username = ses->user_name;
 	ctx->password = ses->password;


