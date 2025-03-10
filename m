Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1CC622F17C;
	Mon, 10 Mar 2025 17:08:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741626529; cv=none; b=SwfZR2rlb08AFgaemRVULkV/9IyIBWJNge4UW+tmERuDs4+hqSRVtM8iiAZB0bF/C5ks7r+TeC534978A7gtIOF5Od3upfVp//7cQOcayyfxui/wgJdqlrQy0DKS/l7mhTBBrbM3cpl/NeZtd2AwTOOlr/kDKWpgESjeGSP9Vlc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741626529; c=relaxed/simple;
	bh=J7jDXwcO3c3U4iCFx1DKK2ZzjKXt13zdU83F+IPS+B8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qB1eafzRzywEqBC3ozTbshqUUTPmxmqtg+iugjTMvpfoDWwMg+SZN7VFUqb98Wb6ZUt7AiSmN2OLNZgPXQHwAytdu7I/JfKF8I4Oi9TSei5PzawMgRS4xxAEFOrEyiX3fZLILxpYvWXbnwBKDLO6I09KYR+2cPXR1Ovs8lX6CRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k1XkPTTf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k1XkPTTf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2A05C4CEE5;
	Mon, 10 Mar 2025 17:08:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741626529;
	bh=J7jDXwcO3c3U4iCFx1DKK2ZzjKXt13zdU83F+IPS+B8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k1XkPTTfupudqDy9keE/K2IsU7PrNJpM/dDpAlcYmkdQQ8fNzyQveLmVGRTqCyzCH
	 TrCmljPkqawcgPWxkWPXsxRaN3uZc+P10nwAT/iq9kVrRufWsZ4ha/cgEbcaxmKFEA
	 5EWotuxGqd8qI9YDjBCyN/BqYnmf8dg6B17X2w7M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Norbert Szetei <norbert@doyensec.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.13 023/207] ksmbd: fix bug on trap in smb2_lock
Date: Mon, 10 Mar 2025 18:03:36 +0100
Message-ID: <20250310170448.693716178@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170447.729440535@linuxfoundation.org>
References: <20250310170447.729440535@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

commit e26e2d2e15daf1ab33e0135caf2304a0cfa2744b upstream.

If lock count is greater than 1, flags could be old value.
It should be checked with flags of smb_lock, not flags.
It will cause bug-on trap from locks_free_lock in error handling
routine.

Cc: stable@vger.kernel.org
Reported-by: Norbert Szetei <norbert@doyensec.com>
Tested-by: Norbert Szetei <norbert@doyensec.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/smb2pdu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -7467,7 +7467,7 @@ no_check_cl:
 retry:
 		rc = vfs_lock_file(filp, smb_lock->cmd, flock, NULL);
 skip:
-		if (flags & SMB2_LOCKFLAG_UNLOCK) {
+		if (smb_lock->flags & SMB2_LOCKFLAG_UNLOCK) {
 			if (!rc) {
 				ksmbd_debug(SMB, "File unlocked\n");
 			} else if (rc == -ENOENT) {


