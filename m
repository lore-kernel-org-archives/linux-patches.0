Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1E9C18040;
	Tue, 18 Jun 2024 12:58:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715499; cv=none; b=BaznFxp2ZZ0J7eE4zKBE01hGVJBl3xPkBij2pJWV3FQc4wpr0RWPv0ZS80CNPudzrWU633OfHpn39mQBTtf0o3uvjQDTO+BxvJSI0M5mtiv6h4NgkrdY5FOScFLPTNPWHFmsVQsj5FkIKPv8k6wXqdHTZRb0+xnpA4XHqe7F/6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715499; c=relaxed/simple;
	bh=53fkgyjz/hdZmpoQI5BgkroWaQyV7mWJSAViEzjWy3g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ou08TGikIkF3Nae/2uJsJGtaGwG4oEBK0xzJk3og4Yc1xwAVW5YLBvzc0iGZbvx+EZzJSqmXoMm9h6hIhWcwP48lf0+fsJERGrR6RcXVEip+3fdSN0/Qz9Zfy7+NPcDxzG/nQ4qn0oEM2meLnLfkOdQwX/l9rg0IrlSRKcRRiy4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KoeyAaKy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KoeyAaKy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B26EC3277B;
	Tue, 18 Jun 2024 12:58:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715499;
	bh=53fkgyjz/hdZmpoQI5BgkroWaQyV7mWJSAViEzjWy3g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KoeyAaKyby9jZuwe6LHQl/fbzfjvzk6HrbY1fekUT0zcPVmlQ4LvfxY7G+sficjbI
	 BOUt96GhBLIQ+MfusB4MbK1iVlWRIAQCRm99FURojZXlJHk5g/sDmoICKi9Km5yt+M
	 6poiPdHXsvAbD3G/6cA+BFQtIh5n9qtQn6BAdpKs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	"J. Bruce Fields" <bfields@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 329/770] NFSD: Prevent a possible oops in the nfs_dirent() tracepoint
Date: Tue, 18 Jun 2024 14:33:02 +0200
Message-ID: <20240618123419.970692047@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240618123407.280171066@linuxfoundation.org>
References: <20240618123407.280171066@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 7b08cf62b1239a4322427d677ea9363f0ab677c6 ]

The double copy of the string is a mistake, plus __assign_str()
uses strlen(), which is wrong to do on a string that isn't
guaranteed to be NUL-terminated.

Fixes: 6019ce0742ca ("NFSD: Add a tracepoint to record directory entry encoding")
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/trace.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/nfsd/trace.h b/fs/nfsd/trace.h
index 68a0fecdd5f46..de245f433392d 100644
--- a/fs/nfsd/trace.h
+++ b/fs/nfsd/trace.h
@@ -408,7 +408,6 @@ TRACE_EVENT(nfsd_dirent,
 		__entry->ino = ino;
 		__entry->len = namlen;
 		memcpy(__get_str(name), name, namlen);
-		__assign_str(name, name);
 	),
 	TP_printk("fh_hash=0x%08x ino=%llu name=%.*s",
 		__entry->fh_hash, __entry->ino,
-- 
2.43.0



