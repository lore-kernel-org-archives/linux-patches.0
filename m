Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 640E927F749;
	Wed,  4 Feb 2026 14:53:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770216826; cv=none; b=F9msioe3mLWJJEYlDdiFGbGMv2mJMFkJ0fmGp7eBJrLeNQCDwjV2XWDKekwkJfglPXanHCu7f9RG1oPKIJTxdXYbuPpQ91m6iaUHo2nwdUVgCbg4MnxMuP1ALowSbSyHrcm1XaUN5F2qr1wD4eLw6ZdvOOnY9WNEZ6n9y3J3K08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770216826; c=relaxed/simple;
	bh=g0Q0KXpUqMNgYpwXspCA1ZvISK28ni7cUjbd8Yu45YQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fvphy33PnYcPTO9HUwPSanRDP8GPz94gJJOzmj9i7WbhUeBEaYtVjGU8LZweaUv1Yq2iwvccqbRjpPyunv+AKPNmARVxp562hTrGa2qpHi+VtAelHPd3h725JfJa6fyBYLlZvGfiH/ivqZfPkz+w9Fw7nadNU/wr39cvX1PBSdg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TYdezitF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TYdezitF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D2A3C4CEF7;
	Wed,  4 Feb 2026 14:53:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770216825;
	bh=g0Q0KXpUqMNgYpwXspCA1ZvISK28ni7cUjbd8Yu45YQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TYdezitFRNC/iFsq0ADcLIe8E8uorrSyRNrSB4DM8ba4DW/vf9f3gDt9h/18WnP7x
	 TFUOKmxkiUp+GT+PovnmUVxlbriGZeR3QiGd6F3qM/O9ZrAe2s+qRvcCyUCdh0LnnO
	 PsWDn4KhTCvGaN93gEjwVyTJyoPF89ywy8ThiMgw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Airlie <airlied@redhat.com>,
	Lyude Paul <lyude@redhat.com>
Subject: [PATCH 5.15 042/206] drm/nouveau/disp/nv50-: Set lock_core in curs507a_prepare
Date: Wed,  4 Feb 2026 15:37:53 +0100
Message-ID: <20260204143859.726506932@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143858.193781818@linuxfoundation.org>
References: <20260204143858.193781818@linuxfoundation.org>
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

From: Lyude Paul <lyude@redhat.com>

commit 9e9bc6be0fa0b6b6b73f4f831f3b77716d0a8d9e upstream.

For a while, I've been seeing a strange issue where some (usually not all)
of the display DMA channels will suddenly hang, particularly when there is
a visible cursor on the screen that is being frequently updated, and
especially when said cursor happens to go between two screens. While this
brings back lovely memories of fixing Intel Skylake bugs, I would quite
like to fix it :).

It turns out the problem that's happening here is that we're managing to
reach nv50_head_flush_set() in our atomic commit path without actually
holding nv50_disp->mutex. This means that cursor updates happening in
parallel (along with any other atomic updates that need to use the core
channel) will race with eachother, which eventually causes us to corrupt
the pushbuffer - leading to a plethora of various GSP errors, usually:

  nouveau 0000:c1:00.0: gsp: Xid:56 CMDre 00000000 00000218 00102680 00000004 00800003
  nouveau 0000:c1:00.0: gsp: Xid:56 CMDre 00000000 0000021c 00040509 00000004 00000001
  nouveau 0000:c1:00.0: gsp: Xid:56 CMDre 00000000 00000000 00000000 00000001 00000001

The reason this is happening is because generally we check whether we need
to set nv50_atom->lock_core at the end of nv50_head_atomic_check().
However, curs507a_prepare is called from the fb_prepare callback, which
happens after the atomic check phase. As a result, this can lead to commits
that both touch the core channel but also don't grab nv50_disp->mutex.

So, fix this by making sure that we set nv50_atom->lock_core in
cus507a_prepare().

Reviewed-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Lyude Paul <lyude@redhat.com>
Fixes: 1590700d94ac ("drm/nouveau/kms/nv50-: split each resource type into their own source files")
Cc: <stable@vger.kernel.org> # v4.18+
Link: https://patch.msgid.link/20251219215344.170852-2-lyude@redhat.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/nouveau/dispnv50/curs507a.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/nouveau/dispnv50/curs507a.c
+++ b/drivers/gpu/drm/nouveau/dispnv50/curs507a.c
@@ -84,6 +84,7 @@ curs507a_prepare(struct nv50_wndw *wndw,
 		asyh->curs.handle = handle;
 		asyh->curs.offset = offset;
 		asyh->set.curs = asyh->curs.visible;
+		nv50_atom(asyh->state.state)->lock_core = true;
 	}
 }
 


