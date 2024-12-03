Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 956F81F754A;
	Tue,  3 Dec 2024 15:53:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733241186; cv=none; b=bKZf4FtObcpH0Cf132DVoLjzqKja+X49uvbkjlJhUQ6k/OccN1swjmToxvO64bedmgToRMmAAj2TnJGkZqZtFv/qDLXBtKX0BqK8T9jpL+pkepf8Eva05Cbh6FtXEHYUpR89Mt+yF13XNwv1PeOcKznko0wi5nZ7s6tdDqvhYBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733241186; c=relaxed/simple;
	bh=yZaoxfks6jFWJ89Hs5GFplxN89xlKmachmzNOnTEdsE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QjkSdXfoDqu8+twTDkDDKYmGmOegnEZ+Rmo/XhugnaaFwIVfqewS/VOnZIt55SjL+BEPpGhjPHk9O9cZ4g1FqrVIkB8rlZfzvySSGAIzBEX1lJwhR0Ur29FJHtcKgJoO4HJSJZpgyl8jDAHyUNW1IXEqeLG3F9TmPZa3UuTnTEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DdNkS7/5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DdNkS7/5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7E36C4CECF;
	Tue,  3 Dec 2024 15:53:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733241186;
	bh=yZaoxfks6jFWJ89Hs5GFplxN89xlKmachmzNOnTEdsE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DdNkS7/5nfD+i70ayq2Qpf43KvCFKhQ+prf6T0Dqi0Q8SSKMgxjTx23CQ5msPDPMH
	 PaHrI3RHxsKvYMhxuyZEmP+B8pcpP6AuISaDKO9hGZF64WHePXndO7ehFH5vr2+MSt
	 XgFVxrUI3ErB0Ndg3KdQDYOiDKlLZw/wLJJRREMQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Aring <aahringo@redhat.com>,
	David Teigland <teigland@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 350/826] dlm: fix dlm_recover_members refcount on error
Date: Tue,  3 Dec 2024 15:41:17 +0100
Message-ID: <20241203144757.416222170@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

From: Alexander Aring <aahringo@redhat.com>

[ Upstream commit 200b977ebbc313a59174ba971006a231b3533dc5 ]

If dlm_recover_members() fails we don't drop the references of the
previous created root_list that holds and keep all rsbs alive during the
recovery. It might be not an unlikely event because ping_members() could
run into an -EINTR if another recovery progress was triggered again.

Fixes: 3a747f4a2ee8 ("dlm: move rsb root_list to ls_recover() stack")
Signed-off-by: Alexander Aring <aahringo@redhat.com>
Signed-off-by: David Teigland <teigland@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/dlm/recoverd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/dlm/recoverd.c b/fs/dlm/recoverd.c
index 34f4f9f49a6ce..12272a8f6d75f 100644
--- a/fs/dlm/recoverd.c
+++ b/fs/dlm/recoverd.c
@@ -151,7 +151,7 @@ static int ls_recover(struct dlm_ls *ls, struct dlm_recover *rv)
 	error = dlm_recover_members(ls, rv, &neg);
 	if (error) {
 		log_rinfo(ls, "dlm_recover_members error %d", error);
-		goto fail;
+		goto fail_root_list;
 	}
 
 	dlm_recover_dir_nodeid(ls, &root_list);
-- 
2.43.0



