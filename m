Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14F0E3DB634;
	Tue, 21 Jul 2026 18:06:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657169; cv=none; b=FLpysOWjJEuSYsCdLDBKNkT/wDhEdt7X38I6s1RKCwBq6s1rfeo1i+fgUAOvYBoFq2xrIddTK8ehpMpoXZy8m2oRBaQjTn4wfrO2jsaH3fVX3EckRyDU6ZsC3Pp1N39Lw5oXHHrGwUK0ml/LI9okCjoEcwEm4U0/rtYAX2cmqvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657169; c=relaxed/simple;
	bh=fAK1gWIqvVKSgOzBZTPqQuoYW1V78hslAxVprQikYUw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cfQ4xkrXUa6D4wM+e+vUAMdRAAW926peZF10PHOYSyqvjDl6KtlsRqoTRf4zLKi9ihSUiOkFkyMNX7zVEZlUnqHiGnCg+k3Cdmuol+GnFAeDCAEnzunm3AJsY46fR4VAzxrtVAEkDYGr0niimn7sod0yptfgUJ9OnfiONrj56+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tIGgCvYP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tIGgCvYP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A52A1F000E9;
	Tue, 21 Jul 2026 18:06:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657168;
	bh=ssBgdlh1jSU7/q6+iPWJ5XCeIdT8BpnhArItm0UJ+og=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tIGgCvYPXF8EQdvNrPYz76fSo+vH+MvicfirICs2M+sDS9Vnh9rfxWV/Go+Wd4fQv
	 Skb/9XUUsUDHyHRDgDYJq3ViMmEPO7Rskt3dca1zVHlx4LMTqINBVh5fGmVbwTzOF8
	 1zWVemPUTr1S5ehNJQrSkVs3LEI9rXVBcfCd+6kM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sagi Grimberg <sagi@grimberg.me>,
	Anna Schumaker <anna.schumaker@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0664/1611] pNFS/filelayout: fix cheking if a layout is striped
Date: Tue, 21 Jul 2026 17:13:00 +0200
Message-ID: <20260721152530.317716290@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: Sagi Grimberg <sagi@grimberg.me>

[ Upstream commit 91668417d4e925c98cae4a55b1b9860380ddbf16 ]

A layout can still be striped with num_fh = 1 as it is perfectly possible
that both MDS and DSs can handle the same filehandle. Hence check according
to stripe_count > 1, which is the correct check to begin with.

We should not be called with flseg->dsaddr = NULL, but if for some reason
we do, return our best guess with is flseg->num_fh > 1.

Fixes: a6b9d2fa0024 ("pNFS/filelayout: Fix coalescing test for single DS")
Signed-off-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Anna Schumaker <anna.schumaker@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/filelayout/filelayout.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/nfs/filelayout/filelayout.c b/fs/nfs/filelayout/filelayout.c
index 5c4551117c58c0..c933e3b695bc36 100644
--- a/fs/nfs/filelayout/filelayout.c
+++ b/fs/nfs/filelayout/filelayout.c
@@ -778,6 +778,8 @@ filelayout_alloc_lseg(struct pnfs_layout_hdr *layoutid,
 static bool
 filelayout_lseg_is_striped(const struct nfs4_filelayout_segment *flseg)
 {
+	if (flseg->dsaddr)
+		return flseg->dsaddr->stripe_count > 1;
 	return flseg->num_fh > 1;
 }
 
-- 
2.53.0



