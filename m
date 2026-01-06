Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E0D3376BE4;
	Tue,  6 Jan 2026 18:00:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767722402; cv=none; b=KkZvbamh9hNpitZD0aVfVAcLRIib/qdt5eYRMGV7AftI3YwtRpU+JFGkla+GFbyKOVKNj98Z0XzZm9n02IhEqeIOoAGjVZJ5Z/nK4JNEFjZppO+atxMdOUlhr5Y7PvR6rMopRUx5RfnKbZpt4HOLrO/goJfkYBO5BsamQ7avBvw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767722402; c=relaxed/simple;
	bh=XL0agXkuCgBa6hoLWcc7/I8SgzJgqgJBSzKvmpWqh4w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ILAJeyOelMoaSSY08qZcuDRvxSU4NPh5ufv+IDIEDh62WmVc/IXyez9mrUTI/lXqtQ0vd838wQ67nnwjN81O/Y39AtWAlFFKuSpiX5AZkLqgLLFLr6vy539Jje895htqH1RVwekp3FSeG00FrSsRGZ7udnvbO6+V3Vx/QTvYDXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c/0hxJNH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c/0hxJNH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43592C116C6;
	Tue,  6 Jan 2026 18:00:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767722401;
	bh=XL0agXkuCgBa6hoLWcc7/I8SgzJgqgJBSzKvmpWqh4w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c/0hxJNH/1AWbfXMBDnUJH0DXOm2VXMDFeHRaplbIAkZr35dSbthGMdvPWUcZiM02
	 RPNEHTdulurQb0JG4al+JhAcPJhmN+3Aggo3a8S0jerk21Rv9I/g1P6V0ZpjCKTIO7
	 DNLpCbn91RJucKyCx5lXoMNPBDXXOQaLBFscQCkU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.18 253/312] nfsd: Drop the client reference in client_states_open()
Date: Tue,  6 Jan 2026 18:05:27 +0100
Message-ID: <20260106170557.001431604@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170547.832845344@linuxfoundation.org>
References: <20260106170547.832845344@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>

commit 1f941b2c23fd34c6f3b76d36f9d0a2528fa92b8f upstream.

In error path, call drop_client() to drop the reference
obtained by get_nfsdfs_clp().

Fixes: 78599c42ae3c ("nfsd4: add file to display list of client's opens")
Cc: stable@vger.kernel.org
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfs4state.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -3099,8 +3099,10 @@ static int client_states_open(struct ino
 		return -ENXIO;
 
 	ret = seq_open(file, &states_seq_ops);
-	if (ret)
+	if (ret) {
+		drop_client(clp);
 		return ret;
+	}
 	s = file->private_data;
 	s->private = clp;
 	return 0;


