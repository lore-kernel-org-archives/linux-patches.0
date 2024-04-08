Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C451342046;
	Mon,  8 Apr 2024 13:55:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584515; cv=none; b=SLQ0LoRExMvy3yB6m7P1Fl1PQ5MJxVst3MuAcKT8ThUKzDIrkHkYSo1GL2yV/PmKV1W+rYOSaNxnDc5IKJ4G+tC9EhEBWGCc3Nf7EkwsO6y9x+sSpcq5/eL80Mi/c6Mmjhq3fxrSBQKF61h2XXuWDVKymcDprbUDhtRnKp87m/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584515; c=relaxed/simple;
	bh=TaVl3kbbWRNCwd/ULduU9eHN38N7FYif80kVtR4oEik=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kzbv2MCdzPQWSUmJyb1YP2c+zkLi/VbSW+s427VCPkrklMmpdDineiXsORYMyQFLQW92stxy6ydjzqE4IkbXeBKQ6VHhrVYHwhRP3keWdBKG3pa/aaAhEQXzjI/eG6gKomT+SQM95CeslpPNKHqreYS7p5KrL2WTKzLpRrJ+21M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uq+pzvn8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uq+pzvn8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BC9AC433F1;
	Mon,  8 Apr 2024 13:55:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584515;
	bh=TaVl3kbbWRNCwd/ULduU9eHN38N7FYif80kVtR4oEik=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uq+pzvn8nNNUrJDQRgZC8XEsKwBOXzbw/7UnT9vvlkkquvoLNW9+9Q5ijakMzCh5v
	 +F0gzakJoXLiNWtkBHhpXgFePmxmTQdxH2ThoL2g8EvrdEEOUOmKTHN+QqS8VuxExd
	 GKmChcSchbV3vPjOcH7AmdBhZvLwEzB/YSW2Egic=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yongcheng Yang <yoyang@redhat.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 465/690] nfsd: put the export reference in nfsd4_verify_deleg_dentry
Date: Mon,  8 Apr 2024 14:55:31 +0200
Message-ID: <20240408125416.465941578@linuxfoundation.org>
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

From: Jeff Layton <jlayton@kernel.org>

[ Upstream commit 50256e4793a5e5ab77703c82a47344ad2e774a59 ]

nfsd_lookup_dentry returns an export reference in addition to the dentry
ref. Ensure that we put it too.

Link: https://bugzilla.redhat.com/show_bug.cgi?id=2138866
Fixes: 876c553cb410 ("NFSD: verify the opened dentry after setting a delegation")
Reported-by: Yongcheng Yang <yoyang@redhat.com>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/nfs4state.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index d19629de2af5d..7cfc92aa2a236 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -5397,6 +5397,7 @@ nfsd4_verify_deleg_dentry(struct nfsd4_open *open, struct nfs4_file *fp,
 	if (err)
 		return -EAGAIN;
 
+	exp_put(exp);
 	dput(child);
 	if (child != file_dentry(fp->fi_deleg_file->nf_file))
 		return -EAGAIN;
-- 
2.43.0



