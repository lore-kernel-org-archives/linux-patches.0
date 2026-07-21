Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C361E3BE154;
	Tue, 21 Jul 2026 22:12:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784671924; cv=none; b=FoMRlcnkbPQpNffAdPNnQYcflq2TklwGIFptGtmwi3Pb4nzYUHWOK1eSlOU/aEcLyDCD+8h9gwP14KT/WzHHo94mn5q2mRDKzmpE7u/rczL7QmkXrRuWYqL4Fq+YlMF33HrfV1nuv64cW9ztyAupVx1qlqDDI7Rb4obc4/Dn0Ko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784671924; c=relaxed/simple;
	bh=YE6Gbqah5I7WDoGCvRcW9L6j0ygRMBI4WO0iuqnYbV0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LwEejpq60xLrT9YEloyFOG58iK7JpyHjUnpIRq8FHvmp6A07egfQvny9izrdjryWQLRb79KUhsWYA2/wsgozR8s6exkhiuWF71/4R5jyFbvLY77MSLom2p0FkDErdWRstYMecdZfuv91u2GtcvusCqOsZZ6RubOj4opdzSGth1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Nlsgkw1c; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Nlsgkw1c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3508A1F000E9;
	Tue, 21 Jul 2026 22:12:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784671922;
	bh=/zGcStt/GdDwotNyZuABw4kDlVdiJ8d2oRXdRP+yLKc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Nlsgkw1cg2tnxPobXt5ZePXRIZhOO3TzTGGT+vUQSOcu10ovgMXJT/UdD1507OLdq
	 Ula9+4w5Yidl6iHXu3JnsudU13DDLaL9MbVaqF0alrq/6i5Yc85RZF6NVPpIwWrNp+
	 UJPFuA7I0L30JKV9AxjoMZQkJaLWkJF3GicLuGP4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Georgia Garcia <georgia.garcia@canonical.com>,
	=?UTF-8?q?Maxime=20B=C3=A9lair?= <maxime.belair@canonical.com>,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 430/843] apparmor: fix potential UAF in aa_replace_profiles
Date: Tue, 21 Jul 2026 17:21:05 +0200
Message-ID: <20260721152415.706398678@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maxime Bélair <maxime.belair@canonical.com>

[ Upstream commit 7b42f95813dc9ceb6bda35afcf914630909a19f9 ]

The function aa_replace_profiles was accessing udata->size after calling
aa_put_loaddata(udata), causing a potential UAF.

Fixed this by saving the size to a local variable before dropping the
reference.

Fixes: 5ac8c355ae001 ("apparmor: allow introspecting the loaded policy pre internal transform")
Reviewed-by: Georgia Garcia <georgia.garcia@canonical.com>
Signed-off-by: Maxime Bélair <maxime.belair@canonical.com>
Signed-off-by: John Johansen <john.johansen@canonical.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/apparmor/policy.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/security/apparmor/policy.c
+++ b/security/apparmor/policy.c
@@ -922,6 +922,7 @@ ssize_t aa_replace_profiles(struct aa_ns
 	struct aa_loaddata *rawdata_ent;
 	const char *op;
 	ssize_t count, error;
+	ssize_t udata_sz;
 	LIST_HEAD(lh);
 
 	op = mask & AA_MAY_REPLACE_POLICY ? OP_PROF_REPL : OP_PROF_LOAD;
@@ -1106,13 +1107,15 @@ ssize_t aa_replace_profiles(struct aa_ns
 	mutex_unlock(&ns->lock);
 
 out:
+	udata_sz = udata->size;
+
 	aa_put_ns(ns);
 	aa_put_profile_loaddata(udata);
 	kfree(ns_name);
 
 	if (error)
 		return error;
-	return udata->size;
+	return udata_sz;
 
 fail_lock:
 	mutex_unlock(&ns->lock);


