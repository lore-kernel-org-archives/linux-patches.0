Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B90B02C324F;
	Mon,  2 Jun 2025 14:53:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748875982; cv=none; b=XJjjHRIg0fovM5ikn8dXCEvdwQEJrfkFSechf7xvCvIb+z7Z/fj/Ybk9wgVGoCSEw5kWxxG4YJM6ajcdRhLzRZhv6mi77OUYA7OIAOfZsm5nih2IDZUf8p82Ngtnw95XvMYpg6Dg9bOD2WbYNwC9lCuSylq2cMrI0SM3y4xeGb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748875982; c=relaxed/simple;
	bh=hMIuOp2NPGJnK+KPHbrvlFc5qaBDqhbEpyZAngcr1CM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TuRftR7omrUzO+8BJof2op95HesfPSToOPBN9DpNvNjPc7WliI7ZzUOyFaywIUfH3pvUoIXbrnuDzKBxZZib1Zen3A9Tbw2g8l2P2D7BI+mFxOalsvZIzIKlBrFHF4Aln9cFlbF/2D9OLwsmT4T6aeE4r/QXxD/Rq4RRbvNQIgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TB4oRWcN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TB4oRWcN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F1D0C4CEEB;
	Mon,  2 Jun 2025 14:53:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748875982;
	bh=hMIuOp2NPGJnK+KPHbrvlFc5qaBDqhbEpyZAngcr1CM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TB4oRWcNIqoynR7QeJ4ESFxGP3ejyDG7uFXp8LewtksD+VVSMnHgW3oFVwUy7skDk
	 WaeaHe4ilJmDMMOn+JE+ZDHk+RfC1rVTW7HBk3dir7DE4Kpp+EAoWEsSRPwyrPdov7
	 CMswaJpWg6sfPEH89bgc0d4DJV0Pw2usraWeu318=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heming Zhao <heming.zhao@suse.com>,
	David Teigland <teigland@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 035/207] dlm: make tcp still work in multi-link env
Date: Mon,  2 Jun 2025 15:46:47 +0200
Message-ID: <20250602134300.138225488@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134258.769974467@linuxfoundation.org>
References: <20250602134258.769974467@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heming Zhao <heming.zhao@suse.com>

[ Upstream commit 03d2b62208a336a3bb984b9465ef6d89a046ea22 ]

This patch bypasses multi-link errors in TCP mode, allowing dlm
to operate on the first tcp link.

Signed-off-by: Heming Zhao <heming.zhao@suse.com>
Signed-off-by: David Teigland <teigland@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/dlm/lowcomms.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/dlm/lowcomms.c b/fs/dlm/lowcomms.c
index 1eb95ba7e7772..5b53425554077 100644
--- a/fs/dlm/lowcomms.c
+++ b/fs/dlm/lowcomms.c
@@ -1852,8 +1852,8 @@ static int dlm_tcp_listen_validate(void)
 {
 	/* We don't support multi-homed hosts */
 	if (dlm_local_count > 1) {
-		log_print("TCP protocol can't handle multi-homed hosts, try SCTP");
-		return -EINVAL;
+		log_print("Detect multi-homed hosts but use only the first IP address.");
+		log_print("Try SCTP, if you want to enable multi-link.");
 	}
 
 	return 0;
-- 
2.39.5



