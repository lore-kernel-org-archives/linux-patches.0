Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 447A543B490;
	Tue, 21 Jul 2026 22:12:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784671929; cv=none; b=r07216wmus0cOoR251jrXFHGKl1ydQJ2n4NX/JZQuuyssHAF77D5CU0lMMc5iiJgAUfcP2BBf80Ejcposoqfrh69D+CO2zsiCRfE3guA9+e5vLWoEb1mISPP8cqt5VytT5jX49x2MIPfDQ0xF80Bdv8bmVRO+DD6RDmFfzX9vlM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784671929; c=relaxed/simple;
	bh=p2rzMjFHNHSOTnmgZViSoaWpHqGrK0hKgoasPWnvg68=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lXxOHbq6Sbal7mAFIK54cy4gf32cG5MlzDyaThvrIQLYUWOwmLMOIG/DPcEf3mttiFFx2FDFh9QztmJ4y44HwiVMdWIDNhJON3kPB2nYKuWBCLejBedKGGIUC95GCphim2rRMokvY5WX9OWT579dZPijs3RQu0ezFwbS54qSEIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T+XYCZcj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T+XYCZcj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A4BD1F000E9;
	Tue, 21 Jul 2026 22:12:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784671928;
	bh=NZJb8pY+6mReGP3RXXBP//i4LEmnArIYulGXpMrTenk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T+XYCZcjIQWQrtXjdAhvQ1IDPbtlQmoFfxAxGOYfnr2qsjQ7RY2w0UXkDPqMP+R14
	 DKpH8dDLag+dLgRPQFxIaLGnxGx3wyrGD8qr0QdF150o1y5CKC3xC62PXLx2Ml5t95
	 KhJbCouxqHYdJ+gnEPKmb+J6Kq/QdRqhRN7WJFzA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tyler Hicks <code@thicks.com>,
	Ryan Lee <ryan.lee@canonical.com>,
	Zygmunt Krynicki <me@zygoon.pl>,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 431/843] apparmor: aa_getprocattr free procattr leak on format failure
Date: Tue, 21 Jul 2026 17:21:06 +0200
Message-ID: <20260721152415.730357576@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zygmunt Krynicki <me@zygoon.pl>

[ Upstream commit fea23bf73f0cae8ccb1d0684e4a3003874771f41 ]

aa_getprocattr() allocates the output string before rendering the label
into it. If the second aa_label_snxprint() call fails, the function
returned without freeing that allocation.

Free and clear the output pointer on the uncommon formatting failure path
before dropping the namespace reference.

Fixes: 76a1d263aba3 ("apparmor: switch getprocattr to using label_print fns()")
Reviewed-by: Tyler Hicks <code@thicks.com>
Reviewed-by: Ryan Lee <ryan.lee@canonical.com>
Signed-off-by: Zygmunt Krynicki <me@zygoon.pl>
Signed-off-by: John Johansen <john.johansen@canonical.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/apparmor/procattr.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/security/apparmor/procattr.c b/security/apparmor/procattr.c
index c929bf4a3df1c0..3beb0915892a16 100644
--- a/security/apparmor/procattr.c
+++ b/security/apparmor/procattr.c
@@ -56,6 +56,8 @@ int aa_getprocattr(struct aa_label *label, char **string)
 				FLAG_SHOW_MODE | FLAG_VIEW_SUBNS |
 				FLAG_HIDDEN_UNCONFINED);
 	if (len < 0) {
+		kfree(*string);
+		*string = NULL;
 		aa_put_ns(current_ns);
 		return len;
 	}
-- 
2.53.0



