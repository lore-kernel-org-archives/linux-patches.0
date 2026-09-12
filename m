Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F0212594BD;
	Sat, 12 Sep 2026 13:50:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789221052; cv=none; b=kG6M2i5dt/ijkHVM+mHLaaB/ckSEq+sruCFyMsKJnky0fno/luAktY76R+02Zf+Fwqg6sPypJUZiQjhZCoWD1lOVmnwEbYW2Ua+//q6GzkZm+o8H4HiC5UCTsZkVIGX44nM1XzeWEY+L/ewjjg0q7/L+e+XFCQURBn8Ifwo1gX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789221052; c=relaxed/simple;
	bh=Sqpg4iOP9Vsu0+tuM6XEMIJlUsnQrv9qn3RcMVei740=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uY6bZHo16xOapffweuLKPDsnCON/knOqEmx3D0s5g8xsPh60qjwheOFS3wrjI23c772IRCQPhXXSDnWP3CCc5Kvt830q8amqQWmhNPipWc0l5xzIB6v41pIYZ/kcRsrb9XGHfdY4uFKxzvM2NJ/s5jXrk1a6F23DzrrhlrmZZNs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r6xFAXTM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r6xFAXTM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 412BC1F000FF;
	Sat, 12 Sep 2026 13:50:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789221051;
	bh=rwFpwBqig3RJWqg1tYEkavtsdNlAPSMUUqKuriqbatk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=r6xFAXTMRBFu5sdoMBEhSKj0cTI/rk92+K0Lu3bIrs5Uuw8E8bN4KGf9qJU/XobuD
	 OWYT597MvPAscj/iGmNMab4YbXKQuxRbFcbPIPKJDj/6pcu3DxFjTJ6WIletamp4fr
	 QbsCmzwd6Qcw1euw/3XlOkCw5jtQzpSpxhGiThP4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fan Ye <fy15309206903@gmail.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 0261/1424] net: thunderbolt: Release the Rx HopID that was handed out on mismatch
Date: Sat, 12 Sep 2026 08:44:53 +0200
Message-ID: <20260912065613.123585959@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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
 


