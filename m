Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C88003AF66A;
	Mon, 23 Mar 2026 14:41:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774276898; cv=none; b=R8pdKlwkpAJ704UABFFSfWaXJ/jJb6wPsQ/YOqNHGMCtCaaY3sOxEAHLzOF/seFybtGEZ1fwiSjHnSwxc3Huu3EVqHeByeKdcdxByr+AmF/sakLdSWAyjlckQFOtiNgw7vwZ1yQU2/aHU3sOcYSHlmE74pZD9PMUpOj2Rsrycoo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774276898; c=relaxed/simple;
	bh=iySqGAV1ae9CH7yzf1rOgdbiGVOe/uWFDBZPLeXEZb0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dwbi4YhXgdfS+TGIqASYmOMqdKbPrl9mKFbqI+TsQFdGKSaooNInb8ad/pPyCJzIzo6aNaWiSGB6Q6Zu7hl1mhCDDPOK6lOOjmNfeLeYfw73yPsvqw2kXgOD0fOrw7Ug2UO42TajX9pizgFkacfTYzNyWNyJ2JxPM/pE3rrA8ps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bHYxTx2y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bHYxTx2y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B066C4CEF7;
	Mon, 23 Mar 2026 14:41:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774276898;
	bh=iySqGAV1ae9CH7yzf1rOgdbiGVOe/uWFDBZPLeXEZb0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bHYxTx2yq7YZZNGMjQPyRnJU77VPYxWtLYFAs03jJG1K47TAfqzuo+Ix5xTyIogA7
	 /kOmDGbPMwFT5x4gyyUUslKxJopQ4WbgIC1PTDQ2YY2aernGOmXMAuYj2M4EDr59kW
	 wzDZTgZA3uLFKsQ7ioF5fCmdjm1GmuR7gY61xRLc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ethan Tidmore <ethantidmore06@gmail.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	"Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>,
	Carlos Maiolino <cem@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 239/460] xfs: Fix error pointer dereference
Date: Mon, 23 Mar 2026 14:43:55 +0100
Message-ID: <20260323134532.377540977@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134526.647552166@linuxfoundation.org>
References: <20260323134526.647552166@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ethan Tidmore <ethantidmore06@gmail.com>

[ Upstream commit cddfa648f1ab99e30e91455be19cd5ade26338c2 ]

The function try_lookup_noperm() can return an error pointer and is not
checked for one.

Add checks for error pointer in xrep_adoption_check_dcache() and
xrep_adoption_zap_dcache().

Detected by Smatch:
fs/xfs/scrub/orphanage.c:449 xrep_adoption_check_dcache() error:
'd_child' dereferencing possible ERR_PTR()

fs/xfs/scrub/orphanage.c:485 xrep_adoption_zap_dcache() error:
'd_child' dereferencing possible ERR_PTR()

Fixes: 73597e3e42b4 ("xfs: ensure dentry consistency when the orphanage adopts a file")
Cc: stable@vger.kernel.org # v6.16
Signed-off-by: Ethan Tidmore <ethantidmore06@gmail.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Nirjhar Roy (IBM) <nirjhar.roy.lists@gmail.com>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
[ adapted try_lookup_noperm() calls to d_hash_and_lookup() ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/orphanage.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/fs/xfs/scrub/orphanage.c
+++ b/fs/xfs/scrub/orphanage.c
@@ -443,6 +443,11 @@ xrep_adoption_check_dcache(
 		return 0;
 
 	d_child = d_hash_and_lookup(d_orphanage, &qname);
+	if (IS_ERR(d_child)) {
+		dput(d_orphanage);
+		return PTR_ERR(d_child);
+	}
+
 	if (d_child) {
 		trace_xrep_adoption_check_child(sc->mp, d_child);
 
@@ -480,7 +485,7 @@ xrep_adoption_zap_dcache(
 		return;
 
 	d_child = d_hash_and_lookup(d_orphanage, &qname);
-	while (d_child != NULL) {
+	while (!IS_ERR_OR_NULL(d_child)) {
 		trace_xrep_adoption_invalidate_child(sc->mp, d_child);
 
 		ASSERT(d_is_negative(d_child));


