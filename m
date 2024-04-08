Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F24852E405;
	Mon,  8 Apr 2024 13:51:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584313; cv=none; b=t6qyxIWcQXawfujD963UvzUszF13saIyr5zIBP6smPWcyngDpp2Y0Z+VKk7XTTnYKvS5wHUmDHkVWQhYZ8WQ7Yami6HGsid7yW0YWXftU8tO/fWgljG7rUHYXb5KYHWMkSu2sITeF3x/hYgynuMuNdTzNZrQmDkFtJnL1/8U2mU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584313; c=relaxed/simple;
	bh=1sJjmucA8yQl4LEhpu19SDHgrO3nAfIJ5g6wgyYK4O4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eTZ/QOChqVEuSGEjzeq6as243q8D8iAJ3tOM83EgnbR4X9g4GQ5Z9Eioqd0Np18Ea20DcjIa1xRveqWlIvVVNdiuNmlJr9TStTKcDYuB7ZKM+hDStzhnFU2QuKhtN0Yqs/xQiNv7xT89V7xhia5eCad/eCM4UGsMt6YZwyWIMlo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rjdKRRhd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rjdKRRhd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71930C43390;
	Mon,  8 Apr 2024 13:51:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584312;
	bh=1sJjmucA8yQl4LEhpu19SDHgrO3nAfIJ5g6wgyYK4O4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rjdKRRhdFu2aukw4PLZTn2J1sFGSECSW8YW4bsFlRzOL5mU5LvLT5pni8Ksv4Rfin
	 ZcPpthOXQsUZoGwrBnGmTD2lfOW9YofWrMUSwCipP/auOYa+6UYdasX6p3tQaDZK1i
	 ZwuSwI6jQt35890kP/Y14TSehk0GEDBDA+nLmr+o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 396/690] NFSD: Refactor nfsd4_cleanup_inter_ssc() (2/2)
Date: Mon,  8 Apr 2024 14:54:22 +0200
Message-ID: <20240408125413.892826349@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 478ed7b10d875da2743d1a22822b9f8a82df8f12 ]

Move the nfsd4_cleanup_*() call sites out of nfsd4_do_copy(). A
subsequent patch will modify one of the new call sites to avoid
the need to manufacture the phony struct nfsd_file.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/nfs4proc.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/fs/nfsd/nfs4proc.c b/fs/nfsd/nfs4proc.c
index 238df435b395d..10130f0b088ef 100644
--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -1716,13 +1716,6 @@ static __be32 nfsd4_do_copy(struct nfsd4_copy *copy, bool sync)
 		nfsd4_init_copy_res(copy, sync);
 		status = nfs_ok;
 	}
-
-	if (nfsd4_ssc_is_inter(copy))
-		nfsd4_cleanup_inter_ssc(copy->ss_mnt, copy->nf_src->nf_file,
-					copy->nf_dst);
-	else
-		nfsd4_cleanup_intra_ssc(copy->nf_src, copy->nf_dst);
-
 	return status;
 }
 
@@ -1778,9 +1771,14 @@ static int nfsd4_do_async_copy(void *data)
 			/* ss_mnt will be unmounted by the laundromat */
 			goto do_callback;
 		}
+		copy->nfserr = nfsd4_do_copy(copy, 0);
+		nfsd4_cleanup_inter_ssc(copy->ss_mnt, copy->nf_src->nf_file,
+					copy->nf_dst);
+	} else {
+		copy->nfserr = nfsd4_do_copy(copy, 0);
+		nfsd4_cleanup_intra_ssc(copy->nf_src, copy->nf_dst);
 	}
 
-	copy->nfserr = nfsd4_do_copy(copy, 0);
 do_callback:
 	cb_copy = kzalloc(sizeof(struct nfsd4_copy), GFP_KERNEL);
 	if (!cb_copy)
@@ -1856,6 +1854,7 @@ nfsd4_copy(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 		status = nfs_ok;
 	} else {
 		status = nfsd4_do_copy(copy, 1);
+		nfsd4_cleanup_intra_ssc(copy->nf_src, copy->nf_dst);
 	}
 out:
 	return status;
-- 
2.43.0



