Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4E9020125F;
	Mon, 23 Mar 2026 13:50:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774273852; cv=none; b=N+KdDTtk3OfDVp6avcidoy2y6oJswS64PePLNlZ2YuyT+/H+/GDrmfWH8qZDLiWrtMnHIBl2Mk/hzj/TzMfH6/h7IX465t62v0FLVJGJPgw/S/SmhVbn8ER1ox1ouPu+6LHN8lpf3CxuLgzn0RQ5qs4X87qpt6LwKIxNjE26QuI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774273852; c=relaxed/simple;
	bh=yIQIYBb/AmmhgVQuBBFvoCwSaDzQSMYYJvD5YWeSiHs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pJZENYYL3RPdPNwRjItvjWnzfxfzdSKDiSvGqiNpth36VSw0er1MAdWmHsNyEHGKEwwrVjn+wdzIZMPInyvcC7K0t/wgSi4Jkb3TlXq9n5byTyEqSSBi68FILlv1Qnu1KRDLs/5GjkNOXe+sAGKlz/rs6zFQsw++4hAxuvkpVLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bhVsL7rO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bhVsL7rO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CF2DC2BC9E;
	Mon, 23 Mar 2026 13:50:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774273852;
	bh=yIQIYBb/AmmhgVQuBBFvoCwSaDzQSMYYJvD5YWeSiHs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bhVsL7rOZCRbO9YJ4ktpSZbE7aPXTCFX74Gh+GjZ633qlZryXnNw8bY5S32RcN/bS
	 YoqGpftXc/Qui5sH3JexakKmi7fpRjt2XE3wc5fF8KmHELzK49JlErGMA+FCaxmX3M
	 QAvyhYTpd+cexlbcgww8mwS+FDxHsUHwbufk5ZU4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiri Kosina <jkosina@suse.com>,
	Benjamin Tissoires <bentiss@kernel.org>
Subject: [PATCH 6.19 005/220] HID: bpf: prevent buffer overflow in hid_hw_request
Date: Mon, 23 Mar 2026 14:43:02 +0100
Message-ID: <20260323134504.750388607@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134504.575022936@linuxfoundation.org>
References: <20260323134504.575022936@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Tissoires <bentiss@kernel.org>

commit 2b658c1c442ec1cd9eec5ead98d68662c40fe645 upstream.

right now the returned value is considered to be always valid. However,
when playing with HID-BPF, the return value can be arbitrary big,
because it's the return value of dispatch_hid_bpf_raw_requests(), which
calls the struct_ops and we have no guarantees that the value makes
sense.

Fixes: 8bd0488b5ea5 ("HID: bpf: add HID-BPF hooks for hid_hw_raw_requests")
Cc: stable@vger.kernel.org
Acked-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Benjamin Tissoires <bentiss@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/bpf/hid_bpf_dispatch.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/hid/bpf/hid_bpf_dispatch.c
+++ b/drivers/hid/bpf/hid_bpf_dispatch.c
@@ -447,6 +447,8 @@ hid_bpf_hw_request(struct hid_bpf_ctx *c
 					      (u64)(long)ctx,
 					      true); /* prevent infinite recursions */
 
+	if (ret > size)
+		ret = size;
 	if (ret > 0)
 		memcpy(buf, dma_data, ret);
 


