Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774149;
	b=OlvAkgioA+HdAUz3bwujmBSZ/ZPvwGKvC2tsZj9S4jisZYiPJZYVuyolnOQJm0J+zjUD
	 tvjUivjxcSppYGDNQQLzPZ8hDgLMyXTUU0myCke35fQ+Dlqyw0CNAE7+aLubQ3pHBwosJ
	 HSUUQ/WNAJeGYDL8g4gbBvTPxGmDfBbEi36XZ8crjkmlyW80qosfNGtkis/BX3wKZKNXJ
	 DlxLxUOdmEYPM477yI0G+jWnux1FAT1KJwMWyumN5iqENLpAHU7ghuvfqJi9knZm8pc2g
	 XVQQPRYfY/OYbDKeo4Xlf5qRufO7yj5Afu2wfZd4mMDOsJCBQkfNZ4l/I/2TC1+jgUA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774149;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/iD/5X504DTIMFszWBNr34mUV7ovhsFt1hlbSsdg28Q=;
	b=o/6lBR/AHNuXZ0J4aT0bPuwbBBgzz6OESwL3l0+xdz1hEIWvcMm4DExa2i22B3fGLy5R
	 7Ib2lh4a/b5ykeH756p/FhOjOwD9b02w1bFpLtXMjImDI89sRs1ZITfp8ZPKLT10owkfk
	 YPnEbXqRjaQLmEI7s4jc4w+i4JtiJ2V0IRY/6tClgG6qxOy/H3J17TEQAbeYClq2sN10m
	 K4wNE4tE+crbKthQXaOp/Vfj95PlIk1hGojp44SkvREFIjA/NPi5Dd5F1PW62IXo5ofrW
	 ChW1hVbmcO0W1Z/YGjEWYLoia+iyuJsY+XlDpibn9YVuLVXgzf1H4UJb5K1U0/AR+cA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Chwz/yig";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4845606A321;
	Fri, 23 Oct 2026 16:49:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Chwz/yig
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A1311F01825;
	Fri, 23 Oct 2026 16:49:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774148;
	bh=/iD/5X504DTIMFszWBNr34mUV7ovhsFt1hlbSsdg28Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Chwz/yigWKw78IKyQ+QE+q8q57HcAxxEPRPC63GTi6JHzjuhgOhvOjaHcdU860gML
	 LQfxjxZSfWUmrZ8stFij2MnwDrlnggxx3a1CLiqNvgCRK1EdrK8kfVlxyuNpioULjn
	 Bpf/NqrN3ZigIvLQBEh+csQRhbbtfNN5VuomRVvk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yehyeong Lee <yhlee@isslab.korea.ac.kr>,
	Juergen Gross <jgross@suse.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>
Subject: [PATCH 6.18 099/193] scsi: xen/scsifront: Check for a NULL shadow entry on a backend response
Date: Fri, 23 Oct 2026 18:36:16 +0200
Message-ID: <20261023163716.546501680@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163714.201276352@linuxfoundation.org>
References: <20261023163714.201276352@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>

commit 8c8222c255772713eb36cde695777a1fce224917 upstream.

scsifront_do_response() validates the rqid in a backend response against
VSCSIIF_MAX_REQS before using it to index info->shadow[], but then
dereferences the entry to test ->inflight without checking that the slot
is populated.  Shadow slots are NULL before a command is submitted (the
host private area is zeroed at allocation) and are reset to NULL in
_scsifront_put_rqid() once a request completes, so an in-range rqid that
does not correspond to an outstanding request makes the frontend
dereference a NULL pointer.

A malicious or buggy backend can thus crash the guest by returning a
response whose rqid is in range but not in flight -- for example a
spurious response before any command has been issued, or a duplicate of
one already completed.  The ring has only VSCSIIF_MAX_REQS (16) slots,
so before the first command every in-range rqid selects a NULL slot.

Reject a response whose shadow slot is not populated.

Fixes: 6d1c2f48f3fc ("xen/scsifront: harden driver against malicious backend")
Cc: stable@vger.kernel.org
Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
Reviewed-by: Juergen Gross <jgross@suse.com>
Link: https://patch.msgid.link/20261005123555.253995-1-yhlee@isslab.korea.ac.kr
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/xen-scsifront.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/scsi/xen-scsifront.c
+++ b/drivers/scsi/xen-scsifront.c
@@ -367,6 +367,7 @@ static void scsifront_do_response(struct
 	struct vscsifrnt_shadow *shadow;
 
 	if (ring_rsp->rqid >= VSCSIIF_MAX_REQS ||
+	    !info->shadow[ring_rsp->rqid] ||
 	    !info->shadow[ring_rsp->rqid]->inflight) {
 		scsifront_set_error(info, "illegal rqid returned by backend!");
 		return;


