Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EA263D3499;
	Mon,  4 May 2026 14:01:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777903291; cv=none; b=NTNmN05w05LGxs6Ev/1RWU5yZ8hpT5Bxx0rojokWKxhklMDE11l7a8tR4V3rUqXUETV21gf8wv+m92iB5oEG/mpNQfDsKUSp7pDj4mcUN9T08zXZR+QafrsUUR+uf0WODK4+CbitgUD5BYNb1LSy5PjmpsehVwzZfGewfpnXVxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777903291; c=relaxed/simple;
	bh=6hm+zMbtktE6CzCLYAMJl586kGk4uRm7FIwVYW3Knqg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UOGVLeuJNV3JnnGKets49KNfv5sQrzm32DXnWcJqmaEizLiGKUKWV1ThNFD2kqk7XaXOiEG/z1e9U+QVI92xcLwqj9caU6JeT1FiHowqdtCcm0HosNZdqrw0I2z0Tn3AxXQeuFnRXRoTE8NIJU8C6crh68pGd/gYn6pQbXR4HKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fDaTHICu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fDaTHICu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9ECFC2BCB8;
	Mon,  4 May 2026 14:01:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777903291;
	bh=6hm+zMbtktE6CzCLYAMJl586kGk4uRm7FIwVYW3Knqg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fDaTHICubrxGQUs7HExIs9BfqrYIVf02iSoa+xmPjrqBA9ya6l+PmW/JpFmW8X2zI
	 rbDy6LWP5/rF6srfJEfBmr8NXzxFDSg/zS4H1/M/rzquojEat3BFAvb2jPqKBVPe5f
	 e5PfkVo9MIf2M3C8d/XZC4Y8LU5IvmcaEuwQzQ0Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 7.0 178/307] xfs: fix a resource leak in xfs_alloc_buftarg()
Date: Mon,  4 May 2026 15:51:03 +0200
Message-ID: <20260504135149.571022954@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.814938198@linuxfoundation.org>
References: <20260504135142.814938198@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>

commit 29a7b2614357393b176ef06ba5bc3ff5afc8df69 upstream.

In the error path, call fs_put_dax() to drop the DAX
device reference.

Fixes: 6f643c57d57c ("xfs: implement ->notify_failure() for XFS")
Cc: stable@vger.kernel.org
Signed-off-by: Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_buf.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1831,6 +1831,7 @@ xfs_alloc_buftarg(
 	return btp;
 
 error_free:
+	fs_put_dax(btp->bt_daxdev, mp);
 	kfree(btp);
 	return ERR_PTR(error);
 }


