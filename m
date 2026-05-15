Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BA473E929C;
	Fri, 15 May 2026 16:15:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778861740; cv=none; b=nQIY9c7xlDKzdOROxZqwG4R/I5M5zYMc9Ci7UJRm+hA0HyEClGyA/ckpSkIxC45of6IgD2NdVcGiZ8svXH+6bc9UNggC0au/ViRzjCMT1ZNSXnv0OkSHX/U8cSrQAWu5zEdpuN+opJrmlvqlFOVY/Fy7GB1kgOMW+dDWcFJWKh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778861740; c=relaxed/simple;
	bh=E1zItTB9UUXC1djE6GrXgCU5Cq+PGIm4N/lVL668HMA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TqoCfxb7Xk1X0vqUJXVENsnjkchzbI93WP0rByuhcahjZ1kBlUOdIg1UEaoVZsfbh1mbfOT2lHllRToSw9cpiSJx+d8BbqXkH9Vc0r5FVuLz8DJxDtM8NigDYXkr77rvde0nCkaeM2DQBL6XxGcDTbgxi/KtuSv+o49CbDgU6x8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Lq2pkwTk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Lq2pkwTk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8847C2BCB0;
	Fri, 15 May 2026 16:15:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778861740;
	bh=E1zItTB9UUXC1djE6GrXgCU5Cq+PGIm4N/lVL668HMA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Lq2pkwTkV4BuYuvwUG2d/IujZx4ecaQZ37aR8XztwPkRkwIyYOVXl5yKBQtuhh8yb
	 /kcVqLwtZjGDc+Z5TW9/tUblxdUC7X0QJSKN2wKZDYoVvaCoHJzy+VJc2kdS5GjACX
	 vnuv6XmOPJwdix4wv2n7yAH3YnB8HkxoiNgwwpxc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Siwei Zhang <oss@fourdim.xyz>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.6 445/474] Bluetooth: L2CAP: Fix null-ptr-deref in l2cap_sock_get_sndtimeo_cb()
Date: Fri, 15 May 2026 17:49:14 +0200
Message-ID: <20260515154724.717336500@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154715.053014143@linuxfoundation.org>
References: <20260515154715.053014143@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Siwei Zhang <oss@fourdim.xyz>

commit 78a88d43dab8d23aeef934ed8ce34d40e6b3d613 upstream.

Add the same NULL guard already present in
l2cap_sock_resume_cb() and l2cap_sock_ready_cb().

Fixes: 8d836d71e222 ("Bluetooth: Access sk_sndtimeo indirectly in l2cap_core.c")
Cc: stable@kernel.org
Signed-off-by: Siwei Zhang <oss@fourdim.xyz>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/l2cap_sock.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/bluetooth/l2cap_sock.c
+++ b/net/bluetooth/l2cap_sock.c
@@ -1731,6 +1731,9 @@ static long l2cap_sock_get_sndtimeo_cb(s
 {
 	struct sock *sk = chan->data;
 
+	if (!sk)
+		return 0;
+
 	return sk->sk_sndtimeo;
 }
 


