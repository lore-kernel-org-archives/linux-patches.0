Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 805647E10F;
	Wed, 21 Feb 2024 14:11:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708524687; cv=none; b=Lmob3BBpprcajuhb6DzjIuE59Em5j5cItyt/Ky+pmfnrxoZLHyN3d87wSj+Rd7NdrLc1twrjAaqUysMoSkcQ+KqGcP3vu/9OGuBouunC++Sp9nBET0dCpm1zr2AwZiI/sluHBKIocofAGIooO9cUdM5zGce58k0soyD2lrg83tA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708524687; c=relaxed/simple;
	bh=aMXnqT54/9tnNCJP140I0cfsbaiDl8VuU/GyUEGL7Fs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qWiuoz4rc6OCvrORhzlxEZHvzGST+Ebf3mDDAh0OrMLlYVd08KTgChf4ZBaJ9PwsMohINj8WL85C3+GnDQh+LOy9EwRi+ka++jUwXaPgh/3S2BLS/aPI/gqY+o8X2oOJLzw/fBHQ6jjdABAm3qxZYO7Ztc/I3Pr+63VmtHZMlfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ftVv9uDX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ftVv9uDX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00C1EC433C7;
	Wed, 21 Feb 2024 14:11:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708524687;
	bh=aMXnqT54/9tnNCJP140I0cfsbaiDl8VuU/GyUEGL7Fs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ftVv9uDXJELfg+TGogbI9HsEv8mmTIPKP4wPhR1H8JLXsCL6R6QrhJ2pAjGlVH9Gn
	 U5pVr1dip3OQQx7DzzxsKIeAh/42qcuUevsqKU2Ty0ss/+WF9qhVGn2GLvg2SYcN2Q
	 nBcovilfNOo8f8DXM9XbLFI8TwXwy+4XAZmgwoDA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Ekansh Gupta <quic_ekangupt@quicinc.com>
Subject: [PATCH 5.10 320/379] misc: fastrpc: Mark all sessions as invalid in cb_remove
Date: Wed, 21 Feb 2024 14:08:19 +0100
Message-ID: <20240221130004.412185510@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125954.917878865@linuxfoundation.org>
References: <20240221125954.917878865@linuxfoundation.org>
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

From: Ekansh Gupta <quic_ekangupt@quicinc.com>

commit a4e61de63e34860c36a71d1a364edba16fb6203b upstream.

In remoteproc shutdown sequence, rpmsg_remove will get called which
would depopulate all the child nodes that have been created during
rpmsg_probe. This would result in cb_remove call for all the context
banks for the remoteproc. In cb_remove function, session 0 is
getting skipped which is not correct as session 0 will never become
available again. Add changes to mark session 0 also as invalid.

Fixes: f6f9279f2bf0 ("misc: fastrpc: Add Qualcomm fastrpc basic driver model")
Cc: stable <stable@kernel.org>
Signed-off-by: Ekansh Gupta <quic_ekangupt@quicinc.com>
Link: https://lore.kernel.org/r/20240108114833.20480-1-quic_ekangupt@quicinc.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/fastrpc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/misc/fastrpc.c
+++ b/drivers/misc/fastrpc.c
@@ -1592,7 +1592,7 @@ static int fastrpc_cb_remove(struct plat
 	int i;
 
 	spin_lock_irqsave(&cctx->lock, flags);
-	for (i = 1; i < FASTRPC_MAX_SESSIONS; i++) {
+	for (i = 0; i < FASTRPC_MAX_SESSIONS; i++) {
 		if (cctx->session[i].sid == sess->sid) {
 			cctx->session[i].valid = false;
 			cctx->sesscount--;


