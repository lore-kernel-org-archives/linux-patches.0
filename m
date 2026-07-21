Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EF13470459;
	Tue, 21 Jul 2026 18:44:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659466; cv=none; b=WQZZzSqS3i47LWTZ9srF2hX+je549k7NyN0smHEIygCCDGcJjX1OyJHiyCN6QWHHjA2NiHXybmVd+RfDGoAxr/hdamedWuRxfvgkOIFeox6Kvwt3jFZGnwNV1rFh13g3j/m2mjMLm7nbvUsMz0QfXPCIYVh/LMqd9m1y4xcccJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659466; c=relaxed/simple;
	bh=pMXWlDcwyMYyQv2MRey15B2n6nw+w/DmjO07zR98QKA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pb2mW1bjriFRcfHL+mvgDIjzUOMGgDptai30sU/baYiwrnW5yFxsAU+/pMOaK6KiowSJOPZefxDA7z8NBTCXbwtiNujWexa8e4MmcQ4Qp8JjQM9UZl4VRuzila7I56vk96GGhS5e19DA3MFkIbhF4r0aWAGWNrfPmyFCtzBw7QI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rXQI0jjz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rXQI0jjz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4C6E1F00A3A;
	Tue, 21 Jul 2026 18:44:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659465;
	bh=OEVMyWduJtF7ulJ/EV9TnLJO4c8OtD/IIG9bfQS/t6k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rXQI0jjzHi8qV+r7D6zj9kUrdV4kxqpQcDxeCrwtBe6PPky6zfgVEB+//ZNyxKaF1
	 1qwG9yTX1iZ9FV9Huc+Dd/AS4+zeSfXFJILUa6bJ3Kxvjab7LG9NNNOIjHFVhstXn/
	 Hp0/zbiuRG01DQx/ak2yH/7h+v6nllz1thRxmc34=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xuanqiang Luo <luoxuanqiang@kylinos.cn>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.18 1488/1611] llc: fix SAP refcount leak when creating incoming sockets
Date: Tue, 21 Jul 2026 17:26:44 +0200
Message-ID: <20260721152548.913815194@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: Xuanqiang Luo <luoxuanqiang@kylinos.cn>

commit 2c72eb6286347d05a885412fb076993bd5286b53 upstream.

llc_sap_add_socket() takes a SAP reference for each socket added to a SAP,
and llc_sap_remove_socket() releases it. llc_create_incoming_sock() takes
an additional SAP reference after adding the child socket.

This extra reference was balanced by an explicit llc_sap_put() in
llc_ui_release() until commit 3100aa9d74db ("llc: fix SAP reference
counting w.r.t. socket handling") removed that put. The corresponding hold
in the accept path was left behind.

When such a child socket is removed, only the reference taken by
llc_sap_add_socket() is released. The extra reference keeps the SAP alive
after its last socket is removed. Remove the obsolete hold.

Fixes: 3100aa9d74db ("llc: fix SAP reference counting w.r.t. socket handling")
Cc: stable@vger.kernel.org
Signed-off-by: Xuanqiang Luo <luoxuanqiang@kylinos.cn>
Link: https://patch.msgid.link/20260712130343.518797-1-xuanqiang.luo@linux.dev
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/llc/llc_conn.c |    1 -
 1 file changed, 1 deletion(-)

--- a/net/llc/llc_conn.c
+++ b/net/llc/llc_conn.c
@@ -773,7 +773,6 @@ static struct sock *llc_create_incoming_
 	newllc->dev = dev;
 	dev_hold(dev);
 	llc_sap_add_socket(llc->sap, newsk);
-	llc_sap_hold(llc->sap);
 out:
 	return newsk;
 }


