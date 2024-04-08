Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7D957E115;
	Mon,  8 Apr 2024 13:42:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583775; cv=none; b=a6cJe+MKLduvCZ3SlwO+TghNxhlhJoLZHs4ScmKfQAK1EOoOnoz57OyPZxqWdLIqObtmQHj5tcoMYEJeYpYXu6gA+qS22Qyrkj0D5JY5qtjVEUphilnELeYeWDVkHQNsRp4R3ox2nkJyDlHaGGnpe4IfdNyvdKxalAds5HlM+fw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583775; c=relaxed/simple;
	bh=VZcKaC27O6WBmd546s5pUsa5sMVcnRbYK8EZ3L9M1pQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C4hIMhAgzK3zEQGdRP0AjGn3jDfaPHsNoghU9KC6neBNpsSEu5OpXq40WB+1ZzncUf/kAsOd1l/lnhORm1TrpiqNGjp3h5EXkU4GB1ov/dBC9qWM0kyPTGhDwfSF2PYPp7z2dh/YDue6x3KWhD2//lXzFT+ZDn0h3JAMTKwaVQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c/knpxNr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c/knpxNr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70FC5C433F1;
	Mon,  8 Apr 2024 13:42:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583774;
	bh=VZcKaC27O6WBmd546s5pUsa5sMVcnRbYK8EZ3L9M1pQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c/knpxNrKBVLpApxBFsnjGlwdJxycv8yAr3j/ZoG30wKyDGysDrRspzlLsyBRge0y
	 qewEYdOQXuOxFeYQrcQwJF13+yFOI2p++SY29DACKSTPGEFdf+8CkmxmRAEky1JKfF
	 I0TbhhGQsWUNX4fN1x8H6N4H2hRPqLU783znX0Io=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.6 232/252] smb: client: fix potential UAF in cifs_dump_full_key()
Date: Mon,  8 Apr 2024 14:58:51 +0200
Message-ID: <20240408125313.854606149@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125306.643546457@linuxfoundation.org>
References: <20240408125306.643546457@linuxfoundation.org>
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

commit 58acd1f497162e7d282077f816faa519487be045 upstream.

Skip sessions that are being teared down (status == SES_EXITING) to
avoid UAF.

Cc: stable@vger.kernel.org
Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/ioctl.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/fs/smb/client/ioctl.c
+++ b/fs/smb/client/ioctl.c
@@ -246,7 +246,9 @@ static int cifs_dump_full_key(struct cif
 		spin_lock(&cifs_tcp_ses_lock);
 		list_for_each_entry(server_it, &cifs_tcp_ses_list, tcp_ses_list) {
 			list_for_each_entry(ses_it, &server_it->smb_ses_list, smb_ses_list) {
-				if (ses_it->Suid == out.session_id) {
+				spin_lock(&ses_it->ses_lock);
+				if (ses_it->ses_status != SES_EXITING &&
+				    ses_it->Suid == out.session_id) {
 					ses = ses_it;
 					/*
 					 * since we are using the session outside the crit
@@ -254,9 +256,11 @@ static int cifs_dump_full_key(struct cif
 					 * so increment its refcount
 					 */
 					cifs_smb_ses_inc_refcount(ses);
+					spin_unlock(&ses_it->ses_lock);
 					found = true;
 					goto search_end;
 				}
+				spin_unlock(&ses_it->ses_lock);
 			}
 		}
 search_end:


