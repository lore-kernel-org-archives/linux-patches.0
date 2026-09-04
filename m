Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D27537C106;
	Fri,  4 Sep 2026 05:59:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788501593; cv=none; b=D3hvZkb1p6b7NqDbrERjLyItULlmXXJsOXr9WAeiHOIF4ORW5uDjP587dELmAAHsUSUi1YTLARkkmthFbcwqIum+dbVdWMugd9AiIpmInkyDm46YkGO5SpVQ2qiOdJalwYz6KL1W6BkAIzbeWA14/UkRQt/qXznMWWjN2ycmBE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788501593; c=relaxed/simple;
	bh=N/+GgSHIHz7t3CPo8YI0xQEhhp4+nRwcjDQwEw2TOV0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a8+gQndqHoGQRBNMmbmG/h5LYlqraaI9cemDkx+6+pqIPEP77IkUOJ7A2iC/y1om9CpM6X8hzdtdXhyurewYJyliXlpIhuKIsmh7nNhajsV1pkoPU6V5Agrdzv+Mx3VvTzqk6hElz1g0BefciAZ71L0G3ystqQyRDfzOwQ2/3ec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2AOxf31N; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2AOxf31N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01E4A1F00A3D;
	Fri,  4 Sep 2026 05:59:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788501592;
	bh=EUuDPJ/ZbhT9y8HZhIogx2IftWh413ryZc/VttdJDPk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2AOxf31NI6AtJsB3vsz8YG+XFHiEXNr68XymduD5g3QZm4W+7ZXzASen90/bUv7yo
	 F3Pgbdc+4jladS35/yYMZN16HVOC1NkOvd6GDfQQo9GO9fQd6TkZUr+xyFQX/wSYGG
	 Ampie8y1UL9pbm8LbwAwx3EXPyq2fBq1Wi4N1lXw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fan Ye <fy15309206903@gmail.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 464/552] net: thunderbolt: Release the Rx HopID that was handed out on mismatch
Date: Fri,  4 Sep 2026 07:00:21 +0200
Message-ID: <20260904045801.217643771@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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

From: Fan Ye <fy15309206903@gmail.com>

commit 2f1463554d0561a2fead81e3888604e5c1125e29 upstream.

tb_xdomain_alloc_in_hopid() passes the wanted HopID to ida_alloc_range()
as the lower bound, so a taken id is not an error there: the allocator
returns the next free one above it. tbnet_connected_work() asks for the
peer's transmit path, treats any other id as a failure and returns
without releasing what it got, so that allocation stays live for the rest
of the XDomain connection with nothing left holding a reference to it.

Release the id when it is not the one we asked for, the same way the
error unwind at the end of the function releases the expected one.

Fixes: 180b0689425c ("thunderbolt: Allow multiple DMA tunnels over a single XDomain connection")
Cc: stable@vger.kernel.org
Signed-off-by: Fan Ye <fy15309206903@gmail.com>
Acked-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260811-b4-tbnet-hopid-v3-1-9e75d1b51331@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/thunderbolt/main.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/net/thunderbolt/main.c
+++ b/drivers/net/thunderbolt/main.c
@@ -650,6 +650,8 @@ static void tbnet_connected_work(struct
 	ret = tb_xdomain_alloc_in_hopid(net->xd, net->remote_transmit_path);
 	if (ret != net->remote_transmit_path) {
 		netdev_err(net->dev, "failed to allocate Rx HopID\n");
+		if (ret >= 0)
+			tb_xdomain_release_in_hopid(net->xd, ret);
 		return;
 	}
 


