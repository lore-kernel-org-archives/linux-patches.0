Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0F0D35295D;
	Wed, 21 Jan 2026 18:33:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769020429; cv=none; b=kQNoVAnN/Zn2EH2fDvdR0R4s/eDo8SFOZiZeOmyX1FPoR7BPYZOGDoSANIK2Hl4TcqlPqWL68OfEJSJSfiCbrmkdhA+rRekljqR/4RzA2bgf+FZPr6Q0+KOnUmYyVdDl9LFwSStiiIvm14pqlLfZcWZCqc0YYQiQzNVp+kfpNL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769020429; c=relaxed/simple;
	bh=WXMOColiOK75isy0KxJzSJJqpuZHbFW+wPfG8WCAr3k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PQMe3tnipVbIXQgi5nnDa+dhQgYtzxeg8UkCILRjlfFQf9MPe6mRDrh+Vl8hLN9saJjxdPcnds8ZV1sdgtL1B7JB/g+VdCrBEX/rdDGmklFtnTyfoZYqVMr9T1t7QSKfJAJN8VSvz05/RY10sqrj+O/IXTNsojPp1hFdS/aNJrE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kP+Mxk0t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kP+Mxk0t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D64CEC4CEF1;
	Wed, 21 Jan 2026 18:33:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769020429;
	bh=WXMOColiOK75isy0KxJzSJJqpuZHbFW+wPfG8WCAr3k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kP+Mxk0ttp5QTw0qEVJc+HFvTJcEmudC/1wUjQP7o72dTkE5JsnRIxpEvoDo7yhsn
	 yeq0V+V4kP7U2/1/AG6f+XlJcfxcc2aK/KgISx8Zu/ad5hM8aMzH+KSMQBLNq0kYIY
	 uO1maNqU7ShK0zz6f2TmtnvXWgk1rAxF/IjoyrsI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Airlie <airlied@redhat.com>,
	Lyude Paul <lyude@redhat.com>
Subject: [PATCH 6.18 155/198] drm/nouveau/disp/nv50-: Set lock_core in curs507a_prepare
Date: Wed, 21 Jan 2026 19:16:23 +0100
Message-ID: <20260121181424.131129204@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260121181418.537774329@linuxfoundation.org>
References: <20260121181418.537774329@linuxfoundation.org>
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
 


