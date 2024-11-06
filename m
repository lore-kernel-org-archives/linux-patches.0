Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79D681FBF6A;
	Wed,  6 Nov 2024 12:55:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730897717; cv=none; b=LuFX72O9LML6h56Mgms9GOdBsJsVOn4ltSrcTcGvpmvo7+VpNWRPs+z7EA3WSQBBD4fEqWC7EqSgciVlCzNPH4Cws8q0qQve7yi/aOjBPNdrbAObcwH5Y+sfHlHRhK+EiW3aQv9wawvPai/fZIrzLaBYOmdFqL5Se7SoYIcMVIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730897717; c=relaxed/simple;
	bh=lVnTdrFlWlCj0OQB7EQKnjL73O1XDwSTBLn5j/cCXTA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e3GHPE1/Q/jQXDQXkrT8sdXzrqRxCdUKOOQifPugKyNNbTu1yrA+wahX1djYJ17dJoMERrC3vUB7Mv6cTi9fTLOLyBlDkKgak7CeBsNRsPz2H6sAvmWCAnVJs36Div3dCGQxaBucIV9DscH+s4pKAA6XMmRAwv5PMkVcoKrD89k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u5vdLsX9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u5vdLsX9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F4068C4CECD;
	Wed,  6 Nov 2024 12:55:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730897717;
	bh=lVnTdrFlWlCj0OQB7EQKnjL73O1XDwSTBLn5j/cCXTA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u5vdLsX9UCHTUrqe+I2ITVwYcf/4CSm/w0xo77oPnMEDihyTjiMDCAt73NxxazSHr
	 YaTuP12u9ArGxpHdzR6YmLT5dXWzL/nmjWedMY3ejwh2TUdFmrJZMulXELGF+fpmHX
	 cRl3YcAz5bsfF4xYG9PFueoFgOgkGiSwy39wEZlE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Brauner <brauner@kernel.org>,
	NeilBrown <neilb@suse.de>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Dominique Martinet <asmadeus@codewreck.org>
Subject: [PATCH 6.6 146/151] SUNRPC: Remove BUG_ON call sites
Date: Wed,  6 Nov 2024 13:05:34 +0100
Message-ID: <20241106120312.865793549@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120308.841299741@linuxfoundation.org>
References: <20241106120308.841299741@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

commit 789ce196a31dd13276076762204bee87df893e53 upstream.

There is no need to take down the whole system for these assertions.

I'd rather not attempt a heroic save here, as some bug has occurred
that has left the transport data structures in an unknown state.
Just warn and then leak the left-over resources.

Acked-by: Christian Brauner <brauner@kernel.org>
Reviewed-by: NeilBrown <neilb@suse.de>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sunrpc/svc.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/net/sunrpc/svc.c
+++ b/net/sunrpc/svc.c
@@ -577,11 +577,12 @@ svc_destroy(struct kref *ref)
 	timer_shutdown_sync(&serv->sv_temptimer);
 
 	/*
-	 * The last user is gone and thus all sockets have to be destroyed to
-	 * the point. Check this.
+	 * Remaining transports at this point are not expected.
 	 */
-	BUG_ON(!list_empty(&serv->sv_permsocks));
-	BUG_ON(!list_empty(&serv->sv_tempsocks));
+	WARN_ONCE(!list_empty(&serv->sv_permsocks),
+		  "SVC: permsocks remain for %s\n", serv->sv_program->pg_name);
+	WARN_ONCE(!list_empty(&serv->sv_tempsocks),
+		  "SVC: tempsocks remain for %s\n", serv->sv_program->pg_name);
 
 	cache_clean_deferred(serv);
 


