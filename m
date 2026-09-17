Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1F3D4ABBA1;
	Thu, 17 Sep 2026 15:56:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660616; cv=none; b=Te453OTiMNA4eN5vPgAZ18mXlDBFl4a87qafiFZWJC62JmEGa7JU1UWA/wPUGbD11QyQqGTcDkCEN5SMvAdqeMlrip6vddNuRHkFNWRjfcEeCh05YU+ZHk2xyAyb5WED5dDsoOVJNINaS1aE+iUR8yRUVjrbs/cv3OrPy7e1SbE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660616; c=relaxed/simple;
	bh=ejSs++xkpbHwymJKl6meuAtK5/J4h8ONYH0kOdinYko=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mt2i5ZVqFqttDTMw3+SB1e12gIIJM5hdvO71jAqJhYsbcSWjxdCP+8pJXqjJSfqpBGfRiAheeD8+mMxh/nS70N09JvhtE8251cgTEhVw9SUyoBQKbDVAo1DkQaIkr7vlKZR6pQ567suFyhbO2LaNUtbutaqtoRZB8t+E0MEmQEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vyp4WJ91; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vyp4WJ91"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 435091F000FF;
	Thu, 17 Sep 2026 15:56:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789660614;
	bh=LwrB9CUwLv+2YfQ+x41kFIUbVMTQUVWWZ0Of5TuGtKk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Vyp4WJ91TNI3Wf/7vq70qWZ8HZ3GyNDJxsTaLq5mAAgERvCYwRdKilJd51oukP8Rk
	 1QOGJiBgvaag20bHUXaUTZGTPSWj19bfJDpa6i/EihIvILqZlavQGY+NSC6xGNWxFC
	 us2mVCDFExodBbTPPihDkA+oPSrmk7PvertR+VKE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anuj Gupta <anuj20.g@samsung.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cmaiolino@redhat.com>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 7.2 650/733] xfs: release alleged child inode on metapath unlink error
Date: Thu, 17 Sep 2026 16:15:58 +0100
Message-ID: <20260917151408.821723002@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anuj Gupta <anuj20.g@samsung.com>

commit 48d2b8351bae6d40b44f544fe5540868a55872b2 upstream.

If xchk_metapath_ilock_parent_and_child() fails after xchk_iget()
succeeds, release the inode reference before returning.

Fixes: 0d2c636e489c ("xfs: repair metadata directory file path connectivity")
Cc: stable@vger.kernel.org # v6.13
Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/metapath.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/xfs/scrub/metapath.c
+++ b/fs/xfs/scrub/metapath.c
@@ -556,6 +556,8 @@ xrep_metapath_try_unlink(
 	error = xchk_metapath_ilock_parent_and_child(mpath, ip);
 	if (error) {
 		xchk_trans_cancel(sc);
+		if (ip)
+			xchk_irele(sc, ip);
 		return error;
 	}
 	xfs_trans_ijoin(sc->tp, mpath->dp, 0);


